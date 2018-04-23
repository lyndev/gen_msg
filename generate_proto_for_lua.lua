--[[********************************************************************************
-- Copyright (C), 2017, 
-- 文 件 名: generate_proto_for_lua.lua
-- 作    者: lyn
-- 版    本: V1.0.1
-- 创建日期: 
-- 完成日期: 
-- 功能描述: proto的协议文件转换为lua/js table, 免去手工填写的麻烦
-- 其它相关: 
-- 修改记录: 1.0.1增加了js版本
--********************************************************************************]]

-- 指定目录
local PROTO_DIR = "proto"

-- 指定格式
local EXTENSION = ".proto"

-- 文件列表名输出到目录
local CONFIG_NAME = 'tools-auto-generate-files-do-not-change.ini'

-- 导出的脚本目录
local EXPORT_DIR = "export_msg_js/"

-- 输出脚本格式
local EXPORT_SCRIPT_EXTENSION = '.js' -- .lua / .js

-- 文件头注释
local HEADE_TITLE = "--********************************************************************************\n--  generate: protoForLuaTableTool\n--  version: v1.0.1\n--  author: UndaKunteera\n--********************************************************************************\n\n"
if EXPORT_SCRIPT_EXTENSION == '.js' then
    HEADE_TITLE = "//********************************************************************************\n//  generate: protoForJsTableTool\n//  version: v1.0.1\n//  author: UndaKunteera\n//********************************************************************************\n\n"
end

--[[
-- 函数类型: private
-- 函数功能: 获取指定目录的proto文件
-- 参数[IN]: 无
-- 返 回 值: 所有指定格式的文件名
-- 备    注:
--]]
local function getDirFiles(path, extension)
    os.execute("dir ".. path..' > '..CONFIG_NAME )
    local buff = io.open(CONFIG_NAME, "r")
    if buff then
        local filesName = {}
        local row = 1
        for line in buff:lines() do
            if row > 7 then
                if string.find(line, extension) then
                    print("\t"..string.match(line, "%a+")..'.proto')
                    table.insert(filesName, string.match(line, "%a+"))
                end
            end
            row = row + 1
        end
        return filesName
    end
    return {}
end

--[[
-- 函数类型: private
-- 函数功能: 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
local function generateProtoForTable(fileName)

    -- get file content
    print("start progress:", fileName)
    local buff = io.open(fileName, "r")
    if not buff then
        print("[error] file content is empty : ", fileName)
        return nil
    end
    local allMsg = {}
    for line in buff:lines() do
        table.insert(allMsg, line)
    end

    local function getMsgName(i, line)
        line = string.sub(line, 9, #line)
        local _curMsgName = string.match(line, "%a+")
        return _curMsgName
    end

    local function getMsgID(i,line)            
        local _curMsgID = string.match(line, "%d+")
        if not _curMsgID then
            print("line:", line)
            print("[error] not msg id [line:] "..i.." [content:]"..(_curMsgID or "" ) .. ' [error file:] '..fileName)
            return nil
        end
        return _curMsgID
    end

    local function getMsgNote(i,line)
        local _pattern =  "[%z\1-\194-\244][\128-\191]+"
        line = string.gmatch(line, _pattern)
        local _noteConnect = ''
        if EXPORT_SCRIPT_EXTENSION == '.js' then
            _noteConnect = '// '
        elseif EXPORT_SCRIPT_EXTENSION == '.lua' then
            _noteConnect = '-- '
        end
        for words in line do
            _noteConnect = _noteConnect..words
        end
        return _noteConnect
    end

    -- generate base head format
    local _result = HEADE_TITLE
    
    local _tMsgs = {}
    local _fileName = ''
    for i, v in ipairs(allMsg) do
        if i == 1 then
            _fileName = string.sub(v, 9, #v)
            _fileName = string.match(_fileName, "%a+")
        end

        -- get msgName, get msgID
        local _bfind = (string.find(v, "Req") and string.find(v, "message")) or (string.find(v, "Res") and string.find(v, "message")) or (string.find(v, "Notify")  and string.find(v, "message"))
        if _bfind then

            -- note
            local _note = allMsg[i-1]
            _note = getMsgNote(i, _note)

            -- msgName
            local _curMsgOldName = string.sub(v, 9, #v)
            local _curMsgName = getMsgName(i, v)

            -- msgID
            local _curMsgIDLine = allMsg[i+2]
            if string.find(_curMsgOldName, '{') then
                _curMsgIDLine = allMsg[i+1]
                if not _curMsgIDLine or _curMsgIDLine == '' then
                    _curMsgIDLine = allMsg[i+2]
                end
            end
            local _curMsgID = getMsgID(i, _curMsgIDLine)
            if _fileName and _curMsgID and #(_curMsgID.."") == 6 then
                local _msg = _fileName..'.'.._curMsgName
                table.insert(_tMsgs, {msgID = _curMsgID, msgName = _curMsgName, note = _note})
            else
                print("error line:", v)
            end

        end
    end

    --******************************************************
    
    local _msgIDMappingMsgProto =''
    local _msgTypeIDMappingMsgID =''

    if EXPORT_SCRIPT_EXTENSION == '.js' then
        _msgIDMappingMsgProto =''
        _msgTypeIDMappingMsgID = ''
    elseif EXPORT_SCRIPT_EXTENSION == '.lua' then
        _msgIDMappingMsgProto ='local _msgType =\n{\n'
        _msgTypeIDMappingMsgID = 'local _msgID =\n{\n'
    end
    print("_tMsgs", #_tMsgs)
    for i, v in ipairs(_tMsgs) do
        local _msgProtoName = _fileName..'.'..v.msgName
        if EXPORT_SCRIPT_EXTENSION == '.js' then
            local _oneMsgCotent = "        cc.GameMsg.MSG_TYPE" .."[ "..v.msgID.." ] = ".."\"".._msgProtoName.."\" "..v.note.."\n"
            _msgIDMappingMsgProto = _msgIDMappingMsgProto .. _oneMsgCotent

        elseif EXPORT_SCRIPT_EXTENSION == '.lua' then
            local _oneMsgCotent = "    [ "..v.msgID.." ] = ".."\"".._msgProtoName.."\", "..v.note.."\n"
            _msgIDMappingMsgProto = _msgIDMappingMsgProto .. _oneMsgCotent
        end

        -- msgTypeCentent
        local _msgID = tonumber(v.msgID)
        local _msgTypeContent = "\n"
        local _msgFromTo = math.floor(_msgID / 100) % 10

        -- 1:Server->Client 2:Client->server
        local _fromtTo = ''
        if _msgFromTo == 1 then
            _fromtTo = 'SC'
        elseif _msgFromTo == 2 then
            _fromtTo = 'CS'
        end

        local _msgFunction = _fileName --string.sub(_fileName, 1, #_fileName - 7)
        if EXPORT_SCRIPT_EXTENSION == '.js' then
            local _msgTypeOneLine = _fromtTo..'_'.._msgFunction..'_'..v.msgName .." = ".._msgID..' '..v.note..'\n'
            _msgTypeOneLine = string.upper(_msgTypeOneLine)
            _msgTypeIDMappingMsgID = _msgTypeIDMappingMsgID.."        cc.GameMsg.MSGID.".._msgTypeOneLine
        elseif EXPORT_SCRIPT_EXTENSION == '.lua' then
            local _msgTypeOneLine = "    ".._fromtTo..'_'.._msgFunction..'_'..v.msgName .." = ".._msgID..', '..v.note..'\n'
            _msgTypeOneLine = string.upper(_msgTypeOneLine)
            _msgTypeIDMappingMsgID = _msgTypeIDMappingMsgID.._msgTypeOneLine
        end
    end

    if EXPORT_SCRIPT_EXTENSION == '.js' then 
        _result = _result.."cc.Class({\n    extends: cc.Component,\n"
        _result = _result.."    init : function(){\n" 
        _result = _result.._msgIDMappingMsgProto.."\n".. _msgTypeIDMappingMsgID.."\n"
        _result = _result.."        cc.log('网络消息编号注册完毕！模块：".._fileName.."')\n    }\n})"
    elseif EXPORT_SCRIPT_EXTENSION == '.lua' then  
        _msgIDMappingMsgProto = _msgIDMappingMsgProto.."}\n"
        _msgTypeIDMappingMsgID = _msgTypeIDMappingMsgID.."}\n"
        _result = _result.._msgIDMappingMsgProto.."\n\n".. _msgTypeIDMappingMsgID..'\nTableMerge(_msgType, MSGTYPE)\nTableMerge(_msgID, MSGID)\n'
    end

    -- output to lua file
    local _scriptName ='Msg_'.._fileName..EXPORT_SCRIPT_EXTENSION
    local _outFile = io.open(EXPORT_DIR.._scriptName, "w")
    _outFile:write(_result)
    return 'Msg_'.._fileName
end

function genMsgForLua()
    print("**********************************************")
    print("\tbuild proto to lua table begin")
    print("**********************************************")
    local _files = getDirFiles(PROTO_DIR, EXTENSION) or {}
    local _requireName = HEADE_TITLE
    local _requireName =  _requireName..'if not MSGID then \n    MSGID = {}\nend\nif not MSGTYPE then \n    MSGTYPE = {}\nend\n'
    for i, v in ipairs(_files) do
        local _fileName = generateProtoForTable(PROTO_DIR.."/"..v..EXTENSION) or ''
        if _fileName and _fileName ~= '' then
            _requireName = _requireName .."Import(\".".._fileName.."\")\n"
        end
        if i == #_files then
            local _outFile = io.open(EXPORT_DIR..'MsgRequire.lua', "w")
            _outFile:write(_requireName)
        end
        print("file count", i)
    end
    print("**********************************************")
    print("\tbuild proto to lua table success")
    print("**********************************************")
end


function genMsgForJs()
    print("**********************************************")
    print("\tbuild proto to js table begin")
    print("**********************************************")
    local _files = getDirFiles(PROTO_DIR, EXTENSION) or {}
    local _requireName = ""
    local _callFunctionStrs = ""
    local _newObjStr = ""
    local _sapce8 = "        "
    for i, v in ipairs(_files) do
        local _fileName = ""
        local _gen_struct = generateProtoForTable(PROTO_DIR.."/"..v..EXTENSION)
        if _gen_struct then
            _fileName = _fileName .. _gen_struct or ''
            if _fileName and _fileName ~= '' then
                _requireName = _requireName .._sapce8.."var ".._fileName.." = require(\"".._fileName.."\")\n"
                _newObjStr = _newObjStr.._sapce8.."var _".. _fileName.." = new ".._fileName.."()\n"
                _callFunctionStrs = _callFunctionStrs.."        _".._fileName..".init()\n"
            end
            if i == #_files then
                local _funcStr = "cc.Class({\n    extends: cc.Component,\n    init: function(){\n"
                _requireName = HEADE_TITLE.."cc.GameMsg = {}\n".."cc.GameMsg.MSGID = {}\n".."cc.GameMsg.MSG_TYPE = {}\n\n".._funcStr.._requireName
                _requireName = _requireName .. "\n".._newObjStr.."\n".._callFunctionStrs.."    }\n})"
                local _outFile = io.open(EXPORT_DIR..'MsgRequire.js', "w")
                _outFile:write(_requireName)
            end
            print("file count", i, #_files)
        else
            print(PROTO_DIR.."/"..v..EXTENSION.. " not find")
        end
    end
    print("**********************************************")
    print("\tbuild proto to js table success")
    print("**********************************************")  
end

if EXPORT_SCRIPT_EXTENSION == '.js' then
    genMsgForJs()
elseif EXPORT_SCRIPT_EXTENSION == '.lua' then
    genMsgForLua()
end