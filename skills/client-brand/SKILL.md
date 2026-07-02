---
name: client-brand
description: >
  클라이언트 온보딩 시 브랜드 아이덴티티(색상·타이포·톤)를 추출해
  ../jigeumlab-outputs/clients/{클라이언트}/brand.md로 저장한다.
  나노바나나·발표자료 생성 시 이 파일을 읽어 기본 팔레트를 클라이언트 브랜드로 오버라이드.
when_to_use: >
  클라이언트 온보딩 중 브랜드 항목 수집 시 자동 적용 (client-onboarder가 호출).
  "브랜드 색상 뽑아줘", "brand.md 만들어줘", "나노바나나 색상 변경해줘" 등에도 트리거.
type: encoded-preference
version: 1.0.0
changelog:
  - "1.0.0: 클라이언트 브랜드 추출 스킬 신설 (Anthropic 브랜드 스킬 대체)"
---

# 클라이언트 브랜드 추출 스킬

클라이언트 브랜드 아이덴티티를 수집·구조화해 `../jigeumlab-outputs/clients/{클라이언트}/brand.md`로 저장한다.
저장된 파일은 나노바나나 프롬프트 생성(bizplan-diagram) 시 색상 오버라이드 소스로 사용된다.

---

## 수집 항목

### 필수 (없으면 기본값 사용)

| 항목 | 질문 | 기본값 |
|---|---|---|
| Primary 색상 | "주요 브랜드 색상 HEX 코드가 있나요?" | 업종별 기본 팔레트 |
| Secondary 색상 | "보조 색상 또는 포인트 색상 HEX 코드가 있나요?" | 업종별 기본 팔레트 |
| 폰트 | "사용 중인 폰트가 있나요? (없으면 Pretendard 사용)" | Pretendard |

### 선택 (있으면 추가)

| 항목 | 질문 |
|---|---|
| 브랜드 톤 | "브랜드가 주는 느낌: 신뢰감 / 친근함 / 전문성 / 혁신적 중 택1~2" |
| 금지 요소 | "특정 색상·스타일 피해야 하는 것 있나요?" |
| 자료 위치 | "브랜드 가이드라인 PDF·로고 파일 드라이브 경로가 있나요?" |

---

## 출력 형식 (brand.md 템플릿)

```markdown
---
client: {클라이언트명}
updated: YYYY-MM-DD
source: onboarding-interview | brand-guide-pdf | website
---

## 색상

- primary: #XXXXXX
- secondary: #XXXXXX
- text: #1A1A1A
- background: #FFFFFF

## 타이포그래피

- heading: Pretendard
- body: Pretendard
- 특이사항: (없으면 생략)

## 브랜드 톤

- 키워드: 신뢰감 / 전문성 (예시)
- 금지: (없으면 생략)

## 나노바나나 오버라이드

강조색: {primary HEX}
보조색: {secondary HEX}
폰트: Pretendard (변경 시만 기재)
```

---

## 색상 정보 없을 때 업종별 기본 팔레트

색상 정보를 받지 못한 경우 업종으로 판단해 아래 팔레트를 brand.md에 기재한다.

| 업종 | Primary | Secondary |
|---|---|---|
| Tech / AI / SaaS | #7C3AED | #06B6D4 |
| Healthcare | #1E3A8A | #60A5FA |
| F&B | #EA580C | #FCD34D |
| Finance | #1E40AF | #F59E0B |
| Education | #4F46E5 | #38BDF8 |
| 기타 | #334155 | #64748B |

---

## Constraints

- HEX 코드 없이 "파란색"처럼 색상명만 받은 경우: 근접 HEX를 `(추정)` 태그로 기재
- 브랜드 가이드 PDF 있으면 PDF에서 색상 추출 우선 (pdf-reading 스킬 사용)
- brand.md 경로: `../jigeumlab-outputs/clients/{클라이언트}/brand.md` 고정 — context.md와 같은 디렉토리
- context.md 브랜드 섹션에는 `→ brand.md 참조` 1줄만 남기고 상세 기재 금지 (중복 방지)
