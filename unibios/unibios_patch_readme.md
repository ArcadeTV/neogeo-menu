```
 _____               _     _____ _____ 
|  _  |___ ___ ___ _| |___|_   _|  |  |
|     |  _|  _| .'| . | -_| | | |  |  |
|__|__|_| |___|__,|___|___| |_|  \___/ 
```
# BackToMenu Patch for UNIBIOS 4.0 

- UNIBIOS created by [Razoola](http://unibios.free.fr)

---

This aims to bring back a "Back To Menu" option for the custom 161in1 cart based on the work of VORTEX.

---

## Patching

1. Obtain the [UNIBIOS 4.0 ROM](http://unibios.free.fr/download/uni-bios-40.zip).
2. Use the BPS patch file from the current release to patch your ROM. I recommend [FLIPS](https://dl.smwcentral.net/11474/floating.zip). 

---

## What was altered from the original UNIBIOS?

```
    org         $11C62                          ; disable bios integrity check
    nop 
    nop

    org         $1BBC6                          ; bypass soft reset
    jmp         freeSpace+$C00000

    org         $1FFA0                          ; 96 Bytes free
freeSpace:
    move.w      #0,$2C0FEE.L                    ; send $0000 (Menu ID) to CPLD
    jmp         $C11002.L                       ; adopt original instruction 

```

