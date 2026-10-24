# OpenScreamer for MiSTer: notes

How the port works and how it is built. For playing it, see the [README](README.md).

## Controls in detail

The six driving keys are those of the game's `CONFIG/CONTROLS.CFG` when that file is there. To change one, add a line to `saves/openscreamer.cfg`: `key_accelerate=`, `key_brake=`, `key_left=`, `key_right=`, `key_gear_up=` or `key_gear_down=` with a key's name, such as `key_brake=Space`.

The triggers are read from the controller directly, not through MiSTer's button mapping, so they are not in *Define OpenScreamer buttons* and need a controller whose triggers are analog (Xbox, PlayStation and the like). The stick's steering is each game's own for a joystick: Screamer takes the stick as it is, Screamer 2 through its own curve (gentle near the middle, the full lock at the end). Standing on the grid, an automatic car in Screamer only takes first gear with the pedal nearly all the way down, as in the original. *Rumble* in the OSD is for controllers that have it.

More pictures of Screamer, in the core's four resolutions as they are on a 4:3 screen, are in [`docs/screenshots/`](docs/screenshots/).

## Building

Everything builds in Docker on a Linux PC.

```sh
git clone --recursive https://github.com/ItsDanik/openscreamer_MiSTer.git
cd openscreamer_MiSTer
./build.sh              # ARM game binary  -> build/mister/openscreamer
./core/build_core.sh    # FPGA core (Quartus Lite 17.0.2) -> core/output_files/OpenScreamer.rbf
./package.sh            # release zip      -> dist/OpenScreamer_YYYYMMDD.zip
```

The toolchain image (Debian bullseye, glibc 2.31 to match the MiSTer) is built from `hybrid/toolchain/` on first use. The first build also downloads and builds SDL2, SDL2_mixer and SDL2_net.

### Repository layout

| Path | |
|---|---|
| `hybrid/` | submodule: [ItsDanik/Hybrid_MiSTer](https://github.com/ItsDanik/Hybrid_MiSTer), what all our hybrid ports share: the FPGA host module, the ARM side library, SDL2 drivers, the launcher (`launcher/danik_hybrid_ports.sh`), toolchain and conventions. See its README. |
| `core/` | FPGA core, based on [Template_MiSTer](https://github.com/MiSTer-devel/Template_MiSTer): `OpenScreamer.sv` (OSD and button names) around `hybrid/rtl/hybrid_host.sv` |
| `openscreamer/` | submodule: the game, branch `mister` (the same as its `main`), with the MiSTer changes in `port/src/mister.[ch]` and behind `MISTER_HYBRID` |
| `package/` | the games and their menu entries (`games.txt`), and the files shipped next to the binary (`danik_hybrid_launch.sh`, README) |
| `releases/` | release packages |

### Development notes

- `./build.sh host` builds the same game for the PC. It runs against `hybrid/tools/fakecore`, a stand-in for the FPGA core that takes scripted input and saves screenshots and audio:
  ```sh
  gcc -O2 -o build/host/fakecore hybrid/tools/fakecore.c
  build/host/fakecore /tmp/shm script.txt audio.raw &
  cd <data folder> && MISTER_HYBRID_SHM=/tmp/shm <repository>/build/host/openscreamer
  ```
- `MISTER=root@<address> tools/test_on_mister.sh S1` tries the build on a MiSTer next to what is installed there, without installing it: from `/tmp`, with the installed game's folder mirrored there (what the game writes stays in `/tmp`) and its own OSD settings. `S2` for Screamer 2, `list` and `nodata` for the core started by itself and without data, `log` for the game's log, `stop` to remove all of it again. `TEST_ENV="OS_TALL=1 OS_WIDE=1"` fixes the resolution for a test (the OSD's is not followed then).
- `touch /tmp/openscreamer_nolaunch` on the MiSTer keeps the core loaded without starting the game, so you can start a development binary by hand (`MISTER_HYBRID_CORE=OpenScreamer`, and `MISTER_HYBRID_SET=OpenScreamer_S1` or `_S2` for a game). `/tmp/danik_hybrid_ports.log` shows what the launcher daemon did.
