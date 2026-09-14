rem @echo off
setlocal enabledelayedexpansion

:: ドロップされたファイル
set "input=%~1"

:: 入力が存在しない場合
if not exist "%input%" (
    echo ファイルをドロップしてください
    pause
    exit /b
)

:: 親フォルダを取得
for %%A in ("%input%") do set "folder_path=%%~dpA"

:: ドロップされたファイル名（拡張子なし）
for %%A in ("%input%") do set "dropname=%%~nA"

:: dropname = xxxxx-01 のはずなので "-" で分割してベース名抽出
for /f "tokens=1 delims=-" %%B in ("%dropname%") do set "basename=%%B"

echo ドロップされたファイル: %input%
echo フォルダ: %folder_path%
echo ベース名: %basename%

set "OUTFILE=%basename%_concat.mzt"
set "CHUNK=327680"

if exist "%OUTFILE%" del "%OUTFILE%"

echo.
echo === 320KB アライン連結開始 ===
echo 出力: %OUTFILE%
echo.

:: PowerShell で連結処理
powershell -NoLogo -NoProfile -Command "$chunk=327680;$out=[System.IO.File]::Open('%OUTFILE%','OpenOrCreate','Write','None');$out.SetLength(0);$files=Get-ChildItem '%folder_path%' -Filter '%basename%-*.mzt' | Sort-Object Name;foreach($f in $files){$data=[IO.File]::ReadAllBytes($f.FullName);if($data.Length -gt $chunk){throw \"$($f.Name) too large\"};$pad=New-Object byte[] ($chunk-$data.Length);$out.Write($data,0,$data.Length);$out.Write($pad,0,$pad.Length);Write-Host ($f.Name+': '+$data.Length+' bytes → padded');};$out.Close()"

echo.
echo 完了しました。
pause
