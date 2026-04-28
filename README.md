# mico-claudebar

A minimal, color-coded statusline for [Claude Code](https://claude.ai/code) with visual progress bar.

專為 [Claude Code](https://claude.ai/code) 打造的極簡視覺化狀態列，帶有顏色進度條。

```
◆ Claude Sonnet 4  ▸ miko-digital  ⎇ main  ▓ [████████░░] 78%
```

Progress bar changes color automatically — 進度條自動變色：
- 🟢 0–69% — Safe / 安全
- 🟡 70–89% — Watch out / 注意
- 🔴 90%+ — Open a new session / 建議開新 session

---

📖 [詳細安裝教學 · Full Installation Guide](./INSTALL.md)
 📖 [圖解安裝教學](https://miss31413.github.io/mico-claudebar/)
---

## Quick Install · 快速安裝

**macOS / Linux**
```bash
curl -o ~/.claude/statusline.sh https://raw.githubusercontent.com/miss31413/mico-claudebar/main/statusline.sh
chmod +x ~/.claude/statusline.sh
```

**Windows (PowerShell)**
```powershell
curl -o "$env:USERPROFILE\.claude\statusline.ps1" https://raw.githubusercontent.com/miss31413/mico-claudebar/main/statusline.ps1
```

Add to settings.json · 加入設定檔：

**macOS / Linux** — `~/.claude/settings.json`  
**Windows** — `%USERPROFILE%\.claude\settings.json`

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

> Windows 請將 command 改為 `"pwsh -NoProfile -File %USERPROFILE%\\.claude\\statusline.ps1"`

---

## What's displayed · 顯示內容

| Symbol | EN | 說明 |
|--------|----|------|
| ◆ | Current model (auto-detected) | 目前模型（自動偵測） |
| ▸ | Current folder | 當前資料夾 |
| ⎇ | Git branch (hidden if not git) | Git branch（非 git 專案自動隱藏） |
| ▓ | Context usage + progress bar | Context 使用率與進度條 |

---

## License · 授權

MIT