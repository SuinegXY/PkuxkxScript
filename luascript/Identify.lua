----------------------
--����������
--Code by Suineg
--Version:1.0.0
--Data:20180801
----------------------

SendNoEcho("nick ������$HIY$Tell�к�$NOR$,����ʱ�ٸ�װ������,������޷���");

--------------
--  ������  --
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
--   ����   --
--------------
Identify = {};
Identify.tID = {};
Identify.tIDToList = {};
Identify.tListToID = {};
Identify.nListNow = 0;
Identify.nListOrder = 0;
Identify.nOrderNum = 0;
Identify.nOrderMax = 0;
Identify.EquipCHS = {"����", "����", "�ȼ�", "����", "���", "��ָ", "����", "��", "��", "��", "��", "��", "ǹ", "��", "�", "ذ", "��", "ѥ", "��", "����", "��", "��", "����", "����", "����", "��", "��", "��"};
Identify.EquipENG = {"huxin", "hujian", "tuijia", "hutui", "mask", "ring", "necklace", "sword", "blade", "staff", "whip", "axe", "spear", "hammer", "halberd", "dagger", "armor", "boots", "cloth", "hushou", "armet", "shield", "cape", "belt", "huwan", "needle", "flute", "hook"};
Identify.bTimer = false;
Identify.strName = "";
Identify.strItem = "";
Identify.strEquipBuffer = "";

Common.CreateTrigger("Identify_Start", "^������(\\S+)������������ϸϸ�Ĵ�����һ��.*��$", 'Identify.IdentifyStart("%1")', 12, "Identify", 1);
Common.CreateTrigger("Identify_Log", "^(.*)$", 'Identify.Log("%1")', 12, "Identify", 0);
Common.CreateTrigger("Identify_Get", "^(\\S+)����һ\\S{2}(\\S+)��$", 'Identify.Get("%1", "%2")', 12, "Identify", 1);
Common.CreateTrigger("Identify_CallList", "^(\\S+)\\((\\S+)\\)�����㣺�к�$", 'Identify.CallList("%1", "%2")', 12, "Identify", 1);


Common.Log = function(strContent)
	OpenLog("log/Identify" .. os.date("_%m_%d", os.time()) .. ".txt", true);
	WriteLog(os.date("%H:%M:%S\t", os.time()) .. Identify.strName .. ":\t" .. strContent);
	CloseLog();
end

Identify.Get = function(strName, strItem)
	if strName ~= Identify.tID[Identify.tListToID[Identify.nListNow]] then
		SendNoEcho("say " .. strName .. ",���Ծ��к�,��Ҫ���");
		SendNoEcho("say �����ݲ�֧�ֹ黹��Ʒ");
		Identify.strName = "���";
		Common.Log(strName .. "\t" .. strItem);
	elseif Identify.strEquipBuffer == "" then
		Identify.strName = strName;
		Identify.strItem = Common.Identify(strItem);
		if Identify.strItem == nil then
			SendNoEcho("say " .. strName .. ",ֻ������ְҵװ��������");
			Common.Log("��ʶ��:" .. strItem);
		else
			SendNoEcho("say " .. strName .. "���յ�,1��󷵻�,��ʱ�����벻Ҫ�ٸ�����");
			DoAfterSpecial(1, 'SendNoEcho("give " .. Identify.tListToID[Identify.nListNow] .. " " .. Identify.strItem);Identify.strItem= "";', 12);
		end
	else
		SendNoEcho("say " .. strName .. "������̫��,��ʱ�޷��黹");
		Identify.strName = "��̫��";
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
		SendNoEcho("say " .. strName .. "�ź�:" .. Identify.nOrderMax .. " / ��ǰ����:" .. Identify.nOrderNum);
		Identify.TimerCreate();
	else
		SendNoEcho("tell " .. strID .. " �벻Ҫ�ظ��к�");
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
		SendNoEcho("say " .. Identify.tID[Identify.tListToID[Identify.nListNow]] .. "ʱ�䵽,�������ź�");
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
	SendNoEcho("say ��ǰ�ź�" .. Identify.nOrderNum .. ":" .. Identify.tID[Identify.tListToID[Identify.nListNow]] .. "����10������ǰ��װ������");
	DoAfterSpecial(7, 'SendNoEcho("say " .. Identify.tID[Identify.tListToID[Identify.nListNow]] .. "����3��ʱ�䵽,Ϊ��ֹ��ʱ,��ֹͣ��װ�����ҵ�ʱ�䵽������к�");', 12);
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
			Note("��ʼ����:" .. strName .. ":" .. Identify.strEquipBuffer);
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
			Identify.strImportant = "\t�߼�����";
		end
	else
		if nNumber >= 3 then
			SendNoEcho("put " .. Identify.strEquipBuffer .. " in bao fu");
			Identify.strImportant = "\t�߼�װ��";
		end
	end
	DeleteTrigger("item_kong");
end

Identify.Damage = function(nDamage, strType)
	if Identify.strEquipNameBuffer == "" then return; end
	if Identify.strEquipBuffer ~= "armor" and Identify.strEquipBuffer ~= "shield" and nDamage > 210 then
		SendNoEcho("put " .. Identify.strEquipBuffer .. " in bao fu 2");
		Identify.strImportant = "\t�߹�����";
	end
	Identify.Log("\t" .. Identify.strEquipNameBuffer .. "\t��:" .. Identify.nKong .. "\t" .. strType .. ":" .. nDamage .. Identify.strImportant);
	Identify.strEquipNameBuffer = "";
end

Identify.IdentifyEnd = function()
	if Identify.strEquipNameBuffer == "" then return; end
	Identify.Log("\t" .. Identify.strEquipNameBuffer .. "\t��:" .. Identify.nKong);
	Identify.strEquipNameBuffer = "";
end

Identify.IdentifyStart = function(strName)
	--Note("��ʼ����:" .. strName .. "-" .. Identify.strEquipNameBuffer);
	if strName == Identify.strEquipNameBuffer then
		Identify.strLogContent = "";
		EnableTrigger("Identify_Log", true);
	end
end

Identify.Log = function(strContent)
	if string.find(strContent, "��") == 1 then
		return;
	elseif string.find(strContent, " ") == 1 or string.find(strContent, "��") == 1 or string.find(strContent, "��") == 1 or string.find(strContent, "��") == 1 or string.find(strContent, "��") == 1 or string.find(strContent, "=") == 1 then
		strContent = Replace(strContent, "=", "", ture);
		strContent = Replace(strContent, " ", "", ture);
		strContent = Replace(strContent, "��װ��������", "", ture);
		strContent = Replace(strContent, "��װ������:", "Lv", ture);
		strContent = Replace(strContent, "����", ":", ture);
		strContent = Replace(strContent, "ְҵװ��", "", ture);
		strContent = Replace(strContent, "װ��)��", "", ture);
		strContent = Replace(strContent, "����λ��:", "", ture);
		strContent = Replace(strContent, "���������(", "", ture);
		strContent = Replace(strContent, "(0)", " ", ture);
		strContent = Replace(strContent, "��������", "", ture);
		strContent = Replace(strContent, "��", "", ture);
		strContent = Replace(strContent, "��̶����ԣ�", "", ture);
		strContent = Replace(strContent, "�̬���ԣ�", "", ture);
		strContent = Replace(strContent, "�̬����(�����޹�)��", "", ture);
		if strContent ~= "" then
			Identify.strLogContent = Identify.strLogContent .. strContent .. "\t";
		end
		if string.find(strContent, "ѥ") or string.find(strContent, "��") or string.find(strContent, "��") then
			Identify.strLogContent = Identify.strLogContent .. "\t";
		end
	elseif strContent ~= "" then
		--Note("�ر�");
		Identify.strEquipBuffer = "";
		Identify.strEquipNameBuffer = "";
		EnableTrigger("Identify_Log", false);
		if string.find(Identify.strLogContent, "Lv") then
			Common.Log(Identify.strLogContent);
			Identify.strLogContent = "";
		end
	end
end