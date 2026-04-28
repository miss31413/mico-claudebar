# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**mico-claudebar** is a minimal statusline visualizer for Claude Code that displays the current model, folder, git branch, and context window usage with a color-coded progress bar.

The project consists of two scripts:
- **statusline.sh** — Bash script for macOS/Linux (requires `jq`)
- **statusline.ps1** — PowerShell 7 script for Windows

Both scripts receive JSON input from Claude Code via stdin and output a formatted status line with ANSI colors.

## Architecture

### Input Format
Both scripts expect JSON input via stdin with this structure:
```json
{
  "model": { "display_name": "Claude Sonnet 4" },
  "workspace": { "current_dir": "/path/to/project" },
  "context_window": { "used_percentage": 75 }
}
```

### Output Format
```
◆ Claude Sonnet 4  ▸ myproject  ⎇ main  ▓ [████████░░] 78%
```

Symbols:
- **◆** — Model name
- **▸** — Current folder (only if in a workspace)
- **⎇** — Git branch (only if in a git repository)
- **▓** — Context usage with progress bar

### Progress Bar Logic
- Fills 10 character positions: `█` for filled, `░` for empty
- Percentage calculation: `(context_used_percentage * 10) / 100`
- Color coding (ANSI):
  - **Green** (0–69%) — Safe
  - **Yellow** (70–89%) — Watch out
  - **Red** (90%+) — Consider new session

## Testing & Validation

### Test statusline.sh
```bash
echo '{"model":{"display_name":"Claude Sonnet 4"},"workspace":{"current_dir":"$HOME/myproject"},"context_window":{"used_percentage":75}}' | ./statusline.sh
```

Expected output: `◆ Claude Sonnet 4  ▸ myproject  ▓ [███████░░░] 75%`

### Test statusline.ps1
```powershell
'{"model":{"display_name":"Claude Sonnet 4"},"workspace":{"current_dir":"C:\\Users\\test\\myproject"},"context_window":{"used_percentage":75}}' | pwsh -NoProfile -File .\statusline.ps1
```

### Test Different Scenarios
- **Green bar** (< 70%): Use percentage of 50
- **Yellow bar** (70–89%): Use percentage of 75
- **Red bar** (≥ 90%): Use percentage of 95
- **No git repo**: Set workspace.current_dir to a non-git directory
- **No workspace**: Set workspace.current_dir to empty string or null
- **Missing fields**: Set values to null or omit them

## Platform Considerations

### macOS/Linux (bash)
- Requires `jq` installed for JSON parsing
- Uses `cd` to check git branch in the specified directory
- Handles missing `jq` and command failures gracefully
- Uses ANSI escape codes for colors
- Portable `seq` and `printf` for progress bar generation

### Windows (PowerShell)
- Requires PowerShell 7+ (pwsh), not Windows built-in PowerShell 5
- Uses `ConvertFrom-Json` for JSON parsing (no external dependencies)
- Uses UTF-8 encoding for proper character display
- Uses Unicode character codes (0x2588, 0x2591, etc.) for progress bar
- Uses `Test-Path` and `Push-Location`/`Pop-Location` for directory navigation

## Modification Guidelines

### Adding Features
When modifying either script:
1. Keep the JSON input schema compatible with Claude Code's statusline API
2. Preserve backward compatibility — don't break existing output format unless necessary
3. Both scripts should implement the same feature identically (feature parity)
4. Test on both platforms if adding cross-platform code

### Color Codes
- ANSI codes are used: `\033[31m` (red), `\033[33m` (yellow), `\033[32m` (green), `\033[0m` (reset)
- Use the same thresholds on both platforms (90% red, 70% yellow, <70% green)

### Progress Bar Characters
- Bash: Uses `█` (U+2588) and `░` (U+2591)
- PowerShell: Uses same characters via Unicode escape (`[char]0x2588`, `[char]0x2591`)
- Keep bar width at 10 characters for consistency

## Documentation

- **README.md** — Project overview, quick install, features (English & Chinese)
- **INSTALL.md** — Step-by-step installation guides per platform (English & Chinese)
- **index.html** — Visual/illustrated installation guide (hosted at miss31413.github.io)

When updating documentation, maintain both English and Chinese sections (繁中).
