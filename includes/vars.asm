; [Gamelist Settings]
EntriesPerPage          equ 7
LineLength              equ 32

; [Gamelist Vars]
CurrentPage	            equ 0
CurrentIndex            equ 0
CurrentListPos          equ 0
CurrentListPosR         equ EntriesPerPage-1
GamesCount              equ (GameslistEnd-Gameslist)/32                     ; No of Games in list
TotalPages              equ (GamesCount + EntriesPerPage-1)/EntriesPerPage  ; No of pages
TotalListCount          equ EntriesPerPage*TotalPages                       ; No of "slots" in list
ListOverhead            equ TotalListCount-GamesCount                       ; No of empty "slots" in list
PageCharsCount          equ EntriesPerPage*LineLength                       ; No of chars on a full page

; [GFX Positions]
ARROW_FIXSTART          equ $7066
POS_INDEX               equ $7064
POS_LIST                equ $70A6
POS_PAGE_STR            equ $7364
POS_PAGE_CURRENT        equ $7404
POS_PAGE_TOTAL          equ $7464
POS_LINE_TOP            equ $7065
POS_LINE_BOTTOM         equ $707A
POS_GAME_INFO           equ $707B
POS_MEGS_STR            equ $743B
POS_MEGS                equ $73BB

; [VBLANK]
FLAG_DOTASKS            equ 0

