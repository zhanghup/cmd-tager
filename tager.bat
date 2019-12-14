@echo off
git pull
git add .
git commit -m sync
git push

for /F %%i in ('git describe --tag') do ( set gittag=%%i)

set remark=%1
if "%1" == "" set remark=sync

for /f "tokens=1,2,3 delims=.|-|v" %%a in ("%gittag%") do (

	set c1=%%a
	set c2=%%b
	set c3=%%c
)

set /a c3=%c3%+1

echo git tag -a v%c1%.%c2%.%c3% -m %remark%

git tag -a v%c1%.%c2%.%c3% -m %remark%
git push origin --tag
