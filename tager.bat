@echo off

set version=
set remark=

:param
set command=%1
if "%command%"=="" (
    goto end
)
shift /0



if "%command%"=="-h" (
    goto help
) else if "%2" == "" (
    set param=%command%
    goto remark
) else (
	set param=%1
    shift /0
    if "%param%"=="" (
        goto end
    )
	
    if "%command%"=="-v" (
        goto version
    ) else if "%command%"=="-m" (
        goto remark
    ) else (
        goto param
    )
)




:version
set version=%param%
goto param

:remark
set remark=%param%
goto param

:help
echo --- git auto commit ---
echo,
echo tager [command] [param]
echo,
echo command 
echo -h    help
echo -v    add verion info
echo -m    add remark info
echo,

echo tager [param]
echo equle with: -m [param]
echo,

goto out

:end

if "%remark%" == "" (
    set remark=sync
)

git pull
git add .
git commit -m %remark%
git push

if "%version%" == "" (
    for /F %%i in ('git describe --tag') do ( set gittag=%%i)

    if "%1" == "-v" set version=%2

    for /f "tokens=1,2,3 delims=.|-|v" %%a in ("%gittag%") do (

        set c1=%%a
        set c2=%%b
        set c3=%%c
    )

    if "%c1%" == "" (
        set version=v0.0.1
    ) else (
        set /a c3=%c3%+1
        set version=v%c1%.%c2%.%c3%
    )

    
)


echo git tag -a %version% -m %remark%

git tag -a %version% -m %remark%
git push origin --tag

:out
