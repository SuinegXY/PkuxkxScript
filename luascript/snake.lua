-----------------------------------------------------------------------------
--白驼抓蛇脚本 说明:
--1.依赖GPS功能,如果没有可手动修改路径相关
--2.蛇的id需要自己在表里补充,见下
--3.结束判断用的是SNAKE_OVER系列触发,没经常丰富测试,如有其他描述可以自己补充
--4.使用方法:requiry本文件,或直接引用本脚本
--5.在蛇场输SNAKE开始,输SNAKEX结束
--6.作者:休莱格(suineg)
-----------------------------------------------------------------------------


-------------------------------------
--            通用模块             --
-------------------------------------

Common = Common or {};

Common.StrToNum = Common.StrToNum or function(strContent)
	local _nums = {}
	_nums["一"] = 1;
	_nums["二"] = 2;
	_nums["三"] = 3;
	_nums["四"] = 4;
	_nums["五"] = 5;
	_nums["六"] = 6;
	_nums["七"] = 7;
	_nums["八"] = 8;
	_nums["九"] = 9;
	if (#strContent % 2) == 1 then
		return 0;
	end
	nResult = 0;
	WAN = 1;
	UNIT = 1;
	for i = #strContent -2 , 0, -2 do
		szChar = string.sub(strContent, i+1, i+2);
		if szChar == "十" then
			UNIT = 10 * WAN;
			if i == 0 then
				nResult = nResult + UNIT;
			elseif _nums[string.sub(strContent, i-1, i)] == nil then
				nResult = nResult + UNIT;
			end
		elseif szChar == "百" then
			UNIT = 100 * WAN;
		elseif szChar == "千" then
			UNIT = 1000 * WAN;
		elseif szChar == "万" then
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
--            白驼抓蛇             --
-------------------------------------
SNAKE = {}
SNAKE.strStatus = "SEARCH";
SNAKE.strRoomName = "";
SNAKE.strIndex = 1;
SNAKE.nDigit = 0;
SNAKE.nTime = 2;
SNAKE.bGetShuzhi = false;
SNAKE.table = {
	["竹叶青"] = "zhuye qing",
	["金线蛇"] = "jinxian she",
	["赤练蛇"] = "chilian she",
	["百步蛇"] = "baibu she",
	["黑蛇"] = "hei she",
	["青花蛇"] = "qinghua she",
};
SNAKE.tBuffer = {};
SNAKE.nErrorDigit = 0;

Common.CreateAlias("SNAKE_ALIAS", "^SNAKE\\s?(\\S*)$", 'SNAKE.Alias("%1")', 12, "trigger");
Common.CreateTrigger("SNAKE_CHECK", "蛇场里由你捕捉到的蛇有(\\S+)种.*$", 'SNAKE.Check("%1")', 12, "snake", 0);
Common.CreateTrigger("SNAKE_CHECK2", "现在蛇场里面没有你捕来的蛇。$", 'SNAKE.Check("一")', 12, "snake", 0);
Common.CreateTrigger("SNAKE_RETURN", "^蛇奴说道：「这是最近养育的小蛇中毒性最强的一条，请少主过目。」$", 'SendNoEcho("return she");SendNoEcho("return snake");', 12, "snake", 0);
Common.CreateTrigger("SNAKE_OVER", "^这条怪蛇的毒性猛恶一如以往，可见你对蛇毒的掌握，已然纯熟如意。$", 'SNAKE.Init()', 12, "snake", 0);
Common.CreateTrigger("SNAKE_OVER1", "^虽然你培养出了怪蛇，但是以你的使毒本领而言，这等毒性的怪蛇称不上突破，仅是增生怪蛇数量而已。$", 'SNAKE.Init()', 12, "snake", 0);
Common.CreateTrigger("SNAKE_FIGHT", "^看起来(\\S+)想杀死你！$", 'SNAKE.FightStart();', 12, "snake", 0);
Common.CreateTrigger("SNAKE_FIGHTOVER", "^(\\S+)脚下一个不稳，跌在地上一动也不动了。$", 'SNAKE.FightOver("%1");', 12, "snake", 0);
Common.CreateTrigger("SNAKE_LOCATE", "^(\\S+) - $", 'SNAKE.strRoomName = "%1";if SNAKE.bGetShuzhi then SendNoEcho("get shuzhi"); end', 12, "snake", 0);
Common.CreateTrigger("SNAKE_NEXT", "找了这麽久，你觉得\\S+应该是不会藏着蛇了。$", 'SNAKE.strStatus = "NEXT";', 12, "snake", 0);
Common.CreateTrigger("SNAKE_NOBATTLE", "^【 气势 】.*【 平衡 】.*$", 'DeleteTimer("SNAKE_NOBATTLE");', 12, "snake", 0);
Common.CreateTrigger("SNAKE_ERROR", "^你要搜索哪个地方.+$", 'SNAKE.ErrorDigit()', 12, "snake", 0);


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
		if SNAKE.strRoomName == "蛇场" then
			Execute("gt btsgsl");
		elseif SNAKE.strRoomName == "蛇谷树林" then
			SNAKE.nErrorDigit = 0;
			SendNoEcho("btsearch bush");
			SendNoEcho("btsearch crack");
			SendNoEcho("burn shuzhi");
		elseif SNAKE.strRoomName == "草从" then
			Execute("gt btsgsl");
		end
	elseif SNAKE.strStatus == "BACK" then
		Note(SNAKE.strRoomName);
		if SNAKE.strRoomName == "蛇场" then
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
				Note("抓第一条" .. strName .. " ID:" .. SNAKE.table[strName]);
				SNAKE.tBuffer[strName] = 1;
				SendNoEcho("btcatch " .. SNAKE.table[strName]);
				SNAKE.nDigit = SNAKE.nDigit + 1;
			elseif SNAKE.tBuffer[strName] == 1 then
				Note("抓第二条" .. strName .. " ID:" .. SNAKE.table[strName]);
				SNAKE.tBuffer[strName] = 2;
				SendNoEcho("btcatch " .. SNAKE.table[strName]);
				SNAKE.nDigit = SNAKE.nDigit + 1;
			else
				Note("杀超过第三条" .. strName .. " ID:" .. SNAKE.table[strName]);
				SendNoEcho("kill " .. SNAKE.table[strName]);
			end
			Note("当前蛇数:" .. SNAKE.nDigit);
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

Note("白驼抓蛇脚本加载完成");
