# Installation Guide · 安裝教學

> **EN** — Step-by-step guide for all platforms. No programming experience required.  
> **繁中** — 適合沒有程式背景的人，每個步驟都有說明，照著做就能完成。

---

## Platform · 選擇你的系統

- [macOS](#macos)
- [Linux](#linux)
- [Windows](#windows)

---

## macOS

### Step 1 — Install jq · 安裝 jq

jq is a small tool for reading data. mico-claudebar needs it to work.  
`jq` 是用來讀取資料的小工具，mico-claudebar 需要它才能運作。

```bash
brew install jq
```

> **EN** — If you see `command not found: brew`, install Homebrew first at [brew.sh](https://brew.sh).  
> **繁中** — 如果出現 `command not found: brew`，請先去 [brew.sh](https://brew.sh) 安裝 Homebrew，網站首頁有一行指令複製貼上即可。

Verify · 確認安裝成功：
```bash
jq --version
# 看到版本號（如 jq-1.7）就成功了
```

---

### Step 2 — Download the script · 下載腳本

```bash
curl -o ~/.claude/statusline.sh https://raw.githubusercontent.com/miss31413/mico-claudebar/main/statusline.sh
chmod +x ~/.claude/statusline.sh
```

> **EN** — `chmod +x` tells your computer this file is an executable program.  
> **繁中** — `chmod +x` 是在告訴電腦「這個檔案可以被執行」，少了這步會沒辦法運作。

---

### Step 3 — Edit settings.json · 修改設定檔

```bash
open ~/.claude/settings.json
```

If the file doesn't exist · 如果檔案不存在：
```bash
echo '{}' > ~/.claude/settings.json && open ~/.claude/settings.json
```

Add the following · 貼上以下內容：
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

> ⚠️ **EN** — If you already have other settings in this file, don't overwrite them. Just add the `"statusLine"` block alongside the existing content.  
> ⚠️ **繁中** — 如果設定檔裡已經有其他內容，不要整個覆蓋。只需要把 `"statusLine": { ... }` 這段加在其他設定旁邊。

---

### Step 4 — Test · 測試

```bash
echo '{"model":{"display_name":"Claude Sonnet 4"},"workspace":{"current_dir":"/Users/test/myproject"},"context_window":{"used_percentage":75}}' | ~/.claude/statusline.sh
```

Expected output · 應該看到：
```
◆ Claude Sonnet 4  ▸ myproject  ▓ [███████░░░] 75%
```

---

### Step 5 — Restart Claude Code · 重啟 Claude Code

Close and reopen Claude Code. The statusline will appear at the bottom.  
關掉 Claude Code 再重新開啟，狀態列就會出現在畫面最下方。

---

## Linux

### Step 1 — Install jq · 安裝 jq

**Ubuntu / Debian：**
```bash
sudo apt install jq
```

**Arch Linux：**
```bash
sudo pacman -S jq
```

**Fedora / CentOS：**
```bash
sudo dnf install jq
```

Verify · 確認安裝成功：
```bash
jq --version
```

---

### Step 2 — Download the script · 下載腳本

```bash
curl -o ~/.claude/statusline.sh https://raw.githubusercontent.com/miss31413/mico-claudebar/main/statusline.sh
chmod +x ~/.claude/statusline.sh
```

---

### Step 3 — Edit settings.json · 修改設定檔

```bash
nano ~/.claude/settings.json
```

Add · 加入：
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

Save with `Ctrl + O` then `Enter`, exit with `Ctrl + X`.  
按 `Ctrl + O` 再按 `Enter` 儲存，`Ctrl + X` 離開。

---

### Step 4 — Test & Restart · 測試並重啟

```bash
echo '{"model":{"display_name":"Claude Sonnet 4"},"workspace":{"current_dir":"/home/test/myproject"},"context_window":{"used_percentage":75}}' | ~/.claude/statusline.sh
```

Then restart Claude Code · 再重啟 Claude Code。

---

## Windows

> **EN** — Windows uses a PowerShell script — no jq required.  
> **繁中** — Windows 使用 PowerShell 腳本，跟 macOS/Linux 的版本不同。

> ⚠️ **需要 PowerShell 7（pwsh）**，不是 Windows 內建的 PowerShell 5。  
> 下載：[aka.ms/powershell](https://aka.ms/powershell)（免費，安裝後電腦上會多一個 `pwsh` 指令）

### Step 1 — Download the script · 下載腳本

Open PowerShell and run · 打開 PowerShell 執行：

```powershell
curl -o "$env:USERPROFILE\.claude\statusline.ps1" https://raw.githubusercontent.com/miss31413/mico-claudebar/main/statusline.ps1
```

> **EN** — If the `.claude` folder doesn't exist yet, create it first:  
> **繁中** — 如果 `.claude` 資料夾不存在，先建立它：
> ```powershell
> New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude" -Force
> ```

---

### Step 2 — Allow script execution · 允許執行腳本

Windows blocks scripts by default. Run this once to allow it:  
Windows 預設會擋住腳本執行，先執行這個指令解除限制：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

> **EN** — This only affects scripts you run yourself, not system security.  
> **繁中** — 這只影響你自己執行的腳本，不影響系統安全性。

---

### Step 3 — Edit settings.json · 修改設定檔

Settings file location · 設定檔位置：  
`%USERPROFILE%\.claude\settings.json`

Open it · 打開它：
```powershell
notepad "$env:USERPROFILE\.claude\settings.json"
```

If the file doesn't exist · 如果檔案不存在：
```powershell
New-Item -Path "$env:USERPROFILE\.claude\settings.json" -Value "{}" -Force
notepad "$env:USERPROFILE\.claude\settings.json"
```

Add · 加入：
```json
{
  "statusLine": {
    "type": "command",
    "command": "pwsh -NoProfile -Command \"& '$env:USERPROFILE\\.claude\\statusline.ps1'\""
  }
}
```

> **EN** — Use `-Command` with `&` instead of `-File` for better compatibility.  
> **繁中** — 用 `-Command` 搭配 `&` 而不是 `-File`，相容性更好。

---

### Step 4 — Test · 測試

```powershell
'{"model":{"display_name":"Claude Sonnet 4"},"workspace":{"current_dir":"C:\\Users\\test\\myproject"},"context_window":{"used_percentage":75}}' | pwsh -NoProfile -File "$env:USERPROFILE\.claude\statusline.ps1"
```

Expected output · 應該看到：
```
◆ Claude Sonnet 4  ▸ myproject  ▓ [███████░░░] 75%
```

---

### Step 5 — Restart Claude Code · 重啟 Claude Code

Close and reopen Claude Code. Done!  
關掉 Claude Code 再重新開啟，完成！

---

## Troubleshooting · 常見問題

### macOS / Linux

| Problem · 問題 | Solution · 解決方式 |
|---|---|
| `jq: command not found` | Step 1 的 jq 沒裝成功，重新安裝 |
| `permission denied` | 重新執行 `chmod +x ~/.claude/statusline.sh` |
| 狀態列沒出現 | 確認 settings.json 格式正確，可貼到 [jsonlint.com](https://jsonlint.com) 檢查 |

### Windows

| Problem · 問題 | Solution · 解決方式 |
|---|---|
| 出現紅字錯誤 | 確認有執行 Step 2 的 `Set-ExecutionPolicy` |
| 狀態列沒出現（重啟後仍然） | **試試這個診斷步驟：** 1. 改 settings.json 的 command 為 `echo "Test"` 2. 重啟 Claude Code 看是否顯示 `Test` |
| 診斷成功（顯示 Test） | 表示 statusline 功能正常，脚本命令有問題。確保使用 `-Command \"& '$env:USERPROFILE\\.claude\\statusline.ps1'\"` 格式 |
| 診斷失敗（無顯示） | Claude Code 版本太舊或設定有誤。更新 Claude Code 至最新版本 |
| 出現亂碼或特殊字元顯示不正常 | 確認 PowerShell 7+ (pwsh) 已安裝，使用 `pwsh --version` 檢查版本號 |

---

## Uninstall · 移除

Remove the `statusLine` block from `settings.json` and restart Claude Code.  
把 `settings.json` 裡的 `statusLine` 那段刪掉，重啟 Claude Code 即可。