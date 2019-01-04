-------------------------------------
--ʹ��˵��:
--Code by ������
--���ڲ��Ժ��ڲ��Եص��޷��ڳ���,����Ҫ�����һ���ڿ�ɹ��Ĵ���,����ִ��Execute("MINE")����
--Mine.Start������Ҫ�Լ���ӿ�ɽ�Թ���ڼ����Թ�����
--����MINE��ʼ�ڿ�
--����MINESֹͣ�ڿ�(ʵ����S���Ի��������ַ�)
-------------------------------------


-------------------------------------
--            �������             --
-------------------------------------

Common = Common or {};

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

Common.CreateTimer = function(strName, nMin, nSec, strFunc, bOnce)
	DeleteTimer(strName);
	AddTimer(strName, 0, nMin, nSec, "", 1025, strFunc);
	if bOnce ~= nil then
		 SetTimerOption(strName, "one_shot", true);
	end
end

-------------------------------------
--              �ڿ�               --
-------------------------------------

Mine = {};
Mine.strPlace = "";
Mine.strExit = "";
Mine.nXSelf = 0;
Mine.nYSelf = 0;
Mine.nXMine = 0;
Mine.nYMine = 0;
Mine.nDigit = 0;
Mine.nRecordDigit = 0;

Common.CreateAlias("mine_alias", "^MINE(.{0,1})$", 'Mine.Init("%1");', 12, "triggers");
Common.CreateTrigger("mine_place", "^(\\S+) - $", 'Mine.strPlace = "%1"', 12, "mine", 0);
Common.CreateTrigger("mine_exit", "^\\s+����(����|Ψһ)�ķ�����(.*)$", 'Mine.ExitGet("%2")', 12, "mine", 0);
Common.CreateTrigger("mine_find", "^�����п�������ڵ��¡�$", 'Mine.Find()', 12, "mine", 0);
Common.CreateTrigger("mine_continue1", "^����\\S+�߼�����Ѱ��$", 'Mine.RecordStart()', 12, "mine", 0);
Common.CreateTrigger("mine_continue2", "^������������һ�Ρ�$", 'DoAfterSpecial(1, "Mine.Dig()", 12)', 12, "mine", 0);
Common.CreateTrigger("mine_over1", "^����\\S+�Ŀ���￪�ɵ���һЩ\\S+��$", 'DoAfterSpecial(1, "Mine.Dig()", 12)', 12, "mine", 0);
Common.CreateTrigger("mine_over2", "^�����\\S+�Ŀ���Ѿ��������ˣ�Ҳ����Ҫ���Կ��ɱ�ġ�$", 'DoAfterSpecial(1, "MINE", 10)', 12, "mine", 0);
Common.CreateTrigger("mine_error3", "^�����кܶ�\\S+�Ŀ�أ�����������Ĳɿ���������ֻ��������Ե���ˡ�$", 'DoAfterSpecial(1, "Mine.Dig()", 12)', 12, "mine", 0);
Common.CreateTrigger("mine_error1", "^û�����£����ܲ����������ڰɣ�$", 'Mine.RecordOver()', 12, "mine", 0);
Common.CreateTrigger("mine_error2", "^��һ������\\S+���߹�ȥ��$", 'DoAfterSpecial(1, "Mine.Action()", 12)', 12, "mine", 0);

DeleteTimer("Mine_Start");
DeleteTrigger("Mine_Record");
DeleteTrigger("mine_over");

Mine.Init = function(strParam)
	if strParam == nil or strParam == "" then
		Note("�ڿ�ʼ");
		DeleteTrigger("Mine_Record");
		EnableGroup("mine", true);
		Common.CreateTimer("Mine_Start" , 0, 2, "Mine.Start");
	else
		Note("�ڿ����");
		EnableGroup("mine", false);
		DeleteTimer("Mine_Start");
	end
end

Mine.Start = function()
	if Mine.strPlace == "" then
		SendNoEcho("l");
	elseif Mine.strPlace == "����ɽ��" then
		Execute("south;l");
	elseif Mine.strPlace == "����ɽ��´" then
		Execute("east;l");
	elseif Mine.strPlace == "����ɽ��B" then
		Execute("north;l");
	else
		Execute(Mine.strExit .. ";l");
	end
end

Mine.Find = function()
	Mine.RecordStart();
	DeleteTimer("Mine_Start");
	SendNoEcho("unwield all");
	SendNoEcho("wield tie qiao");
	Common.CreateTimer("Mine_Dig" , 0, 1, "Mine.Dig", true);
end

Mine.Action = function()
	if Mine.nXSelf < Mine.nXMine then
		SendNoEcho("shift right");
	elseif Mine.nXSelf > Mine.nXMine then
		SendNoEcho("shift left");
	else
		SendNoEcho("excavate");
	end
end

Mine.Dig = function()
	SendNoEcho("excavate");
end

Mine.RecordStart = function()
	Mine.nRecordDigit = 0;
	Mine.nDigit = 0;
	Mine.nXSelf = 0;
	Mine.nYSelf = 0;
	Mine.nXMine = 0;
	Mine.nYMine = 0;
	Common.CreateTriggerFunc("Mine_Record", "^.*$", "Mine.Record", "mine");
end

Mine.RecordOver = function()
	DeleteTrigger("Mine_Record");
	Mine.Action();
end

Mine.Record = function(strName, strLine, tWord, tStyles)
	if strLine == "" then
		Mine.nRecordDigit = Mine.nRecordDigit + 1;
		if Mine.nRecordDigit == 2 then
			Mine.RecordOver();
		end
		return;
	end
	Mine.nDigit = Mine.nDigit + 1;
	local nIndex = string.find(strLine, "��");
	if nIndex ~= nil then
		Mine.nXMine = nIndex;
		Mine.nYMine = Mine.nDigit;
	end
	local strBuffer = GetLinesInBufferCount();
	local nLen = GetLineInfo(strBuffer, 11);
	local tBuffer = {};
	local nLength = 0;
	if Mine.nXSelf == 0 then
		for i = 1,nLen do
			if Mine.nXSelf == 0 then
				local strWord = GetStyleInfo(strBuffer, i, 1);
				local nColor = GetStyleInfo(strBuffer, i, 14);
				if nColor == 16776960 then
					Mine.nXSelf = nLength + 1;
					Mine.nYSelf = Mine.nDigit;
				else
					nLength = nLength + string.len(strWord);
				end
			end
		end
	end
end

Mine.ExitGet = function(strExit)
        strExit = Replace(strExit, "��", ";", ture);
	strExit = Replace(strExit, " �� ", ";", ture);
	strExit = Replace(strExit, "��", ";", ture);
        strExit = Replace(strExit, " ", "", ture);
	strExit = string.sub(strExit, 0, string.find(strExit, ";")-1);
        local tFullExits = {"up", "down", "south", "east", "west", "north", "southup", "southdown", "westup", "westdown",
		"eastup", "eastdown", "northup", "northdown", "northwest", "northeast", "southwest", "southeast", "enter", "out"};
        for i = 1, table.getn(tFullExits) do
	     if string.len(tFullExits[i]) == string.len(strExit) then
		   local strRightExit = tFullExits[i];
		   local strCheckExit = strExit;
		   for o = 1,string.len(strRightExit) do
			if string.find(strRightExit, string.sub(strExit, o, o)) then
			      strCheckExit = string.gsub(strCheckExit, string.sub(strExit,o,o), "");
			end
		   end
		   if strCheckExit == "" then
			Mine.strExit = strRightExit;
			return;
		   end
	     end
        end
end

Mine.Error = function()
	DeleteTrigger("Mine_Record");
	Note("====================");
	Note("==�˴��ڿ�ȼ�����==");
	Note("====================");
end

Note("�ڿ�ű��������");