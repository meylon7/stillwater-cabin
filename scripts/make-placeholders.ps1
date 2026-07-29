# Stillwater - placeholder generator
#
# Writes a real JPG at the exact final dimensions for every entry in
# assets/manifest.json, so the layout is built against true aspect ratios and
# every <img> carries correct width/height from day one (CLS < 0.1).
#
# These files are DISPOSABLE. When the real renders arrive, drop them into
# assets/ under the same names and never run this script again.
#
#   pwsh scripts/make-placeholders.ps1

Add-Type -AssemblyName System.Drawing

$root     = Split-Path -Parent $PSScriptRoot
$assets   = Join-Path $root 'assets'
$manifest = Get-Content (Join-Path $assets 'manifest.json') -Raw | ConvertFrom-Json

# The locked palette. Placeholders live inside it so nothing on the page is
# ever a colour that is not a design token.
$ink     = [System.Drawing.ColorTranslator]::FromHtml('#14201d')
$teal    = [System.Drawing.ColorTranslator]::FromHtml('#2f5d55')
$tealDim = [System.Drawing.ColorTranslator]::FromHtml('#4a7a70')
$sand    = [System.Drawing.ColorTranslator]::FromHtml('#f3ede3')
$amber   = [System.Drawing.ColorTranslator]::FromHtml('#c98f4b')

function New-Placeholder {
    param(
        [string]$Path, [int]$Width, [int]$Height,
        [string]$Label, [string]$Sub, [System.Drawing.Color]$Top, [System.Drawing.Color]$Bottom
    )

    $bmp = New-Object System.Drawing.Bitmap $Width, $Height
    $g   = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode     = 'AntiAlias'
    $g.TextRenderingHint = 'ClearTypeGridFit'

    # Vertical gradient, darker at the top - the same grading direction the
    # lesson asks for on the hero video so text contrast survives.
    $rect  = New-Object System.Drawing.Rectangle 0, 0, $Width, $Height
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, $Top, $Bottom, 90.0
    $g.FillRectangle($brush, $rect)

    # Horizon line, so a scroll through the set reads as one place.
    $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(38, 243, 237, 227)), 2
    $g.DrawLine($pen, 0, [int]($Height * 0.62), $Width, [int]($Height * 0.62))

    $scale     = $Width / 1200.0
    $titleFont = New-Object System.Drawing.Font 'Georgia', ([float](46 * $scale)), ([System.Drawing.FontStyle]::Regular)
    $subFont   = New-Object System.Drawing.Font 'Segoe UI', ([float](19 * $scale)), ([System.Drawing.FontStyle]::Regular)
    $dimFont   = New-Object System.Drawing.Font 'Consolas', ([float](16 * $scale)), ([System.Drawing.FontStyle]::Regular)

    $sandBrush  = New-Object System.Drawing.SolidBrush $sand
    $amberBrush = New-Object System.Drawing.SolidBrush $amber
    $faintBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(140, 243, 237, 227))

    $fmt = New-Object System.Drawing.StringFormat
    $fmt.Alignment     = [System.Drawing.StringAlignment]::Center
    $fmt.LineAlignment = [System.Drawing.StringAlignment]::Center

    $mid = New-Object System.Drawing.RectangleF 0, ([float]($Height * 0.40)), ([float]$Width), ([float]($Height * 0.14))
    $g.DrawString($Label, $titleFont, $sandBrush, $mid, $fmt)

    $under = New-Object System.Drawing.RectangleF ([float]($Width * 0.08)), ([float]($Height * 0.55)), ([float]($Width * 0.84)), ([float]($Height * 0.16))
    $g.DrawString($Sub, $subFont, $amberBrush, $under, $fmt)

    $foot = New-Object System.Drawing.RectangleF 0, ([float]($Height * 0.86)), ([float]$Width), ([float]($Height * 0.10))
    $g.DrawString("PLACEHOLDER  $Width x $Height", $dimFont, $faintBrush, $foot, $fmt)

    # quality 88 - close enough in weight to the real graded renders
    $codec  = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
    $params = New-Object System.Drawing.Imaging.EncoderParameters 1
    $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality), 88L
    $bmp.Save($Path, $codec, $params)

    foreach ($d in @($params, $fmt, $faintBrush, $amberBrush, $sandBrush, $dimFont, $subFont, $titleFont, $pen, $brush, $g, $bmp)) { $d.Dispose() }
    "  {0,-28} {1}x{2}" -f (Split-Path $Path -Leaf), $Width, $Height
}

Write-Output 'Renders:'
foreach ($img in $manifest.images) {
    $n     = ($img.file -split '_')[0]
    $label = (($img.file -replace '^\d+_', '') -replace '\.jpg$', '') -replace '_', ' '
    # Exteriors sit colder, interiors warmer - a scroll through the set should
    # not look like eleven unrelated grey boxes.
    $isExterior = $img.file -match 'exterior|dock|deck'
    $top    = if ($isExterior) { $ink } else { $teal }
    $bottom = if ($isExterior) { $tealDim } else { $ink }
    New-Placeholder -Path (Join-Path $assets $img.file) -Width $img.w -Height $img.h `
        -Label $n -Sub $label -Top $top -Bottom $bottom
}

Write-Output 'Posters:'
foreach ($p in $manifest.posters) {
    $label = if ($p.file -match 'flight') { 'FLIGHT' } else { 'HERO' }
    New-Placeholder -Path (Join-Path $assets $p.file) -Width $p.w -Height $p.h `
        -Label $label -Sub 'poster fallback' -Top $ink -Bottom $tealDim
}

# Full-resolution copies for the flight anchors. The legs are rendered from
# these, never from the compressed page assets.
$anchors = Join-Path $root 'media\anchors'
foreach ($img in $manifest.images) {
    if ($img.file -eq '11_host.jpg') { continue }
    Copy-Item (Join-Path $assets $img.file) (Join-Path $anchors $img.file) -Force
}
Write-Output "Anchors: copied $((Get-ChildItem $anchors -Filter *.jpg).Count) files to media/anchors/"
