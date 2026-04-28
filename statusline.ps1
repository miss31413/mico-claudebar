# ~/.claude/statusline.ps1
# Windows PowerShell version of mico-claudebar
# Requires: pwsh (PowerShell 7+)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$input_data = [Console]::In.ReadToEnd()

try {
    $json = $input_data | ConvertFrom-Json
} catch {
    [Console]::WriteLine("Claude Code")
    exit
}

$model  = if ($json.model.display_name)            { $json.model.display_name }              else { "Claude" }
$dir    = if ($json.workspace.current_dir)         { $json.workspace.current_dir }            else { "" }
$pct    = if ($null -ne $json.context_window.used_percentage) { [int]$json.context_window.used_percentage } else { 0 }

$folder = if ($dir) { Split-Path $dir -Leaf } else { "" }

$branch = ""
if ($dir -and (Test-Path $dir)) {
    Push-Location $dir
    try {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
    } catch {}
    Pop-Location
}

$barWidth = 10
$filled   = [int]([Math]::Floor($pct * $barWidth / 100))
$empty    = $barWidth - $filled
$bar      = ([string][char]0x2588 * $filled) + ([string][char]0x2591 * $empty)

$ESC = [char]27
$colorCode = if ($pct -ge 90) { "${ESC}[31m" } elseif ($pct -ge 70) { "${ESC}[33m" } else { "${ESC}[32m" }
$reset     = "${ESC}[0m"

$line = [string][char]0x25C6 + " $model"
if ($folder) { $line += "  " + [string][char]0x25B8 + " $folder" }
if ($branch) { $line += "  " + [string][char]0x2387 + " $branch" }
$line += "  " + [string][char]0x2593 + " [" + $bar + "] $pct%"

[Console]::WriteLine($colorCode + $line + $reset)
