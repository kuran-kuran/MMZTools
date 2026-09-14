@echo off
setlocal enabledelayedexpansion

:: ドロップされたフォルダのパスを取得
set "TARGET_DIR=%~1"

:: 最後のフォルダ名を取得
for %%i in ("%TARGET_DIR%") do set "FOLDER_NAME=%%~ni"

:: 出力フォルダ名を作成（末尾に c1 を付ける）
set "OUT_DIR=%TARGET_DIR%c1"

:: 出力フォルダが無ければ作成
if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

echo 入力フォルダ: %TARGET_DIR%
echo 出力フォルダ: %OUT_DIR%
echo.

:: 1～9999 までループ
for /l %%a in (1, 1, 9999) do (
    set count=%%a
    set "count_str=000!count!"
    set "filename=!count_str:~-4!.png"

    set "infile=%TARGET_DIR%\!filename!"
    set "outfile=%OUT_DIR%\!filename!"

    if exist "!infile!" (
        echo 処理中: !filename!
        ..\bin\DitheringCol8 /blue "!infile!" "!outfile!"
    )
)

echo.
echo 完了しました
pause
endlocal
