# 신뢰 도메인 화이트리스트

Phase 2-A에서 `site:` 한정 쿼리로 사용하는 1차 출처 도메인 목록.

## 한국 정부·공공 1차 출처

| 도메인 | 기관 |
|---|---|
| `site:go.kr` | 정부 통합 — 기재부·산업부·국토부 등 |
| `site:fsc.go.kr` | 금융위원회 |
| `site:fss.or.kr` | 금융감독원 |
| `site:bok.or.kr` | 한국은행 |
| `site:kosis.kr` | 통계청 |
| `site:keit.re.kr` | 산업기술평가관리원 |
| `site:kisa.or.kr` | 한국인터넷진흥원 |
| `site:nia.or.kr` | 한국지능정보사회진흥원 |
| `site:kotra.or.kr` | 대한무역투자진흥공사 |

## 글로벌 1차 출처

| 도메인 | 기관 |
|---|---|
| `site:arxiv.org` | 학술 프리프린트 |
| `site:github.com/anthropics` | Anthropic 공식 |
| `*.edu` / `*.ac.kr` | 대학·학계 |
| `site:oecd.org` | OECD |
| `site:imf.org` | IMF |
| `site:worldbank.org` | 세계은행 |

## 적용 규칙

- 한국 시장·정책 주제: 한국 그룹 최소 1회 탐색
- 글로벌 기술·학술 주제: 글로벌 그룹 적용
- 양쪽 해당 시: 양쪽 모두 탐색
- 결과 0건이어도 쿼리는 트랜스크립트에 보존 (시도 자체가 검증 일부)
