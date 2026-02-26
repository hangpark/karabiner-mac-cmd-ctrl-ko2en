# Karabiner Elements - Mac Cmd/Ctrl ko2en

한글 입력 중에 Cmd/Ctrl 키를 누르면 영어로 자동 임시 전환해주는 [Karabiner-Elements](https://karabiner-elements.pqrs.org/) 룰입니다.

한글 입력 상태에서 `Cmd+A`, `Ctrl+C` 같은 단축키를 누르면 영어가 아니라 원하는 동작이 수행되지 않는 문제, 이제 스트레스 받지 마세요.

## 쉬운 설치

```sh
curl -fsSL https://raw.githubusercontent.com/hangpark/karabiner-mac-cmd-ctrl-ko2en/main/setup.sh | bash
```

또는

```sh
wget -qO- https://raw.githubusercontent.com/hangpark/karabiner-mac-cmd-ctrl-ko2en/main/setup.sh | bash
```

설치 스크립트가 다음을 자동으로 수행합니다:

1. Karabiner-Elements 설치 (Homebrew 사용, 이미 설치되어 있으면 건너뜀)
2. 설정 파일을 Karabiner 설정 폴더에 저장
3. Karabiner-Elements 실행 및 안내 팝업 표시

설치 후 Karabiner-Elements에서 룰을 활성화해 주세요:

1. 좌측 사이드바 **Complex Modifications** 탭 클릭
2. 사단 **Add predefined rule** 클릭
3. 아래 두 룰을 **Enable**:
   - `Command 누르는 동안 영어로 임시 전환`
   - `Control 누르는 동안 영어로 임시 전환 (Ctrl+Space 제외)`

### 권한 설정

⚠️ 처음 실행하는 경우 macOS 권한 설정이 필요합니다. **시스템 설정 > 개인정보 보호 및 보안**에서 아래 두 항목에 Karabiner 관련 항목을 허용해 주세요:

- **입력 모니터링** (Input Monitoring)
- **접근성** (Accessibility)

## 직접 설정

`mac-cmd-ctrl-ko2en.json` 파일을 아래 폴더에 복사하면 됩니다:

```
~/.config/karabiner/assets/complex_modifications/
```

```sh
cp mac-cmd-ctrl-ko2en.json ~/.config/karabiner/assets/complex_modifications/
```

이후 위와 동일하게 Karabiner-Elements에서 룰을 활성화해 주세요.

## 작동 원리

[Karabiner-Elements](https://karabiner-elements.pqrs.org/)의 Complex Modifications 룰로 작동합니다.

- **Cmd 키**: 한글 입력 중 Cmd 키를 누르면 영어로 전환하고, 키에서 손을 떼면 다시 한글로 복귀합니다.
- **Ctrl 키**: 한글 입력 중 `Ctrl+A`~`Ctrl+Z`를 누르면 영어로 전환하여 단축키를 입력한 뒤, 키에서 손을 떼면 다시 한글로 복귀합니다.
- **Ctrl+Space 한영전환**은 룰에 포함되지 않으므로 기존과 동일하게 동작합니다.
