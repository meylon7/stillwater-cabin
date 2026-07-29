# Stillwater - identify each downloaded leg by its CONTENT, not by bookkeeping.
#
# Downloading seven near-identical URLs by hand invites exactly one mistake:
# a leg saved under the wrong number. Nothing downstream catches it - concat
# happily stitches the wrong order and the flight simply teleports.
#
# So the file names are derived, not assumed. Every clip's first and last frame
# is compared against all ten anchors; the closest match wins. If a clip's
# first frame is anchor 05 and its last is anchor 04, it IS leg 4, whatever the
# download said.
#
#   pwsh scripts/identify-legs.ps1

$ErrorActionPreference = 'Stop'
$root    = Split-Path -Parent $PSScriptRoot
$legs    = Join-Path $root 'media\legs'
$anchors = Join-Path $root 'media\anchors'
$tmp     = Join-Path $legs '.identify'
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

# from -> to, in flight order. The seam law: leg N ends where leg N+1 begins.
$plan = [ordered]@{
  '1' = @('01_exterior_dock',      '02_deck_through_glass')
  '2' = @('02_deck_through_glass', '03_great_room')
  '3' = @('03_great_room',         '05_kitchen')
  '4' = @('05_kitchen',            '04_fireplace')
  '5' = @('04_fireplace',          '07_primary_bedroom')
  '6' = @('07_primary_bedroom',    '08_stone_bath')
  '7' = @('08_stone_bath',         '10_dock_dusk')
}

# Mean absolute luma difference between two stills, 0-255.
# Same image scores in the low single digits; different rooms score 40+.
function Get-Diff {
    param([string]$A, [string]$B)
    $out = ffmpeg -v error -i $A -i $B -lavfi `
        "scale=320:-1[a];[1:v]scale=320:-1[b];[a][b]blend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=-" `
        -f null NUL 2>&1
    $m = $out | Select-String 'YAVG=([\d.]+)'
    if ($m) { [double]$m.Matches[0].Groups[1].Value } else { 999 }
}

$clips = Get-ChildItem $legs -Filter '*.mp4' | Sort-Object Name
Write-Output "Identifying $($clips.Count) clips against 10 anchors`n"

$found = @{}
foreach ($clip in $clips) {
    $first = Join-Path $tmp "$($clip.BaseName)_first.png"
    $last  = Join-Path $tmp "$($clip.BaseName)_last.png"
    ffmpeg -y -v error -i $clip.FullName -vf "select=eq(n\,0)" -vframes 1 $first
    ffmpeg -y -v error -sseof -0.08 -i $clip.FullName -vframes 1 $last

    $bestFirst = $null; $bestFirstScore = 999
    $bestLast  = $null; $bestLastScore  = 999
    foreach ($a in Get-ChildItem $anchors -Filter '*.png') {
        $df = Get-Diff $first $a.FullName
        $dl = Get-Diff $last  $a.FullName
        if ($df -lt $bestFirstScore) { $bestFirstScore = $df; $bestFirst = $a.BaseName }
        if ($dl -lt $bestLastScore)  { $bestLastScore  = $dl; $bestLast  = $a.BaseName }
    }

    $leg = ($plan.Keys | Where-Object { $plan[$_][0] -eq $bestFirst -and $plan[$_][1] -eq $bestLast })
    $verdict = if ($leg) { "-> leg $leg" } else { "-> NO MATCHING LEG" }
    "{0,-14} {1} ({2:N1}) .. {3} ({4:N1})  {5}" -f `
        $clip.Name, $bestFirst, $bestFirstScore, $bestLast, $bestLastScore, $verdict

    if ($leg) {
        if ($found.ContainsKey($leg)) { "   !! duplicate of $($found[$leg])" }
        else { $found[$leg] = $clip.Name }
    }
}

Write-Output "`nHave: $(($found.Keys | Sort-Object) -join ', ')"
$missing = 1..7 | ForEach-Object { "$_" } | Where-Object { -not $found.ContainsKey($_) }
if ($missing) { Write-Output "Missing: $($missing -join ', ')" }
