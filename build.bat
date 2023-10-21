@echo off
SETLOCAL EnableDelayedExpansion

REM -------------------------------------------------------------------------------------------------
REM NG_MENU // build.bat
REM ArcadeTV
REM // Created: 2023/10/13 10:19:32
REM // Last modified: 2023/10/21 21:01:08
REM -------------------------------------------------------------------------------------------------

CLS

REM -----------------------------------------------------------------------------------------------
REM SETTINGS: Change these according to your needs:

set PADTO=8
set OUTFILE=menu-p1.bin


REM -----------------------------------------------------------------------------------------------
REM Set date vars

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%%MM%%DD%-%HH%%Min%%Sec%"
echo timestamp: "%fullstamp%">.\tmp\build.log


REM -----------------------------------------------------------------------------------------------
REM Prepare file-related vars

set TARGETMBIT=%PADTO%
set VERSION=%date:/=.%
set /a "NEWSIZE=%TARGETMBIT%*128*1024"


REM -----------------------------------------------------------------------------------------------
REM Create folders if they do not exist

if not exist ".\tmp" mkdir ".\tmp"


REM -----------------------------------------------------------------------------------------------
REM delete any old versions

if exist ".\MAME\roms\menu\%OUTFILE%" (
  DEL ".\MAME\roms\menu\%OUTFILE%"
  echo Deleted old file: %OUTFILE%>>.\tmp\build.log
)


REM -----------------------------------------------------------------------------------------------
REM create version file

echo     dc.b " -  ArcadeTV  - ">.\version.asm
echo     dc.b " - %VERSION% - ">>.\version.asm
echo Set version to %VERSION%>>.\tmp\build.log


REM -----------------------------------------------------------------------------------------------
REM build the ROM

echo Building...
.\_tools\vasmm68k_mot_win32.exe .\main.asm -quiet -chklabels -nocase -w -rangewarnings -Dvasm=1 -L tmp\Listing.txt -DBuildGEN=1 -Fbin -spaces -o .\MAME\roms\menu\!OUTFILE!>>.\tmp\build.log


REM -----------------------------------------------------------------------------------------------
REM apply padding and byteswap

REM 8MBIT=1MBYTE=(8*128*1024)BYTES
echo Pad the source ROM to !NEWSIZE! bytes>>.\tmp\build.log
.\_tools\pad.exe .\MAME\roms\menu\!OUTFILE! !NEWSIZE! 255>>.\tmp\build.log

echo byteswap>>.\tmp\build.log
.\_tools\flip.exe .\MAME\roms\menu\!OUTFILE! .\MAME\roms\menu\!OUTFILE!>>.\tmp\build.log


REM -----------------------------------------------------------------------------------------------
REM create MAME xml file

.\_tools\MakeNeoGeoHash.exe .\MAME\hash\_neogeo.xml .\MAME\hash\neogeo.xml .\MAME\roms\menu>>.\tmp\build.log

REM -----------------------------------------------------------------------------------------------
REM Finished

echo -END OF LOG->>.\tmp\build.log
echo Done. Created !OUTFILE!
echo ROM was padded to %PADTO% MBit.
exit /b


REM -----------------------------------------------------------------------------------------------
REM Subroutines

:LCase
:UCase
:: Converts to upper/lower case variable contents
:: Syntax: CALL :UCase _VAR1 _VAR2
:: Syntax: CALL :LCase _VAR1 _VAR2
:: _VAR1 = Variable NAME whose VALUE is to be converted to upper/lower case
:: _VAR2 = NAME of variable to hold the converted value
:: Note: Use variable NAMES in the CALL, not values (pass "by reference")

SET _UCase=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
SET _LCase=a b c d e f g h i j k l m n o p q r s t u v w x y z
SET _Lib_UCase_Tmp=!%1!
IF /I "%0"==":UCase" SET _Abet=%_UCase%
IF /I "%0"==":LCase" SET _Abet=%_LCase%
FOR %%Z IN (%_Abet%) DO SET _Lib_UCase_Tmp=!_Lib_UCase_Tmp:%%Z=%%Z!
SET %2=%_Lib_UCase_Tmp%
GOTO:EOF