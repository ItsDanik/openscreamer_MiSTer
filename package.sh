#!/bin/sh
# Assemble the MiSTer release in dist/OpenScreamer_<date>/ from the build outputs
set -e
cd "$(dirname "$0")"
DATE=$(date +%Y%m%d)
OUT=dist/OpenScreamer_$DATE
rm -rf "$OUT"
mkdir -p "$OUT/_Other" "$OUT/games/OpenScreamer" "$OUT/Scripts"
cp hybrid/launcher/danik_hybrid_cores.sh "$OUT/Scripts/danik_hybrid_cores.sh"
# a copy with the game too: the daemon installs the newest one it finds
cp hybrid/launcher/danik_hybrid_cores.sh "$OUT/games/OpenScreamer/danik_hybrid_cores.sh"
cp core/output_files/OpenScreamer.rbf "$OUT/_Other/OpenScreamer_$DATE.rbf"
cp -r package/games/OpenScreamer/. "$OUT/games/OpenScreamer/"
cp build/mister/openscreamer "$OUT/games/OpenScreamer/OpenScreamer"
# GAME: files the binary needs next to it (never game data)
hybrid/docker.sh arm-linux-gnueabihf-strip "$OUT/games/OpenScreamer/OpenScreamer"
chmod +x "$OUT/games/OpenScreamer/OpenScreamer" "$OUT"/games/OpenScreamer/*.sh "$OUT/Scripts/danik_hybrid_cores.sh"
cp openscreamer/LICENSE "$OUT/games/OpenScreamer/LICENSE-openscreamer.txt"
cp openscreamer/port/src/nuked/opl3.h "$OUT/games/OpenScreamer/LICENSE-nuked-opl3.txt"
cp build/sdl/src/SDL2-*/LICENSE.txt "$OUT/games/OpenScreamer/LICENSE-sdl.txt"
cp LICENSE "$OUT/games/OpenScreamer/LICENSE-gpl3.txt"
rm -f "dist/OpenScreamer_$DATE.zip"
(cd "$OUT" && python3 -m zipfile -c "../OpenScreamer_$DATE.zip" _Other games Scripts)
find "$OUT" -type f | sort
ls -la "dist/OpenScreamer_$DATE.zip"
