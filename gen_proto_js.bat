del export_msg_js\*.* /S /Q
lua generate_proto_for_lua.lua
copy_exportjs_to_dest.bat
pause