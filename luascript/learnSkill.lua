-------------------------------------
--             学技能              --
-------------------------------------	

LearnSkill = {}
LearnSkill.arrSkills = {}
LearnSkill.arrSkillsName = {}
LearnSkill.nSkillIndexMax = 0
LearnSkill.nSkillIndex = 0
LearnSkill.nSkillMaxLevel = 0

--LearnSkill.nSkillWanna = { "纤云步法", "玉女心法", "基本招架", "基本内功", "基本轻功", "基本剑法", "基本掌法", "黯然销魂掌" }
--LearnSkill.nSkillWanna = { "玉女心法", "基本剑法", "基本拳法", "基本内功", "基本招架", "纤云步法", "玉女剑法" }
LearnSkill.nSkillWanna = { "千灭银针手", "基本暗器" }
LearnSkill.nTeacherID = "xiao"
LearnSkill.wayTeacher = "n;e;e;n;n;n;w;n;n;n;n";
LearnSkill.waySleep = "s;s;s;s;e;s;s;s;w;w;s;sleep";

--[[
LearnSkill.nSkillWanna = { "读书写字" }
LearnSkill.nTeacherID = "xi"
LearnSkill.wayTeacher = "w";
LearnSkill.waySleep = "e;sleep";
]]--

Common.CreateTrigger("LearnSkillSkillLearnAction", "^你共请教了(\\S*)次$", 'LearnSkill.SkillLearnAction("%1")', 12, "xue", 0, true);
Common.CreateTrigger("LearnSkillGoTeacher", "^你一觉醒来，精神抖擞地活动了几下手脚。$", "LearnSkill.GoTeacher()", 12, "xue", 0, true);
Common.CreateTrigger("LearnSkillTrigger1", "^│ *□(\\S+ *\\S+) *│ *([\\S+]*) *│ *(.{8})│ *([0-9]*)\\.[0-9]{1,2}\\+?│(.+?) +.*$", 'LearnSkill.SkillsSet("%1", "%2", "%4", "%5")', 12, "learn", 0);
Common.CreateTrigger("LearnSkillTrigger2", "^│ *(\\S+ *\\S+) *│ *([\\S+]*) *│ *(.{8})│ *([0-9]*)\\.[0-9]{1,2}\\+?│(.+?) +.*$", 'LearnSkill.SkillsSet("%1", "%2", "%4", "%5")', 12, "learn", 0);
Common.CreateTrigger("LearnSkillTrigger3", "^│ *(\\S+ *\\S+) *│ *([\\S+]*) *│ *(.{8})│ *([0-9]*)\\.[0-9]{1,2}\\+?│\\-     │", 'LearnSkill.SkillsSet("%1", "%2", "%4", "9999")', 12, "learn", 0);
Common.CreateTrigger("LearnLevelup", "^你的「(\\S+)」进步了！$", 'LearnSkill.SkillLevelup("%1");', 12, "learn", 0);

LearnSkill.levelupCallback = nil;
LearnSkill.SkillsLearnStart = function(level)
	local nLevel = tonumber(level);
	if nLevel == 0 then
		LearnSkill.SkillsLearnStop();
	else
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
	--Execute("LW 752");
end

LearnSkill.SkillCreate = function(index)
	for i, k in pairs(LearnSkill.nSkillWanna) do
		if LearnSkill.nSkillWanna[i] == LearnSkill.arrSkillsName[index] then
			return true
		end
	end
	return false
end

LearnSkill.SkillsSet = function(name, id, level, max)
	if LearnSkill.arrSkills[name] == nil then
		LearnSkill.arrSkills[name] = {};
		LearnSkill.nSkillIndexMax = LearnSkill.nSkillIndexMax + 1;
		LearnSkill.arrSkillsName[LearnSkill.nSkillIndexMax] = name;
	end
	if LearnSkill.arrSkills[name] ~= nil then
		LearnSkill.arrSkills[name].name = name;
		LearnSkill.arrSkills[name].id = id;
		LearnSkill.arrSkills[name].level = tonumber(level);
		LearnSkill.arrSkills[name].max = tonumber(max);
	end
end

LearnSkill.SkillsSetNew = function(name, id, level, max)
	if LearnSkill.arrSkills[name] == nil then
		LearnSkill.arrSkills[name] = {};
		LearnSkill.nSkillIndexMax = LearnSkill.nSkillIndexMax + 1;
		LearnSkill.arrSkillsName[LearnSkill.nSkillIndexMax] = name;
	end
	if LearnSkill.arrSkills[name] ~= nil then
		LearnSkill.arrSkills[name].name = name
		LearnSkill.arrSkills[name].id = id
		LearnSkill.arrSkills[name].level = tonumber(level)
		LearnSkill.arrSkills[name].max = tonumber(max)
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
	SendNoEcho("yun xinjing");
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