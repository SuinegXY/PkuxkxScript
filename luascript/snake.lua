-----------------------------------------------------------------------------
--����ץ�߽ű� ˵��:
--1.����GPS����,���û�п��ֶ��޸�·�����
--2.�ߵ�id��Ҫ�Լ��ڱ��ﲹ��,����
--3.�����ж��õ���SNAKE_OVERϵ�д���,û�����ḻ����,�����������������Լ�����
--4.ʹ�÷���:requiry���ļ�,��ֱ�����ñ��ű�
--5.���߳���SNAKE��ʼ,��SNAKEX����
--6.����:������(suineg)
-----------------------------------------------------------------------------


-------------------------------------
--            ͨ��ģ��             --
-------------------------------------

Common = Common or {};

Common.StrToNum = Common.StrToNum or function(strContent)
	local _nums = {}
	_nums["һ"] = 1;
	_nums["��"] = 2;
	_nums["��"] = 3;
	_nums["��"] = 4;
	_nums["��"] = 5;
	_nums["��"] = 6;
	_nums["��"] = 7;
	_nums["��"] = 8;
	_nums["��"] = 9;
	if (#strContent % 2) == 1 then
		return 0;
	end
	nResult = 0;
	WAN = 1;
	UNIT = 1;
	for i = #strContent -2 , 0, -2 do
		szChar = string.sub(strContent, i+1, i+2);
		if szChar == "ʮ" then
			UNIT = 10 * WAN;
			if i == 0 then
				nResult = nResult + UNIT;
			elseif _nums[string.sub(strContent, i-1, i)] == nil then
				nResult = nResult + UNIT;
			end
		elseif szChar == "��" then
			UNIT = 100 * WAN;
		elseif szChar == "ǧ" then
			UNIT = 1000 * WAN;
		elseif szChar == "��" then
			UNIT = 10000 * WAN;
			WAN = 10000;
		else
			if _nums[szChar] ~= nil then
				nResult = nResult + _nums[szChar] * UNIT;
			end
		end
	end
	return nResult;
end

Common.CreateTrigger = Common.CreateTrigger or function(strName, strMatch, strAction, nSendto, strGroup, bEnable, bNoShow, nMultiLine)
	DeleteTrigger(strName)
	local nbNoShow = 0;
	if bEnable == nil then bEnable = 1 end
	if bNoShow == true then nbNoShow = 4 end
	AddTriggerEx(strName, strMatch, strAction, bEnable + nbNoShow + 8 + 32 + 1024, -1, 0, "", "", nSendto, 97)
	if nMultiLine and nMultiLine ~= "" then
		SetTriggerOption ( strName, "multi_line", "y");
		SetTriggerOption ( strName, "lines_to_match", nMultiLine);
		SetTriggerOption ( strName, "match", strMatch);
	end
	if strGroup and strGroup ~= "" then
		SetTriggerOption (strName, "group", strGroup)
	end
end

Common.CreateAlias = Common.CreateAlias or function(strName, strMatch, strAction, nSendto, strGroup, bEnable)
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

Common.CreateTimer = Common.CreateTimer or function(strName, nMin, nSec, strFunc, bOnce)
	DeleteTimer(strName);
	AddTimer(strName, 0, nMin, nSec, "", 1025, strFunc);
	if bOnce ~= nil then
		 SetTimerOption(strName, "one_shot", true);
	end
end

-------------------------------------
--            ����ץ��             --
-------------------------------------
SNAKE = {}
SNAKE.strStatus = "SEARCH";
SNAKE.strRoomName = "";
SNAKE.strIndex = 1;
SNAKE.nDigit = 0;
SNAKE.nTime = 2;
SNAKE.bGetShuzhi = false;
SNAKE.table = {
	["��Ҷ��"] = "zhuye qing",
	["������"] = "jinxian she",
	["������"] = "chilian she",
	["�ٲ���"] = "baibu she",
	["����"] = "hei she",
	["�໨��"] = "qinghua she",
};
SNAKE.tBuffer = {};
SNAKE.nErrorDigit = 0;

Common.CreateAlias("SNAKE_ALIAS", "^SNAKE\\s?(\\S*)$", 'SNAKE.Alias("%1")', 12, "trigger");
Common.CreateTrigger("SNAKE_CHECK", "�߳������㲶׽��������(\\S+)��.*$", 'SNAKE.Check("%1")', 12, "snake", 0);
Common.CreateTrigger("SNAKE_CHECK2", "�����߳�����û���㲶�����ߡ�$", 'SNAKE.Check("һ")', 12, "snake", 0);
Common.CreateTrigger("SNAKE_RETURN", "^��ū˵�������������������С���ж�����ǿ��һ������������Ŀ����$", 'SendNoEcho("return she");SendNoEcho("return snake");', 12, "snake", 0);
Common.CreateTrigger("SNAKE_OVER", "^�������ߵĶ����Ͷ�һ���������ɼ�����߶������գ���Ȼ�������⡣$", 'SNAKE.Init()', 12, "snake", 0);
Common.CreateTrigger("SNAKE_OVER1", "^��Ȼ���������˹��ߣ����������ʹ��������ԣ���ȶ��ԵĹ��߳Ʋ���ͻ�ƣ��������������������ѡ�$", 'SNAKE.Init()', 12, "snake", 0);
Common.CreateTrigger("SNAKE_FIGHT", "^������(\\S+)��ɱ���㣡$", 'SNAKE.FightStart();', 12, "snake", 0);
Common.CreateTrigger("SNAKE_FIGHTOVER", "^(\\S+)����һ�����ȣ����ڵ���һ��Ҳ�����ˡ�$", 'SNAKE.FightOver("%1");', 12, "snake", 0);
Common.CreateTrigger("SNAKE_LOCATE", "^(\\S+) - $", 'SNAKE.strRoomName = "%1";if SNAKE.bGetShuzhi then SendNoEcho("get shuzhi"); end', 12, "snake", 0);
Common.CreateTrigger("SNAKE_NEXT", "��������ã������\\S+Ӧ���ǲ���������ˡ�$", 'SNAKE.strStatus = "NEXT";', 12, "snake", 0);
Common.CreateTrigger("SNAKE_NOBATTLE", "^�� ���� ��.*�� ƽ�� ��.*$", 'DeleteTimer("SNAKE_NOBATTLE");', 12, "snake", 0);
Common.CreateTrigger("SNAKE_ERROR", "^��Ҫ�����ĸ��ط�.+$", 'SNAKE.ErrorDigit()', 12, "snake", 0);


SNAKE.Alias = function(strStep)
	if strStep == nil or strStep == "" then
		EnableGroup("snake", true);
		SendNoEcho("l");
		Common.CreateTimer("SNAKE_TIMER", 0, SNAKE.nTime, "SNAKE.Timer");
	else
		EnableGroup("snake", false);
		DeleteTimer("SNAKE_TIMER");
		DeleteTimer("SNAKE_NEXT");
		DeleteTimer("SNAKE_NOBATTLE");
	end
end

SNAKE.Init = function()
	SNAKE.nDigit = 0;
	SNAKE.strIndex = 1;
	SNAKE.strStatus = "SEARCH";
	SNAKE.tBuffer = {};
	SNAKE.nErrorDigit = 0;
end

SNAKE.Check = function(strNum)
	local nNum = Common.StrToNum(strNum);
	if nNum < 3 then
		SNAKE.strStatus = "SEARCH";
	else
		SendNoEcho("manage");
		SNAKE.strStatus = "WAIT";
	end
end

SNAKE.Timer = function()
	Note(SNAKE.strRoomName .. SNAKE.strStatus);
	if SNAKE.strStatus == "WAIT" then
		SendNoEcho("ask nu about snake");
		SendNoEcho("ask nu about guaishe");
	elseif SNAKE.strStatus == "SEARCH" then
		if SNAKE.strRoomName == "�߳�" then
			Execute("gt btsgsl");
		elseif SNAKE.strRoomName == "�߹�����" then
			SNAKE.nErrorDigit = 0;
			SendNoEcho("btsearch bush");
			SendNoEcho("btsearch crack");
			SendNoEcho("burn shuzhi");
		elseif SNAKE.strRoomName == "�ݴ�" then
			Execute("gt btsgsl");
		end
	elseif SNAKE.strStatus == "BACK" then
		Note(SNAKE.strRoomName);
		if SNAKE.strRoomName == "�߳�" then
			SendNoEcho("btfree all");
			SendNoEcho("count");
			SNAKE.nDigit = 0;
		else
			Execute("gt btsc");
		end
	elseif SNAKE.strStatus == "NEXT" then
		SNAKE.strIndex = SNAKE.strIndex + 1;
		if SNAKE.strIndex > 17 then
			SNAKE.strIndex = 1;
		end
		if SNAKE.strIndex ~= 1 then
			Execute("gt btsgsl" .. SNAKE.strIndex);
		else
			Execute("gt btsgsl");
		end
		SNAKE.strStatus = "SEARCH";
	elseif SNAKE.strStatus == "BATTLE" then
		Common.CreateTimer("SNAKE_NOBATTLE", 0, 2, 'SNAKE.Next', true);
	end
end

SNAKE.FightStart = function()
	if SNAKE.strStatus == "SEARCH" then
		SNAKE.strStatus = "BATTLE";
	end
end

SNAKE.FightOver = function(strName)
	if SNAKE.strStatus == "BATTLE" then
		if SNAKE.table[strName] ~= nil then
			if SNAKE.tBuffer[strName] == nil then
				Note("ץ��һ��" .. strName .. " ID:" .. SNAKE.table[strName]);
				SNAKE.tBuffer[strName] = 1;
				SendNoEcho("btcatch " .. SNAKE.table[strName]);
				SNAKE.nDigit = SNAKE.nDigit + 1;
			elseif SNAKE.tBuffer[strName] == 1 then
				Note("ץ�ڶ���" .. strName .. " ID:" .. SNAKE.table[strName]);
				SNAKE.tBuffer[strName] = 2;
				SendNoEcho("btcatch " .. SNAKE.table[strName]);
				SNAKE.nDigit = SNAKE.nDigit + 1;
			else
				Note("ɱ����������" .. strName .. " ID:" .. SNAKE.table[strName]);
				SendNoEcho("kill " .. SNAKE.table[strName]);
			end
			Note("��ǰ����:" .. SNAKE.nDigit);
		--else
			--SendNoEcho("kill " .. SNAKE.table[strName]);
		end
		Common.CreateTimer("SNAKE_NEXT", 0, 10, "SNAKE.Next", true);
	end
end

SNAKE.Next = function()
	if SNAKE.nDigit > 3 then
		SNAKE.strStatus = "BACK";
	else
		SNAKE.strStatus = "SEARCH";
	end
end

SNAKE.ErrorDigit = function()
	SNAKE.nErrorDigit = SNAKE.nErrorDigit + 1;
	if SNAKE.nErrorDigit >= 2 then
		SNAKE.strStatus = "NEXT";
	end
end

Note("����ץ�߽ű��������");
