$OutDir = ".\lingo_screenshots"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$NextDayX = 649
$NextDayY = 1257
$ScrollX  = 540

$Days = @(
    "May23","May24","May25","May26","May27","May28","May29","May30","May31",
    "Jun01","Jun02","Jun03","Jun04","Jun05"
)

function Snap($day, $num) {
    Start-Sleep -Milliseconds 900
    adb shell screencap -p /sdcard/lingo_tmp.png
    adb pull /sdcard/lingo_tmp.png "$OutDir\${day}_${num}.png"
    Write-Host "  Saved ${day}_${num}.png"
}

function ScrollDown {
    adb shell input swipe $ScrollX 1700 $ScrollX 300 600
    Start-Sleep -Milliseconds 900
}

function ScrollToTop {
    adb shell input swipe $ScrollX 300 $ScrollX 1700 300
    Start-Sleep -Milliseconds 500
    adb shell input swipe $ScrollX 300 $ScrollX 1700 300
    Start-Sleep -Milliseconds 1200
}

foreach ($Day in $Days) {
    Write-Host "--- Capturing $Day ---"

    # Scroll to top first — overlay will appear, date bar moves to y=1257
    ScrollToTop

    # Screenshot 1 — top of page with overlay + date bar visible
    Snap $Day "01"

    # Now scroll down for remaining content — overlay disappears as you scroll
    ScrollDown
    Snap $Day "02"

    ScrollDown
    Snap $Day "03"

    ScrollDown
    Snap $Day "04"

    # Scroll back to top so overlay reappears and > is at y=1257
    Write-Host "  -> Scrolling to top for next day tap"
    ScrollToTop

    # Tap > arrow — overlay is showing so it's at y=1257
    Write-Host "  -> Next day"
    adb shell input tap $NextDayX $NextDayY
	adb shell input tap 965 1870
    Start-Sleep -Milliseconds 2500
}

Write-Host "Done! Check $OutDir"