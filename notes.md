Write NGH.w to $2C0FEE and reset to launch games.
(Instructions must be copied and called from RAM)

```
100200: move.w  D0, $2c0fee.l
100206: nop
100208: reset
```