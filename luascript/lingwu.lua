--------------------------------------
--             领悟与练             --
--------------------------------------	

LingwuSkills = LingwuSkills or {};

LingwuSkills.strStatus = "LINGWU"
LingwuSkills.strBuffer = "";
LingwuSkills.nLevelMax = 0;
LingwuSkills.tSkill = nil;
LingwuSkills.timerName = "LingwuAction";
LingwuSkills.bOpen = nil;
LingwuSkills.strTime = "1000";


Common.CreateAlias("Lingwu2", "^LW$", "LingwuSkills.Trigger()", 12, "triggers");
Common.CreateAlias("Lingwu", "^LW (\\d+)$", "LingwuSkills.Start(%1)", 12, "triggers");
Common.CreateTrigger("Lingwu_Auto", "^你目前所学过的技能：（共\\S+项技能，你的技能等级最多能达到(\\S+)级）$", 'LingwuSkills.TriggerOver("%1")', 12, "common", 0)
Common.CreateTrigger("Lingwu_Error", "^(你需要提高基本功，不然练得再多也没有用。)|(你的基本功夫比你的高级功夫还高！)|(你已经达到你的技能等级极限！)$", 'Common.InstanceRun(LingwuSkills.Check);', 12, "lingwu", 0);
Common.CreateTrigger("Lingwu_Times", "^你至多领悟(\\S+)次！$", 'LingwuSkills.strTime = tostring(StrToNum("%1"));', 12, "lingwu", 0);

DeleteTimer("LingwuSkills_FixTimer");

LingwuSkills.Trigger = function()
	EnableTrigger("Lingwu_Auto", true);
	SendNoEcho("sk");
end

LingwuSkills.TriggerOver = function(strLevel)
	EnableTrigger("Lingwu_Auto", false);
	Execute("gt bplgf");
	LingwuSkills.nLevelMax = StrToNum(strLevel);
	DoAfterSpecial(5, 'Execute("LW " .. LingwuSkills.nLevelMax)', 12);
end

LingwuSkills.Start = function(level)
	if level == 0 then
		DeleteTimer("LingwuSkills_FixTimer");
		LingwuSkills.Stop(false);
		print("LingwuSkillsStop");
		EnableGroup("lingwu", false);
		Execute("hps off");
	else
		LingwuSkills.bOpen = GetVariable("XIULIAN");
		if LingwuSkills.bOpen == nil then LingwuSkills.bOpen = "0"; end
		LingwuSkills.nLevelMax = level
		LearnSkill.levelupCallback = LingwuSkills.LevelupCallback;
		Common.SleepOverCallback = LingwuSkills.SleepCallback;
		print("LingwuSkillsStart");
		--SendNoEcho("yun xinjing");
		Common.InstanceRun(LingwuSkills.Check);
		Execute("hps on");
	end
end

LingwuSkills.Check = function()
		DeleteTimer(LingwuSkills.timerName);
		DeleteTimer("LingwuSkills_FixTimer");
		EnableGroup("learn", true);
		EnableGroup("lingwu", true);
		Send("sk");
		DoAfterSpecial(2, "LearnSkill.SkillDebug()", 12);
		DoAfterSpecial(2, "LingwuSkills.LevelupCallback()", 12);
		DoAfterSpecial(2, 'Common.CreateTimer(LingwuSkills.timerName, 0, 0.3, "LingwuSkills.Action")', 12);
end

LingwuSkills.Stop = function(bShuiBed)
	LearnSkill.levelupCallback = nil;
	Common.SleepOverCallback = nil;
	DeleteTimer(LingwuSkills.timerName);
	DeleteTimer("LingwuSkills_FixTimer");
	EnableGroup("learn", false);
	EnableGroup("lingwu", false);
	if bShuiBed == false then return; end
	--if Common.id == "suinegy" then
	--	EnableGroup("dazuo", true);
	--elseif Common.id == "suineg" then
		--EnableGroup("bed", true);
		--Execute("gt gmgmcs");
		--DoAfter(20, "shui bed");
		--Execute("VEIN");
		--DoAfterSpecial(2, 'EnableGroup("dazuo", true)', 12);
		DoAfterSpecial(2, 'Execute(GetVariable("OVER_LINGWU"))', 12);
		--Execute("n;ne;C -b");
	--end
end

LingwuSkills.SleepCallback = function()
	--Common.SleepOverCallback = nil;
	EatAndDrink();
	--DoAfterSpecial(1, 'SendNoEcho("yun xinjing")', 12);
	DoAfterSpecial(1.5, 'Execute(LingwuSkills.strWayLingwu)', 12);
	DoAfterSpecial(2, 'LingwuSkills.strStatus = LingwuSkills.strBuffer', 12);
end

LingwuSkills.LevelupCallback = function()
	local bLingwu = false;
	local strStatus = "LINGWU";
	if GetStatusPot() > 10000 and LearnSkill.arrSkills["玉女心法"] ~= nil and LearnSkill.arrSkills["玉女心法"].level < LingwuSkills.nLevelMax 
		and LearnSkill.arrSkills["玉女心法"].level < LearnSkill.arrSkills["玉女心法"].max and LearnSkill.arrSkills["玉女心法"].level >= 380 then
		strStatus = "XIULIAN"
		bLingwu = true;
	end
	if bLingwu == false then
		for i = 1, #LingwuSkills.arrLingwus do
			local name = LingwuSkills.arrLingwus[i];
			local name2 = LingwuSkills.arrLians[i];
	--		print("Lingwu Check Name:" .. name .. " Name:" .. name2);
			if name ~= nil and LearnSkill.arrSkills[name] ~= nil and LearnSkill.arrSkills[name].level < LingwuSkills.nLevelMax and 
				LearnSkill.arrSkills[name].level < LearnSkill.arrSkills[name].max and LearnSkill.arrSkills[name].level <= LearnSkill.arrSkills[name2].level then	
				LingwuSkills.tSkill = LearnSkill.arrSkills[name];
				strStatus = "LINGWU"
				print("Lingwu Skill:" .. LingwuSkills.tSkill.name .. " Level:" .. LingwuSkills.tSkill.level);
				Execute(LingwuSkills.arrLiansCmd[i]);
				bLingwu = true;
				break;
			end
		end
	end
	if bLingwu == false then
		for i = 1, #LingwuSkills.arrLingwus do
			local name = LingwuSkills.arrLingwus[i];
			local name2 = LingwuSkills.arrLians[i];
			--print("Lian Check Name:" .. name .. " Name:" .. name2 .. " Level:" .. LearnSkill.arrSkills[name2].level .. " Max:" .. LingwuSkills.nLevelMax);
			if name ~= "基本内功" and LearnSkill.arrSkills[name2].level < LingwuSkills.nLevelMax and 
			LearnSkill.arrSkills[name2].level < LearnSkill.arrSkills[name2].max and LearnSkill.arrSkills[name].level > LearnSkill.arrSkills[name2].level then	
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
		if LingwuSkills.strStatus == "XIULIAN" and strStatus ~= "XIULIAN" then
			EnableGroup("xiulian", false);
		end
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
			SendNoEcho("lian " .. LingwuSkills.tSkill.id .. " 50");
			SendNoEcho("lian " .. LingwuSkills.tSkill.id .. " 50");
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
	Execute("n;w;sleep");
end

LingwuSkills.FixTimer = function()
	Common.CreateTimer("LingwuSkills_FixTimer", 2, 00, "LingwuSkills.FixRoad");
end

LingwuSkills.Action = function()
	if LingwuSkills.strStatus == "SLEEP" then
		return;
	elseif LingwuSkills.strStatus == "XIULIAN" then
		if LingwuSkills.bOpen == "1" and GetStatusPot() > 3000 and LearnSkill.arrSkills["玉女心法"] ~= nil and LearnSkill.arrSkills["玉女心法"].level < LingwuSkills.nLevelMax and LearnSkill.arrSkills["玉女心法"].level >= 380 then
			Execute("XF");
		else
			LingwuSkills.LevelupCallback();
		end
		return;
	elseif LingwuSkills.strStatus == "LINGWU" then
		local nl = GetStatusNeili();
		local jl = GetStatusJL();
		if true then
			if nl < 100 then
				Common.SleepOverCallback = LingwuSkills.SleepCallback;
				LingwuSkills.Sleep()
			else
				if jl < 200 then
					Common.RestoreLJ();
				end
				LingwuSkills.Lingwu();
			end
		else
			if jl < 500 then
				Common.RestoreLJ();
				Common.RestoreHP();
			end
			if nl < 400 then
				Common.RestoreLJ();
				Common.RestoreHP();
				SendNoEcho("dazuo max");
			else
				LingwuSkills.Lingwu();
			end
		end
	elseif LingwuSkills.strStatus == "LIAN" then
		local nl = GetStatusNeili();
		local hp = GetStatusHP();
		if true then
			if nl < 200 then
				Common.SleepOverCallback = LingwuSkills.SleepCallback;
				LingwuSkills.Sleep()
			else
				if hp < 200 then
					Common.RestoreHP();
				end
				LingwuSkills.Lingwu();
			end
		else
			if hp < 500 then
				Common.RestoreHP();
			end
			if nl < 400 then
				Common.RestoreLJ();
				Common.RestoreHP();
				SendNoEcho("dazuo max");
			else
				LingwuSkills.Lingwu();
			end
		end
	end
end

LingwuSkills.Stop(false);

-------------------------------------
--             侠客岛              --
-------------------------------------	
XKD = {};
XKD.strStatus = "WATCH";
XKD.strGoFirst = "halt;n;n;n;n;n;n;s;e;n;e;e;e;e;e;e;s;s;s;s;s;s";
XKD.strGoFD = "w;w;w;n;yao;drink;drink;drink;drink;fill hulu;hp";
XKD.strGo = {
	"w;w;w;w;w;w;n;n;n;n",
	--"n;n;n;n;n;n;w",
	"w;w;w",
	"w;w",
	--"n;n",
}
XKD.strSkill = {
	"读书写字",
	--"基本硬功",
	"基本掌法",
	"医    术",
	--"基本拳脚",
}
XKD.nIndex = 1;
XKD.nLevelMax = 0;
XKD.nFDLimit = 200;
XKD.bStart = false;

Common.CreateAlias("XKD", "^XKD (\\d+)$", "XKD.Alias(%1)", 12, "triggers");
--Common.CreateTrigger("XKD_DAZUO_FINISH", "^你运功完毕，深深吸了口气，站了起来。$", 'XKD.strStatus = "WATCH";', 12, "xkd", 0);
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
	--SendNoEcho("yun xinjing");
	if (( GetStatusWater() < XKD.nFDLimit ) or ( GetStatusFood() < XKD.nFDLimit )) and ( XKD.strStatus ~= "GETSD" ) then
		XKD.strStatus = "GETSD";
		DoAfterSpecial(5, 'XKD.GotoFD()', 12);
	elseif ( GetStatusNeili() < 1500 ) and ( XKD.strStatus == "WATCH" ) then
		SendNoEcho("yun recover");
		SendNoEcho("dazuo max");
	elseif ( XKD.strStatus == "WATCH" ) then
		SendNoEcho("watch 石壁 400");
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