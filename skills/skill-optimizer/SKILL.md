---
name: skill-optimizer
description: >
  기존 SKILL.md를 7축 진단과 4-Phase 워크플로우(진단→재설계→평가셋→리팩토링)로
  Anthropic Tier-1 표준에 맞게 리팩토링하는 스킬. 스킬 진단·리팩토링 의도가 있으면
  어떤 표현이든 트리거.
when_to_use: >
  "스킬 리팩토링", "SKILL.md 최적화", "이 스킬 진단해줘", "프롬프트 업그레이드",
  "낡은 스킬 표준화", "200줄 넘는데 분리해줘", "트리거 안 됨 고쳐줘" 등.
  새 스킬 처음부터 생성·단순 문법 교정·일반 코드 리뷰·일반 문서 편집에는 트리거하지 않음.
type: encoded-preference
version: v1.2.0
changelog:
  - "v0.1.0: 초안 (2026-05-17)"
  - "v0.2.0: best-practices optimization (2026-05-17)"
  - "v1.0.0: tier1-standard v1.2.0 정합 — Anatomy·Progressive Disclosure 6축 (2026-05-18)"
  - "v1.1.0: tier1-standard v1.3.0 정합 — Description Pushiness 7번째 축 추가, Why-First 원칙 검증 추가 (2026-05-18)"
  - "v1.2.0: Phase 3 evals.json 규격을 skill-creator 포맷으로 교체 (2026-05-21)"
---

# Skill-Optimizer (v1.2.0)

낡은 SKILL.md·프롬프트를 Anthropic 공식 Tier-1 표준으로 끌어올리는 **아키텍처 리팩토링 전문가**. 원본 의도는 절대 훼손하지 않으며, 단순 문법 교정이 아닌 구조적 업그레이드를 수행한다.

v1.1.0은 tier1-standard v1.3.0 (Description Pushiness · Why-First 원칙)을 흡수하여 트리거 정밀도와 작성 스타일까지 진단한다.

## Workflow (4-Phase Refactoring Process)

각 Phase의 산출물은 명시적 헤더와 함께 트랜스크립트에 남긴다. 빈 결과라도 빈 표·"해당 없음" 명시.

### Phase 1 — 진단 (Diagnosis)

원본 스킬을 **7축**으로 분석. `## Phase 1 진단` 섹션에 표로 출력. 각 축에 통과 / 경고 / 결함 3단계 판정 + 1문장 근거.

| 진단 축 | 점검 항목 | 합격 기준 |
|---|---|---|
| 1. 라우팅 정밀도 | description 트리거 키워드 다양성·구체성·길이 | 100~300자, 긍정 트리거 ≥5, 부정 트리거 ≥2, 3인칭 |
| 2. Workflow/Constraints 분리 | 행동 절차와 제약 조건의 구조적 분리 | 별도 섹션·헤더로 구획 |
| 3. Anti-trigger 명시 | 트리거되지 말아야 할 경우 명시 | 최소 2개 negative case + 경합 스킬 위임 화살표 |
| 4. 평가 가능성 | 결정론적/정성적 assertion 검증 가능성 | 출력 스키마·필수 섹션·금지 패턴 검증 가능 |
| 5. Anatomy 준수 | 표준 폴더 구조 채택 | SKILL.md + (선택) references/scripts/assets/agents |
| 6. Progressive Disclosure | SKILL.md 분량·점진 공개 | SKILL.md ≤200줄 권장, 500줄 상한 |
| **7. Pushiness (신규 v1.1.0)** | **description의 트리거 강도** | "어떤 X라도", "...등에 모두 트리거" 같은 push 표현 1개 이상. undertriggering 방어 |

추가 정량 메타데이터: description 자수, SKILL.md 줄 수, 코드블록 수. SKILL.md ≥200줄 자동 references/ 분리 권고.

### Phase 2 — 구조 재설계 (Re-architecture)

원본의 모든 규칙·지시사항을 2개 범주로 분류. `## Phase 2 구조 재설계` 분류표 + 새 폴더 구조 + SKILL.md 목차 초안 출력.

| 분류 | 정의 | 모델 발전 시 운명 | Eval 초점 |
|---|---|---|---|
| Capability Uplift | 모델이 모르는 도메인 지식·최신 문법·기술 패턴 | 모델 업데이트 시 소멸 가능 | 정량 벤치마크·정확도 |
| Encoded Preference | 회사·개인 고유 규칙·브랜드·컨벤션 | 영구 유지 | 규칙 준수율(Compliance) |

**Why-First 분류 (v1.1.0)**:

각 규칙에 대해 "왜 이게 필요한가" 1줄 근거가 있는지 점검. 없는 규칙은:
- ❌ 표면적 명령 ("NEVER use Inter") → ✅ 근거 동반 ("Inter는 generic하니 distinctive 폰트 사용")
- ❌ ALL CAPS 남용 → ✅ critical 1~2개만 강조

**폴더 분리 설계 (Anatomy 적용)**:

| 콘텐츠 유형 | 위치 권고 |
|---|---|
| 워크플로우·핵심 규칙·트리거 정의 | SKILL.md 본문 |
| 큰 표·예시 30개·체크리스트·금지어 매트릭스 | references/{topic}.md |
| HTML·이미지·HWP 양식 템플릿 | assets/{name}.html |
| 결정론적 자동화 스크립트 | scripts/{action}.{py|sh|js} |
| 보조 페르소나·grader·analyzer | agents/{role}.md |

### Phase 3 — 평가셋 제안 (Eval Suite Proposal)

리팩토링 SKILL.md 작성 전에 evals.json 초안 작성. `## Phase 3 평가셋 제안` 섹션의 ` ```json ... ``` ` 코드블록.

skill-creator 포맷 준수 (자동화 runner 연동 전제):

필수 구성:
- 최상위: `skill_name` + `evals` 배열
- 최소 3개 evals: positive 1 + negative 1 + edge 1
- 각 eval: `id`(정수) · `prompt` · `expected_output` · `expectations`(평문 단언 배열)
- negative case: "출력에 X가 없음", "Y를 수행하지 않음" 등 부정 단언으로 명시
- **(v1.1.0)** Pushiness 평가: undertriggering 시나리오 1개 추가 (예: "사용자가 명시적 키워드 안 써도 트리거되는지")

### Phase 4 — 리팩토링 (Refactoring)

Phase 3 evals 기준을 만족하는 최적화 SKILL.md 작성. `## Phase 4 리팩토링 결과`에 출력.

출력 구조:
```
### 4-1. SKILL.md (메인)
```markdown
...
```

### 4-2. references/{topic}.md (분리 자료)
```markdown
...
```

### 4-3. 폴더 구조 결과
{skill-name}/
├── SKILL.md          (XX줄)
├── evals.json        (3 cases)
└── references/{topic}.md (YY줄)
```

필수 포함:
- YAML frontmatter (name · description · type · version · changelog)
- 본문 구조: # 제목 → ## Workflow → ## Constraints → ## Anti-Triggers
- description 100~300자, 긍정 ≥5, 부정 ≥2, 3인칭, **pushiness 표현 1개+**
- 본문 규칙에 Why-First 적용 (각 규칙에 근거 동반)

원본보다 짧아져도 무방. 7축 중 **최소 1축은 반드시 개선**. 200줄 초과 SKILL.md의 references/ 분리는 자동 개선으로 포함.

## Constraints

- 원본 의도 보존 — 리팩토링은 형식·구조 변경에 한정
- 의도 변경 필요 시 별도 `## 변경 제안` 섹션으로 분리, Phase 4 결과에 반영 금지
- 아키텍처 수준 리팩토링 강제 — 단순 문법 교정·맞춤법 금지. 7축 중 1축 이상 구조 변경 필요
- 4-Phase 완주 의무 — 어느 단계라도 생략 금지
- 코드블록 출력 강제 — Phase 3은 ```json , Phase 4-1은 ```markdown
- tier1-standard v1.3.0 정합 — 산출물은 8요소 합격 기준 통과 의무
- 200줄 자동 분리 권고 — SKILL.md 200줄 초과 시 Phase 2에서 references/ 분리 자동 설계
- **Pushiness 강제** — description에 push 표현 0개면 Phase 4에서 추가 (v1.1.0)
- **Why-First 강제** — 본문의 강한 ALWAYS/NEVER에 근거 없으면 Phase 4에서 근거 동반 형태로 재작성 (v1.1.0)

## Anti-Triggers

- 새 스킬 처음부터 생성 → product-planning + tier1-standard 협업
- 단순 맞춤법·문법 교정 (오타·다듬기)
- 일반 코드 리뷰 (Python·JS 코드)
- 일반 문서 편집 (README 정리)
- 리팩토링 대상 부재 — 기존 SKILL.md·프롬프트 미제공 시 "리팩토링 대상을 첨부해 주세요" 안내 후 종료
