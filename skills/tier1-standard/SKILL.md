---
name: tier1-standard
description: >
  Jieum.lab 스킬 라이브러리의 품질 게이트키퍼. 8요소 합격 기준·Anatomy 표준·
  Progressive Disclosure·Description Pushiness·Why-First 원칙·evals.json 규격을
  제공하며 스킬 생성·수정 시 강제 적용됨.
when_to_use: >
  "스킬 만들어줘", "SKILL.md 작성", "스킬 수정", "evals.json 작성", "스킬 표준 확인",
  "references 분리", "폴더 구조 검토", "description 압축·보강" 등에 트리거.
  스킬 실행·일반 코딩·문서 작성·사업계획서 작업·코드 프로젝트 컨텍스트에는 트리거하지 않음.
type: encoded-preference
version: v1.4.0
changelog:
  - "v1.0.0: 초안 (2026-05-17)"
  - "v1.1.0: description 3인칭 단행 (2026-05-17)"
  - "v1.2.0: Anatomy·Progressive Disclosure 도입, 7→8요소 (2026-05-18)"
  - "v1.3.0: 5개 공식 Anthropic SKILL.md 정독 후 Description Pushiness·Why-First·확장성 패턴 흡수 (2026-05-18)"
  - "v1.4.0: evals.json 규격을 skill-creator 포맷으로 전면 교체 (2026-05-21)"
---

# Tier-1 스킬 표준 (Tier-1 Standard)

본 표준은 Jieum.lab 스킬 라이브러리의 **단일 게이트키퍼**다. 신규 스킬 생성·기존 스킬 수정 시 본 표준을 통과하지 못한 산출물은 `.claude/skills/`에 머지하지 않는다.

v1.3.0은 5개 Anthropic 공식 SKILL.md(frontend-design · theme-factory · brand-guidelines · canvas-design · skill-creator)의 실제 작성 패턴·문체·구조를 깊이 흡수하여 description 라우팅 정밀도와 본문 작성 스타일을 강화한다.

## 0. 자동 적용 트리거

<HARD-GATE>
- `.claude/skills/` · `.claude/agents/` · `.claude/commands/` 하위에 새 `.md` 또는 `.json` 파일 생성
- 기존 SKILL.md · evals.json 수정
- references/ · scripts/ · assets/ · agents/ 하위 폴더 신규 생성
- "스킬 만들어줘", "프롬프트 표준화", "이 스킬 좀 봐줘", "references 분리", "폴더 구조 검토", "description 압축·보강" 등 스킬 생성·수정·진단 의도 표현
</HARD-GATE>

## 1. Anatomy — 스킬 표준 폴더 구조

Anthropic 공식 표준(skill-creator SKILL.md `## Anatomy of a Skill`)을 그대로 채택한다.

```
{skill-name}/
├── SKILL.md          ← 필수, YAML frontmatter + 본문
├── evals.json        ← 권장, 트리거·동작 평가셋 (P0·P1 필수)
├── references/       ← 선택, 점진 공개용 큰 자료 분리
├── scripts/          ← 선택, 결정론적·반복 작업 자동화
├── assets/           ← 선택, 출력에 사용되는 정적 파일
└── agents/           ← 선택, 보조 subagent (멀티페르소나 스킬)
```

## 2. Progressive Disclosure — 점진 공개 원칙

| 레벨 | 시점 | 분량 권고 |
|---|---|---|
| Level 1 — name + description | 항상 컨텍스트에 존재 | 100~300자 (한국어) |
| Level 2 — SKILL.md 본문 | 트리거 시 로드 | **200줄 권장, 500줄 상한** |
| Level 3 — references/·scripts/·assets/·agents/ | 필요할 때만 | 무제한 |

SKILL.md 200줄 초과 시 워크플로우·핵심 규칙만 본문에 남기고 큰 자료는 references/{topic}.md로 분리한다.

## 3. 8요소 합격 기준 (v1.3.0)

| # | 요소 | 합격 기준 |
|---|---|---|
| 1 | YAML frontmatter | name · description · type · version 4개 필수 |
| 2 | **Description 라우팅 정밀도** | 100~300자, 긍정 트리거 ≥5, 부정 트리거 ≥2, 3인칭, **pushiness 포함** (3-1 참조) |
| 3 | Workflow 섹션 | Phase 분리, 단계별 산출물·종료 조건 |
| 4 | Constraints 섹션 | Workflow와 별도 헤더로 분리 |
| 5 | Anti-Triggers 섹션 | 최소 2개 카테고리, 경합 스킬 위임 화살표 |
| 6 | Output Schema | 결정론적 검증 가능한 형태 |
| 7 | 동반 evals.json | positive · negative · edge 3-case, skill-creator 포맷 준수 |
| 8 | Progressive Disclosure 준수 | SKILL.md ≤200줄. 초과 시 references/ 분리 |

### 3-1. Description Pushiness (skill-creator 흡수)

Claude는 기본적으로 **스킬을 undertrigger** 하는 경향이 있다 — 적용 가능한 상황인데도 스킬 없이 응답하려는 성향. 이를 방어하려면 description을 "약간 강하게" 쓴다.

❌ 약함: "사업계획서 작성을 돕는 스킬"
✅ 강함: "사업계획서 작성·섹션 집필·HWP 양식 본문 입력·지원사업 신청서 작성·계획서 수정 요청 시 트리거. 정부지원사업 관련 어떤 작업이라도 본 스킬을 사용하라."

push 키워드 예시: "어떤 X라도", "X 관련 모든 작업에", "사용자가 명시적으로 요청하지 않아도 X 맥락이면", "...등에 모두 트리거".

## 4. Why-First 작성 원칙 (skill-creator 흡수)

규칙·금지 사항을 적을 때 **이유를 함께 적는다**. 강한 ALWAYS·NEVER 명령보다 *왜 그래야 하는지*를 설명하면 모델이 엣지케이스에서도 원칙을 올바르게 적용한다.

❌ 약함: "NEVER use Inter font. ALWAYS use distinctive fonts."
✅ 강함: "Inter는 AI가 기본 선택하는 폰트라 결과물이 generic하게 보임. 디자인 의도를 살리려면 의도적으로 특이한 폰트(Pretendard·Schibsted Grotesk 등) 사용."

ALL CAPS 강조는 진짜 critical한 1~2개에만 사용. 남용 시 효과 소멸.

## 5. 공식 풍 톤 가이드 (5개 공식 SKILL.md 흡수)

| 요소 | 권장 패턴 |
|---|---|
| 단정 어조 | "Implement working code that is..." (frontend-design) — 명령 아닌 결과 묘사 |
| 구체적 예시 | "brutally minimal, maximalist chaos, retro-futuristic..." (frontend-design) — 추상어 대신 구체 카탈로그 |
| 차별점 강조 | "AI slop 회피" (frontend-design) — 부정 예시로 quality bar 설정 |
| 확장 패턴 | "Create your Own Theme" (theme-factory) — 사용자가 정의된 X 외에 신규 생성 허용 |
| 메모리 활용 | "The user ALREADY said..." (canvas-design) — 이전 발화 인용으로 refinement loop |

## 6. YAML Frontmatter 스키마

```yaml
---
name: {snake-case}
description: {라우팅용 설명, 100~300자, 긍정 트리거 5+ / 부정 트리거 2+, pushiness 포함}
type: {capability-uplift | encoded-preference}
version: {v0.1.0}
license: {선택, 외부 공유 시}
tools: {선택, 도구 제한 필요 시}
argument-hint: {선택, 슬래시 커맨드성 스킬에만}
changelog:
  - "v0.1.0: 초안"
---
```

## 7. evals.json 필수 규격

skill-creator 공식 포맷 준수. 자동화 runner 연동 전제.

- 위치: `{skill-name}/evals.json` (스킬 폴더 루트)
- 최상위: `skill_name` (문자열) + `evals` (배열)
- evals 최소 3개: positive 1 + negative 1 + edge 1
- 각 eval 필수 필드: `id`(정수) · `prompt` · `expected_output` · `expectations`
- `expectations`: 독립적으로 검증 가능한 단언 문장 배열 (평문, 타입 태그 없음)
- negative case: "출력에 X가 없음", "Y를 수행하지 않음" 등 부정 단언으로 명시

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "positive 시나리오",
      "expected_output": "성공 조건 한 줄 요약",
      "expectations": [
        "출력에 '필수 섹션명'이 포함됨",
        "~함/~임 종결형으로 작성됨"
      ]
    },
    {
      "id": 2,
      "prompt": "negative 시나리오",
      "expected_output": "스킬이 발동되지 않아야 함",
      "expectations": [
        "출력에 스킬 전용 헤더가 없음",
        "범위 밖임을 안내하거나 일반 응답을 제공함"
      ]
    }
  ]
}

## 8. 파일명·폴더 컨벤션

- 스킬 폴더: `{snake-case-name}/`
- SKILL 파일: `SKILL.md` (대문자 고정)
- references: `references/{topic}.md`
- scripts: `scripts/{action}.{py|sh|js}`
- assets: `assets/{name}.{html|png|svg}`
- agents: `agents/{role}.md`

## Workflow

### Phase 1 — 의도·스코프 캡처
목적·분류(capability-uplift / encoded-preference)·트리거 조건 확인. positive/negative/edge 3 시나리오 미리 식별.

### Phase 2 — evals.json 초안 작성 (스킬 작성 전 필수)
3 시나리오를 evals.json으로 먼저 작성. 스킬이 무엇을 해야 하는지 테스트로 정의한 뒤 SKILL.md 작성 시작.

<HARD-GATE>
evals.json 없이 SKILL.md 작성 시작 금지.
</HARD-GATE>

### Phase 3 — SKILL.md 초안 작성
Phase 2 evals 기준을 만족하는 SKILL.md 작성. 1~8 기준 + Why-First + 공식 풍 톤 적용. 200줄 초과 예측 시 처음부터 references/ 분리 설계.

### Phase 4 — 자가 점검·분해
Grader/Analyzer 관점에서 8요소 + Pushiness + Why-First 재검토. evals assertion이 SKILL.md 규칙과 정합하는지 교차 확인. 200줄 초과 시 references/ 분리 실행.

## Constraints

- 본 표준을 통과하지 못한 산출물은 `.claude/skills/`에 머지하지 않음
- Description: 100~300자, 긍정 트리거 ≥5, 부정 트리거 ≥2, 3인칭, pushiness 포함
- Description의 push는 "정직 강조" 수준 — 거짓·과장 금지
- ALL CAPS·강한 ALWAYS/NEVER는 진짜 critical한 1~2개에만 사용
- 규칙에 이유(why) 동반 — 그 규칙이 깨질 때의 결과·맥락 설명
- SKILL.md ≤200줄, 500줄 절대 상한
- references/·scripts/·assets/·agents/ 4종 폴더는 공식 Anatomy 준수
- SKILL.md와 evals.json은 항상 짝으로 생성·삭제

## Anti-Triggers

- 스킬 실행·사용 (평가가 아닌 기능 수행 요청)
- 일반 코딩·디버깅 (스킬 파일과 무관)
- 문서 편집·사업계획서 → business-plan 스킬
- 신규 스킬 컨셉 브레인스토밍 → product-planning 스킬
