@echo off
if not defined MDTOPDF_RUNNING (
    set MDTOPDF_RUNNING=1
    cmd /k "%~f0" %*
    exit /b
)

set "MDTOPDF_OUT=C:\Temp"

echo Markdown to PDF Converter
echo.
if "%~1"=="" (
    echo Fehler: Keine Datei angegeben!
    exit /b 1
)
if not exist "%MDTOPDF_OUT%" mkdir "%MDTOPDF_OUT%"

for %%f in (%*) do call :convert "%%~f"

echo ========================================
echo Fertig! Ausgabe in %MDTOPDF_OUT%
exit /b 0

:convert
echo Konvertiere: %~nx1
rem md-to-pdf has no target option and always drops the PDF next to the source.
rem So generate first, then move - nothing is left behind in the project.
call npx md-to-pdf "%~f1"
if not exist "%~dpn1.pdf" (
    echo   FEHLER: kein PDF erzeugt fuer %~nx1
    echo.
    exit /b 1
)
move /y "%~dpn1.pdf" "%MDTOPDF_OUT%\%~n1.pdf" >nul
if errorlevel 1 (
    echo   FEHLER: Verschieben nach %MDTOPDF_OUT% fehlgeschlagen, PDF liegt noch bei der Quelle
    echo.
    exit /b 1
)
echo   -^> %MDTOPDF_OUT%\%~n1.pdf
echo.
exit /b 0
