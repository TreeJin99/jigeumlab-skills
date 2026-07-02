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

Codex는 스킬을 `~/.agents/skills`(사용자 전역) 또는 작업 폴더의 `.agents/skills`(프로젝트)에서 읽는다.

```
git clone https://github.com/TreeJin99/jigeumlab-skills.git
mkdir -p ~/.agents/skills
cp -r jigeumlab-skills/skills/* ~/.agents/skills/
```

또는 원클릭 설치:
```
git clone https://github.com/TreeJin99/jigeumlab-skills.git
cd jigeumlab-skills && ./install.sh          # 기본: Codex(~/.agents/skills)
./install.sh claude                          # Claude Code(~/.claude/skills)로 설치
```

설치 후 Codex에서 `/skills`로 목록 확인, `$skill-name`으로 직접 호출 가능하다.

각 스킬은 `SKILL.md`(진입점) + `references/`(상세) + `evals.json`(테스트) 구조다. 스킬은 작업 내용이 `SKILL.md`의 description과 맞을 때 자동으로 선택된다. Codex가 요구하는 frontmatter는 `name`·`description` 두 필드이며, 전 스킬이 이를 충족한다.

### 작업 규칙 (AGENTS.md)

[`AGENTS.md`](AGENTS.md)는 Codex가 세션마다 읽는 상시 지침(행동 원칙·한국어 문체·포맷 규칙)이다. 전역 적용하려면 `~/.codex/AGENTS.md`로, 특정 작업 폴더에만 적용하려면 그 폴더 루트에 복사한다. 상단 "회사 정보"만 채우면 된다.
```
cp jigeumlab-skills/AGENTS.md ~/.codex/AGENTS.md
```

## 라이선스

MIT
