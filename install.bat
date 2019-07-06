@echo off

cd /d %~dp0

copy /y Windows_x64\cxcsz.exe c:\windows\
copy /y Windows_x64\cxcsi.exe c:\windows\

if exist c:\windows\cxcsz.exe goto success
if not exist c:\windows\cxcsz.exe goto fail

:fail

echo "Install  for windows fail."

:success

echo "Install  for windows successful."



pause

exit

