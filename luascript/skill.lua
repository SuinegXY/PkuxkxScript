--=========================================
--==�÷�˵��:
--==ѧ����:����ʦ������SL XXX��    ����:SL 350
--==����:�����������LW XXX��      ����:LW 400
--==���͵�:��ʯ������λ������XKD XXX��   ����:XKD 400
--==����������Ҫ�Լ��޸�
--==��Щ��ˢ��Ϣ,���뿴�Ŀ����Լ��Ӵ�������
--==��Variable�������һ������ΪID�ı���,IDΪ�Լ���ɫID�ı���
--                  ��ʵ�ֲ�ͬ��ɫ����ͬһ�ű�����ͬ���书
--                  ��Ϊ�Ҵ��С������ʱ���ϴ�,��ѧϰ�ϲ������������,����ûд��һ��,
--                  ���Բ���������һ��ķ�ʽȥ�޸�
--==�ҵĽ�ɫ���ݻ�ȡ��ʽҲ��һ������,����λ�᲻��ʹ����,�����λ���Ѿ����Լ���,���ԸĶ�Ӧģ�鼴��
--=========================================


Common = Common or {};
Common.id = Common.id or GetVariable("ID");
-----------------------------------------
--             ѧ���ܲ���              --
-----------------------------------------	
LearnSkill = {};

LearnSkill.nSkillWanna = { "������", "��Ů�ķ�", "���Ʋ���", "��������", "�����ڹ�", "�����м�", "��������"};
LearnSkill.nTeacherID = "yang";
--��˯������ʦ��·��
LearnSkill.wayTeacher = "n;e;e;n;n;n;w;n;n;n;n";
--����ʦ��˯����·��,ĩβ��sleep
LearnSkill.waySleep = "s;s;s;s;e;s;s;s;w;w;s;sleep";


------------------------------------------
--             ������������             --
------------------------------------------
LingwuSkills = LingwuSkills or {};
if Common.id == "suineg" then
	--arrLingwus��arrLiansΪ�����������书,Ҫһһ��Ӧ,�������ظ�
	--ֻ֧�ֵ�һ�ڹ�,�Լ��Ĵ����֧�ֶ��ڹ�
	--��һ����Ϊ�ڹ�
	LingwuSkills.arrLingwus = {"�����ڹ�", "�����Ṧ", "��������", "�����м�", "��������", "�����Ʒ�"};
	LingwuSkills.arrLians = {"��Ů�ķ�", "���Ʋ���", "��������", "��������", "��Ů����", "��Ȼ������"};
	--��Ӧ�����书��Ҫ��jifa��װ��,����ע��unwield all
	LingwuSkills.arrLiansCmd = {"", "", "wield sword;jifa sword xuantie-jian", "wield sword;jifa parry xuantie-jian", "wield sword;jifa sword yunu-jianfa", "unwield all"};
	--��˯���������·��
	LingwuSkills.strWayLingwu = "e;eat;drink;s";
	--������㵽˯��·��,������sleep
	LingwuSkills.strWaySleep = "n;w;sleep";
	--����ʱ������·��,������sleep,��֤�м���һ���ж϶��ܻص�˯����,����д�ɿ���
	LingwuSkills.strFixWay = "n;w;sleep";
	--�����ڹ���ʼ�����ĵȼ�
	LingwuSkills.nStartXL = 380;
	--�����ڹ�������ʽ
	LingwuSkills.strXL = "xiulian yunu-xinfa";
elseif Common.id == "suinegy" then
	LingwuSkills.arrLingwus = {"�����ڹ�", "�����Ṧ", "��������", "�����м�", "��������", "����ȭ��" };
	LingwuSkills.arrLians = {"��Ů�ķ�", "���Ʋ���", "��������", "��������", "��Ů����", "��Ůȭ"};
	LingwuSkills.arrLiansCmd = {"", "", "wield sword;jifa sword xuantie-jian", "wield sword;jifa parry xuantie-jian", "wield sword;jifa sword yunu-jianfa", "unwield all"};
	LingwuSkills.strWayLingwu = "e;eat;drink;s";
	LingwuSkills.strWaySleep = "n;w;sleep";
	LingwuSkills.strFixWay = "n;w;sleep";
	LingwuSkills.nStartXL = 380;
	LingwuSkills.strXL = "xiulian yunu-xinfa";
end

-----------------------------------------
--             ���͵�����              --
-----------------------------------------	
XKD = {};

--�Ӵ��Ÿս�ȥ�����ұ�,Ҳ���������½�Ϊ���дӦ��·��
--·���ͼ�����Ҫһһ��Ӧ
--�Լ�������ȷ��;
XKD.strGo = {
	"w;w;w;w;w;w;n;n;n;n",
	"w;w",
	"n;n;n;n;n;n;w",
	"w;w;w",
	"n;n",
}
XKD.strSkill = {
	"����д��",
	"ҽ    ��",
	"����Ӳ��",
	"�����Ʒ�",
	"����ȭ��",
}

-----------------------------------------
--              ��ɫ����               --
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
--              ͨ��ģ��               --
-----------------------------------------

StrToNum = StrToNum or function(str)
	if (#str % 2) == 1 then
		return 0;
	end
	local _nums = {};
	_nums["һ"] = 1;
	_nums["��"] = 2;
	_nums["��"] = 3;
	_nums["��"] = 4;
	_nums["��"] = 5;
	_nums["��"] = 6;
	_nums["��"] = 7;
	_nums["��"] = 8;
	_nums["��"] = 9;
	result = 0;
	wan = 1;
	unit = 1;
	for i = #str -2 ,0,-2 do
		char = string.sub(str,i+1,i+2);
		if char == "ʮ" then
			unit = 10 * wan;
			if i ==0 then
				result = result + unit;
			elseif _nums[string.sub(str,i-1,i)] == nil then
				result = result + unit;
			end
		elseif char=="��" then
			unit = 100 * wan;
		elseif char == "ǧ" then
			unit = 1000 * wan;
		elseif char == "��" then
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
--             ѧ���ܴ���              --
-----------------------------------------

LearnSkill.arrSkills = {};
LearnSkill.arrSkillsName = {};
LearnSkill.nSkillIndexMax = 0;
LearnSkill.nSkillIndex = 0;
LearnSkill.nSkillMaxLevel = 0;

Common.CreateAlias("LearnSkill", "SL (\\d+)", 'LearnSkill.SkillsLearnStart("%1")', 12, "triggers");
Common.CreateTrigger("LearnSkillSkillLearnAction", "^�㹲�����(\\S*)��$", 'LearnSkill.SkillLearnAction("%1")', 12, "xue", 0, true);
Common.CreateTrigger("LearnSkillGoTeacher", "^��һ�������������ӵػ�˼����ֽš�$", "LearnSkill.GoTeacher()", 12, "xue", 0, true);
Common.CreateTrigger("LearnSkillTrigger1", "^^�� *��(\\S+ *\\S+) *�� *([a-zA-Z\\-]*) *�� *(.{8})�� *([0-9]*)\\.[0-9]{1,2}��.*$", 'LearnSkill.SkillsSet("%1", "%2", "%4")', 12, "learn", 0);
Common.CreateTrigger("LearnSkillTrigger2", "^�� *(\\S+ *\\S+) *�� *([a-zA-Z\\-]*) *�� *(.{8})�� *([0-9]*)\\.[0-9]{1,2}��.*$", 'LearnSkill.SkillsSet("%1", "%2", "%4")', 12, "learn", 0);
Common.CreateTrigger("LearnSkillTrigger3", "^��ġ�(\\S+)�������ˣ�$", 'LearnSkill.SkillLevelup("%1");', 12, "learn", 0);

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
	name = Replace(name, "��", "", ture);
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
	if nLearnTime == "��" then
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
--             ������������             --
------------------------------------------	
LingwuSkills = LingwuSkills or {};

LingwuSkills.strStatus = "LINGWU"
LingwuSkills.strBuffer = "";
LingwuSkills.nLevelMax = 0;
LingwuSkills.tSkill = nil;
LingwuSkills.timerName = "LingwuAction";
LingwuSkills.strTime = "1000";

Common.CreateAlias("Lingwu", "LW (\\d+)", "LingwuSkills.Start(%1)", 12, "triggers");
Common.CreateTrigger("Lingwu_Error", "^����Ҫ��߻���������Ȼ�����ٶ�Ҳû���á�$", 'Common.InstanceRun(LingwuSkills.Check);', 12, "lingwu", 0);
Common.CreateTrigger("Lingwu_Sleep", "^��һ�������������ӵػ�˼����ֽš�$", "LingwuSkills.SleepCallback()", 12, "lingwu");
Common.CreateTrigger("Lingwu_Times", "^����������(\\S+)�Σ�$", 'LingwuSkills.strTime = tostring(StrToNum("%1"));', 12, "lingwu", 0);

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
	--���������һ��Ҫ������--
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
			if name ~= "�����ڹ�" and LearnSkill.arrSkills[name2].level < LingwuSkills.nLevelMax and LearnSkill.arrSkills[name].level > LearnSkill.arrSkills[name2].level then	
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
--             ���͵�����              --
-----------------------------------------
XKD.strStatus = "WATCH";
XKD.strGoFirst = "halt;n;n;n;n;n;n;s;e;n;e;e;e;e;e;e;s;s;s;s;s;s";
XKD.strGoFD = "w;w;w;n;yao;drink;drink;drink;drink;fill hulu;hp";
XKD.nIndex = 1;
XKD.nLevelMax = 0;
XKD.nFDLimit = 200;

Common.CreateAlias("XKD", "^XKD (\\d+)$", "XKD.Alias(%1)", 12, "triggers");
Common.CreateTrigger("XKD_FOOD_WATER", "^�����һ����ˮ��«��$", 'XKD.GetFoodOver();', 12, "xkd", 0);

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
		SendNoEcho("watch ʯ�� 100");
		SendNoEcho("yun regenerate");
	end
end
XKD.Watch = XKD.Action;

XKD.GotoLS = function()
	Execute(XKD.strGoFirst);
	DoAfterSpecial(2, XKD.strGo[XKD.nIndex], 10);
	DoAfterSpecial(2.4, 'l ʯ��', 10);
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