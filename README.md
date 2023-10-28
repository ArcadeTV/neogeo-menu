```
 _____               _     _____ _____ 
|  _  |___ ___ ___ _| |___|_   _|  |  |
|     |  _|  _| .'| . | -_| | | |  |  |
|__|__|_| |___|__,|___|___| |_|  \___/ 
```
# MENU FOR NEO GEO 161in1 MULTICART 

![Menu Screenshot](https://raw.githubusercontent.com/ArcadeTV/neogeo-menu/main/gfx/menu.png)

- Based on the work of [Vortex](https://github.com/xvortex/VTXCart)
- Used Furrtek's "Hello World" [example code](https://wiki.neogeodev.org/index.php?title=Hello_world_tutorial)
- Ongoing discussion on [arcade-projects.com](https://www.arcade-projects.com/threads/reverse-engineering-161-in-1-cartridge-to-change-rom-games.15069/latest)

---

This aims to be an alternative menu for the chinese 161in1 multicart that was fully reverse engineered by vortex in 2023.

---

## Building

On Windows use the `build.bat` file to start the toolchain.
When everything works as expected you'll find the `menu-p1.bin` romfile in the `MAME\roms\menu` folder.

---

## Run the menu in MAME

Although this was made to be used on real hardware, you can run it in MAME:

### The easy way:

1. Add a MAME executable to the MAME folder and run `emu.bat` after `build.bat`

### In your own MAME folder:

1. Run `build.bat`
2. Open `MAME\hash\neogeo.xml` from this repository in any text editor and copy the element `<software name="menu">` till `</software>` into the `neogeo.xml` from your MAME folder.
3. copy the folder `MAME\roms\menu` (where the roms are located) to your MAME setup.
4. Open a commandline terminal in your MAME folder and run MAME like this: `mame.exe neogeo -cart1 menu` or `mame.exe neogeo -cart1 menu -debug` if you want debugging features.

---

## How to Play

| Control | Function             |
| ------: | :------------------- |
|      Up | former list index    |
|    Down | next list index      |
|    Left | previous page        |
|   Right | next page            |
|       A | launch games         |
|       B | toggle game infos    |
|       C | unused               |
|       D | toggle credit screen |

---

## Gamelist

The list-entries in the rom come from `gamelist.asm`. 
It has several sections to store data that has relations to other data.
Also there are 2 sets of data, the latter is suffixed with `_j`, that is because the menu shows different lists depending on the region that is set either in your system or unibios.

To make it work with vortex' compiler there will some kind of automation in the future.
As of today I generate it dynamically from this [google sheet](https://docs.google.com/spreadsheets/d/1SvTqueoCBW6DWAlXX2c7Bu-1nL3tjjF4dnOUXxzvHcQ/edit?usp=sharing).

- You can open the sheet in your browser and make a copy from the menu.
- Make sure your sheet is publically available.
- Copy the ID of your sheet from the URL (between `https://docs.google.com/spreadsheets/d/` and the next slash `/`)
- Go to [https://ngmenu.arcade-tv.de/](https://ngmenu.arcade-tv.de/) and fill your sheet ID in the textfield, then click `generate gameslist.asm`
- Copy the generated text and replace the contents of your gamelist.asm
- Build the ROM with the provided `build.bat`

---

## Limitations

|       Text | Max characters |
| ---------: | :------------- |
| List Entry | 32             |
|  Game Info | 22             |
|       Megs | 3              |
|        NGH | 4              |

