# 하네스 모드 — 서브에이전트 fan-out 레시피

> SKILL.md "실행 모드 선택"에서 **하네스**로 분기했을 때만 사용. 단일 컨텍스트 모드면 이 파일을 읽지 않는다.

## 왜 하네스인가

단일 컨텍스트 딥서치의 3가지 약점을 서브에이전트로 메운다:

| 약점 (단일 컨텍스트) | 하네스가 주는 것 |
|---|---|
| 8각도 결과가 한 창에 쌓여 토큰 폭증·후반 합성 오염 | 각도별 에이전트 격리 — 각자 깨끗한 컨텍스트 |
| 같은 모델이 자기 머릿속에서 교차검증 → 자기확증 편향 | 독립 verify 에이전트가 "반증"을 목표로 검증 |
| 8각도 순차 → 각도끼리 본 걸 못 잊음 | 병렬 + blind — multi-modal sweep 효과 복원 |

## 실행 — Workflow 도구로 fan-out

메인 세션이 `Workflow` 도구를 호출해 아래 구조를 실행한다. 토픽·하위질문은 Phase 1에서 분해한 결과를 `args`로 넘긴다.

### 파이프라인 구조

```
Phase 2  8각도 병렬 검색      → parallel: 각도 8개 에이전트, 각자 WebSearch/WebFetch
                                (각도 정의 = references/search-angles.md)
   ↓ (barrier: 전체 수집 후 dedup)
Phase 3  교차검증 + 적대적 verify → 수치 주장별로 skeptic 3인 fan-out, 다수결 반증 시 폐기
   ↓
Phase 4  합성                  → 1개 synthesis 에이전트가 확정 팩트로 보고서 작성
```

Phase 3에서 barrier가 정당한 이유: dedup은 8각도 **전체** 결과를 한 번에 봐야 한다(같은 수치 중복 제거). 그 다음 verify는 다시 병렬.

### 스크립트 템플릿

```javascript
export const meta = {
  name: 'osint-deepsearch-harness',
  description: 'OSINT 딥서치 — 8각도 병렬 검색 + 적대적 검증',
  phases: [{ title: 'Search' }, { title: 'Verify' }, { title: 'Synthesize' }],
}

// args = { topic, subQuestions: [...], angles: [...8각도 프롬프트] }
const FINDINGS = { type: 'object', properties: {
  facts: { type: 'array', items: { type: 'object', properties: {
    claim: { type: 'string' }, value: { type: 'string' },
    source: { type: 'string' }, url: { type: 'string' }, tier: { type: 'string' },
  }}}}, required: ['facts'] }
const VERDICT = { type: 'object', properties: {
  refuted: { type: 'boolean' }, reason: { type: 'string' }, grade: { type: 'string' },
}, required: ['refuted', 'grade'] }

phase('Search')
const perAngle = await parallel(args.angles.map((angle, i) => () =>
  agent(`주제: ${args.topic}\n검색 각도: ${angle}\n이 각도로만 WebSearch/WebFetch 수행. ` +
        `한국 주제면 references/trusted-domains.md 화이트리스트 site: 쿼리 1회 포함. ` +
        `정량 수치·고유명사·인용에 출처 URL 부착해 반환.`,
    { label: `angle:${i+1}`, phase: 'Search', schema: FINDINGS })))

// barrier 후 dedup — 같은 수치를 여러 각도가 잡으면 합침(독립 출처 수는 보존)
const facts = dedupeByClaim(perAngle.filter(Boolean).flatMap(r => r.facts))

phase('Verify')
const verified = await parallel(facts.map(f => () =>
  parallel([1,2,3].map(n => () =>                          // 적대적 verify 3인
    agent(`다음 주장을 반증하라(기본값 refuted=true): "${f.claim} = ${f.value}" 출처: ${f.url}\n` +
          `독립 출처로 교차 확인 안 되면 반증 처리. A/B/C/D 등급 부여.`,
      { label: `verify:${f.claim.slice(0,20)}`, phase: 'Verify', schema: VERDICT })))
    .then(votes => {
      const v = votes.filter(Boolean)
      const survives = v.filter(x => !x.refuted).length >= 2  // 다수결 생존
      return { ...f, survives, grade: v[0]?.grade }
    })))
const confirmed = verified.filter(x => x.survives)

phase('Synthesize')
const report = await agent(
  `다음 확정 팩트만으로 SKILL.md Output Schema 형식의 딥서치 보고서를 작성하라.\n` +
  `주제: ${args.topic}\n확정 팩트(JSON): ${JSON.stringify(confirmed)}\n` +
  `폐기된 주장은 ## Missing Pieces에 사유와 함께 기록.`,
  { phase: 'Synthesize' })

return { report, confirmedCount: confirmed.length, droppedCount: facts.length - confirmed.length }
```

> `dedupeByClaim`은 스크립트 안에서 직접 구현(같은 claim 키 병합, 출처 배열은 유지). 에이전트로 돌리지 않는다.

## 하네스 모드의 Phase 5

Workflow가 반환한 `report`를 메인 세션이 받아 **SKILL.md Phase 5 규칙 그대로** 저장한다(폴더화 + sources/ 원자료 아카이빙). 하네스는 검색·검증 실행만 바꾸고, 저장·등급·TRIANGULATE 기준은 단일 모드와 동일하다.

## 비용 가드

- 8각도 + (확정 후보 N × verify 3인) + 합성 1 = 에이전트 수가 수십 개. 토큰 수 배.
- 직인용 수치가 적거나 단일 클라이언트면 단일 컨텍스트가 맞다 — 하네스는 "글로벌 다각도 대규모" 또는 "직인용 수치 5건+ 적대적 검증 필요"에만.
- 진입 전 사용자에게 대략 규모(에이전트 수·예상 토큰)를 한 줄 고지하고 동의받는다.
