@echo off



set commit=false
set target=false
set version=
set remark=

if "%1" == "" (
    set commit=true
    set target=true
    set version=
    set remark=sync
)

:param
set command=%1
if "%command%"=="" (
    goto result
)

shift /0

if "%command%" == "" (
    goto result
) else if "%command%"=="-h" (
    goto help
) else if "%command%"=="-c" (
    set commit=true
    goto param
) else if "%command%"=="-t" (
    set target=true
    goto param
) else if "%1" == "" (
    goto result
) else (
    shift /0

    if "%command%"=="-v" (
        set version=%1
    ) else if "%command%"=="-m" (
        set remark=%1
    set commit=true
    set target=true
    ) 

    goto param
)

:help
echo --- git auto commit ---
echo,
echo tager [command] [param]
echo,
echo command 
echo -h    help
echo -v    add verion info
echo -m    add remark info
echo -c    commit and push changes
echo -t    create tag and push it 
echo,

echo tager [param]
echo equle with: -m [param]
echo,

goto out


:GetVersion

if "%version%" neq "" (
    goto result
)

for /F %%i in ('git describe --tag') do ( set tagversion=%%i)

for /f "tokens=1,2,3 delims=.|-|v" %%a in ("%tagversion%") do (
    set c1=%%a
    set c2=%%b
    set c3=%%c
)

echo,

set /a c3=%c3%+1
set version=v%c1%.%c2%.%c3%

:result
if "%version%" == "" (
    goto GetVersion
)


git pull --tags --force
git submodule update --remote --init --force

git add .

if "%commit%" equ "true" (
    echo ############################ commit ###############################
    echo,
    echo    git commit -m %remark% 
    echo    git push
    echo,
    echo ###################################################################
    git commit -m %remark%
    git push
)

if "%target%" == "true" (
    echo ############################ publish ##############################
    echo,
    echo    git tag -a %version% -m %remark% 
    echo    push origin --tag
    echo,
    echo ###################################################################
    git tag -a %version% -m %remark%
    git push origin --tag
)

:out
