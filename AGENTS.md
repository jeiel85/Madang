# Madang 개발 지침

- 프로젝트 책임자(사수님)와는 한국어로 소통한다.
- Madang은 Deskland Preview 0.1.3(BLEZZ0102/Deskland, GPL-3.0)을 2026-11-13에 포크한 독립 프로젝트다. Deskland 원작자와 관계가 없으며, 공식 관계를 암시하는 표현을 쓰지 않는다.
- 저장소: `origin` = jeiel85/Madang(공개). `upstream` = BLEZZ0102/Deskland는 수정을 가져오는 용도로만 쓰고, 통째로 병합하지 말고 필요한 커밋만 골라(cherry-pick) 가져온다. `deskland-fork` = 예전 포크 jeiel85/Deskland.

## 이름과 식별자

- 표시 이름 `Madang`, 실행 파일 `host/bin/Madang.exe`, 아이콘 `host/Madang.ico`.
- 데이터 `%LOCALAPPDATA%\Madang`, 설치 `Programs\Madang`, 시작 프로그램 Run 값 `Madang`, 이벤트·뮤텍스 `MadangHost_*`, 격리 프로필 환경 변수 `MADANG_PROFILE_DIR`.
- Deskland 이름, 원작 아이콘, deskland.app 링크, 원작 유료판(壁纸版) 안내·구매 화면을 다시 넣지 않는다. upstream에서 가져온 수정에 이런 것이 섞여 있으면 Madang 것으로 바꾼다.
- 내부 식별자(`window.desklandSnapshot`, `window.desklandRecord`, `window.DESKLAND_THUMBS`, `deskland-limited-range`)는 사용자에게 보이지 않으므로 upstream과 맞추려고 그대로 둔다.
- 상표·이름 관련 내용을 공개하거나 바꾸기 전에는 사수님의 명시적인 지시를 받는다.

## 테마

- 테마는 HTML 페이지 하나와 `prototype/themes.json` 항목 하나로 이루어진다. 테마를 추가하면 `themes.json`, `prototype/i18n/*.json`의 `themes`, `tools/build-installer.ps1`의 `$themeFiles` 목록을 함께 맞춘다.
- 원작의 유료(잠긴) 테마를 썸네일이나 이름을 보고 재현하지 않는다. 겹치지 않는 자체 컨셉으로 만든다.
- 테마를 수정하면 아이콘 이동, 미리보기, 일시정지, 공유를 확인한다. 모든 캔버스는 실제 픽셀과 소수 표시 크기에 맞춰 그린다.
- 배경화면은 항상 백그라운드에서 돌므로 내장 그래픽 30fps를 목표로 한다. 정적인 그림은 캐시하고, 작은 물체는 국소 레이어를 쓰며, 전체 화면 셰이더에서 많은 물체를 하나씩 계산하지 않는다.
- `prototype/thumbs/beach.webp`, `meadow.webp`는 사람이 디자인한 썸네일이므로 요청 없이 다시 만들거나 덮어쓰지 않는다.

## 언어

- 현재 화면 언어는 한국어, 영어, 간체 중국어다. 언어를 추가할 때는 `prototype/i18n/<언어>.json`을 만들고, `host/DesktopHost.cs`의 `I18n.Supported`, `prototype/settings.html`의 `LANGS`, `tools/build-installer.ps1`의 파일 목록, `tools/installer.nsi`의 언어와 `LangString`에 함께 넣는다.
- 문구를 바꾸면 `en.json`, `zh-CN.json`, `ko.json`의 키와 `{자리표시자}`를 맞춘다. 한국어 문구에서 `{sw}`, `{label}`처럼 무엇이 들어갈지 모르는 자리 뒤에는 조사(이/가, 을/를)를 붙이지 않는다.
- 간체 중국어의 테마 문구는 `themes.json` 자체이고, 다른 언어는 `i18n/<언어>.json`의 `themes`에 둔다.

## 빌드와 실행

- 호스트 빌드: `powershell -ExecutionPolicy Bypass -File host\build.ps1` → `host/bin/Madang.exe`.
- 브라우저 미리보기: `node prototype\serve.mjs` → `http://localhost:5178/settings.html`.
- Windows 호스트 코드는 `host/DesktopHost.cs`. 테마 HTML/JS만 바꿨다면 호스트를 다시 빌드하지 않고 트레이의 "다시 불러오기"로 확인한다.
- 설치 파일: `powershell -ExecutionPolicy Bypass -File tools\build-installer.ps1` → `dist/`.
- 계정 로그인, 구매 복원, 자동 업데이트 확인은 넣지 않는다.

## 저장소 관리

- `host/bin/`, `host/lib/`, `dist/`, 개인 데이터, 자격 증명, 로컬 경로는 커밋하지 않는다.
- GPL-3.0: `LICENSE`와 `NOTICE`의 원작 저작권 고지를 유지한다. 이름과 아이콘 정책은 `TRADEMARKS.md`를 따른다.

## 기록

- 2026-11-13: Deskland Preview 0.1.3에서 포크하고 브랜드를 분리했다. 이름·식별자를 Madang으로 바꾸고, 원작 유료 테마 카드 11개와 썸네일, 구매 안내를 없앴다. Codex가 만든 시안 A로 새 아이콘을 넣었고, 버전은 0.1.0부터 시작한다.
- 2026-11-13: 한국어 화면을 추가했다(설정 화면, 트레이·알림, 테마 이름과 설정, 설치 파일). 설정 화면이 처음 뜰 때 공유 버튼 문구가 중국어로 남던 원본 버그를 고쳤다.
