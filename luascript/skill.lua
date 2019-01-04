--=========================================
--==用法说明:
--==学技能:在老师点输入SL XXX级    比如:SL 350
--==领悟:在领悟点输入LW XXX级      比如:LW 400
--==侠客岛:在石壁任意位置输入XKD XXX级   比如:XKD 400
--==其他参数需要自己修改
--==有些屏刷信息,不想看的可以自己加触发屏蔽
--==在Variable里面添加一个名字为ID的变量,ID为自己角色ID的变量
--                  可实现不同角色加载同一脚本领悟不同的武功
--                  因为我大号小号练的时间差较大,在学习上不存在这个问题,所以没写这一块,
--                  可以参照领悟那一块的方式去修改
--==我的角色数据获取方式也是一个亮点,看各位会不会使用了,如果各位中已经有自己的,可以改对应模块即可
--=========================================


Common = Common or {};
Common.id = Common.id or GetVariable("ID");
-----------------------------------------
--             学技能参数              --
-----------------------------------------	
LearnSkill = {};

LearnSkill.nSkillWanna = { "九阴神功", "玉女心法", "纤云步法", "基本剑法", "基本内功", "基本招架", "玄铁剑法"};
LearnSkill.nTeacherID = "yang";
--从睡到到老师的路径
LearnSkill.wayTeacher = "n;e;e;n;n;n;w;n;n;n;n";
--从老师到睡觉的路径,末尾带sleep
LearnSkill.waySleep = "s;s;s;s;e;s;s;s;w;w;s;sleep";


------------------------------------------
--             领悟与练参数             --
------------------------------------------
LingwuSkills = LingwuSkills or {};
if Common.id == "suineg" then
	--arrLingwus与arrLians为基本与特殊武功,要一一对应,基本可重复
	--只支持单一内功,自己改代码可支持多内功
	--第一个必为内功
	LingwuSkills.arrLingwus = {"基本内功", "基本轻功", "基本剑法", "基本招架", "基本剑法", "基本掌法"};
	LingwuSkills.arrLians = {"玉女心法", "纤云步法", "玄铁剑法", "玄铁剑法", "玉女剑法", "黯然销魂掌"};
	--对应特殊武功需要的jifa与装备,空手注意unwield all
	LingwuSkills.arrLiansCmd = {"", "", "wield sword;jifa sword xuantie-jian", "wield sword;jifa parry xuantie-jian", "wield sword;jifa sword yunu-jianfa", "unwield all"};
	--从睡觉到领悟点路径
	LingwuSkills.strWayLingwu = "e;eat;drink;s";
	--从领悟点到睡觉路径,结束带sleep
	LingwuSkills.strWaySleep = "n;w;sleep";
	--出错时的修正路径,结束带sleep,保证中间任一点中断都能回到睡觉点,不会写可空着
	LingwuSkills.strFixWay = "n;w;sleep";
	--特殊内功开始修练的等级
	LingwuSkills.nStartXL = 380;
	--特殊内功修练方式
	LingwuSkills.strXL = "xiulian yunu-xinfa";
elseif Common.id == "suinegy" then
	LingwuSkills.arrLingwus = {"基本内功", "基本轻功", "基本剑法", "基本招架", "基本剑法", "基本拳法" };
	LingwuSkills.arrLians = {"玉女心法", "纤云步法", "玄铁剑法", "玄铁剑法", "玉女剑法", "美女拳"};
	LingwuSkills.arrLiansCmd = {"", "", "wield sword;jifa sword xuantie-jian", "wield sword;jifa parry xuantie-jian", "wield sword;jifa sword yunu-jianfa", "unwield all"};
	LingwuSkills.strWayLingwu = "e;eat;drink;s";
	LingwuSkills.strWaySleep = "n;w;sleep";
	LingwuSkills.strFixWay = "n;w;sleep";
	LingwuSkills.nStartXL = 380;
	LingwuSkills.strXL = "xiulian yunu-xinfa";
end

-----------------------------------------
--             侠客岛参数              --
-----------------------------------------	
XKD = {};

--从大门刚进去后最右边,也就是最右下角为起点写应对路径
--路径和技能名要一一对应
--自己保持正确性;
XKD.strGo = {
	"w;w;w;w;w;w;n;n;n;n",
	"w;w",
	"n;n;n;n;n;n;w",
	"w;w;w",
	"n;n",
}
XKD.strSkill = {
	"读书写字",
	"医    术",
	"基本硬功",
	"基本掌法",
	"基本拳脚",
}

-----------------------------------------
--              角色数据               --
-----------------------------------------

local nPluginIDStatus = "66c7d927ed3516f8cfadc2ec"

function GetPluginVariableSave(strID, strKey)
	local strValue = GetPluginVariable(strID, strKey);
	if strValue == nil then strValue = "10000"; end
	return strValue;
end

function GetStatusHP()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "HP"))
end

function GetStatusJL()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "JL"))
end

function GetStatusNeili()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "NEILI"))
end

function GetStatusFood()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "S_FOOD"))
end

function GetStatusWater()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "S_WATER"))
end

function GetStatusPot()
	return tonumber(GetPluginVariableSave(nPluginIDStatus, "S_POT"))
end

-----------------------------------------
--              通用模块               --
-----------------------------------------

StrToNum = StrToNum or function(str)
	if (#str % 2) == 1 then
		return 0;
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
	result = 0;
	wan = 1;
	unit = 1;
	for i = #str -2 ,0,-2 do
		char = string.sub(str,i+1,i+2);
		if char == "十" then
			unit = 10 * wan;
			if i ==0 then
				result = result + unit;
			elseif _nums[string.sub(str,i-1,i)] == nil then
				result = result + unit;
			end
		elseif char=="百" then
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

EatAndDrink = EatAndDrink or function()
	SendNoEcho("drink hulu");
	SendNoEcho("drink jiudai");
	SendNoEcho("eat doufu");
	SendNoEcho("eat fentiao");
	SendNoEcho("eat baicai");
	SendNoEcho("eat qiezi");
	SendNoEcho("eat liang");
	SendNoEcho("eat ji");
	SendNoEcho("eat baozi");
end

Common.CreateTrigger = Common.CreateTrigger or function(strName, strMatch, strAction, nSendto, strGroup, bEnable, bNoShow, nMultiLine, nLive, nDepth)
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
		SetTriggerOption (strName, "group", strGroup);
	end
end

Common.CreateTimer = Common.CreateTimer or function(strName, nMin, nSec, strFunc, bOnce)
	DeleteTimer(strName);
	AddTimer(strName, 0, nMin, nSec, "", 1025, strFunc);
	if bOnce ~= nil then
		 SetTimerOption(strName, "one_shot", true);
	end
end

Common.CreateAlias = Common.CreateAlias or function(strName, strMatch, strAction, nSendto, strGroup, bEnable)
	DeleteAlias(strName);
	if bEnable == nil then bEnable = 1; end
	AddAlias (strName, strMatch, strAction, bEnable +128 + 1024, "");
	if nSendto and type(nSendto) == "number" then
		SetAliasOption ( strName, "send_to", nSendto);
	end
	if strGroup and strGroup ~= "" then
		SetAliasOption (strName, "group", strGroup);
	end
	SetAliasOption (strName, "sequence", 99);
	SetAliasOption (strName, "match", strMatch);
end

Common.RestoreLJ = Common.RestoreLJ or function()
	SendNoEcho("yun regenerate");
end

Common.RestoreHP = Common.RestoreHP or function()
	SendNoEcho("yun recover");
end

Common.tInstanceVoid = Common.tInstanceVoid or {};
Common.InstanceRun = Common.InstanceRun or function(pVoid, nTime, vParam)
	local strKey = tostring(pVoid);
	if strKey == nil or strKey == "" then return false; end
	if Common.tInstanceVoid[strKey] ~= nil then return false; end
	if nTime == nil then nTime = 2; end
	Common.tInstanceVoid[strKey] = 1;
	pVoid(vParam);
	DoAfterSpecial(nTime, "Common.InstanceReset(\"" .. strKey .. "\")", 12);
	return true;
end
Common.InstanceRunLater = Common.InstanceRun or function(strVoid, nTime, strParam)
	if strVoid == nil or strVoid == "" then return false; end
	if Common.tInstanceVoid[strVoid] ~= nil then return false; end
	if nTime == nil then nTime = 2; end
	if strParam == nil then strParam = ""; end
	Common.tInstanceVoid[strVoid] = 1;
	DoAfterSpecial(nTime, strVoid .. "(" .. strParam .. ")", 12);
	DoAfterSpecial(nTime, "Common.InstanceReset(\"" .. strVoid .. "\")", 12);
	return true;
end
Common.InstanceReset = Common.InstanceRun or function(strKey)
	if strKey == nil or strKey == "" then return; end
	Common.tInstanceVoid[strKey] = nil;
end

-----------------------------------------
--             学技能代码              --
-----------------------------------------

LearnSkill.arrSkills = {};
LearnSkill.arrSkillsName = {};
LearnSkill.nSkillIndexMax = 0;
LearnSkill.nSkillIndex = 0;
LearnSkill.nSkillMaxLevel = 0;

Common.CreateAlias("LearnSkill", "SL (\\d+)", 'LearnSkill.SkillsLearnStart("%1")', 12, "triggers");
Common.CreateTrigger("LearnSkillSkillLearnAction", "^你共请教了(\\S*)次$", 'LearnSkill.SkillLearnAction("%1")', 12, "xue", 0, true);
Common.CreateTrigger("LearnSkillGoTeacher", "^你一觉醒来，精神抖擞地活动了几下手脚。$", "LearnSkill.GoTeacher()", 12, "xue", 0, true);
Common.CreateTrigger("LearnSkillTrigger1", "^^│ *□(\\S+ *\\S+) *│ *([a-zA-Z\\-]*) *│ *(.{8})│ *([0-9]*)\\.[0-9]{1,2}│.*$", 'LearnSkill.SkillsSet("%1", "%2", "%4")', 12, "learn", 0);
Common.CreateTrigger("LearnSkillTrigger2", "^│ *(\\S+ *\\S+) *│ *([a-zA-Z\\-]*) *│ *(.{8})│ *([0-9]*)\\.[0-9]{1,2}│.*$", 'LearnSkill.SkillsSet("%1", "%2", "%4")', 12, "learn", 0);
Common.CreateTrigger("LearnSkillTrigger3", "^你的「(\\S+)」进步了！$", 'LearnSkill.SkillLevelup("%1");', 12, "learn", 0);

LearnSkill.levelupCallback = nil;
LearnSkill.SkillsLearnStart = function(level)
	local nLevel = tonumber(level);
	if nLevel == 0 then
		LearnSkill.SkillsLearnStop();
	else
		Execute("hps on");
		LearnSkill.nSkillMaxLevel = nLevel;
		LearnSkill.nSkillIndex = 1;
		Send("sk");
		EnableGroup("learn", true);
		EnableGroup("xue", true);
		print("SkillLearnStart");
		SendNoEcho("unwield all");
		SendNoEcho("yun xinjing");
		SendNoEcho("bai " .. LearnSkill.nTeacherID);
		DoAfterSpecial(2, "LearnSkill.SkillCheck()", 12);
		DoAfterSpecial(3, "LearnSkill.SkillLearn()", 12);
	end
end

LearnSkill.SkillsLearnStop = function()
	EnableGroup("learn", false)
	EnableGroup("xue", false)
	print("SkillLearnStop")
end

LearnSkill.SkillCreate = function(index)
	for i, k in pairs(LearnSkill.nSkillWanna) do
		if LearnSkill.nSkillWanna[i] == LearnSkill.arrSkillsName[index] then
			return true
		end
	end
	return false
end

LearnSkill.SkillsSet = function(name, id, level)
	name = Replace(name, "□", "", ture);
	if LearnSkill.arrSkills[name] == nil then
		LearnSkill.arrSkills[name] = {};
		LearnSkill.nSkillIndexMax = LearnSkill.nSkillIndexMax + 1;
		LearnSkill.arrSkillsName[LearnSkill.nSkillIndexMax] = name;
	end
	if LearnSkill.arrSkills[name] ~= nil then
		LearnSkill.arrSkills[name].name = name
		LearnSkill.arrSkills[name].id = id
		LearnSkill.arrSkills[name].level = tonumber(level)
	end
end

LearnSkill.SkillCheck = function()
	nIndex = #LearnSkill.arrSkillsName + 1
	for i = 1, #LearnSkill.arrSkillsName do
		if LearnSkill.SkillCreate(i) and LearnSkill.arrSkills[LearnSkill.arrSkillsName[i]].level < LearnSkill.nSkillMaxLevel then
			print("Learn ---> " .. LearnSkill.arrSkills[LearnSkill.arrSkillsName[LearnSkill.nSkillIndex]].name .. " " .. LearnSkill.arrSkills[LearnSkill.arrSkillsName[LearnSkill.nSkillIndex]].id .. " " .. LearnSkill.arrSkills[LearnSkill.arrSkillsName[LearnSkill.nSkillIndex]].level);
			nIndex = i
			break
		end
	end
	LearnSkill.nSkillIndex = nIndex
end

LearnSkill.SkillLevelup = function(name)
	if LearnSkill.arrSkills[name] == nil then
		LearnSkill.arrSkills[name] = {};
		LearnSkill.arrSkills[name].name = name;
		LearnSkill.arrSkills[name].id = "unknown";
		LearnSkill.arrSkillsName[LearnSkill.nSkillIndexMax] = name;
		LearnSkill.nSkillIndexMax = LearnSkill.nSkillIndexMax + 1;
		LearnSkill.arrSkills[name].level = 0;
	end
	if LearnSkill.arrSkills[name] ~= nil then
		LearnSkill.arrSkills[name].level = LearnSkill.arrSkills[name].level + 1;
		LearnSkill.SkillCheck();
	end
	if LearnSkill.levelupCallback ~= nil then
		LearnSkill.levelupCallback();
	end
end

LearnSkill.GoTeacher = function()
	Execute(LearnSkill.wayTeacher);
	--SendNoEcho("yun xinjing");
	DoAfterSpecial(1, "LearnSkill.SkillLearn()", 12);
end

LearnSkill.SkillLearn = function()
	if LearnSkill.nSkillIndex <= LearnSkill.nSkillIndexMax then
		local strCmd = "xue " .. LearnSkill.nTeacherID .. " for " .. LearnSkill.arrSkills[LearnSkill.arrSkillsName[LearnSkill.nSkillIndex]].id .. " 50";
		SendNoEcho(strCmd);
	else
		LearnSkill.SkillsLearnStop();
	end
end

LearnSkill.SkillLearnAction = function(nLearnTime)
	local nl = GetStatusNeili();
	local jl = GetStatusJL();
	if nLearnTime == "零" then
		if jl < 50 then
			if nl < 300 then
				Execute(LearnSkill.waySleep);
			else
				Common.RestoreLJ();
			end
		end
	end
	LearnSkill.SkillLearn();
end

LearnSkill.SkillDebug = function()
	for i, k in pairs(LearnSkill.arrSkills) do
		print( i .. " : " .. LearnSkill.arrSkills[i].name .. " : " .. LearnSkill.arrSkills[i].id .. " : " .. LearnSkill.arrSkills[i].level )
	end
end

LearnSkill.GetLevel = function(strName)
	if LearnSkill.arrSkills[strName] == nil then return 9999; end
	return LearnSkill.arrSkills[strName].level;
end

------------------------------------------
--             领悟与练代码             --
------------------------------------------	
LingwuSkills = LingwuSkills or {};

LingwuSkills.strStatus = "LINGWU"
LingwuSkills.strBuffer = "";
LingwuSkills.nLevelMax = 0;
LingwuSkills.tSkill = nil;
LingwuSkills.timerName = "LingwuAction";
LingwuSkills.strTime = "1000";

Common.CreateAlias("Lingwu", "LW (\\d+)", "LingwuSkills.Start(%1)", 12, "triggers");
Common.CreateTrigger("Lingwu_Error", "^你需要提高基本功，不然练得再多也没有用。$", 'Common.InstanceRun(LingwuSkills.Check);', 12, "lingwu", 0);
Common.CreateTrigger("Lingwu_Sleep", "^你一觉醒来，精神抖擞地活动了几下手脚。$", "LingwuSkills.SleepCallback()", 12, "lingwu");
Common.CreateTrigger("Lingwu_Times", "^你至多领悟(\\S+)次！$", 'LingwuSkills.strTime = tostring(StrToNum("%1"));', 12, "lingwu", 0);

DeleteTimer("LingwuSkills_FixTimer");

LingwuSkills.Start = function(level)
	if level == 0 then
		DeleteTimer("LingwuSkills_FixTimer");
		LingwuSkills.Stop(false);
		print("LingwuSkillsStop");
		EnableGroup("lingwu", false);
	else
		Execute("hps on");
		if LingwuSkills.bOpen == nil then LingwuSkills.bOpen = "0"; end
		LingwuSkills.nLevelMax = level
		LearnSkill.levelupCallback = LingwuSkills.LevelupCallback;
		EnableGroup("learn", true);
		EnableGroup("lingwu", true);
		print("LingwuSkillsStart");
		SendNoEcho("yun xinjing");
		Common.InstanceRun(LingwuSkills.Check);
		DoAfterSpecial(2, 'Common.CreateTimer(LingwuSkills.timerName, 0, 0.3, "LingwuSkills.Action")', 12);
	end
end

LingwuSkills.Check = function()
		Send("sk");
		DoAfterSpecial(2, "LearnSkill.SkillDebug()", 12);
		DoAfterSpecial(2, "LingwuSkills.LevelupCallback()", 12);
end

LingwuSkills.Stop = function(bShuiBed)
	LearnSkill.levelupCallback = nil;
	Common.SleepOverCallback = nil;
	DeleteTimer(LingwuSkills.timerName);
	DeleteTimer("LingwuSkills_FixTimer");
	EnableGroup("learn", false);
	EnableGroup("lingwu", false);
	--------------------------
	--领悟完后下一步要做的事--
	--------------------------
end

LingwuSkills.SleepCallback = function()
	Common.SleepOverCallback = nil;
	EatAndDrink();
	DoAfterSpecial(1, 'SendNoEcho("yun xinjing")', 12);
	DoAfterSpecial(1.5, 'Execute(LingwuSkills.strWayLingwu)', 12);
	DoAfterSpecial(2, 'LingwuSkills.strStatus = LingwuSkills.strBuffer', 12);
end

LingwuSkills.LevelupCallback = function()
	local bLingwu = false;
	local strStatus = "LINGWU";
	for i = 1, #LingwuSkills.arrLingwus do
		local name = LingwuSkills.arrLingwus[i];
		local name2 = LingwuSkills.arrLians[i];
--		print("Lingwu Check Name:" .. name .. " Name:" .. name2);
		if name ~= nil and LearnSkill.arrSkills[name] ~= nil and LearnSkill.arrSkills[name].level < LingwuSkills.nLevelMax and LearnSkill.arrSkills[name].level <= LearnSkill.arrSkills[name2].level then	
			LingwuSkills.tSkill = LearnSkill.arrSkills[name];
			strStatus = "LINGWU"
			print("Lingwu Skill:" .. LingwuSkills.tSkill.name .. " Level:" .. LingwuSkills.tSkill.level);
			Execute(LingwuSkills.arrLiansCmd[i]);
			bLingwu = true;
			break;
		end
	end
	if bLingwu == false then
		for i = 1, #LingwuSkills.arrLingwus do
			local name = LingwuSkills.arrLingwus[i];
			local name2 = LingwuSkills.arrLians[i];
			--print("Lian Check Name:" .. name .. " Name:" .. name2 .. " Level:" .. LearnSkill.arrSkills[name2].level .. " Max:" .. LingwuSkills.nLevelMax);
			if name ~= "基本内功" and LearnSkill.arrSkills[name2].level < LingwuSkills.nLevelMax and LearnSkill.arrSkills[name].level > LearnSkill.arrSkills[name2].level then	
				LingwuSkills.tSkill = LearnSkill.arrSkills[name];
				print("Lian Skill:" .. LingwuSkills.tSkill.name .. " Level:" .. LingwuSkills.tSkill.level);
				Execute(LingwuSkills.arrLiansCmd[i]);
				strStatus = "LIAN";
				bLingwu = true;
				break;
			end
		end
	end
	if bLingwu == false then
		LingwuSkills.Stop();
	else
		LingwuSkills.strStatus = strStatus;
	end
end

LingwuSkills.Lingwu = function()
	if LingwuSkills.tSkill == nil then
		LingwuSkills.tSkill = LearnSkill.arrSkills[LingwuSkills.arrLingwus[1]];
	end
	if LingwuSkills.tSkill ~= nil and LingwuSkills.tSkill.id ~= nil then
		if LingwuSkills.strStatus == "LINGWU" then
			SendNoEcho("lingwu " .. LingwuSkills.tSkill.id .. " " .. LingwuSkills.strTime);
		elseif LingwuSkills.strStatus == "LIAN" then
			SendNoEcho("lian " .. LingwuSkills.tSkill.id .. " 50");
		end
	end
end

LingwuSkills.Sleep = function()
	LingwuSkills.FixTimer();
	print("GOTO SLEEP");
	LingwuSkills.strBuffer = LingwuSkills.strStatus
	LingwuSkills.strStatus = "SLEEP";
	DoAfterSpecial(1, 'Execute(LingwuSkills.strWaySleep)', 12);
end

LingwuSkills.FixRoad = function()
	Execute(LingwuSkills.strFixWay);
end

LingwuSkills.FixTimer = function()
	Common.CreateTimer("LingwuSkills_FixTimer", 2, 00, "LingwuSkills.FixRoad");
end

LingwuSkills.Action = function()
	if LingwuSkills.strStatus == "SLEEP" then
		return;
	elseif LingwuSkills.strStatus == "LINGWU" then
		if GetStatusPot() > 1800 and LearnSkill.arrSkills[LingwuSkills.arrLians[1]] ~= nil and LearnSkill.arrSkills[LingwuSkills.arrLians[1]].level < LingwuSkills.nLevelMax and LearnSkill.arrSkills[LingwuSkills.arrLians[1]].level >= LingwuSkills.nStartXL then
			Execute(LingwuSkills.strXL);
		end
		local nl = GetStatusNeili();
		local jl = GetStatusJL();
		if nl < 100 then
			LingwuSkills.Sleep()
		else
			if jl < 200 then
				Common.RestoreLJ();
			end
			LingwuSkills.Lingwu();
		end
	elseif LingwuSkills.strStatus == "LIAN" then
		local nl = GetStatusNeili();
		local hp = GetStatusHP();
		if nl < 200 then
			LingwuSkills.Sleep()
		else
			if hp < 200 then
				Common.RestoreHP();
			end
			LingwuSkills.Lingwu();
		end
	end
end

LingwuSkills.Stop(false);

-----------------------------------------
--             侠客岛代码              --
-----------------------------------------
XKD.strStatus = "WATCH";
XKD.strGoFirst = "halt;n;n;n;n;n;n;s;e;n;e;e;e;e;e;e;s;s;s;s;s;s";
XKD.strGoFD = "w;w;w;n;yao;drink;drink;drink;drink;fill hulu;hp";
XKD.nIndex = 1;
XKD.nLevelMax = 0;
XKD.nFDLimit = 200;

Common.CreateAlias("XKD", "^XKD (\\d+)$", "XKD.Alias(%1)", 12, "triggers");
Common.CreateTrigger("XKD_FOOD_WATER", "^你捡起一个清水葫芦。$", 'XKD.GetFoodOver();', 12, "xkd", 0);

XKD.Alias = function(nLevel)
	Note(nLevel);
	if nLevel == 0 or nLevel == nil then
		DeleteTimer("XKD_FOOD_WATER_OVER");
		DeleteTimer("XKD_TIMER");
		XKD.bStart = false;
		XKD.Stop();
		print("XDX_Stop");
		EnableGroup("lingwu", false);
	else
		XKD.bStart = true;
		XKD.nLevelMax = nLevel;
		LearnSkill.levelupCallback = XKD.LevelupCallback;
		EnableGroup("learn", true);
		EnableGroup("xkd", true);
		Send("sk");
		print("XDX_Start");
		DoAfterSpecial(2, "XKD.LevelCheck()", 12);
		DoAfterSpecial(3, "XKD.GotoLS()", 12);
		DoAfterSpecial(10, 'Common.CreateTimer("XKD_TIMER", 0, 1.2, "XKD.Action")', 12);
	end
end

XKD.Stop = function()
	LearnSkill.levelupCallback = nil;
	Common.SleepOverCallback = nil;
	DeleteTimer("XKD_FOOD_WATER_OVER");
	DeleteTimer("XKD_TIMER");
	EnableGroup("learn", false);
	EnableGroup("xkd", false);
	if XKD.bStart == true then
		Execute("VEIN");
		DoAfterSpecial(2, 'EnableGroup("dazuo", true)', 12);
	end
end

XKD.Action = function()
	EatAndDrink();
	SendNoEcho("yun xinjing");
	if (( GetStatusWater() < XKD.nFDLimit ) or ( GetStatusFood() < XKD.nFDLimit )) and ( XKD.strStatus ~= "GETSD" ) then
		XKD.strStatus = "GETSD";
		DoAfterSpecial(5, 'XKD.GotoFD()', 12);
	elseif ( GetStatusNeili() < 1500 ) and ( XKD.strStatus == "WATCH" ) then
		SendNoEcho("yun recover");
		SendNoEcho("dazuo max");
	elseif ( XKD.strStatus == "WATCH" ) then
		SendNoEcho("watch 石壁 100");
		SendNoEcho("yun regenerate");
	end
end
XKD.Watch = XKD.Action;

XKD.GotoLS = function()
	Execute(XKD.strGoFirst);
	DoAfterSpecial(2, XKD.strGo[XKD.nIndex], 10);
	DoAfterSpecial(2.4, 'l 石壁', 10);
	DoAfterSpecial(2.5, 'XKD.strStatus = "WATCH";', 12);
end

XKD.GotoFD = function()
	Execute(XKD.strGoFirst);
	DoAfterSpecial(2, XKD.strGoFD, 10);
	DoAfterSpecial(5, XKD.strGoFirst, 10);
	DoAfterSpecial(7, 'XKD.GotoLS()', 12);
end

XKD.GetFoodOver = function()
	--SendNoEcho("eat liang");
	--SendNoEcho("drink hulu");
	--SendNoEcho("hp");
	--Common.CreateTimer("XKD_FOOD_WATER_OVER" , 0, 2, "XKD.GotoLS", true);
end

XKD.LevelCheck = function()
	Note(XKD.strSkill[XKD.nIndex] .. " : " .. LearnSkill.GetLevel(XKD.strSkill[XKD.nIndex]));
	if ( LearnSkill.GetLevel(XKD.strSkill[XKD.nIndex]) >= XKD.nLevelMax ) then
		XKD.nIndex = XKD.nIndex + 1;
		if ( XKD.nIndex > #XKD.strSkill ) then
			XKD.Stop();
		else
			XKD.LevelCheck();
		end
	end
end

XKD.LevelupCallback = function()
	if ( LearnSkill.GetLevel(XKD.strSkill[XKD.nIndex]) >= XKD.nLevelMax ) then
		XKD.nIndex = XKD.nIndex + 1;
		if ( XKD.nIndex > #XKD.strSkill ) then
			XKD.Stop();
		else
			XKD.strStatus = "GONEXT";
			DoAfterSpecial(5, 'XKD.GotoLS()', 12);
		end
	end
end

XKD.Stop();