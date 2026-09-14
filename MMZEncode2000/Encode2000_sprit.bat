echo off
setlocal enabledelayedexpansion

set "exe_path=..\bin\MmzEncode.exe"
set "folder_path=%1\"
set index=1
for %%i in ("%~1") do set "mztbase=%%~ni"

set "mztname=%mztbase%-01.mzt"
%exe_path% %folder_path%0001.png !mztname!

for /l %%a in (1, 1, 9999) do (
    set count=%%a
    set "count_str=000!count!"
    set "filename1=!count_str:~-4!.png"

    set /a count+=1
    set "count_str=000!count!"
    set "filename2=!count_str:~-4!.png"

    if not exist %folder_path%!filename1! goto :end
    if not exist %folder_path%!filename2! goto :end

    rem バックアップを取る
    set "mztnamebkup=%mztbase%-!index!_bak.mzt"
    copy "!mztname!" "!mztnamebkup!" > nul

    rem ファイルを追加する
    %exe_path% /add %folder_path%!filename1! %folder_path%!filename2! !mztname!

    rem サイズ取得
    for %%F in ("!mztname!") do set size=%%~zF

    rem 320KB超え時の処理
    if !size! GEQ 327680 (
        echo 320KB超え → 320KB未満の前の物を採用
        del "!mztname!"
        copy "!mztnamebkup!" "!mztname!" > nul

        rem 新しいMZTを作成
        set /a index+=1
        set "index_str=0!index!"
        set "index_str=!index_str:~-2!"
        set "mztname=%mztbase%-!index_str!.mzt"
        %exe_path% /add %folder_path%!filename1! %folder_path%!filename2! !mztname!
    )
    del "!mztnamebkup!"
)

:end

call concat320kb "!mztname!"

endlocal
pause
