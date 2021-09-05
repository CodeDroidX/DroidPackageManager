if "%*"=="" echo "xecho {Black;DarkBlue;DarkGreen;DarkCyan;DarkRed;DarkMagenta;DarkYellow;Gray;DarkGray;Blue;Green;Cyan;Red;Magenta;Yellow;White} Your Text" & goto n
if "%*"=="-h" echo "xecho {Black;DarkBlue;DarkGreen;DarkCyan;DarkRed;DarkMagenta;DarkYellow;Gray;DarkGray;Blue;Green;Cyan;Red;Magenta;Yellow;White} Your Text" & goto n
if "%*"=="/h" echo "xecho {Black;DarkBlue;DarkGreen;DarkCyan;DarkRed;DarkMagenta;DarkYellow;Gray;DarkGray;Blue;Green;Cyan;Red;Magenta;Yellow;White} Your Text" & goto n
if "%*"=="-?" echo "xecho {Black;DarkBlue;DarkGreen;DarkCyan;DarkRed;DarkMagenta;DarkYellow;Gray;DarkGray;Blue;Green;Cyan;Red;Magenta;Yellow;White} Your Text" & goto n
if "%*"=="?" echo "xecho {Black;DarkBlue;DarkGreen;DarkCyan;DarkRed;DarkMagenta;DarkYellow;Gray;DarkGray;Blue;Green;Cyan;Red;Magenta;Yellow;White} Your Text" & goto n

CALL:colorecho %~1 %~2
:n
goto ex

:colorecho
for /f "usebackq tokens=2 delims=:" %%i in (`chcp`) do set sOldCP=%%~i
>nul chcp 866
powershell write-host -foregroundcolor %1 %2
if defined sOldCP >nul chcp %sOldCP%
goto ex
:ex