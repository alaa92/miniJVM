@echo off

set GLFWDIR=win_i686
set TARGETDIR=win32
set LIBDIR=i686-w64-mingw32
set GCCHOME=D:\msys64\mingw32
rem ==============================================================


echo [INFO]Build require tdm-gcc , setup gcc home : %GCCHOME%
if exist  %GCCHOME% (
    echo [INFO]tdm-gcc found
) else (
    echo [ERROR]tdm-gcc not found
    echo [INFO]Please download tdm-gcc: https://jmeubank.github.io/tdm-gcc/ 
    echo [INFO]Change GCCHOME with installed directory
    goto :eof
)

set GCCLIBDIR=%GCCHOME%\%LIBDIR%\lib

set path=%path%;%GCCHOME%\bin

setlocal enabledelayedexpansion

echo [INFO]build mini_jvm.exe
call :jvm_compile mini_jvm.exe ..\minijvm\c %TARGETDIR%
echo [INFO]build libgui.dll
call :gui_compile libgui.dll ..\desktop\glfw_gui\c %TARGETDIR%

goto :eof
rem ==============================================================
:jvm_compile
    set SRCFILES=
    @for /f "delims=" %%i in ('@dir /S /B %2\*.c ^| @find /V "sljit" ^| @find /V "cmake-"') do (@set SRCFILES=!SRCFILES! %%i)
    rem echo %SRCFILES%
    %GCCHOME%\bin\gcc  -o %1 -I%2\jvm -I%2\utils\ -I%2\utils\sljit\ -I%2\utils\https\ -I%2\utils\https\mbedtls\include\ -L%GCCLIBDIR%  %SRCFILES% %2\utils\sljit\sljitLir.c  -lpthread -lm -lws2_32 
    move %1 %3
goto :eof

:gui_compile
    set SRCFILES=
    @for /f "delims=" %%i in ('@dir /S /B %2\*.c ^| @find /V "cmake-"') do (@set SRCFILES=!SRCFILES! %%i)
    rem echo %SRCFILES%
    %GCCHOME%\bin\gcc -shared -fPIC -o %1 -I..\minijvm\c\jvm -I%2\ -I%2\deps\include -L%2\deps\lib\%GLFWDIR%  %SRCFILES% -lglfw3 -lopengl32 -mwindows
    move %1 %3
goto :eof
