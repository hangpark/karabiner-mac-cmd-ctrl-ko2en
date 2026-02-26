#!/usr/bin/env bash
set -e

# --- 색상 및 출력 헬퍼 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${BOLD}$*${RESET}"; }
success() { echo -e "${GREEN}${BOLD}$*${RESET}"; }
warn()    { echo -e "${YELLOW}${BOLD}$*${RESET}"; }
error()   { echo -e "${RED}${BOLD}$*${RESET}" >&2; }

# --- macOS 체크 ---
if [ "$(uname -s)" != "Darwin" ]; then
  error "이 스크립트는 macOS에서만 사용할 수 있습니다."
  exit 1
fi

# --- Homebrew 체크 ---
if ! command -v brew &>/dev/null; then
  error "Homebrew가 설치되어 있지 않습니다."
  echo "아래 링크에서 Homebrew를 먼저 설치해 주세요:"
  info "  https://brew.sh"
  exit 1
fi

echo ""
echo "=========================================="
echo "  Cmd/Ctrl 한영전환 도구 설치 스크립트"
echo "=========================================="
echo ""
echo "한글 입력 중에 Command/Control 키를 누르면"
echo "자동으로 영어로 전환해주는 Karabiner 룰을 설치합니다."
echo "(Ctrl+Space 한영전환은 그대로 동작해요!)"
echo ""

# 1. Karabiner-Elements 설치 (이미 설치되어 있으면 skip)
if ! brew list --cask karabiner-elements &>/dev/null; then
  info "Karabiner-Elements 설치 중..."
  warn "(Mac 암호 입력이 필요할 수 있어요)"
  echo ""
  brew install --cask karabiner-elements
else
  success "Karabiner-Elements 프로그램이 이미 설치되어 있어요!"
fi

# 2. complex_modifications 폴더 생성 및 JSON 파일 저장
DEST_DIR="$HOME/.config/karabiner/assets/complex_modifications"
JSON_FILE="mac-cmd-ctrl-ko2en.json"
GITHUB_RAW_URL="https://raw.githubusercontent.com/hangpark/karabiner-mac-cmd-ctrl-ko2en/main/$JSON_FILE"
mkdir -p "$DEST_DIR"

# 로컬 파일 확인 (파이프 실행이 아닌 경우에만)
if [ -f "$0" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$JSON_FILE" ]; then
  if ! cp "$SCRIPT_DIR/$JSON_FILE" "$DEST_DIR/$JSON_FILE"; then
    error "설정 파일 복사에 실패했습니다."
    exit 1
  fi
else
  if ! curl -fsSL "$GITHUB_RAW_URL" -o "$DEST_DIR/$JSON_FILE"; then
    error "설정 파일 다운로드에 실패했습니다."
    echo "URL: $GITHUB_RAW_URL"
    exit 1
  fi
fi

echo ""
success "설정 파일 저장 완료!"

# 3. Karabiner-Elements 실행 및 확인
open -a "Karabiner-Elements"

STARTED=false
for i in $(seq 1 10); do
  if pgrep -q karabiner 2>/dev/null; then
    success "Karabiner-Elements가 실행되었습니다!"
    STARTED=true
    break
  fi
  sleep 1
done
if [ "$STARTED" = false ]; then
  warn "Karabiner-Elements 실행을 확인하지 못했습니다."
  warn "직접 Karabiner-Elements를 실행해 주세요."
fi

# 4. 안내 팝업
osascript -e 'display dialog "Cmd/Ctrl 한영전환 도구 설치 완료!

한글 입력 중에 Cmd/Ctrl 키를 누르면
자동으로 영어로 전환해주는 도구예요.
Cmd+C, Ctrl+A 같은 단축키가 바로 먹힙니다!

이제 Karabiner-Elements에서 룰만 켜주면 돼요.

1. Complex Modifications 탭 클릭
2. Add predefined rule 클릭
3. 아래 두 룰을 Enable:
   - Command 누르는 동안 영어로 임시 전환
   - Control 누르는 동안 영어로 임시 전환

※ Ctrl+Space 한영전환은 그대로 동작합니다.

처음 실행하는 경우 권한 설정이 필요해요!
시스템 설정 > 개인정보 보호 및 보안 에서
입력 모니터링과 접근성 권한을 허용해 주세요." with title "Cmd/Ctrl 한영전환 도구" buttons {"알겠어요!"} default button "알겠어요!" with icon note' &>/dev/null &

echo ""
success "설치 끝! Karabiner-Elements에서 룰을 활성화해 주세요."
echo ""
