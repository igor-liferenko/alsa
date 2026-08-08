chcp 1251
set datetemp=%date:~6,4%-%date:~3,2%-%date:~0,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%
@echo %DATETEMP% %1 %2 %3 %4 %5 %6 %7 %8 %9>>D:\M-200\alarm\m200upats.txt
"C:\Program Files\PuTTY\plink.exe" -batch -i "C:\Program Files\PuTTY\private.ppk"
  -ssh user@192.168.40.199 /etc/asterisk/alarm.sh m200upats %1 %2 %3 %4 %5 %6 %7 %8 %9
