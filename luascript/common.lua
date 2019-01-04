-------------------------------------
--              通用               --
-------------------------------------

local nPluginIDStatus = "66c7d927ed3516f8cfadc2ec"
local nPluginP2P = "c9acd48b7875883527e058d0"

function SetSkipCombatInfo()
	SendNoEcho("set skip_combat 2");
end

function EatAndDrink()
	SendNoEcho("drink hulu");
	SendNoEcho("drink jiudai");
	SendNoEcho("drink soup");
	SendNoEcho("eat doufu");
	SendNoEcho("eat liang");
end

function DropRubbish()
	SendNoEcho("drop shi tan");
	SendNoEcho("drop huo tong");
	SendNoEcho("drop yun tie");
	SendNoEcho("drop xuan bing");
	SendNoEcho("drop shan yin");
end

function GetPluginVariableSave(strID, strKey)
	local strValue = GetPluginVariable(strID, strKey);
	if strValue == nil then strValue = "10000"; end
	return strValue;
end

function GetStatusHP()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "HP"))
end

function GetStatusHPUp()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "HP_UP"))
end

function GetStatusHPMax()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "HP_MAX"))
end

function GetStatusJL()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "JL"))
end

function GetStatusJLUp()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "JL_UP"))
end

function GetStatusJLMax()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "JL_MAX"))
end

function GetStatusNeili()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "NEILI"))
end

function GetStatusNeiliMax()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "NEILI_MAX"))
end

function GetStatusJingli()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "JINGLI"))
end

function GetStatusJingliMax()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "JINGLI_MAX"))
end

function GetStatusFood()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "S_FOOD"))
end

function GetStatusWater()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "S_WATER"))
end

function GetStatusPower()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "S_POWER"))
end

function GetStatusPowerMax()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "S_POWER_MAX"))
end

function GetStatusPot()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "S_POT"))
end

function GetStatusFullmeTime()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "FULLME_TIME"))
end

function Common_StatusClear()
	SetVariable("Q_status", "")
	SetVariable("Q_location", "")
	SetVariable("Q_name", "")
	--SetVariable("Q_misc", "")
	SetVariable("Q_misc2", "")
end

function Common_CorpseCheck(strName)
	SendNoEcho("l corpse")
	--SendNoEcho("get map from corpse")
	SendNoEcho("get gem from corpse")
	--SendNoEcho("get han from corpse")
	--SendNoEcho("get xin from corpse")
	SendNoEcho("get gold from corpse")
	--SendNoEcho("get silver from corpse")
end

local _nums = {};
_nums["一"] = 1;
_nums["二"] = 2;
_nums["三"] = 3;
_nums["四"] = 4;
_nums["五"] = 5;
_nums["六"] = 6;
_nums["七"] = 7;
_nums["八"] = 8;
_nums["九"] = 9;
function StrToNum(str)
	if #str%2 == 1 then
		return 0;
	end
	result = 0;
	wan = 1;
	unit = 1;
	for i = #str-2, 0, -2 do
		char = string.sub(str,i+1,i+2);
		if char == "十" then
			unit = 10 * wan;
			if i == 0 then
				result = result + unit;
			elseif _nums[string.sub(str,i-1,i)] == nil then
				result = result + unit;
			end
		elseif char == "百" then
			unit = 100 * wan;
		elseif char == "千" then
			unit = 1000 * wan;
		elseif char == "万" then
			unit = 10000 * wan;
			wan = 10000;
		else
			if _nums[char] ~= nil then
				result = result + _nums[char] * unit;
			end
		end
	end
	return result;
end

function StrToToward(str)
	if str == "东" then return "east";
	elseif str == "西" then return "west";
	elseif str == "北" then return "north";
	elseif str == "南" then return "south";
	end
	return "l";
end

-------------------------------------
--              通用               --
-------------------------------------
Common = {}
Common.id = GetVariable("ID");

Common.Sell = function(strName)
	local strID = Common.tZiHua[strName];
	if strID then
		SendNoEcho("sell " .. strID);
	end
	SendNoEcho("jianding zi hua");
	SendNoEcho("jianding gu wan");
end

Common.ShowCommand = function(strContent, bContinue)
	SelectCommand();
	PasteCommand(strContent);
	if bContinue == nil then
		SelectCommand();
	end
end

Common.Info = function(strContent, bClear)
	if bClear ~= false then
		InfoClear();
	end
	Info(strContent);
end

Common.Log = function(strContent)
	OpenLog("MyCode/log/" .. Common.id .. os.date("_%m_%d", os.time()) .. ".txt", true);
	WriteLog(os.date("%H:%M:%S", os.time()) .. " " .. GetVariable("Q_name") .. ":\t" .. strContent);
	CloseLog();
end

Common.LogEquip = function(strContent)
	OpenLog("MyCode/log/Equip_" .. Common.id .. os.date("_%m_%d", os.time()) .. ".txt", true);
	WriteLog(os.date("%H:%M:%S ", os.time()) .. strContent);
	CloseLog();
end

Common.strFindID = "";
Common.Location = function(place, id)
--	print("地点:" .. place);
	SetVariable("Q_location", place);
end
Common.SetID = function(id)
	Common.strFindID = id;
end
Common.Find = function(id)
	if id then
		Common.strFindID = id;
		SendNoEcho("group ...");
		SendNoEcho("group find " .. id);
	end
end
Common.FindAgain = function()
	if Common.strFindID then
		SendNoEcho("group ...");
		SendNoEcho("group find " .. Common.strFindID);
		SendNoEcho("helpme ...");
		SendNoEcho("helpme find " .. Common.strFindID);
	end
end
Common.Toward = function()
	SetVariable("Q_misc", GetPluginVariable(nPluginP2P, "fullpath"))
end

Common.CreateAlias = function(strName, strMatch, strAction, nSendto, strGroup, bEnable)
	DeleteAlias(strName)
	if bEnable == nil then bEnable = 1 end
	AddAlias (strName, strMatch, strAction, bEnable +128 + 1024, "")
	if nSendto and type(nSendto) == "number" then
		SetAliasOption ( strName, "send_to", nSendto);
	end
	if strGroup and strGroup ~= "" then
		SetAliasOption (strName, "group", strGroup)
	end
	SetAliasOption (strName, "sequence", 99)
	SetAliasOption (strName, "match", strMatch)
end
Common.CreateTrigger = function(strName, strMatch, strAction, nSendto, strGroup, bEnable, bNoShow, nMultiLine, nLive, nDepth)
	DeleteTrigger(strName)
	local nbNoShow = 0;
	if bEnable == nil then bEnable = 1; end
	if bNoShow == true then nbNoShow = 4; end
	if nDepth == nil then nDepth = 97; end
	if nLive == nil and nLive ~= 0 then nLive = 8; end
	AddTriggerEx(strName, strMatch, strAction, bEnable + nbNoShow + nLive + 32 + 1024, -1, 0, "", "", nSendto, nDepth)
	if nMultiLine and nMultiLine ~= "" then
		SetTriggerOption ( strName, "multi_line", "y");
		SetTriggerOption ( strName, "lines_to_match", nMultiLine);
		SetTriggerOption ( strName, "match", strMatch);
	end
	if strGroup and strGroup ~= "" then
		SetTriggerOption (strName, "group", strGroup)
	end
end
Common.CreateTriggerFunc = function(strName, strMatch, strFunc, strGroup, bEnable, bNoShow, nMultiLine)
	DeleteTrigger(strName)
	local nNoShow = 0;
	if bEnable == nil then bEnable = 1 end
	if bNoShow == true then nNoShow = 4 end
	AddTriggerEx(strName, strMatch, "", bEnable + nNoShow + 8 + 32 + 1024, -1, 0, "", strFunc, 0, 95)
	if nMultiLine and nMultiLine ~= "" then
		SetTriggerOption ( strName, "multi_line", "y");
		SetTriggerOption ( strName, "lines_to_match", nMultiLine);
		SetTriggerOption ( strName, "match", strMatch);
	end
	if strGroup and strGroup ~= "" then
		SetTriggerOption (strName, "group", strGroup)
	end
end
Common.CreateTimer = function(strName, nMin, nSec, strFunc, bOnce, strGroup)
	DeleteTimer(strName);
	AddTimer(strName, 0, nMin, nSec, "", 1025, strFunc);
	if bOnce ~= nil and (bOnce == 1 or bOnce == true) then
		SetTimerOption(strName, "one_shot", true);
	end
	if strGroup ~= nil then
		SetTimerOption(strName, "group", strGroup);
	end
end
Common.CreateTimerFunc = function(strName, nMin, nSec, strFunc, bOnce, strGroup)
	DeleteTimer(strName);
	AddTimer(strName, 0, nMin, nSec, strFunc, 1025, "");
	SetTimerOption(strName, "send_to", 12);
	if bOnce ~= nil and (bOnce == 1 or bOnce == true) then
		SetTimerOption(strName, "one_shot", true);
	end
	if strGroup ~= nil then
		SetTimerOption(strName, "group", strGroup);
	end
end

Common.RbzENG = {"finger", "neck", "sword", "blade", "whip", "dagger", "armor", "boots", "cloth", "hands", "head", "shield", "surcoat", "waist", "wrists"};
Common.RBZList = function()
	EnableTrigger("rbz_check", true);
	for i = 1, table.getn(Common.RbzENG) do
		SendNoEcho("list " .. Common.RbzENG[i]);
	end
	DoAfterSpecial(30, 'EnableTrigger("rbz_check", false)', 12);
end
Common.RBZCheck = function(strID, strType, strNum)
	if strNum == "?" then return; end
	local nNum = tonumber(strNum);
	if strType == "ring" or strType == "necklace" then
		if nNum >= 2 then
			Send("buy " .. strID);
		end
	else
		if nNum >= 3 then
			Send("buy " .. strID);
		end
	end
end

Common.canSleep = true;
Common.timerName = "SleepCheck";
Common.SleepOverCallback = nil;
Common.SleepOver = function()
	Common.canSleep = false;
--	SendNoEcho("drink jiang");
--	Common.CreateTimer(Common.timerName, 0, 50, "Common.SleepTime");
	if Common.SleepOverCallback ~= nil then
		Common.SleepOverCallback();
	end
end
Common.SleepTime = function()
	Common.canSleep = true;
--	DeleteTimer(Common.timerName);
end

Common.RestoreLJ = function()
	SendNoEcho("yun regenerate");
end

Common.RestoreHP = function()
	SendNoEcho("yun recover");
end
Common.CreateAlias("alias_fill", "FW", 'Execute("s;s;w;drink");Common.FillWater()', 12, "triggers");
Common.CreateTrigger("common_fill", "^你将\\S+装满清水。$", 'Common.FillWater()', 12, "common");
Common.GetAll = function()
	SendNoEcho("get all");
	--DoAfterSpecial(2, "e;n;n", 10);
end
Common.FillWater = function()
	DeleteTimer("common_fill_timer");
	Common.CreateTimer("common_fill_timer", 0, 1, "Common.GetAll", true);
	SendNoEcho("fill hulu");
	SendNoEcho("drop hulu");
	SendNoEcho("fill skin");
	SendNoEcho("drop skin");
	SendNoEcho("fill soup");
	SendNoEcho("drop soup");
end

Common.TableIndex = function(tTable, unvoid)
	for i = 1, #tTable do
		if unvoid == tTable[i] then
			return i;
		end
	end
	return nil;
end
Common.TableAdd = function(tTable, strFunc)
	if Common.TableIndex(tTable, strFunc) == nil then
		table.insert(tTable, strFunc);
	end
end
Common.TableDel = function(tTable, strFunc)
	local index = Common.TableIndex(tTable, strFunc);
	if index ~= nil then
		table.remove(tTable, index);
	end
end

Common.CloseAllGroup = function()
	--Note("触发全关");
	for i = 1, #Common.tQuest do
		EnableGroup(Common.tQuest[i], false);
	end
	DeleteTrigger("gsz_record");
	Battle.SetOnePfm(false);
	Battle.AddPower(0);
end

Common.Split = function (str, delim, maxNb)   
	if str~=nil and str~="" then
		if string.find(str, delim) == nil then  
			return { str }  
		end  
		if maxNb == nil or maxNb < 1 then  
			maxNb = 0    -- No limit   
		end  
		local result = {}  
		local pat = "(.-)" .. delim .. "()"   
		local nb = 0  
		local lastPos   
		for part, pos in string.gmatch(str, pat) do  
			nb = nb + 1  
			result[nb] = part   
			lastPos = pos   
			if nb == maxNb then 
				break 
			end  
		end   
		if nb ~= maxNb then  
			result[nb + 1] = string.sub(str, lastPos)   
		end
		return result   
	else
		return {}
	end
end

Common.tInstanceVoid = {};
Common.InstanceRun = function(pVoid, nTime, vParam)
	local strKey = tostring(pVoid);
	if strKey == nil or strKey == "" then return false; end
	if Common.tInstanceVoid[strKey] ~= nil then return false; end
	if nTime == nil then nTime = 2; end
	Common.tInstanceVoid[strKey] = 1;
	pVoid(vParam);
	DoAfterSpecial(nTime, "Common.InstanceReset(\"" .. strKey .. "\")", 12);
	return true;
end
Common.InstanceRunLater = function(strVoid, nTime, strParam)
	if strVoid == nil or strVoid == "" then return false; end
	if Common.tInstanceVoid[strVoid] ~= nil then return false; end
	if nTime == nil then nTime = 2; end
	if strParam == nil then strParam = ""; end
	Common.tInstanceVoid[strVoid] = 1;
	DoAfterSpecial(nTime, strVoid .. "(" .. strParam .. ")", 12);
	DoAfterSpecial(nTime, "Common.InstanceReset(\"" .. strVoid .. "\")", 12);
	return true;
end
Common.InstanceReset = function(strKey)
	if strKey == nil or strKey == "" then return; end
	Common.tInstanceVoid[strKey] = nil;
end

Common.tRunWithNoMsg = {};
Common.tRunWithNoMsgAction = {};
Common.RunWithNoMsg = function(strVoid, strContent, strAction)
	if Common.tRunWithNoMsg[strVoid] ~= nil then return; end
	Common.tRunWithNoMsg[strVoid] = strContent;
	Common.tRunWithNoMsgAction[strVoid] = strAction;
	DoAfterSpecial(1, "Execute(strAction)", 12);
	Common.CreateTimer("RunWithNoMsg_" .. strVoid, 0, 2, strVoid, true);
	Common.CreateTimer("RunWithNoMsgAction_" .. strVoid, 0, 2, "Common.RunWithNoMsgAction(" .. strVoid .. ")", true);
	Common.CreateTrigger("RunWithNoMsgTrigger_" .. strVoid, "^".. strContent .. "$", "Common.RunWithNoMsgCancel(" .. strVoid .. ")", 12, "jiang", 1);
end
Common.RunWithNoMsgAction = function(strVoid)
	Common.tRunWithNoMsg[strVoid] = nil;
	DeleteTrigger("RunWithNoMsgTrigger_" .. strVoid);
end
Common.RunWithNoMsgCancel = function(strVoid)
	DeleteTimer("RunWithNoMsg_" .. strVoid);
	Common.RunWithNoMsg(strVoid, Common.tRunWithNoMsg[strVoid], Common.tRunWithNoMsgAction[strVoid]);
end

Common.Look = function()
	SendNoEcho("l");
end

Common.CheckBusy = function()
	Common.InstanceRun(Common.CheckBusyAction, 1);
end

Common.CheckBusyAction = function()
	SendNoEcho("checkbusy");
end

-------------------------------------
--              气精               --
-------------------------------------
YunQiJing = {}
YunQiJing.qi = 0
YunQiJing.jing = 0
YunQiJing.Qi = function()
	EnableTrigger("yunqijing", YunQiJing.qi == 0);
	YunQiJing.qi = 1 - YunQiJing.qi;
	if YunQiJing.qi == 1 then
		print("运气:开");
		SendNoEcho("yun qi");
		YunQiJing.jing = 0;
	else
		print("运气:关");
	end
end
YunQiJing.ForceQi = function()
	print("运气:开");
	EnableTrigger("yunqijing", true);
	YunQiJing.qi = 1;
	YunQiJing.jing = 0;
	SendNoEcho("yun qi");
end
YunQiJing.Jing = function()
	EnableTrigger("yunqijing", YunQiJing.jing == 0);
	YunQiJing.jing = 1 - YunQiJing.jing;
	if YunQiJing.jing == 1 then
		print("运精:开");
		SendNoEcho("yun jing");
		YunQiJing.qi = 0;
	else
		print("运精:关");
	end
end
YunQiJing.Action = function()
	if YunQiJing.qi == 1 then
		SendNoEcho("yun qi")
	elseif YunQiJing.jing == 1 then
		SendNoEcho("yun jing")
	end
end


------------------------------------------
-- triggers
Common.CreateTrigger("SleepTrigger", "^你一觉醒来，精神抖擞地活动了几下手脚。$", "Common.SleepOver()", 12, "common");
Common.CreateTrigger("JiandingZihua", "^你发现手中的竟是(.*)。$", 'Common.Sell("%1")', 12, "common");