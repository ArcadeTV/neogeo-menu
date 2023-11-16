# MENU FOR NEO GEO 161in1 MULTICART

```text
 _____               _     _____ _____ 
|  _  |___ ___ ___ _| |___|_   _|  |  |
|     |  _|  _| .'| . | -_| | | |  |  |
|__|__|_| |___|__,|___|___| |_|  \___/ 
```

![Menu Screenshot](https://raw.githubusercontent.com/ArcadeTV/neogeo-menu/main/gfx/menu.png)

- Based on the work of [Vortex](https://github.com/xvortex/VTXCart)
- Used Furrtek's "Hello World" [example code](https://wiki.neogeodev.org/index.php?title=Hello_world_tutorial)
- Ongoing discussion on [arcade-projects.com](https://www.arcade-projects.com/threads/reverse-engineering-161-in-1-cartridge-to-change-rom-games.15069/latest)

---

_This aims to be an alternative menu for a modded chinese 161in1 v3 multicart that was fully reverse engineered by vortex in 2023._

Please see this [flowchart](https://raw.githubusercontent.com/ArcadeTV/neogeo-menu/main/161in1v3_mod_flowchart.pdf), it outlines the process of modding a cartridge. A full writeup with all the details is currently not available.

---

## Configuration Options

You can change the settings in `config.asm` to fit your needs.

| Name  | Description                                                                    |
| :---- | :----------------------------------------------------------------------------- |
| THEME | Changes the colors used in the palettes<br>0: NEOGEO Style<br>1: UNIBIOS Style |

---

## Building

**Requirements:**

- Windows x64
- All files from this repository incl. the `_tools` folder
- A gameslist.asm file (see details below)

On Windows use the `build.bat` file to start the toolchain.
When everything works as expected you'll find the roms ready for the modded 161in1 V3 in the `copy_to_vortex_repo` folder.

---

## Run the menu in MAME

Although this was made to be used on real hardware, you can run it in MAME:

### The easy way

1. Add a MAME executable to the MAME folder
2. Add a bios (neogeo.zip) to MAME/roms
3. Run `build.bat`
4. Run `emu.bat` or `debug.bat` to launch MAME

### In your own MAME folder

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

## Gameslist

The list-entries in the rom come from the `gameslist.asm` file which is included upon building the rom. It has several sections to store data that has relations to other data, such as MEG-count, release year, publisher and category.

[!] The order of your gameslist and the roms you flashed to your ICs need to match. **Please double check the ordering!**

You can generate both `gameslist.asm` and `games.txt` dynamically from my [generator](https://ngmenu.arcade-tv.de). Just follow the instructions on the page.

_This is not about any "Master List" or Homebrew-Conversions - it's a cart with flash-roms that can hold any software the system is capable of (some mapper limitations apply), so please do not see my Google Sheet as "This must be on your cart", but as a template for the correct format to get your own folder-contents into a) a gameslist.asm for building the custom menu and b) the games.txt for the vortex compiler that packs your roms into big binaries for programming your chips. The Google Sheet could as well be empty, but then you would have to fill all the meta data yourself._

---

## Limitations

|       Text | Max characters |
| ---------: | :------------- |
| List Entry | 32             |
|  Game Info | 22             |
|       Megs | 3              |
