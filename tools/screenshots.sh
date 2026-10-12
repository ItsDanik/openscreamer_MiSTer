#!/bin/sh
# Make the screenshots of docs/screenshots/ again: the game's PC build of the
# mister branch (cmake -S openscreamer/port -B build/x86), its robot driver,
# and the core's four picture sizes. Each is saved as it is on a 4:3 screen.
# usage: tools/screenshots.sh <the game's folder (DATA, GFX)>
set -e
cd "$(dirname "$0")/.."
GAME=${1:?the folder of the original game}
BIN=$PWD/build/x86/openscreamer
OUT=$PWD/docs/screenshots
WORK=$PWD/build/tmp/shots
rm -rf "$WORK"; mkdir -p "$WORK" "$OUT"
cd "$WORK"
export OPENSCREAMER_HOME=$WORK/home OPENSCREAMER_DATA=$GAME SDL_VIDEODRIVER=dummy OS_NOSOUND=1 OS_UNLOCK=1
mkdir -p "$OPENSCREAMER_HOME"

# name  track  frames  view(0 bumper,1 cockpit,2 near,3 far)  tall  wide
race() {
    OS_TALL=$5 OS_WIDE=$6 OS_VIEW=$4 OS_DRIVE_DEMO=$3 "$BIN" "build/dec/MAP$2" "$2" > /dev/null 2>&1
    mv demo.ppm "$1.ppm"
}
race race_palm_town_320x200     1  640 2 0 0
race race_cockpit_320x200       1  900 1 0 0
race race_lake_valley_320x240   2 1500 3 1 0
race race_track3_640x200        3 1300 2 0 1
race race_track4_night_640x240  4  900 3 1 1
race race_track5_320x240        5 1100 2 1 0
race race_track6_640x240        6 1000 2 1 1
race race_grid_640x240          1  330 3 1 1

OS_TALL=1 OS_WIDE=1 OS_MENU_PAGE=0 OS_MENU_STEPS=70 OS_MENU_SHOT=0,0,menu_main_640x240.ppm "$BIN" > /dev/null 2>&1
OS_TALL=0 OS_WIDE=1 OS_MENU_STEPS=40 OS_MENU_SHOT=1,2,menu_cars_640x200.ppm "$BIN" > /dev/null 2>&1
OS_TALL=0 OS_WIDE=0 OS_MENU_STEPS=40 OS_MENU_SHOT=0,3,menu_tracks_320x200.ppm "$BIN" > /dev/null 2>&1

python3 - "$OUT" <<'EOF'
import sys, glob, os
from PIL import Image
out = sys.argv[1]
for f in sorted(glob.glob("*.ppm")):
    im = Image.open(f)
    # 4:3 at 1920x1440: whole-number steps first, then the rows averaged down
    big = im.resize((1920, im.height * 36), Image.NEAREST) if im.height == 200 else im.resize((1920, 1440), Image.NEAREST)
    if big.height != 1440:
        big = big.resize((1920, 1440), Image.BOX)
    name = os.path.splitext(f)[0] + ".png"
    big.save(os.path.join(out, name), optimize=True)
    print(name, im.size)
EOF
