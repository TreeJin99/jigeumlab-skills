---
name: hwp-reading
description: >
  한글파일(.hwp·.hwpx)을 받으면 scripts/hwp_extract.py로 본문·표·이미지를 자동 추출해
  읽는 규칙. hwp5txt가 표를 뭉개는 문제를 피해 hwp5html(.hwp)·zip파싱(.hwpx)으로
  표 셀과 임베드 이미지를 보존함.
when_to_use: >
  ".hwp 읽어줘", ".hwpx 열어봐", "한글파일 내용 알려줘", "이 사업계획서(hwp) 분석",
  "한글파일 표·이미지 추출", "HWP 안에 뭐 있어?" 등 한글파일이 입력으로 주어질 때 트리거.
  PDF 파일 읽기(→ pdf-reading)·텍스트 파일(.txt·.md·.csv)·코딩 작업에는 트리거하지 않음.
  코드 프로젝트(package.json·pyproject.toml·go.mod 등) 컨텍스트에서도 트리거하지 않음.
type: encoded-preference
version: v1.0.0
changelog:
  - "v1.0.0: 한글파일 자동 추출 규칙 신설 — pyhwp(hwp5html)+zip파싱 검증 (2026-06-02)"
---

# 한글파일(HWP·HWPX) 읽기 규칙

<HARD-GATE>
사용자가 .hwp·.hwpx 파일을 주면, 변환 요청을 따로 받지 않아도
scripts/hwp_extract.py로 자동 추출한 뒤 읽을 것.
hwp5txt 단독 사용 금지 — 표를 "<표>" 한 글자로 뭉개 사업계획서가 거의 빈 결과가 됨.
</HARD-GATE>

## 왜 이 방식인가

- 한국 사업계획서·신청서는 대부분 내용이 **표 안**에 들어감. 표 셀을 살려야 의미가 있음.
- `.hwp`(바이너리 HWP5)는 pyhwp `hwp5html`로 변환 후 표 셀을 탭/줄바꿈으로 텍스트화 → 깨진 글자 없이 표·본문 보존, 이미지는 bindata로 회수.
- `.hwpx`(신형 ZIP+XML)는 zip을 직접 열어 section XML 본문·표·메모 + BinData 이미지 회수.

## Workflow

### Phase 1 — 파일 수신·판별
- 확장자 확인: `.hwp` / `.hwpx`
- 양식 성격 판단: 공고문·신청양식(레이아웃 중요) / 사업계획서·일반문서(내용 중심)

### Phase 2 — 자동 추출
```
python3 scripts/hwp_extract.py "파일경로.hwp" --out 결과폴더 --images
```
- 결과: `결과폴더/text.md`(본문·표·메모) + `결과폴더/images/`(임베드 이미지)
- 본문만 빠르게 볼 땐 `--out`·`--images` 없이 stdout으로도 가능
- 추출한 `text.md`를 읽어 작업에 사용. 필요 시 이미지 파일을 개별로 확인

### Phase 3 — 레이아웃 중요 문서 보강
- 공고문·신청양식에서 **체크박스 상태(□/■)·병합셀·도장 위치**가 핵심이면:
  - 동일 내용의 PDF가 함께 있으면 PDF를 우선(→ `pdf-reading` 이미지 모드)
  - PDF가 없으면 HWP 추출로 진행하되, 양식 모양이 어긋날 수 있음을 한 번 짚어줌

## Constraints

- **자동 처리**: 사용자가 PDF로 변환해 달라고 하지 않아도 한글파일은 직접 추출. "PDF 주세요" 요구 금지
- **표 보존 필수**: hwp5txt 단독 금지. 반드시 hwp_extract.py(hwp5html/zip) 경로 사용
- **의존성·이식성**: pyhwp 필요. 스크립트가 **첫 실행 시 pyhwp 자동 설치**(`pip install --user pyhwp`)하므로 드라이브 동기화된 다른 노트북에서도 별도 준비 없이 동작(python3·pip·네트워크 전제). hwp5html이 PATH에 없으면 `~/Library/Python/*/bin`·`~/.local/bin`에서 자동 탐색
- **한계 고지**: ① soffice(LibreOffice) HWP 필터는 이 환경에서 막혀 PDF 변환 경로 불가 ② 암호 걸린 HWP는 hwp-extract 별도 필요 ③ 추출 이미지가 대용량 BMP면 읽기 전 PNG 변환이 필요할 수 있음

## Anti-Triggers

- **PDF 파일**: `.pdf`는 `pdf-reading`(이미지 모드)으로 처리
- **텍스트 파일**: `.txt`·`.md`·`.csv`·`.json` 등은 그대로 읽음
- **코딩·디버깅**: 코드 수정·리뷰
- **코드 프로젝트 컨텍스트**: package.json·pyproject.toml·go.mod 등이 있는 폴더
