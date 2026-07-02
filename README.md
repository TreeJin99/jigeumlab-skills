# jigeumlab-skills

지금랩([jigeum.info](https://jigeum.info))이 정부지원사업 컨설팅·문서 작업에 쓰는 **Agent Skills** 모음. [Anthropic Agent Skills 표준](https://code.claude.com/docs/en/skills)을 따르므로 **Claude Code**와 **OpenAI Codex CLI** 양쪽에서 동작한다.

> 클라이언트 실명·연락처·내부 인프라(노션 DB·슬랙 채널 ID 등)는 모두 제외·익명화된 공개판이다.

## 스킬 목록

| 스킬 | 용도 |
|---|---|
| `biz-plan` | 정부지원사업 사업계획서·신청서를 PSST 구조로 작성 |
| `bizplan-diagram` | 사업계획서 섹션을 16개 도식 패턴으로 자동 판단·프롬프트화 |
| `notice-quickread` | 공고문 PDF를 9블록 템플릿으로 분석 |
| `osint-deepsearch` | 4단계 워크플로우 + 출처 A/B/C/D 등급 심층 리서치 |
| `devils-advocate` | 3-Phase 다중 페르소나 토론으로 초안 결함 검증 |
| `writing-style` | 정부지원사업 한국어 문체·개조식·금지어 교정 |
| `char-count` · `word-count` | 양식 글자수·바이트수 정밀 카운트 |
| `hwp-reading` · `pdf-reading` | 한글·PDF 레이아웃 보존 추출 |
| `client-brand` | 브랜드 아이덴티티(색상·타이포·톤) 추출 |
| `skill-creator` · `skill-optimizer` · `tier1-standard` | 스킬 제작·리팩토링·품질 게이트 |
| `docx` · `pdf` · `pptx` · `xlsx` · `theme-factory` | 문서·슬라이드·스프레드시트 생성/편집 (Anthropic 공식 번들) |

## 설치

### Claude Code
```
git clone https://github.com/TreeJin99/jigeumlab-skills.git
cp -r jigeumlab-skills/skills/* ~/.claude/skills/
```

### OpenAI Codex CLI
```
git clone https://github.com/TreeJin99/jigeumlab-skills.git
cp -r jigeumlab-skills/skills/* ~/.codex/skills/
```

각 스킬은 `SKILL.md`(진입점) + `references/`(상세) + `evals.json`(테스트) 구조다. 스킬은 작업 내용이 `SKILL.md`의 description과 맞을 때 자동으로 선택된다.

## 라이선스

MIT
