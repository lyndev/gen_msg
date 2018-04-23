lua core/generate_proto_for_lua.lua

del ..\..\runtime\win32\src\script\Message\*.* /S /Q

xcopy export ..\..\runtime\win32\src\script\Message\ /E /I /Y

echo "********************************************************"
echo "*    tcopy msg lua to scrip/Message success            *"
echo "********************************************************"

pause