----------------------
--鉴定机器人
--Code by Suineg
--Version:1.0.0
--Data:20180801
----------------------

SendNoEcho("nick 鉴定先$HIY$Tell叫号$NOR$,到号时再给装备鉴定,错给暂无法还");

--------------
--  公共库  --
--------------
Common = Common or {};
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

--------------
--   鉴定   --
--------------
Identify = {};
Identify.tID = {};
Identify.tIDToList = {};
Identify.tListToID = {};
Identify.nListNow = 0;
Identify.nListOrder = 0;
Identify.nOrderNum = 0;
Identify.nOrderMax = 0;
Identify.EquipCHS = {"护心", "护肩", "腿甲", "护腿", "面具", "戒指", "项链", "剑", "刀", "杖", "鞭", "斧", "枪", "锤", "戟", "匕", "甲", "靴", "袍", "护手", "盔", "盾", "披风", "腰带", "护腕", "针", "箫", "钩"};
Identify.EquipENG = {"huxin", "hujian", "tuijia", "hutui", "mask", "ring", "necklace", "sword", "blade", "staff", "whip", "axe", "spear", "hammer", "halberd", "dagger", "armor", "boots", "cloth", "hushou", "armet", "shield", "cape", "belt", "huwan", "needle", "flute", "hook"};
Identify.bTimer = false;
Identify.strName = "";
Identify.strItem = "";
Identify.strEquipBuffer = "";

Common.CreateTrigger("Identify_Start", "^你捧着(\\S+)上上下下仔仔细细的打量了一遍.*。$", 'Identify.IdentifyStart("%1")', 12, "Identify", 1);
Common.CreateTrigger("Identify_Log", "^(.*)$", 'Identify.Log("%1")', 12, "Identify", 0);
Common.CreateTrigger("Identify_Get", "^(\\S+)给你一\\S{2}(\\S+)。$", 'Identify.Get("%1", "%2")', 12, "Identify", 1);
Common.CreateTrigger("Identify_CallList", "^(\\S+)\\((\\S+)\\)告诉你：叫号$", 'Identify.CallList("%1", "%2")', 12, "Identify", 1);


Common.Log = function(strContent)
	OpenLog("log/Identify" .. os.date("_%m_%d", os.time()) .. ".txt", true);
	WriteLog(os.date("%H:%M:%S\t", os.time()) .. Identify.strName .. ":\t" .. strContent);
	CloseLog();
end

Identify.Get = function(strName, strItem)
	if strName ~= Identify.tID[Identify.tListToID[Identify.nListNow]] then
		SendNoEcho("say " .. strName .. ",请自觉叫号,不要插队");
		SendNoEcho("say 机器暂不支持归还物品");
		Identify.strName = "插队";
		Common.Log(strName .. "\t" .. strItem);
	elseif Identify.strEquipBuffer == "" then
		Identify.strName = strName;
		Identify.strItem = Common.Identify(strItem);
		if Identify.strItem == nil then
			SendNoEcho("say " .. strName .. ",只接受新职业装备和武器");
			Common.Log("不识别:" .. strItem);
		else
			SendNoEcho("say " .. strName .. "已收到,1秒后返回,这时间内请不要再给东西");
			DoAfterSpecial(1, 'SendNoEcho("give " .. Identify.tListToID[Identify.nListNow] .. " " .. Identify.strItem);Identify.strItem= "";', 12);
		end
	else
		SendNoEcho("say " .. strName .. "东西给太快,暂时无法归还");
		Identify.strName = "给太快";
		Common.Log(strName .. ":" .. strItem);
	end
end

Identify.CallList = function(strName, strID)
	Identify.tID[strID] = strName;
	if Identify.tIDToList[strID] == nil then
		Identify.nListOrder = Identify.nListOrder + 1;
		if Identify.nListOrder > 100 then
			Identify.nListOrder = Identify.nListOrder - 100;
		end
		Identify.nOrderMax = Identify.nOrderMax + 1;
		Identify.tIDToList[strID] = Identify.nListOrder;
		Identify.tListToID[Identify.nListOrder] = strID;
		SendNoEcho("say " .. strName .. "排号:" .. Identify.nOrderMax .. " / 当前号码:" .. Identify.nOrderNum);
		Identify.TimerCreate();
	else
		SendNoEcho("tell " .. strID .. " 请不要重复叫号");
	end
end

Identify.TimerCreate = function()
	if Identify.bTimer == false then
		Identify.bTimer = true;
		Identify.TimerEvent();
		Common.CreateTimer("Identify_TimerEvent", 0, 10, "Identify.TimerEvent");
	end
end

Identify.TimerClose = function()
	if Identify.bTimer == true then
		Identify.bTimer = false;
		DeleteTimer("Identify_TimerEvent");
	end
end

Identify.TimerEvent = function()
	if Identify.tListToID[Identify.nListNow] ~= nil then
		SendNoEcho("say " .. Identify.tID[Identify.tListToID[Identify.nListNow]] .. "时间到,请重新排号");
		Identify.tID[Identify.tListToID[Identify.nListNow]] = nil;
		Identify.tIDToList[Identify.tListToID[Identify.nListNow]] = nil;
		Identify.tListToID[Identify.nListNow] = nil;
	end
	if Identify.nListNow == Identify.nListOrder then
		Identify.TimerClose();
		return;
	end
	Identify.nListNow = Identify.nListNow + 1;
	if Identify.nListNow > 100 then
		Identify.nListNow = Identify.nListNow - 100;
	end
	Identify.nOrderNum = Identify.nOrderNum + 1;
	SendNoEcho("say 当前排号" .. Identify.nOrderNum .. ":" .. Identify.tID[Identify.tListToID[Identify.nListNow]] .. "请在10秒内上前给装备鉴定");
	DoAfterSpecial(7, 'SendNoEcho("say " .. Identify.tID[Identify.tListToID[Identify.nListNow]] .. "还有3秒时间到,为防止到时,请停止给装备并且等时间到后继续叫号");', 12);
end
Identify.TimerClose();

Common.Identify = function(strName)
	Identify.strImportant = "";
	Identify.strEquipBuffer = "";
	Identify.strEquipNameBuffer = "";
	for i = 1, table.getn(Identify.EquipCHS) do
		if string.find(strName, Identify.EquipCHS[i]) then
			Identify.strEquipBuffer = Identify.EquipENG[i];
			Identify.strEquipNameBuffer = strName;
			SendNoEcho("jianding " .. Identify.EquipENG[i]);
			Note("开始鉴定:" .. strName .. ":" .. Identify.strEquipBuffer);
			return Identify.strEquipBuffer;
		end
	end
end

Identify.Kong = function(nNumber)
	if Identify.strEquipNameBuffer == "" then return; end
	DeleteTrigger("item_kong");
	Identify.nKong = nNumber;
	if Identify.strEquipBuffer == "ring" or Identify.strEquipBuffer == "necklace" then
		if nNumber >= 2 then
			SendNoEcho("put " .. Identify.strEquipBuffer .. " in bao fu");
			Identify.strImportant = "\t高级首饰";
		end
	else
		if nNumber >= 3 then
			SendNoEcho("put " .. Identify.strEquipBuffer .. " in bao fu");
			Identify.strImportant = "\t高级装备";
		end
	end
	DeleteTrigger("item_kong");
end

Identify.Damage = function(nDamage, strType)
	if Identify.strEquipNameBuffer == "" then return; end
	if Identify.strEquipBuffer ~= "armor" and Identify.strEquipBuffer ~= "shield" and nDamage > 210 then
		SendNoEcho("put " .. Identify.strEquipBuffer .. " in bao fu 2");
		Identify.strImportant = "\t高攻武器";
	end
	Identify.Log("\t" .. Identify.strEquipNameBuffer .. "\t孔:" .. Identify.nKong .. "\t" .. strType .. ":" .. nDamage .. Identify.strImportant);
	Identify.strEquipNameBuffer = "";
end

Identify.IdentifyEnd = function()
	if Identify.strEquipNameBuffer == "" then return; end
	Identify.Log("\t" .. Identify.strEquipNameBuffer .. "\t孔:" .. Identify.nKong);
	Identify.strEquipNameBuffer = "";
end

Identify.IdentifyStart = function(strName)
	--Note("开始鉴定:" .. strName .. "-" .. Identify.strEquipNameBuffer);
	if strName == Identify.strEquipNameBuffer then
		Identify.strLogContent = "";
		EnableTrigger("Identify_Log", true);
	end
end

Identify.Log = function(strContent)
	if string.find(strContent, "【") == 1 then
		return;
	elseif string.find(strContent, " ") == 1 or string.find(strContent, "☆") == 1 or string.find(strContent, "★") == 1 or string.find(strContent, "◇") == 1 or string.find(strContent, "◎") == 1 or string.find(strContent, "=") == 1 then
		strContent = Replace(strContent, "=", "", ture);
		strContent = Replace(strContent, " ", "", ture);
		strContent = Replace(strContent, "◎装备条件：", "", ture);
		strContent = Replace(strContent, "可装备级别:", "Lv", ture);
		strContent = Replace(strContent, "仅限", ":", ture);
		strContent = Replace(strContent, "职业装备", "", ture);
		strContent = Replace(strContent, "装备)：", "", ture);
		strContent = Replace(strContent, "铭文位置:", "", ture);
		strContent = Replace(strContent, "◇基本属性(", "", ture);
		strContent = Replace(strContent, "(0)", " ", ture);
		strContent = Replace(strContent, "【基础】", "", ture);
		strContent = Replace(strContent, "无", "", ture);
		strContent = Replace(strContent, "★固定属性：", "", ture);
		strContent = Replace(strContent, "☆动态属性：", "", ture);
		strContent = Replace(strContent, "☆动态属性(暗淡无光)：", "", ture);
		if strContent ~= "" then
			Identify.strLogContent = Identify.strLogContent .. strContent .. "\t";
		end
		if string.find(strContent, "靴") or string.find(strContent, "袍") or string.find(strContent, "盔") then
			Identify.strLogContent = Identify.strLogContent .. "\t";
		end
	elseif strContent ~= "" then
		--Note("关闭");
		Identify.strEquipBuffer = "";
		Identify.strEquipNameBuffer = "";
		EnableTrigger("Identify_Log", false);
		if string.find(Identify.strLogContent, "Lv") then
			Common.Log(Identify.strLogContent);
			Identify.strLogContent = "";
		end
	end
end