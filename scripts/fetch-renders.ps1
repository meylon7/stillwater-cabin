# Stillwater - pull the Kolbo renders into the project
#
# media/anchors/NN_role.png  full resolution, untouched. The flight legs are
#                            rendered from these.
# assets/NN_role.jpg         the page copy: graded a touch darker and
#                            compressed. Never used as a flight anchor.
#
# The grade is the same decision the lesson makes about the hero video: darken
# the source rather than lay a flat overlay over the copy.
#
#   pwsh scripts/fetch-renders.ps1

$ErrorActionPreference = 'Stop'
$root    = Split-Path -Parent $PSScriptRoot
$assets  = Join-Path $root 'assets'
$anchors = Join-Path $root 'media\anchors'
$base    = 'https://media.kolbo.ai/kolboai-media/generated-images/698a319850e5ce92d6963ad6/6a69bf2cb3e63bc59b9a4f45'

# shot -> the Kolbo generation id fragment in the file name
$renders = [ordered]@{
  '01_exterior_dock'      = '6a69c207'
  '02_deck_through_glass' = '6a69c20a'
  '03_great_room'         = '6a69c20f'
  '04_fireplace'          = '6a69c213'
  '05_kitchen'            = '6a69c218'
  '06_dining'             = '6a69c21d'
  '07_primary_bedroom'    = '6a69c220'
  '08_stone_bath'         = '6a69c224'
  '09_sauna'              = '6a69c228'
  '10_dock_dusk'          = '6a69c22c'
}

foreach ($name in $renders.Keys) {
    $png = Join-Path $anchors "$name.png"
    $jpg = Join-Path $assets  "$name.jpg"
    $url = "$base/A-modern-two-storey-lakef-$($renders[$name])-gpt-image-2.png"

    if (-not (Test-Path $png)) {
        Invoke-WebRequest -Uri $url -OutFile $png
    }

    # No scale filter on purpose. The renders come back at 1024x688 and
    # upscaling to a rounder number buys bytes, not detail.
    ffmpeg -y -loglevel error -i $png `
        -vf "eq=brightness=-0.03:saturation=0.96" `
        -q:v 4 $jpg

    $dim = (ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 $png)
    "{0,-24} anchor {1,-10} page {2,7:N0} KB" -f $name, $dim, ((Get-Item $jpg).Length / 1KB)
}

# the hero poster is shot 01, exactly the frame the hero video will animate.
# Graded a stop darker than the page copy so the hero headline clears 4.5:1
# against the brightest part of the frame, not the average.
ffmpeg -y -loglevel error -i (Join-Path $anchors '01_exterior_dock.png') `
    -vf "eq=brightness=-0.05:saturation=0.94" `
    -q:v 3 (Join-Path $assets 'hero-poster.jpg')
"hero-poster.jpg          {0,7:N0} KB" -f ((Get-Item (Join-Path $assets 'hero-poster.jpg')).Length / 1KB)

# the flight poster is the first frame of the flight, which is also shot 01
Copy-Item (Join-Path $assets 'hero-poster.jpg') (Join-Path $assets 'flight_poster.jpg') -Force
