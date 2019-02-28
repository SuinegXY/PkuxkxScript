-------------------------------------
--             万安塔              --
-------------------------------------
Wat = {};
Wat.nLevel = 1;
Wat.nMax = 4;
Wat.nOver = false;

Common.CreateTrigger("wat_fightOver", "^暗处的番邦武士对你一抱拳，道“阁下果然武功不凡！”$", 'Wat.FightOver()', 12, "wat", 0);
Common.CreateTrigger("wat_questOver", "^    这里便是万安塔了，塔下木门紧闭。寻常人等似乎无法进入。”$", 'Wat.QuestOver()', 12, "wat", 0);
Common.CreateTrigger("wat_startQuest", "^    玄冥二老 鹿杖客\\(Luzhang ke\\) \\[任务发放\\]$", 'Wat.Ask()', 12, "wat", 0);
Common.CreateTrigger("wat_startwait", "^    玄冥二老 鹿杖客\\(Luzhang ke\\)$", 'DoAfter(2, "l");', 12, "wat", 0);
Common.CreateTrigger("wat_startFighte", "^系统回馈：BATTLE = 1$", 'DeleteTimer("wat_up");', 12, "wat", 0);
Common.CreateTrigger("wat_setLevel", "^万安塔(\\S+)层 - .*$", 'Wat.SetLevel("%1");', 12, "wat", 0);
Common.CreateTrigger("wat_koulingOK", "^恭喜你，答对了口令，你可以敲锣离开了，你被允许下次进入万安塔的时间被提前了一分钟。$", 'SendNoEcho("qiao luo");', 12, "wat", 0);
Common.CreateTrigger("wat_kouling", "^请用kouling命令回答当日万安塔的口令，如果错误，将受到一定惩罚。$", 'Wat.Kouling()', 12, "wat");
Common.CreateTrigger("wat_kouling2", "^你在万安塔任务中被奖励了.*$", 'Wat.Over()', 12, "wat");
Common.CreateTrigger("wat_box", "^鹿杖客给你一个宝盒。$", 'Execute("open box;pack gem")', 12, "wat");

EnableGroup("wat", false);
DeleteTimer("wat_killcmd");
DeleteTimer("wat_up")

Wat.Ask = function()
	DoAfterSpecial(2, "WAT", 10);
end

Wat.Init = function()
	local strNum = GetVariable("WAT_NUM");
	if ( strNum ~= nil ) then
		Wat.nMax = tonumber(strNum);
	end
	Common.CloseAllGroup();
	Wat.nLevel = 1;
	--Battle.BattlePerformSwtich(false);
	EnableGroup("wat", true);
	SetVariable("Q_name", "万安塔");
	SendNoEcho("ask ke about 进塔");
	Battle.SetEscape(false);
	Common.CreateTimer("wat_killcmd", 0, 1, "Wat.Kill", 0, "wat");
	--Common.CreateTimer("wat_up", 0, 1, "Wat.Up");
end

Wat.Kill = function()
	if string.find(Way.strPlace, "万安塔") then
		SendNoEcho("kill wushi");
		SendNoEcho("sp chainless");
		if Wat.nLevel >= Wat.nMax and Battle.bBattle == false then
			SendNoEcho("qiao luo");
		end
	end
end

Wat.FightOver = function()
	if GetVariable("WAT_ZD") ~= "0" then
		if Wat.nLevel < Wat.nMax then
			if Wat.nLevel > 2 then
				Battle.BattlePerformSwtich(true);
			end
		else
			Wat.nOver = true;
			SendNoEcho("qiao luo");
		end
	end
end

Wat.QuestOver = function()
	if Wat.nOver then
		EnableGroup("wat", false);
		Execute(wat,hsz);
		Wat.nOver = false;
		DeleteTimer("wat_killcmd");
		--DeleteTimer("wat_up");
		SetVariable("Q_name", "");
	end
end

Wat.Up = function()
	if Wat.nLevel < Wat.nMax and Wat.nLevel < 8 and Battle.TryHeal() and string.find(Way.strPlace, "万安塔") == 1 then
		SendNoEcho("up");
	end
end

Wat.SetLevel = function(strNum)
	Wat.nLevel = StrToNum(strNum);
	if Wat.nLevel >= Wat.nMax then
		SendNoEcho("qiao luo");
	end
end

Wat.Kouling = function()
	if GetVariable("WAT_KOULING") ~= "1" then
		SendNoEcho("qiao luo");
	else
		Common.ShowCommand("kouling ", true);
	end
end

Wat.Over = function()
	DeleteTimer("wat_killcmd");
	QuestOver.WAT();
end

-------------------------------------
--              漂流               --
-------------------------------------
PiaoLiu = {};
PiaoLiu.strLength = "";
PiaoLiu.strToward = "";
PiaoLiu.strHua = "";
PiaoLiu.bFight = false;
PiaoLiu.strHuaDist = "";
EnableGroup("pl", false);

Common.CreateAlias("alias_pl_start", "^PL$", 'PiaoLiu.Init("")', 12, "triggers");
Common.CreateAlias("alias_pl", "^PL (\\S+) (\\S+) (\\S+)$", 'PiaoLiu.Init("%1", "%2", "%3")', 12, "pl");
Common.CreateAlias("alias_pl_mid", "^PL (\\S+)$", 'PiaoLiu.SetLength("%1")', 12, "pl");
Common.CreateTrigger("PL_BATTLE_OVER", "^系统回馈：BATTLE = 0$", 'PiaoLiu.FightOver()', 12, "pl", 0);
Common.CreateTrigger("PL_BATTLE_OVER2", "^系统回馈：BATTLE = 0$", 'PiaoLiu.BattleOver()', 12, "pl", 0);
Common.CreateTrigger("pl_piao", "^小船已经顺流漂出了(\\S+)里开外了。$", 'PiaoLiu.Piao("%1")', 12, "pl", 0, true);
Common.CreateTrigger("pl_fight", "^一个\\S+爬上了你的小船。$", 'PiaoLiu.Fight()', 12, "pl", 0);
Common.CreateTrigger("pl_hua", "^小船被你向\\S+划出了(\\S+)里了。$", 'PiaoLiu.Hua("%1")', 12, "pl", 0);
Common.CreateTrigger("pl_dalao", "^你把锚缓缓放下，立刻开始着手准备打捞\\(dalao\\)宝物。$", 'PiaoLiu.Dalao()', 12, "pl", 0);
Common.CreateTrigger("pl_over", "^也许你可以返航了。可以使用hua back命令。$", 'PiaoLiu.Over()', 12, "pl", 0);
Common.CreateTrigger("pl_nextQuest", "^你已经完成了\\S+次鄱阳湖寻宝任务。$", 'QuestOver.PL()', 12, "pl", 0);
Common.CreateTrigger("pl_busy", "^你正忙着呢，现在不能划桨?$", 'SendNoEcho(1, "PLH", 2)', 12, "pl", 0);
--Common.CreateTrigger("pl_over", "^你终于打退了\\S+的攻击。$", 'PiaoLiu.Over()', 12, "pl", 0);
--Common.CreateTrigger("pl_hua2", "^打败鄱阳内湖水贼，你额外获得\\S+经验、\\S+点潜能。$", 'PiaoLiu.Hua(PiaoLiu.strHuaDist)', 12, "pl", 0);
DeleteTrigger("pl_hua2");
DeleteTimer("PL_DALAO_ACTION");

PiaoLiu.Init = function(strLength, strToward, strHua)
	if strLength == "" then
		Common.CloseAllGroup();
		EnableGroup("pl", true);
		Battle.bPerform = true;
		SetVariable("Q_name", "漂流");
		EnableTrigger("pl_fight", false);
		EnableTrigger("PL_BATTLE_OVER", false);
		local bHard = GetVariable("PL_HARD");
		if bHard == nil then bHard = "0"; end
		if bHard == "1" then
			Note("漂流开始---->困难模式");
			SendNoEcho("ask ren about 重宝");
		else
			Note("漂流开始---->普通模式");
			SendNoEcho("ask ren about job");
		end
	else
		--YunQiJing.ForceQi();
		PiaoLiu.strLength = strLength;
		PiaoLiu.strToward = StrToToward(strToward);
		PiaoLiu.strHua = strHua;
		PiaoLiu.strHuaDist = "";
		Send("answer 漂" .. strLength .. "里后往" .. strToward .. "划" .. strHua .. "里");
		Note("Toward:" .. PiaoLiu.strToward);
		SendNoEcho("shang boat");
		SendNoEcho("jie sheng");
		SendNoEcho("gua");
		Battle.SetEscape(false);
	end
end

PiaoLiu.SetLength = function(strLength)
	PiaoLiu.strLength = strLength;
end

PiaoLiu.Piao = function(strLength)
	SetVariable("Q_misc2", strLength .. ":" .. PiaoLiu.strLength);
	if GetVariable("PL_HARD") == "1" and Battle.bBattle == true then
		SendNoEcho("sheng");
		SendNoEcho("xia");
	end
	if strLength == PiaoLiu.strLength then
		SendNoEcho("ting");
		SendNoEcho("gua");
		SendNoEcho("shouqi");
		EnableTrigger("pl_fight", true);
		DoAfterSpecial(4, 'PiaoLiu.HuaCheck()', 12);
	end
	Execute("BUFF");
	Note("################ 漂流进度: " .. strLength .. " / " .. PiaoLiu.strLength .. " ################");
end

PiaoLiu.Fight = function()
	PiaoLiu.bFight = true;
	EnableTrigger("PL_BATTLE_OVER", true);
	--Battle.FightOverAdd(PiaoLiu.FightOver);
end

PiaoLiu.FightOver = function()
	--Note("PL结束");
	PiaoLiu.bFight = false;
	--EnableTrigger("PL_BATTLE_OVER", false);
	PiaoLiu.Hua(PiaoLiu.strHuaDist);
end

PiaoLiu.BattleOver = function()
	SendNoEcho("killall");
	SendNoEcho("gua");
	SendNoEcho("shouqi");
end

PiaoLiu.HuaCheck = function()
	if PiaoLiu.bFight == false then
		PiaoLiu.Hua(PiaoLiu.strHuaDist);
		--EnableTrigger("pl_fight", false);
	end
end

PiaoLiu.Hua = function(strHua)
	SetVariable("Q_misc2", strHua .. ":" .. PiaoLiu.strHua );
	if strHua == PiaoLiu.strHua then
		SendNoEcho("xiamao");
	else
		--Note("PL Hua:" .. PiaoLiu.strToward);
		SendNoEcho("hua " .. PiaoLiu.strToward);
		PiaoLiu.strHuaDist = strHua;
	end
end

PiaoLiu.Dalao = function()
	Common.CreateTimer("PL_DALAO_ACTION", 0, 5, "PiaoLiu.DalaoAction", 0, "pl");
end

PiaoLiu.DalaoAction = function()
	SendNoEcho("dalao");
end

PiaoLiu.Over = function()
	DeleteTimer("PL_DALAO_ACTION");
	SendNoEcho("hua back");
	SendNoEcho("give ren xiang");
	DoAfterSpecial(0.5, 'SendNoEcho("give ren xiang")', 12);
	DoAfterSpecial(1.5, 'SendNoEcho("give ren xiang")', 12);
	DoAfterSpecial(2, 'SendNoEcho("give ren xiang")', 12);
	DoAfterSpecial(3, 'Execute(GetVariable("PL_OVER"))', 12);
	EnableGroup("pl", false);
end


-------------------------------------
--             胡一刀              --
-------------------------------------
HYD = {};
HYD.id = "";
HYD.name = "";
HYD.area = "";
HYD.complate = false;
HYD.bMap = false;
HYD.nNum = 0;

Common.CreateAlias("alias_hyd", "^HYD(\\S+)$", 'HYD.Trigger("%1")', 12, "triggers");
Common.CreateAlias("alias_hyd_pic", "^HYD (\\S+) (\\S+)$", 'HYD.Alias("%1", "%2")', 12, "triggers");
Common.CreateAlias("alias_hyd_map", "^HYDM (\\S+)$", 'HYD.GoMap("%1")', 12, "triggers");
Common.CreateTrigger("hyd_init", "^胡一刀说道：『我收到消息，听说(\\S+)有盗宝人(\\S+)\\((\\S+)\\)找到了闯王宝藏的地图,你可否帮忙找回来！』$", 'HYD.Init("%1", "%3", "%2")', 12, "hyd", 0);
Common.CreateTrigger("hyd_accept", "^    \\S*辽东大侠 胡一刀\\(Hu yidao\\)(.*)$", 'HYD.Accept("%1")', 12, "hyd", 0);
Common.CreateTrigger("hyd_nect", "^\\S+说道：“你有种去(\\S+)找我兄弟(\\S+)\\((\\S+)\\)，他会给我报仇的！”$", 'HYD.Init("%1", "%3", "%2")', 12, "hyd", 0);
Common.CreateTrigger("hyd_check", "^.*盗 宝 人 「\\S+龙」(\\S+)\\((.+)\\).*$", 'HYD.Check("%1", "%2")', 12, "hyd", 0);
Common.CreateTrigger("hyd_map", "^    \\S+\\(Sui cong\\)$", 'HYD.Map()', 12, "hyd", 0);
Common.CreateTrigger("hyd_over", "^\\S+长叹道：“人算不如天算，想不到我兄弟五人都栽在你的手中！”$", 'HYD.Combine()', 12, "hyd", 0);
Common.CreateTrigger("hyd_baotu", "^胡一刀把一张注释过的藏宝图递给了你。$", 'HYD.Baotu()', 12, "hyd", 0);
Common.CreateTrigger("hyd_goto", "^.*告诉你：【.*】目前在【(\\S*)】,快去摁死它吧!$", 'HYD.strGotoPlace = "%1";if Battle.bBattle == false then Common.InstanceRun(HYD.Goto, 10); end', 12, "hyd", 0);
Common.CreateTrigger("hyd_startbl", "^系统回馈：WALK_FINISH = 0$", 'HYD.StartBL()', 12, "hyd", 0);
--Common.CreateTrigger("hyd_gotobl", '^系统回馈：BL_ID = (\\S+)$', 'HYD.GotoID("%1")', 12, "hyd", 0);
--Common.CreateTrigger("hyd_gotoblerror", "^系统回馈：BL_ERROR = 0$", 'HYD.Find(HYD.id)', 12, "hyd", 0);
Common.CreateTrigger("hyd_goto2", "^盗宝人(\\S+)在(\\S+)$", 'HYD.Goto2("%2", "%1")', 12, "hyd", 0);
Common.CreateTrigger("hyd_xunbaoOver2", "^你找到了闯王宝藏的线索$", 'HYD.Over2()', 12, "hyd", 0);
Common.CreateTrigger("hyd_xunbaoOver", "^你给胡一刀一张闯王宝藏藏宝图。$", 'HYD.Over()', 12, "hyd", 0);
Common.CreateTrigger("hyd_getmap", "^你从\\S+的尸体身上搜出一片宝藏地图残片。$", 'HYD.Digit()', 12, "hyd", 0);
Common.CreateTrigger("hyd_item", "^从\\S+身上掉了出来一颗\\S+$", 'SendNoEcho("pack gem")', 12, "hyd", 0);
Common.CreateTrigger("hyd_mapstart", "^我发现附近的小树林里面藏着一伙盗宝人，从他们身上可能会获得线索。我这就带你过去。$|^系统回馈：WALK_STEP = 1$", 'DoAfterSpecial(2, "HYD.MapStep()", 12)', 12, "hyd", 0);
DeleteTrigger("hyd_mapstart");

EnableGroup("hyd", false);

HYD.Trigger = function(strParam)
	Common.CloseAllGroup();
	Battle.bPerform = true;
	EnableGroup("hyd", true);
	SetVariable("Q_name", "胡一刀");
	if strParam == "A" then
		SendNoEcho("set adv_quest 50");
		SendNoEcho("ask hu about job");
		Battle.SetEscape(true);
		HYD.bMap = false;
		HYD.complate = false;
		HYD.nNum = 0;
		SendNoEcho("unwield");
		Execute("E_A");
	elseif strParam == "B" then
		SendNoEcho("ask hu about 帮助");
	elseif strParam == "M" then
		HYD.bMap = true;
	elseif strParam == "F" and HYD.id then
		Common.Find(HYD.id);
	end
end

HYD.Alias = function(strArea, strName)
	EnableGroup("hyd", true);
	HYD.name = strName;
	Way.Goto(strArea);
end

HYD.GoMap = function(strPlace)
	HYD.bMap = true;
	Way.Goto(strPlace);
end

HYD.MapStep = function()
	if HYD.nNum == 5 then return; end
	if Battle.bBattle == false then
		if HYD.nNum < 4 then
			Way.FindItemWayRandom("盗 宝 人", "∨", "铜板");
		else
			Way.FindItemWayRandom("盗 宝 人", "", "铜板");
		end
	end
	--DoAfterSpecial(4, 'Common.InstanceRun(HYD.MapStep, 3)', 12);
end

HYD.Accept = function(strCan)
	if strCan ~= nil and strCan ~= "" and HYD.complate == false then
		Execute("HYDA");
	elseif HYD.complate then
		SendNoEcho("combine");
		SendNoEcho("give hu cangbao tu");
		--HYD.Over();
	else
		DoAfterSpecial(5, 'SendNoEcho("l")', 12);
	end
end

HYD.StartBL = function()
	--Execute("bl " .. HYD.area .. " " .. HYD.name);
	SendNoEcho("xunbao");
	DoAfterSpecial(3, "Way.TryBl()", 12);
end

HYD.Init = function(strArea, strID, strName)
	local strPlaceID = Name.TrancelateLocate(strArea);
	SetVariable("Q_misc", strArea);
	SetVariable("Q_misc2", strID);
	HYD.id = strID;
	HYD.name = strName;
	HYD.area = strArea;
	Way.Goto(Location.tBLID[HYD.area]);
	SetVariable("BL_PLACE", HYD.area);
	SetVariable("BL_NAME", HYD.name);
	SetVariable("AIM_NPC_ID", HYD.id);
	--Execute("blcha " .. strArea);
	--Common.Find(HYD.id);
	--SendNoEcho("group find ...");
	--SendNoEcho("group find " .. strID);
	Note("胡一刀:" .. strPlaceID .. " ID:" .. strPlaceID .. " 找 " .. strID );
	HYD.nNum = HYD.nNum + 1;
	SetVariable("Q_location", HYD.nNum);
end

HYD.Map = function()
	if HYD.bMap == true then
		SendNoEcho("ask sui cong about 藏宝图");
	end
end

HYD.strGotoPlace = "";
HYD.Goto = function()
	--Execute("bl off");
	Note(HYD.strGotoPlace);
	Way.GotoCH(HYD.strGotoPlace);
end

HYD.GotoID = function(strID)
	Way.Goto(strID);
end

HYD.Goto2 = function(strPlace, strName)
	HYD.name = strName;
	HYD.strNextPlace = strPlace;
	Note("测试:HYD的NPC地址:" .. strPlace);
	DoAfterSpecial(1, 'Way.GotoCH(HYD.strNextPlace)', 12);
	local t = Location.GetPlace(strPlace);
	SetVariable("BL_PLACE", t.area);
	SetVariable("BL_NAME", HYD.name);
end

HYD.Check = function(strName, strID)
	--Note(strName .. ":" .. strID);
	if strName == HYD.name or HYD.bMap then
		Execute("BUFF");
		Execute("E_A");
		Way.GotoEnd();
		Way.Clear();
		SendNoEcho("halt");
		local strID = string.lower(strID);
		SetVariable("AIM_NPC_ID", strID);
		SendNoEcho("follow " .. strID)
		SendNoEcho("kill "  .. strID);	
		Note("========");
		Note("==发现==");
		Note("========");
	end
end

HYD.Combine = function()
	HYD.complate = true;
	SendNoEcho("combine");
	--DoAfterSpecial(2, 'Way.Goto("hyd")', 12);
	Common.SetID(nil);
	SetVariable("Q_misc", "完成");
	SetVariable("Q_misc2", "");
end

HYD.Over = function()
	if GetVariable("HYD_NOMAP") == "1" then
		QuestOver.HYD();
	end
end

HYD.Over2 = function()
	Execute("close_fullme");
	QuestOver.HYD();
end

HYD.Baotu = function()
	SendNoEcho("chakan bao tu");
	Common.ShowCommand("gt ", true);
end

HYD.Digit = function()
	if HYD.bMap == false then return; end
	HYD.nNum = HYD.nNum + 1;
	SetVariable("Q_location", HYD.nNum);
	SendNoEcho("combine");
	if HYD.nNum == 5 then
		HYD.complate = true;
		DoAfterSpecial(2, 'Execute("combine;out;gt hyd")', 12);
	end
end

-------------------------------------
--             孟之经              --
-------------------------------------
MZJ = {};
MZJ.bStart = false;
MZJ.strWaitPlace = "";
MZJ.strWaitID = "";
MZJ.tCode = {};
MZJ.tDecode = {};
MZJ.nDecodeIndex = 1;
MZJ.strAimLocate = "";
MZJ.strAimID = "";
MZJ.strAimNpcName = "";
MZJ.strAimNpcID = "";
MZJ.bComplate = false;
MZJ.bStartBL = false;
MZJ.bOnce = false;
MZJ.bAskFail = false;
MZJ.bRecode = false;
MZJ.bZhanbu = false;

Common.CreateAlias("alias_mzj", "^MZJ([AB]{1})$", 'MZJ.Trigger("%1")', 12, "triggers");
Common.CreateAlias("alias_mzjfail", "^MZJF$", 'MZJ.Fail()', 12, "mzj", 0);
Common.CreateAlias("alias_mzjpic", "^MZJ (\\S+)$", 'MZJ.Pic("%1")', 12, "mzj", 0);
Common.CreateAlias("alias_mzjpic2", "^MZJP(\\S+)$", 'MZJ.Pic("%1")', 12, "mzj", 0);
Common.CreateTrigger("mzj_finish", "^    大宋 建康都统制府赞划 孟之经\\(Meng zhijing\\)$", 'MZJ.Complate()', 12, "mzj", 0);
Common.CreateTrigger("mzj_findout", "^你定睛一看，(\\S+)正是你要找的汉奸卖国贼！$", 'MZJ.Findout("%1")', 12, "mzj", 0);
Common.CreateTrigger("mzj_check", "^.*大元 建康府南城路\\S+使 (\\S+)\\((\\S+ \\S+)\\).*$", 'MZJ.Check("%1", "%2")', 12, "mzj", 0);
Common.CreateTrigger("mzj_escape", "^(\\S+)往(\\S+)落荒而逃了。$", 'MZJ.Escape("%1", "%2")', 12, "mzj", 0);
Common.CreateTrigger("mzj_decode2", "^[0-9 ]{2,4}(\\S+)$", 'MZJ.Decode("%1")', 12, "mzj", 0);
Common.CreateTrigger("mzj_complate", "^恭喜！你完成了都统制府行刺任务！$", 'MZJ.GoBack()', 12, "mzj", 0);
Common.CreateTrigger("mzj_code1", "^孟之经\\(meng zhijing\\)告诉你：第一个字在：第(\\S{2,4})行，第(\\S{2,4})列。第二个字在：第(\\S{2,4})行，第(\\S{2,4})列。对照\\(duizhao\\)这页，你就知道你要刺杀的人在哪了。$", 'MZJ.Code("%1", "%2", "%3", "%4")', 12, "mzj", 0);
Common.CreateTrigger("mzj_code2", "^孟之经\\(meng zhijing\\)告诉你：第一个字在：第(\\S{2,4})行，第(\\S{2,4})列。第二个字在：第(\\S{2,4})行，第(\\S{2,4})列。第三个字在：第(\\S{2,4})行，第(\\S{2,4})列。对照\\(duizhao\\)这页，你就知道你要刺杀的人在哪了。$", 'MZJ.Code("%1", "%2", "%3", "%4", "%5", "%6")', 12, "mzj", 0);
Common.CreateTrigger("mzj_code3", "^孟之经\\(meng zhijing\\)告诉你：第一个字在：第(\\S{2,4})行，第(\\S{2,4})列。第二个字在：第(\\S{2,4})行，第(\\S{2,4})列。第三个字在：第(\\S{2,4})行，第(\\S{2,4})列。第四个字在：第(\\S{2,4})行，第(\\S{2,4})列。对照\\(duizhao\\)这页，你就知道你要刺杀的人在哪了。$", 'MZJ.Code("%1", "%2", "%3", "%4", "%5", "%6", "%7", "%8")', 12, "mzj", 0);
Common.CreateTrigger("mzj_code4", "^孟之经\\(meng zhijing\\)告诉你：第一个字在：第(\\S{2,4})行，第(\\S{2,4})列。第二个字在：第(\\S{2,4})行，第(\\S{2,4})列。第三个字在：第(\\S{2,4})行，第(\\S{2,4})列。第四个字在：第(\\S{2,4})行，第(\\S{2,4})列。第五个字在：第(\\S{2,4})行，第(\\S{2,4})列。对照\\(duizhao\\)这页，你就知道你要刺杀的人在哪了。$", 'MZJ.Code("%1", "%2", "%3", "%4", "%5", "%6", "%7", "%8", "%9", "%<10>")', 12, "mzj", 0);
Common.CreateTrigger("mzj_wait", "^你向孟之经打听有关『job』的消息。\\n孟之经说道：「这里人多眼杂，你先到(\\S+)等候，我自会通知你。」$", 'MZJ.Wait("%1");MZJ.bZhanbu = true', 12, "mzj", 0, false, 2);
Common.CreateTrigger("mzj_wait2", "^孟之经\\(meng zhijing\\)告诉你：叫你到(\\S+)等候，你还慢腾腾地闲逛，赶紧点。$", 'MZJ.Wait("%1")', 12, "mzj", 0, false, 2);
Common.CreateTrigger("mzj_init", "^    大宋 建康都统制府赞划 孟之经\\(Meng zhijing\\) \\[任务发放\\]$", 'SendNoEcho("ask meng about job")', 12, "mzj", 0);
Common.CreateTrigger("mzj_cantfind", "^系统回馈：BL_NO_FIND = 0$", 'MZJ.Fail()', 12, "mzj", 0);
Common.CreateTrigger("mzj_blstart", "^系统回馈：WALK_FINISH = 0$", 'MZJ.BL();', 12, "mzj", 0);
Common.CreateTrigger("mzj_start", "^你背着众人，悄悄地打开了旧纸。$", 'MZJ.StartRecode()', 12, "mzj", 0);
--Common.CreateTrigger("mzj_over", "^.*$", 'MZJ.StopRecode()', 12, "mzj", 0);
DeleteTrigger("mzj_over");

DeleteTimer("mzj_timer_search");
EnableTrigger("mzj_decode2", false);

MZJ.Init = function()
	MZJ.strWaitPlace = "";
	MZJ.strWaitID = "";
	MZJ.tCode = {};
	MZJ.tDecode = {};
	MZJ.nDecodeIndex = 1;
	MZJ.strAimLocate = "";
	MZJ.strAimID = "";
	MZJ.bComplate = false;
	MZJ.bStartBL = false;
	MZJ.bOnce = false;
	MZJ.bAskFail = false;
	MZJ.bRecode = false;
	MZJ.bZhanbu = false;
	Common_StatusClear();
	Battle.bPerform = true;
	Battle.SetEscape(true);
	SetVariable("Q_name", "刺杀");
	--Note("MZJ清空:" .. MZJ.strWaitID);
end

MZJ.GoBack = function()
	MZJ.bComplate = true;
	DoAfterSpecial(2, 'Way.Goto("mzj")', 12);
	DeleteTimer("mzj_timer_search");
end

MZJ.Complate = function()
	if MZJ.bStart == true then
		if MZJ.bAskFail then
			SendNoEcho("ask meng about finish");
			SendNoEcho("ask meng about fail");
		else
			SendNoEcho("ask meng about finish");
		end
		DoAfterSpecial(1, 'SendNoEcho("drop zhi")', 12);
	end
end

MZJ.Trigger = function(strParam)
	if strParam == "A" then
		Common.CloseAllGroup();
		EnableGroup("mzj", true);
		EnableTrigger("mzj_decode2", false);
		MZJ.bStart = false;
		DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	elseif strParam == "B" then
		EnableGroup("mzj", false);
	end
end

MZJ.Wait = function(strPlace)
	MZJ.Init();
	MZJ.strWaitPlace = "建康" .. strPlace;
	MZJ.strWaitID = Name.TrancelateLocate(MZJ.strWaitPlace);
	--if GetVariable("ENABLE_ZHANBU") == "1" then
	--	Execute("w;zhanbu -myself");
	--	DoAfterSpecial(10, 'Way.Goto(MZJ.strWaitID)', 12);
	--else
		Way.Goto(MZJ.strWaitID);
	--end
	
	SetVariable("Q_place", strPlace);
	SetVariable("Q_misc2", MZJ.strWaitID);
	--Note("MZJ测试:" .. MZJ.strWaitID);
	QuestOver.QuestStart();
end

MZJ.Pic = function(strParam)
	--Note(strParam .. ":" .. #strParam);
	MZJ.tDecode = {};
	MZJ.tCode.x = {};
	MZJ.tCode.y = {};
    local tCode = utils.split(strParam,",");
	if #tCode%2 == 1 then
		Note("参数错误");
		if Fullme.IsStart() == true then
			Fullme.Wrong();
		end
		return;
	end
	for i = 1, #tCode/2 do
		MZJ.tCode.y[i] = tonumber(tCode[i*2-1]);
		MZJ.tCode.x[i] = tonumber(tCode[i*2]);
	end
	Execute("close_fullme");
	SendNoEcho("duizhao");
end

MZJ.StartRecode = function()
	MZJ.strAimLocate = "";
	MZJ.tDecode = {};
	MZJ.nDecodeIndex = 1;
	MZJ.bRecode = true;
	EnableTrigger("mzj_decode2", true);
	Common.CreateTimer("mzj_decode", 0, 1, "MZJ.StopRecode", true, "mzj");
end

MZJ.StopRecode = function()
	if MZJ.bRecode == true then
		MZJ.bRecode = false;
		EnableTrigger("mzj_decode2", false);
		MZJ.DecodeStart();
	end
end

MZJ.Code = function(strY1, strX1, strY2, strX2, strY3, strX3, strY4, strX4, strY5, strX5)
	MZJ.tCode.x = {};
	MZJ.tCode.y = {};
	MZJ.tCode.x[1] = StrToNum(strX1);
	MZJ.tCode.y[1] = StrToNum(strY1);
	MZJ.tCode.x[2] = StrToNum(strX2);
	MZJ.tCode.y[2] = StrToNum(strY2);
	if strY3 ~= nil then
		MZJ.tCode.x[3] = StrToNum(strX3);
		MZJ.tCode.y[3] = StrToNum(strY3);
	end
	if strY4 ~= nil then
		MZJ.tCode.x[4] = StrToNum(strX4);
		MZJ.tCode.y[4] = StrToNum(strY4);
	end
	if strY5 ~= nil then
		MZJ.tCode.x[5] = StrToNum(strX5);
		MZJ.tCode.y[5] = StrToNum(strY5);
	end
	--MZJ.bRecode = true;
	--EnableTrigger("mzj_decode2", true);
	SendNoEcho("duizhao");
end

MZJ.Decode = function(strLine)
	if MZJ.bRecode == false then return; end
	MZJ.tDecode[MZJ.nDecodeIndex] = strLine;
	--Note(MZJ.nDecodeIndex .. ":" .. MZJ.tDecode[MZJ.nDecodeIndex]);
	MZJ.nDecodeIndex = MZJ.nDecodeIndex +1;
	--Common.CreateTimer("mzj_decode", 0, 1, "MZJ.DecodeStart", true, "mzj");
end

MZJ.DecodeStart = function()
	MZJ.bRecode = false;
	if MZJ.tCode and MZJ.tCode.x[1] ~= nil then
		for i = 1, #MZJ.tCode.x do
			local nY = tonumber(MZJ.tCode.y[i]);
			local nX = tonumber(MZJ.tCode.x[i]);
			--Note("X:" .. nX .. " Y:" .. nY);
			--Note(MZJ.tDecode[nY]);
			--Note(MZJ.tCode.y[i] .. " " .. MZJ.tCode.x[i] .. " " .. MZJ.tDecode[nY] .. " : " .. nX);
			local strWord = string.sub(MZJ.tDecode[nY], nX*2 - 1, nX*2);
			--Note(strWord);
			MZJ.strAimLocate = MZJ.strAimLocate .. strWord;
		end
		EnableTrigger("mzj_decode2", false);
		if MZJ.strAimLocate ~= "" then
			SetVariable("Q_location", MZJ.strAimLocate);
			MZJ.strAimID = Location.tBLID[MZJ.strAimLocate];
			if Fullme.IsStart() == true then
				if MZJ.strAimID ~= nil then
					Fullme.Right();
				else
					Fullme.Wrong();
				end
			end
			if MZJ.strAimID == nil then
				--MZJ.strAimID = Location.strAreaIDs[MZJ.strAimLocate];
				MZJ.strAimID = Name.TrancelateLocate(MZJ.strAimLocate);
			end
			if MZJ.strAimID ~= nil then
				SetVariable("Q_misc2", MZJ.strAimID);
				Way.Goto(MZJ.strAimID, false);
				--Way.To(MZJ.strWaitID, MZJ.strAimID, false);
				MZJ.bStartBL = true;
			end
			SetVariable("BL_PLACE", MZJ.strAimLocate);
			SetVariable("BL_NAME", "查找未知目标待确定");
		end
	end
	MZJ.bStart = true;
end

MZJ.BL = function()
	if MZJ.bStartBL == true then
		DoAfterSpecial(3, "Way.TryBl()", 12);
		MZJ.bOnce = ture;
	elseif MZJ.bZhanbu == true then
		SendNoEcho("zhanbu -myself");
		MZJ.bZhanbu = false;
	end
end

MZJ.Findout = function(strName)
	Execute("blNpc " .. strName);
	SetVariable("BL_NAME", strName);
	MZJ.strAimNpcName = strName;
	SendNoEcho("l");
	DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	--Execute("wks");
	if MZJ.bOnce == ture then
		MZJ.bStartBL = false;
	end
	Note("============");
	Note("====找到====");
	Note("============");
end

MZJ.Search = function()
	if Battle.bBattle == false then
		Way.FindItemWay(MZJ.strAimNpcName);
	end
end

MZJ.Check = function(strName, strID)
--	Note(strName .. strID);
	if strName == MZJ.strAimNpcName then
		MZJ.strAimNpcID = string.lower(strID);
		SendNoEcho("follow " .. MZJ.strAimNpcID );
		--SendNoEcho("trap " .. MZJ.strAimNpcID );
		--SendNoEcho("zhanbu " .. MZJ.strAimNpcID );
		SendNoEcho("killall " .. MZJ.strAimNpcID );
		SetVariable("AIM_NPC_ID", MZJ.strAimNpcID);
		DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	end
	if MZJ.bOnce == true then
		Common.CreateTimer("mzj_timer_search", 0, 5, "MZJ.Search", 0, "mzj");
	end
end

MZJ.Escape = function(strName, strToward)
	DoAfterSpecial(1, 'SendNoEcho("killall " .. MZJ.strAimNpcID)', 12);
end

MZJ.Fail = function()
	Execute("bl off");
	MZJ.bAskFail = true;
	MZJ.bStartBL = false;
	Way.Goto("mzj");
end

-------------------------------------
--              天珠               --
-------------------------------------
TZ = {};
TZ.strPlaceID = "";
TZ.nKill = 0;
TZ.bNext = false;
TZ.bAskFail = false;
TZ.bFind = false;
TZ.bOver = false;
TZ.bStart = false;
TZ.bNeedFail = false;
TZ.nShaqi = 0;
DeleteTimer("TZ_AddNext");

Common.CreateAlias("alias_tzfail", "^TZF$", 'TZ.Fail()', 12, "tz", 0);
Common.CreateAlias("alias_tzCha", "^TZC$", 'SendNoEcho("ask lianhua about 煞气");', 12, "tz", 0);
Common.CreateTrigger("TZ_FIND", "^似乎有什么东西一闪……$", 'TZ.Find()', 12, "tz", 0);
Common.CreateTrigger("TZ_YOU_ARE_HERE", "^系统回馈：YOU_ARE_HERE = 0$", 'TZ.AddNext()', 12, "tz", 0);
Common.CreateTrigger("TZ_BATTLE_OVER", "^系统回馈：BATTLE = 0$", 'TZ.BattleOver()', 12, "tz", 0);
Common.CreateTrigger("TZ_BATTLE_START", "^.*出现，恶狠狠地看着你。$", 'TZ.BattleStart()', 12, "tz", 0);
Common.CreateTrigger("TZ_PIC", "^莲花生大士\\(lianhuasheng dashi\\)告诉你：天珠即将出世。$", 'TZ.Pic()', 12, "tz", 0);
Common.CreateTrigger("TZ_SHAQI", "^莲花生大士\\(lianhuasheng dashi\\)告诉你：天珠出世，煞气为(\\S+)。$", 'TZ.Shaqi("%1")', 12, "common", 1);
Common.CreateTrigger("TZ_over", "^莲花生大士默默接过你手中的天珠，轻轻抚摸着。$", 'QuestOver.TZ()', 12, "tz", 1);

TZ.Ask = function(strWord)
	if strWord ~= "" then
		Execute("TZ");
	else
		if TZ.bAskFail then
			TZ.bStart = false;
			TZ.bOver = false;
			Execute("TZS");
			SendNoEcho("tzbreak");
			--SendNoEcho("drop tian zhu");
		elseif TZ.bOver == true then
			TZ.bStart = false;
			--TZ.bOver = false;
			SendNoEcho("give dashi tian zhu");
			DoAfterSpecial(5, 'SendNoEcho("l")', 12);
		elseif TZ.bStart == false then
			--TZ.bStart = true;
			DoAfterSpecial(2, 'SendNoEcho("ask dashi about job")', 12);
		end
		SendNoEcho("give dashi tian zhu");
	end
end

TZ.Pic = function()
	if TZ.bNeedFail == true then
		TZ.bNeedFail = false;
		DoAfterSpecial(1, 'Execute("close_fullme")', 12);
		DoAfterSpecial(1, 'SendNoEcho("ask dashi about fail")', 12);
	else
		TZ.bNeedFail = true;
		TZ.Init();
		EnableTimer("quest_look", false);
		SelectCommand();
		PasteCommand("T ");
	end
end

TZ.Shaqi = function(strShaqi)
	SetVariable("Q_misc2", strShaqi);
	local strSet = GetVariable("TZ_DEPTH");
	if strSet == "" then strSet = "0"; end
	local nShaqi = tonumber(strSet);
	--Note("设置煞气等级:" .. nShaqi);
	TZ.nShaqi = StrToNum(strShaqi);
	if TZ.nShaqi < nShaqi then
		TZ.bNeedFail = false;
	end
end

TZ.Init = function()
	Common.CloseAllGroup();
	Execute("EGA tz");
	if Common.id ~= "suinegy" or true then
		Battle.SetEscape(true);
		Battle.bPerform = true;
	end
	SetVariable("Q_name", "天珠");
	SendNoEcho("unset adv_quest");
	SendNoEcho("ask dashi about job");
	TZ.bAskFail = false;
	TZ.bOver = false;
	TZ.bStart = false;
	--Battle.SetOnePfm(true);
end

TZ.Accept = function(strPlace)
	SendNoEcho("ask lianhua about 煞气");
	QuestOver.QuestStart();
	if strPlace ~= "" then
		if Common.id ~= "suinegy" or true then
			if TZ.bNeedFail == true then
				TZ.bNeedFail = false;
				SendNoEcho("ask dashi about fail");
				return;
			else
				TZ.bNeedFail = true;
			end
		end
		local tPlace = Location.GetPlace_Test(strPlace);
		TZ.GoPlace(Name.TrancelateLocate(tPlace.area..tPlace.room));
		SetVariable("Q_location", strPlace);
	end
end

TZ.Alias = function(strPlaceID)
	SendNoEcho("ask lianhua about 煞气");
	Execute("close_fullme");
	TZ.GoPlace(strPlaceID);
end

TZ.Fail = function()
	TZ.bAskFail = true;
	Way.Goto("tianzhu");
end

TZ.Find = function()
	if Fullme.IsStart() == true and TZ.bFind == false then
		Fullme.Right();
		DeleteTimer("TZ_FullmeError");
		TZ.bFind = true;
	end
	Common.CreateTimer("look", 0, 4, "Common.Look", true, "tz");
	Execute("BUFF");
	Execute("wks");
	SendNoEcho("yun qi");
	--SendNoEcho("unwield all");
	Execute("E_T");
	SendNoEcho("unwield left");
	Battle.BattlePerformOn();
	TZ.KillStart();
	Way.GotoEnd();
	Way.Clear();
	TZ.bNext = false;
	DeleteTimer("TZ_AddNext");
end

TZ.GoPlace = function(strPlaceID)
	TZ.bStart = true;
	TZ.nKill = 0;
	TZ.strPlaceID = strPlaceID;
	TZ.bNext = false;
	if TZ.strPlaceID == "sczldsm" then
		EnableTrigger("tz_norun", false);
	elseif TZ.strPlaceID == "gbad" then
		TZ.strPlaceID = "gbad24";
	elseif TZ.strPlaceID == "hhba" then
		TZ.strPlaceID = "hhba2";
	elseif TZ.strPlaceID == "lytdhad" then
		TZ.strPlaceID = "lytdhad2";
	elseif TZ.strPlaceID == "ljmd" then
		TZ.strPlaceID = "ljmd2";
	elseif Way.CantArrive(TZ.strPlaceID) then
		SendNoEcho("ask dashi about fail");
		if Common.id == "suinegy" then
			Execute("TZ");
		end
		return;
	elseif TZ.strPlaceID == "jkjnxd" or TZ.strPlaceID == "ywmssl" or TZ.strPlaceID == "ywmtqxd" or TZ.strPlaceID == "hhndk" 
	  or TZ.strPlaceID == "hhbdk" or TZ.strPlaceID == "dlchy" or TZ.strPlaceID == "xymz" or TZ.strPlaceID == "lyxs" 
	  or TZ.strPlaceID == "lzhty" or TZ.strPlaceID == "jkxx" then
		TZ.bNext = true;
		Note("开启遍历");
	end
	if GetVariable("ENABLE_ZHANBU") == "1" then
		SendNoEcho("zhanbu -myself");
		DoAfterSpecial(10, 'Way.Goto(TZ.strPlaceID)', 12);
	else
		Way.Goto(TZ.strPlaceID);
	end
	TZ.bFind = false;
end

TZ.FullmeError = function()
	Fullme.Wrong();
	TZ.bFind = true;
end

TZ.AddNext = function()
	if Fullme.IsStart() == true and TZ.bFind == false then
		Common.CreateTimerFunc("TZ_FullmeError", 0, 10, "TZ.FullmeError()", true, "tz");
	else
		Common.CreateTimer("TZ_AddNext", 0, 10, "TZ.Next", true, "tz");
	end
end

TZ.Next = function()
	if TZ.bNext == false then return; end
	Note("开始遍历");
	Way.Roll(TZ.strPlaceID);
end

TZ.Finish = function()
	SendNoEcho("ask lianhua about 煞气");
	--TZ.Action();
	TZ.strPlaceID = "";
	Battle.SetEscape(false);
	Battle.AddPower(0);
--	EnableGroup("tz", false);
end

TZ.BattleStart = function()
	Common.InstanceRun(Way.FindWayEscape, 5, "天珠");
	DoAfterSpecial(2, 'SendNoEcho("l")', 12);
end

TZ.BattleOver = function()
	DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	DoAfterSpecial(4, 'SendNoEcho("l")', 12);
end

TZ.Back = function()
	Way.Goto("tianzhu");
	TZ.bOver = true;
	if Common.id ~= "suinegy" or true then
		local nNum = GetVariable("TZ_NUM");
		if nNum == nil or nNum == "" then nNum = "1"; end
		nNum = tonumber(nNum);
		if TZ.nKill < nNum then
			TZ.bAskFail = true;
			TZ.bNeedFail = false;
		end
	end
end

TZ.KillStart = function()
	Common.CreateTriggerFunc("tz_kill", "^\\S+死了。$", "TZ.KillDigit", "tz");
end

TZ.KillDigit = function()
	TZ.nKill = TZ.nKill + 1;
end

TZ.KillEnd = function()
	DeleteTrigger("tz_kill");
end

TZ.Action = function()
	local nNum = GetVariable("TZ_NUM");
	if nNum == nil or nNum == "" then nNum = "1"; end
	nNum = tonumber(nNum);
	--if TZ.nKill < nNum then
	--	SendNoEcho("break");
	--else
		SendNoEcho("pei");
	--end
end

TZ.Wait = function()
	Execute("wd;DZ");
	DoAfterSpecial(2, "eu;TZ", 10);
end

-------------------------------------
--             韩世忠              --
-------------------------------------
HSZ = {};
HSZ.strArea = "";
HSZ.bCanBack = false;

Common.CreateTrigger("HSZ_BATTLE_OVER", "^系统回馈：BATTLE = 0$", 'HSZ.Leave()', 12, "hsz", 0);
--Common.CreateTrigger("HSZ_ROAD", "^请注意，忽略验证码中的红色文字。\\nhttp://pkuxkx.*/antirobot/robot.*\\n(【.*)$", 'HSZ.Road("%1")', 12, "hsz", 0, false, 3);
Common.CreateTrigger("HSZ_ROAD", "^【\\S+】【\\S+】.*$", 'HSZ.Road("%0")', 12, "hsz", 0);

HSZ.Road = function(strRoad)
	strRoad, _ = strRoad:match'(.*)(】.*)'
	strRoad = string.gsub(strRoad , "【", "");
	strRoad = string.gsub(strRoad , "】", ";");
	for i,v in pairs(Location.GetTowardChs) do
		strRoad = string.gsub(strRoad, i, v);
	end
	for i,v in pairs(Location.GetTowardChs2) do
		strRoad = string.gsub(strRoad, i, v);
	end
	strRoad = string.gsub(strRoad , ";;", ";");
	Note(strRoad);
	--DoAfterSpecial(2, strRoad, 10);
	Execute(strRoad);
	Execute("close_fullme");
end

HSZ.Trigger = function()
	Common.CloseAllGroup();
	Execute("EGA hsz");
	SetVariable("Q_name", "韩世忠");
	Battle.bPerform = true;
	Battle.SetEscape(true);
	HSZ.bCanBack = false;
end

HSZ.Init = function(strPlace)
	QuestOver.QuestStart();
	local tPlace = Location.GetPlace_Test(strPlace);
	HSZ.strArea = tPlace.area;
	local strPlaceID = Name.TrancelateLocate(tPlace.area..tPlace.room);
	Way.Goto(strPlaceID);
	SetVariable("Q_location", strPlace);
end

HSZ.Leave = function()
	if HSZ.bCanBack == true then
		Execute("close_fullme");
		DoAfterSpecial(1, 'Execute("leave;GT hsz")', 12);
	end
end

HSZ.Finish = function()
	Battle.SetEscape(false);
	QuestOver.HSZ();
	SendNoEcho("drop bing fu");
end

-------------------------------------
--             张金鳌              --
-------------------------------------
ZJA = {}
ZJA.nStep = 0;
ZJA.strID = "";
ZJA.bFirst = true;

Common.CreateAlias("ZJA_ALIAS", "^ZJA\\s?(\\S*)$", 'ZJA.Alias("%1")', 12, "triggers");
Common.CreateAlias("ZJA_ALIAS_END", "^ZJS$", 'ZJA.Stop();SendNoEcho("ask zhang about fail");', 12, "triggers");
Common.CreateTrigger("ZJA_GIVE", "^    丐帮副帮主 张金鳌\\(Zhang jinao\\)$", 'SendNoEcho("give zhang core")', 12, "zja", 0);
Common.CreateTrigger("ZJA_KILL", "^    木人\\(Mu ren\\)$", 'SendNoEcho("killall mu ren")', 12, "zja", 0);
Common.CreateTrigger("ZJA_XIANSUO", "^这是一张纸，似乎是张金鏊提到的线索，木人似乎就在(\\S+)附近，去拆了它吧。$", 'ZJA.Go("%1")', 12, "zja", 0);
Common.CreateTrigger("ZJA_OVER", "^你获得了一枚机关核心，可以回去交任务了。$", 'ZJA.Back()', 12, "zja", 0);
Common.CreateTrigger("ZJA_INIT", "^你默默寻思，听说张金鏊极度痴迷机关消息，也许能从他哪弄点好处。\\n你对着张金鳌道：“不知道在下有什么可以效劳的地方？”\\n张金鳌深深地叹了口气。\\n张金鳌说道：「我之前费尽千辛万苦，从少林寺弄了一具木人，你去帮我看看吧。」\\n张金鳌说道：「你去到(\\S+)之后缓行\\(walk\\)(\\S+)步当可发现我留下的线索，一切自有分晓。」\\n你暗暗想到：“这\\S+步可是很容易走过的，我可要及时停下来\\(walk -p\\)。”", 'ZJA.Init("%1", "%2")', 12, "zja", 0, false, 6);
Common.CreateTrigger("ZJA_FOUND", "^你揉揉眼睛仔细一看，这似乎就是张金鏊提到的线索？$", 'DoAfter(1, "get xian suo");DoAfter(1.2, "l xian suo");', 12, "zja", 0);
Common.CreateTrigger("ZJA_WAIT", "^你向张金鳌打听有关『job』的消息。\\n你默默寻思，听说张金鏊极度痴迷机关消息，也许能从他哪弄点好处。\\n你对着张金鳌道：“不知道在下有什么可以效劳的地方？”\\n张金鳌说道：「最近找我的人不少，你过会再来吧。」$", 'ZJA.Wait()', 12, "zja", 0, false, 4);
Common.CreateTrigger("ZJA_FINISH", "^你总共完成了\\S+次张金鳌的任务。$", 'ZJA.Stop()', 12, "zja", 0);
Common.CreateTrigger("ZJA_ARRIVE", "^系统回馈：WALK_FINISH = 0$", 'ZJA.Alias()', 12, "zja", 0);

ZJA.tPlace = {
["泰山"] = "tsdzf",
["张家口"] = "zjk",
["天龙寺"] = "tlsrhm",
["洛阳"] = "ly",
["信阳"] = "xiny",
["慕容嘉兴入口"] = "jxthb",
["灵州"] = "lz",
["泉州"] = "qzh",
["大轮寺"] = "dlssm",
["荆州"] = "xyjz",
["镇江长江渡口"] = "cjndk4",
["晋阳"] = "jygc",
["临安府"] = "hz",
["麒麟村"] = "qlc",
["岳王墓"] = "yfm",
--["燕子矶"] = "yzj",
["华山"] = "hsqcc",
["岳阳"] = "yy",
["平西王府"] = "pingxiwang",
["兰州"] = "lzh",
["苏州"] = "szclt",
["曲阜"] = "qfgl",
["回疆小镇"] = "hzxz",
["北京北永安门"] = "bj",
["洛阳黄河渡口"] = "hhnamjd",
["归云庄"] = "gyz",
["关外"] = "gwllt",
["北京北安定门"] = "bjadm",
["北京广安门"] = "bjgam",
["北京德胜门"] = "bjdsm",
["濮阳"] = "py",
["濮阳黄河渡口"] = "hhbdk3",
["铜雀台"] = "tqt2",
["蒙古"] = "mgtl",
["日月神教"] = "ry",
["晋阳黄河渡口"] = "hhbafld",
["兰州黄河渡口"] = "hhbgd",
["湟中"] = "hzzx",
["灵州黄河渡口"] = "hhngd",
["洛阳黄河渡口"] = "hhnamjd",
["曲阜黄河渡口"] = "hhndk",
["灵鹫宫"] = "lingjiu",
["长安金光门"] = "cajgm",
["长安通化门"] = "cathm",
["长安明德门"] = "camdm",
["南阳"] = "nanyang",
["汝州"] = "ruzhou",
["许昌"] = "xuchang",
["华山村"] = "xc",
["襄阳"] = "xy",
["信阳"] = "xiny",
["武当山"] = "wdsm",
["扬州"] = "yz",
["杀手帮"] = "ssbgc",
["扬州丐帮分舵"] = "gb",
["淮北"] = "huaibei",
["全真派"] = "qzgm",
["古墓派"] = "gm",
["长江扬州东渡口"] = "yzj",
["长江扬州西渡口"] = "cjbdk",
["信阳长江渡口"] = "cjbdk2",
["荆州长江渡口"] = "lj",
["赞普广场"] = "zp",
["凌霄城"] = "lx",
["成都"] = "cd",
["大理城"] = "dl",
["峨眉山"] = "emsm",
["昆明"] = "km",
["昆明苗疆入口"] = "kmsl3",
["岳阳长江渡口"] = "cjnlj",
["江州长江渡口"] = "cjndk2",
["燕子矶"] = "cjnyzj",
["南昌苗疆入口"] = "miaoling",
["南昌"] = "nc",
["江州"] = "jz",
["建康府清凉门"] = "jkqlm",
["建康府正阳门"] = "jkzym",
["建康府神策门"] = "jkscm",
["建康府朝阳门"] = "jkcym",
["镇江"] = "zj",
["慕容苏州入口"] = "mr",
["义兴县"] = "zjyxxc",
["嘉兴"] = "jx",
["陆家庄"] = "jxljz",
["福州"] = "fz",
["莆田"] = "putian",
["西湖梅庄"] = "xhmzgsmz",
["岳王墓"] = "yfm",
["牙山"] = "ys",
["明州府"] = "mzqyg",
["少林寺"] = "2xu",
["星宿海"] = "xx",
};

ZJA.Alias = function(strStep)
	if strStep == nil or strStep == "" then
		Common.CloseAllGroup();
		SendNoEcho("unwield all");
		Execute("E_A");
		EnableGroup("zja", true);
		if ZJA.nStep == nil or ZJA.nStep == 0 then
			SendNoEcho("ask zhang about job");
		else
			ZJA.RecordStart();
		end
	else
		ZJA.Step(strStep);
	end
end

ZJA.Arrived = function()
	if ZJA.bFirst then
		ZJA.Alias();
	end
end

ZJA.Stop = function()
	EnableGroup("zja", false);
	ZJA.nStep = 0;
end

ZJA.Init = function(strLocation, strStep)
	ZJA.nStep = StrToNum(strStep);
	SetVariable("Q_misc2", ZJA.nStep);
	SetVariable("Q_location", strLocation);
	ZJA.strID = "";
	ZJA.bFirst = true;
	Note("步数:" .. ZJA.nStep);
	local strPlaceID = ZJA.tPlace[strLocation];
	if strPlaceID ~= nil then
		Execute("gt " .. strPlaceID);
	end
end

ZJA.Wait = function()
	DoAfterSpecial(5, 'SendNoEcho("ask zhang about job")', 12);
end

ZJA.Walk = function()
	if ZJA.nStep > 0 and ZJA.strID ~= "" then
		ZJA.bFirst = false;
		SendNoEcho("walk " .. ZJA.strID);
		local nTime = ZJA.nStep - 1;
		DoAfter(nTime*2+1, "walk -p");
	end
end

ZJA.Go = function(strLocation)
	SetVariable("Q_location", strLocation);
	local tPlace = Location.GetPlace_Test(strLocation);
	Way.Goto(Name.TrancelateLocate(tPlace.area..tPlace.room), false);
end

ZJA.Step = function(strStep)
	ZJA.nStep = tonumber(strStep);
	Note("步数:" .. ZJA.nStep);
	ZJA.Walk();
end

ZJA.Back = function()
	Execute("gt hz");
	ZJA.nStep = 0;
	ZJA.strID = "";
end

ZJA.Record = function(strName, strLine, tWord, tStyles)
	local strLine = GetLinesInBufferCount();
	local nLen = GetLineInfo(strLine, 11);
	local tBuffer = {};
	for i = 1,nLen do
		local strWord = GetStyleInfo(strLine, i, 1);
		if strWord and #strWord > 2 then
			nColor = GetStyleInfo(strLine, i, 14);
			if nColor == 12632256 then
				--Note(tWord[1]);
				ZJA.strID = tWord[1];
				ZJA.Walk();
			end
		end
	end
end
   
ZJA.RecordStart = function()
	ZJA.strID = "";
	Common.CreateTriggerFunc("ZJA_record", "^\\│\\S+\\s+\\│(.+)\\s+\\│$", "ZJA.Record", "zja");
	Common.CreateTriggerFunc("ZJA_record_end", "^└─────────────┴───◎ 北大侠客行 ◎──┘$", "ZJA.RecordEnd", "zja");
	SendNoEcho("walk -c");
end

ZJA.ReloadEnd = function()
	DeleteTrigger("ZJA_record");
	DeleteTrigger("ZJA_record_end");
end

-------------------------------------
--              TASK               --
-------------------------------------
Task = {}
Task.tObject = nil;
Task.strStatus = "Start";
Task.strNpcID = "";
Task.strObject = "";

Task.Init = function(strName, strObject, strPlace, strNpc)
	SetVariable("Q_name", "TASK");
	Note(strName .. " " .. strObject);
	if string.find(strNpc, "null") then return; end
	Task.tObject = Task.Object[strObject];
	if Task.tObject == nil then return; end
	Task.strStatus = "Start";
	Task.strObject = strObject;
	local strID = Name.TrancelateLocate(strPlace);
	Way.Goto(strID);
	local nIndex1 = string.find(strNpc, ",");
	local nIndex2 = string.find(strNpc, ",", nIndex1+1);
	if nIndex2 == nil or nIndex2 == 0 then
		Task.strNpcID = string.lower(string.sub(strNpc, nIndex1+1));
		Note(nIndex1 .. ";" .. strNpc .. ";" .. Task.strNpcID);
	else
		Task.strNpcID = string.lower(string.sub(strNpc, nIndex1+1, nIndex2-1));
		Note(nIndex1 .. ";" .. nIndex2 .. ";" .. strNpc .. ";" .. Task.strNpcID);
	end
	DeleteTimer("task_find");
end

Task.Init2 = function(strObject, strPlace)
	SetVariable("Q_name", "TASK");
	Note(strObject .. " " .. strPlace);
	Task.tObject = Task.Object[strObject];
	if Task.tObject == nil then return; end
	Task.strStatus = "Start";
	Task.strObject = strObject;
	local tPlace = Location.GetPlace_Test(strPlace);
	Way.Goto(Name.TrancelateLocate(tPlace.area..tPlace.room));
	DeleteTimer("task_find");
end

Task.WalkFinish = function()
	if Task.strStatus == "Start" then
		SendNoEcho("killall");
	elseif Task.strStatus == "Give" and Task.tObject ~= nil then
		SendNoEcho("give " .. Task.tObject.npc .. " " .. Task.tObject.id);
	end
end

Task.GetObject = function(strObject)
	if strObject == Task.strObject and Task.strObject ~= "" then
		Note("================");
		Note("==找到TASK物品==");
		Note("================");
		Way.Goto(Task.tObject.place);
		Task.strStatus = "Give";
	end
end

Task.Dead = function()
	if Task.strStatus == "Start" and Task.tObject ~= nil then
		SendNoEcho("get " .. Task.tObject.id .. " from corpse");
		SendNoEcho("get " .. Task.tObject.id .. " from corpse 2");
		SendNoEcho("get " .. Task.tObject.id .. " from corpse 3");
		SendNoEcho("get " .. Task.tObject.id .. " from corpse 4");
		SendNoEcho("get " .. Task.tObject.id .. " from corpse 5");
	end
end

Task.Next = function(bStart)
	Execute("TASK_TELL");
	--if GetVariable("TASK_NO_STEP_TWO") == "1" or bStart == true then
	--	Common.CreateTimer("task_find", 0, 3, "Task.Find");
	--end
end

Task.Find = function()
	Execute("TASK_TELL");
end

------------------------------------
--             杀手帮             --
------------------------------------

SSB = {};
SSB.strName = "";
SSB.strID = "";
SSB.tLocation = {};
SSB.strLocation = "";
SSB.bBianli = false;
SSB.bFind = false;
SSB.bFind2 = false;
SSB.nTimes = 0;

Common.CreateAlias("alias_ssb_start", "^SSB (.*)$", 'SSB.Init("%1")', 12, "triggers");
Common.CreateTrigger("SSB_FIND", "^忽然间，有人悄悄告诉你，\\S+可能在(\\S+)出现过。$", 'SSB.Location("%1")', 12, "ssb", 0);
Common.CreateTrigger("SSB_BIANLI", "^系统回馈：YOU_ARE_HERE = 0$", 'SSB.Bianli()', 12, "ssb", 0);
Common.CreateTrigger("SSB_AIM", "^.*?(\\S+)\\((\\S+) daxia\\).*$", 'SSB.FindNpc("%1", "%2")', 12, "ssb", 0);
Common.CreateTrigger("SSB_OVER", "^\\S+叫道：啊啊啊啊啊啊~~~~我终究还是免不了被贱人所害。$", 'SSB.Over()', 12, "ssb", 0);
DeleteTimer("SSB_FIND");

SSB.Init = function(strName)
	SSB.bBianli = false;
	SSB.bFind = false;
	SSB.bFind2 = false;
	SSB.nTimes = 0;
	SSB.tLocation = {};
	SSB.strLocation = "";
	SSB.strName = strName;
	SetVariable("BL_NAME", SSB.strName);
	SSB.strID = "";
	EnableGroup("ssb", true);
	Execute("s;w;w;n");
	Common.CreateTimer("SSB_FIND", 0, 2, "SSB.Search");
end

SSB.Search = function()
	SendNoEcho("dating " .. SSB.strName);
end

SSB.Location = function(strLocation)
	SSB.nTimes = SSB.nTimes + 1;
	if SSB.tLocation[strLocation] == nil then
		SSB.tLocation[strLocation] = 1;
	else
		SSB.tLocation[strLocation] = SSB.tLocation[strLocation] + 1;
	end
	if SSB.tLocation[strLocation] >= 3 and SSB.nTimes >= 5 then
		DeleteTimer("SSB_FIND");
		SSB.strLocation = strLocation;
		SetVariable("BL_PLACE", SSB.strLocation);
		Way.Goto(Location.tBLID[strLocation]);
		--Execute("BL " .. strLocation .. " " .. SSB.strName);
		SSB.bBianli = true;
	end
end

SSB.Bianli = function()
	if SSB.bBianli == true then
		SSB.bBianli = false;
		DoAfterSpecial(2, 'Execute("BL")', 12);
		--Execute("bl " .. SSB.strLocation .. " " .. SSB.strName);
	end
end

SSB.FindNpc = function(strName, strID)
	if string.find(strName, SSB.strName) and SSB.bFind2 == false then
		SSB.bFind2 = true;
		SSB.strID = string.lower(strID) .. " daxia";
		SendNoEcho("yun xinjing");
		SendNoEcho("hit " .. SSB.strID);
		Common.ShowCommand("kill " .. SSB.strID);
	end
end

SSB.Over = function()
	EnableGroup("ssb", false);
end

------------------------------------
--             藏经阁             --
------------------------------------

CJG = {};
CJG.nTime = 0;
CJG.nFight = 0;

DeleteTimer("CJG_TIME_COUNT");
Common.CreateTrigger("CJG_OVER", "^藏经阁小院 - $", 'CJG.Over()', 12, "cjg", 0);
Common.CreateTrigger("CJG_FIGHT", "^系统回馈：BATTLE = 1$", 'CJG.Fight()', 12, "cjg", 0);

CJG.Start = function()
	Common_StatusClear();
	--SendNoEcho("set adv_quest 50")
	Battle.SetEscape(false);
	CJG.nTime = 0;
	CJG.nFight = 0;
	Common.CreateTimer("CJG_TIME_COUNT", 0, 1, "CJG.Timer");
	DoAfterSpecial(1, 'SendNoEcho("look map")', 12);
	DoAfterSpecial(1.2, 'SendNoEcho("look map")', 12);
	DoAfterSpecial(1.4, 'SendNoEcho("look map")', 12);
	DoAfterSpecial(1.6, 'SendNoEcho("look map")', 12);
	DoAfterSpecial(1.8, 'SendNoEcho("look map")', 12);
	DoAfterSpecial(2.0, 'SendNoEcho("look map")', 12);
	DoAfterSpecial(2.2, 'SendNoEcho("look map")', 12);
end

CJG.Timer = function()
	CJG.nTime = CJG.nTime + 1;
	SetVariable("Q_misc2", CJG.nTime);
end

CJG.Over = function()
	DeleteTimer("CJG_TIME_COUNT");
	SendNoEcho("ask huangmei seng about 奖励");
	--SendNoEcho("unset adv_quest")
end

CJG.Fight = function()
	CJG.nFight = CJG.nFight + 1;
	SetVariable("Q_misc2", CJG.nFight);
end

------------------------------------
--             萧峰              ---
------------------------------------

XF = {};
XF.nType = 0;
XF.nStep = 0;
XF.strID = "";
XF.bFail = false;
XF.bInit4Wait = false;
XF.bSure = false;
XF.strCutName = "";
XF.bFind = false;
XF.strPlace = "";
XF.bKill = false;
XF.bGoBack = false;

Common.CreateAlias("alias_xf_start", "^XFA$", 'XF.Accept()', 12, "triggers");
Common.CreateAlias("alias_xf_timer", "^XFT$", 'DeleteTimer("XF_SEARCH");DeleteTimer("XF_CUT");', 12, "xf");
Common.CreateAlias("alias_xf_init", "^XF (\\S+) (.*)$", 'XF.Init("%1", "%2")', 12, "xf");
Common.CreateAlias("alias_xf_give", "^XFG$", 'XF.Give()', 12, "xf");
Common.CreateAlias("alias_xf_fail", "^XFF$", 'XF.bFail = true;XF.nStep = 1;SendNoEcho("l");Way.Goto("xiaofeng");', 12, "xf");
Common.CreateAlias("alias_xf_set", "^XFS(.*)$", 'XF.nType = tonumber("%1");XF.nStep = 1;', 12, "xf");
--if Common.id == "suineg" then
Common.CreateTrigger("XF_INIT1", "^你向萧峰打听有关『job』的消息。\\n萧峰点了点头：好！\\n萧峰道：「传闻西夏一品堂派出了若干蒙面杀手，最近出现在(\\S+)附近的(.+)。\\n *此人于中原武林颇为有用，你去将他擒回这里交给我。打晕其之后若他再醒来，可直接点晕\\(dian\\)他。\\n.*\\n萧峰拍拍你的肩，说道：「好兄弟，就交给你了！珍重！」$", 'XF.Init1("%1", "%2")', 12, "xf", 0, false, 6);
Common.CreateTrigger("XF_INIT2", "^你向萧峰打听有关『job』的消息。\\n萧峰点了点头：好！\\n萧峰道：「传闻西夏一品堂派出了若干蒙面杀手，最近出现在(\\S+)附近的(.+)。\\n *此人为非作歹，早已恶贯满盈。你去将他除掉，取其首级回来。\\n.*\\n萧峰拍拍你的肩，说道：「好兄弟，就交给你了！珍重！」$", 'XF.Init2("%1", "%2")', 12, "xf", 0, false, 6);
Common.CreateTrigger("XF_INIT3", "^你向萧峰打听有关『job』的消息。\\n萧峰点了点头：好！\\n萧峰道：「传闻西夏一品堂派出了若干蒙面杀手，最近出现在(\\S+)附近的(.+)。\\n *此人加入西夏一品堂不久，尚可教化，你去劝劝\\(quan\\)他吧。\\n.*\\n萧峰拍拍你的肩，说道：「好兄弟，就交给你了！珍重！」$", 'XF.Init3("%1", "%2")', 12, "xf", 0, false, 6);
Common.CreateTrigger("XF_INIT4", "^你向萧峰打听有关『job』的消息。\\n萧峰点了点头：好！\\n萧峰道：「传闻西夏一品堂派出了若干蒙面杀手，最近出现在(\\S+)附近的(.+)。\\n *此人气焰甚是嚣张，你去给他点颜色瞧瞧，让他认输就好。\\n.*\\n萧峰拍拍你的肩，说道：「好兄弟，就交给你了！珍重！」$", 'XF.Init4("%1", "%2")', 12, "xf", 0, false, 6);
Common.CreateTrigger("XF_PIC", "^你向萧峰打听有关『job』的消息。\\n萧峰点了点头：好！\\n你的客户端不支持MXP,请直接打开链接查看图片。$", 'XF.Pic()', 12, "xf", 0, false, 3);
--end
Common.CreateTrigger("XF_WAIT", "^你向萧峰打听有关『job』的消息。\\n萧峰说道：「刚刚已经有人前去了，多谢\\S+好意。」$", 'DoAfter(3, "l");', 12, "xf", 0, false, 2);
Common.CreateTrigger("XF_WAIT2", "(^过1秒再来问吧。$)|(^萧峰说道：「你先忙完你的事情吧。」$)", 'DoAfter(3, "l");', 12, "xf", 0);
Common.CreateTrigger("XF_TRIP", "(^蒙面杀手一不留神给你狠狠拌了一跤。$)|(^看来教训教训他再试试，可能效果会更好。$)", 'SendNoEcho("l");SendNoEcho("follow mengmian shashou")', 12, "xf", 0);
Common.CreateTrigger("XF_FINISH", "^    丐帮第八代帮主 萧峰\\(Xiao feng\\)$", 'XF.Finish()', 12, "xf", 0);
Common.CreateTrigger("XF_NEXTSTEP", '^系统回馈：WALK_FINISH = 0$', 'XF.NextStep()', 12, "xf", 0);
Common.CreateTrigger("XF_FindNpc", "^(.*)西夏一品堂 (\\S+)\\((\\S* \\S+)\\)(.*)$", 'XF.FindNpc("%3", "%4", "%2", "%1")', 12, "xf", 0);
Common.CreateTrigger("XF_BATTLE_OVER", "^系统回馈：BATTLE = 0$", 'XF.BattleOver()', 12, "xf", 0);
Common.CreateTrigger("XF_OVER2", "^你已经完成了\\S+杀手的工作。$", 'XF.Over()', 12, "xf", 0);
Common.CreateTrigger("XF_DAMAGE", "^\\(.*『蒙面杀手\\( *气血:(\\d+)%/(\\d+)%\\).*$", 'XF.Damage("%1", "%2")', 12, "xf", 0);
Common.CreateTrigger("XF_QUAN", "^蒙面杀手纵身远远的去了。$|^蒙面杀手深深地叹了口气。$", 'XF.Quan()', 12, "xf", 0);
Common.CreateTrigger("XF_QUAN2", "^你一顿棍棒乱揍，看来杀手有点怕你了。$", 'Execute("halt;quan")', 12, "xf", 0);
Common.CreateTrigger("XF_DIAN", "^(你走近蒙面杀手，只见蒙面杀手衣领上几个蝇头小字，显是蒙面杀手姓名。)|(而此时蒙面杀手嘴唇青黑，身中剧毒，眼见不活了。)$", 'XF.Dian()', 12, "xf", 0);
--Common.CreateTrigger("XF_RENSHU1", "^蒙面杀手向后退了几步，说道：「这场比试算我输了，下回看我怎么收拾你！」$", 'XF.RenShu()', 12, "xf", 0);
Common.CreateTrigger("XF_RENSHU2", "^蒙面杀手深深地叹了口气。$", 'XF.RenShu()', 12, "xf", 0);
Common.CreateTrigger("XF_SHOUJI", "^你捡起一颗(\\S+)的首级。$", 'XF.Shouji("%1")', 12, "xf", 0);
Common.CreateTrigger("XF_SHOUJI2", "^你抓住(\\S+)的尸体，手上发力，硬生生的将\\S+的头颅从尸体上扯了下来，提在手中！$", 'XF.Shouji("%1")', 12, "xf", 0);
Common.CreateTrigger("XF_SHOUJI3", "^你提起手中的.*，对准(\\S+)的尸体的脖颈中猛斩了下去，将血淋淋的首级提在手中。$", 'XF.Shouji("%1")', 12, "xf", 0);
Common.CreateTrigger("XF_INIT", "^    丐帮第八代帮主 萧峰\\(Xiao feng\\) \\[任务发放\\]$", 'XF.Accept()', 12, "xf", 0);
Common.CreateTrigger("XF_FAIL", "^由于放弃任务，你被扣了经验.*$", 'XF.Over()', 12, "xf", 0);
Common.CreateTrigger("XF_ASKFAIL", "^系统回馈：BL_NO_FIND = 0$", 'XF.Fail()', 12, "xf", 0);
Common.CreateTrigger("XF_INIT4_WAIT", "^蒙面杀手说道：「我不服，等我休息一下，咱们再打过！」$|^蒙面杀手说道：「我还没恢复好，你想乘人之危么？」$|^看起来蒙面杀手并不想跟你较量。$", 'XF.Wait()', 12, "xf", 0);
Common.CreateTrigger("XF_SUREAIM", "^蒙面杀手说道：「就你也配跟我讨教功夫？！」$", 'XF.bKill = true;SendNoEcho("killall mengmian shashou")', 12, "xf", 0);
Common.CreateTrigger("XF_NPCDEAD", "(^蒙面杀手死了。$)|(.*蒙面杀手的尸体\\(Corpse\\)$)", 'XF.NpcDead()', 12, "xf", 0);
Common.CreateTrigger("XF_SEARCH", "^这里没有 mengmian shashou。$", 'Common.InstanceRun(XF.Sure, 2)', 12, "xf", 0);
DeleteTrigger("XF_RENSHU1");

DeleteTimer("XF_SEARCH");
DeleteTimer("XF_CUT");

XF.Accept = function()
	Common.CloseAllGroup();
	EnableGroup("xf", true);
	SetVariable("Q_name", "萧峰");
	EnableTrigger("XF_DAMAGE", false);
	XF.nType = 0;
	XF.nStep = -1;
	XF.strID = "";
	XF.bFail = false;
	XF.bSure = false;
	XF.bFind = false;
	XF.bKill = false;
	XF.bGoBack = false;
	XF.strCutName = "";
	XF.strPlace = "";
	Battle.SetEscape(true);
	DoAfterSpecial(2, 'SendNoEcho("ask xiao about job")', 12);
end

XF.Init = function(strPlace, strType)
	QuestOver.QuestStart();
	XF.nStep = 0;
	Execute("close_fullme");
	if strPlace ~= "" and strPlace ~= nil then
		strPlace = Way.strBlPlaceID[string.lower(strPlace)];
	end
	if strPlace ~= "" and strPlace ~= nil then
		XF.strPlace = strPlace;
		Execute("BL " .. strPlace .. " 西夏一品堂 蒙面杀手");
		SetVariable("Q_place", strPlace);
	else
		Note("地址输出有误");
	end
	if strType ~= "" and strType ~= nil then
		XF.nType = tonumber(strType);
		SetVariable("Q_misc2", strType);
		if XF.nType == 1 then
			SendNoEcho("unset adv_quest");
		end
	end
	if XF.nType == 1 or XF.nType == 4 then	
		SendNoEcho("jifa sword yunu-jianfa");
	end
end

XF.Pic = function()
	SetVariable("Q_misc2", "摛:1 杀:2 劝:3 降:4");
	SelectCommand();
	PasteCommand("XF ");
end

XF.Finish = function()
	--if XF.bFind == false and XF.bFail == false then return; end
	DeleteTimer("XF_SEARCH");
	DeleteTimer("XF_CUT");
	if XF.nStep > 0 then
		if XF.nType == 1 or XF.nType == 4 then	
			SendNoEcho("jifa sword xuantie-jian");
		end
		SendNoEcho("give xiao shou ji");
		Send("give " .. XF.strID .. " to xiao");
		SendNoEcho("ask xiao about finish");
		--XF.nType = 0;
		--XF.nStep = -1;
		DoAfterSpecial(2, 'SendNoEcho("ask xiao about fail")', 12);
	else
		DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	end
end

XF.Init1 = function(strPlace, strRoom)
	QuestOver.QuestStart();
	XF.nType = 1;
	XF.nStep = 0;
	Battle.bPerform = false;
	SendNoEcho("unset adv_quest");
	Execute("E_Q");
	Execute("BL " .. strPlace .. " 西夏一品堂 蒙面杀手");
	--Way.GotoCH(strPlace);
	SetVariable("Q_misc2", "搬");--摛
	SetVariable("Q_status", strRoom);
	SetVariable("Q_place", strPlace);
	--SendNoEcho("jifa sword yunu-jianfa");
end

XF.Init2 = function(strPlace, strRoom)
	QuestOver.QuestStart();
	XF.nType = 2;
	XF.nStep = 0;
	Battle.bPerform = true;
	Execute("E_T");
	Execute("BL " .. strPlace .. " 西夏一品堂 蒙面杀手");
	--Way.GotoCH(strPlace);
	SetVariable("Q_misc2", "杀");
	SetVariable("Q_status", strRoom);
	SetVariable("Q_place", strPlace);
end

XF.Init3 = function(strPlace, strRoom)
	QuestOver.QuestStart();
	XF.nType = 3;
	XF.nStep = 0;
	Battle.bPerform = false;
	Execute("E_Q");
	Execute("BL " .. strPlace .. " 西夏一品堂 蒙面杀手");
	--Way.GotoCH(strPlace);
	SetVariable("Q_misc2", "劝");
	SetVariable("Q_status", strRoom);
	SetVariable("Q_place", strPlace);
end

XF.Init4 = function(strPlace, strRoom)
	QuestOver.QuestStart();
	XF.nType = 4;
	XF.nStep = 0;
	Battle.bPerform = false;
	Execute("E_Q");
	Execute("BL " .. strPlace .. " 西夏一品堂 蒙面杀手");
	--Way.GotoCH(strPlace);
	SetVariable("Q_misc2", "胜");--降
	SetVariable("Q_status", strRoom);
	SetVariable("Q_place", strPlace);
	--SendNoEcho("jifa sword yunu-jianfa");
end

XF.NextStep = function()
	Note("XFStep:" .. XF.nStep .. " ;XFType:" .. XF.nType);
	if  XF.bGoBack == false and XF.nStep >= 0 and XF.nType > 0 then
		if Way.TryBl() then
			XF.nStep = 1;
		end
	end
end

XF.Sure = function()
	Way.FindItemWay("西夏一品堂 蒙面杀手");
end

XF.FindNpc = function(strID, strEnd, strChnName, strPrefix)
	Note("XFStep:" .. XF.nStep .. " ;XFType:" .. XF.nType .. " ;ID:" .. strID);
	if XF.nStep <= 0 then return; end
	strID = string.lower(strID);
	if strID ~= "mengmian shashou" then
		XF.strID = strID;
	end
	SendNoEcho("follow mengmian shashou");
	SendNoEcho("trap mengmian shashou");
	SendNoEcho("ask shashou about fight");
	if XF.nType == 1 then
		if strID== "mengmian shashou" then
			Execute("E_Q");
			if string.find(strPrefix, "武林高手") or string.find(strPrefix, "江湖新星") then
				SendNoEcho("wield xuantie sword");
				DoAfterSpecial(1, 'SendNoEcho("jianyi")', 12);
			end
			SendNoEcho("hit mengmian shashou");
		else
			SendNoEcho("dian");
			SendNoEcho("get " .. XF.strID);
			XF.nStep = 2;
			XF.bFail = true;
			XF.GoBack();
		end
	elseif XF.nType == 2 then
		if strID == "mengmian shashou" then		
			SendNoEcho("kill mengmian shashou");
			DoAfterSpecial(1, 'SendNoEcho("jianyi")', 12);
		else
			XF.strCutName = strChnName;
			DeleteTimer("XF_SEARCH");
			XF.nStep = 2;
			Execute("W_T");
			Common.CreateTimer("XF_CUT", 0, 1, "XF.Cut", 0, "xf");
		end
	elseif XF.nType == 3 then
		if strID == "mengmian shashou" then			
			EnableTrigger("XF_DAMAGE", true);
			Execute("E_T");
			DoAfterSpecial(1, 'SendNoEcho("jianyi")', 12);
			--if string.find(strPrefix, "武林高手") or string.find(strPrefix, "江湖新星") then
			--	SendNoEcho("wield xuantie sword");
			--	DoAfterSpecial(1, 'SendNoEcho("jianyi")', 12);
			--else
			--	Execute("E_Q");
			--end
			if XF.nStep < 3 then
				SendNoEcho("hit mengmian shashou");
				XF.nStep = 2;
			end
		else
			XF.nStep = 4;
			XF.GoBack();
		end
	elseif XF.nType == 4 then
		if strID == "mengmian shashou" then			
			EnableTrigger("XF_DAMAGE", true);
			Execute("E_T");
			DoAfterSpecial(1, 'SendNoEcho("jianyi")', 12);
			--if string.find(strPrefix, "武林高手") or string.find(strPrefix, "江湖新星") then
			--	Execute("E_T");
			--	--DoAfterSpecial(1, 'SendNoEcho("jianyi")', 12);
			--else
			--	SendNoEcho("wield xuantie sword");
			--	DoAfterSpecial(1, 'SendNoEcho("jianyi")', 12);
			--end
			if XF.nStep < 3 then
				if XF.bInit4Wait == true then
					--SendNoEcho("give shashou 1 jin");
					--DoAfterSpecial(2, 'SendNoEcho("l")', 12);
					SendNoEcho("yun lifeheal mengmian shashou");
				else
					SendNoEcho("fight mengmian shashou");
				end
				XF.nStep = 2;
			end
		else
			XF.nStep = 4;
			XF.GoBack();
		end
	end
end

XF.Cut = function()
	SendNoEcho("cut corpse");
	SendNoEcho("cut corpse 2");
	SendNoEcho("cut corpse 3");
	SendNoEcho("cut corpse 4");
	SendNoEcho("cut corpse 5");
	SendNoEcho("get shou ji");
end

XF.Search = function()
	if Battle.bBattle == false then
		SendNoEcho("l");
		Way.FindItemWay("西夏一品堂 蒙面杀手");
	end
end

XF.BattleOver = function()
	if XF.nType == 1 then
		SendNoEcho("l")
	elseif XF.nType == 2 then
		--Execute("W_T;cut corpse");
		--DoAfterSpecial(2, "get shou ji", 10);
	end
end

XF.Over = function()
	Battle.SetEscape(false);
	QuestOver.XF();
end

XF.Damage = function(strHP1, strHP2)
	local nHP1 = tonumber(strHP1);
	local nHP2 = tonumber(strHP2);
	local nHP = nHP1*nHP2;
	if XF.nType == 3 then
		if nHP < 4000 then
			SendNoEcho("halt");
			SendNoEcho("quan");
			SendNoEcho("follow mengmian shashou");
			DoAfterSpecial(1, 'SendNoEcho("halt")', 12);
			DoAfterSpecial(1, 'SendNoEcho("quan")', 12);
			DoAfterSpecial(2, 'SendNoEcho("follow mengmian shashou")', 12);
			DoAfterSpecial(2, 'SendNoEcho("l")', 12);
		end
	elseif XF.nType == 4 then
		if nHP < 2500 then
			Execute("ask shashou about 认输");
		end
	end
end

XF.Dian = function()
	Common.InstanceRun(Common.Look, 2);
	DoAfterSpecial(2, 'SendNoEcho("l")', 12);
end

XF.Quan = function()
	if XF.nType == 3 and XF.nStep == 2 then
		XF.nStep = 3;
		XF.GoBack();
	end
end

XF.Give = function()
	Send("give xiao " .. XF.strID);
	Send("give " .. XF.strID .. " to xiao");
end

XF.RenShu = function()
	if XF.nType == 4 and XF.nStep == 2 then
		XF.nStep = 3;
		SendNoEcho("halt");
		XF.GoBack();
	end
end

XF.Shouji = function(strName)
	if strName == "蒙面杀手" then
		XF.OnceAgain();
	elseif strName == XF.strCutName then
		XF.GoBack();
	end
end

XF.NpcDead = function()
	if XF.bKill == true then
		XF.OnceAgain();
	end
	--if XF.nType ~= 2 then
	--	XF.OnceAgain();
	--end
end

XF.OnceAgain = function()
	DeleteTimer("XF_SEARCH");
	DeleteTimer("XF_CUT");
	XF.nStep = 1;
	--DoAfterSpecial(2, 'XF.BL()', 12);
	Execute("wkc");
end

XF.BL = function()
	local strContant = "BL " .. GetVariable("Q_place") .. " 西夏一品堂 蒙面杀手";
	Note(strContant);
	Execute(strContant)
end

XF.Fail = function()
	XF.GoBack();
	XF.bFail = true;
end

XF.Wait = function()
	if XF.nType ~= 4 then
		return;
	end
	XF.bInit4Wait = true;
	SendNoEcho("halt");
	SendNoEcho("follow mengmian shashou");
	SendNoEcho("yun lifeheal mengmian shashou");
	--SendNoEcho("give shashou 1 jin");
	DoAfterSpecial(2, 'SendNoEcho("follow mengmian shashou")', 12);
	DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	Common.CreateTimer("XF_WaitOver", 0, 2, "XF.WaitOver", true, "xf");
end

XF.WaitOver = function()
	XF.bInit4Wait = false;
end

XF.GoBack = function()
	XF.bGoBack = true;
	DoAfterSpecial(2, 'Way.Goto("xiaofeng")', 12);
	DeleteTimer("XF_SEARCH");
	DeleteTimer("XF_CUT");
end

-----------------------------------
--             破阵              --
-----------------------------------

Pozhen = {}
Pozhen.bSuccess = true;
Pozhen.bMaze = false;
Pozhen.strToward = "";
Pozhen.nIndex = 1;
Pozhen.tBuffer = {};

Common.CreateTrigger("pozhen_kill", "^你战胜了\\S+!$", 'SendNoEcho("l")', 12, "pozhen", 0);
Common.CreateTrigger("pozhen_start", "^这里似乎就是迷阵布下的地点了。$", 'Pozhen.MazeStart()', 12, "pozhen", 0);
Common.CreateTrigger("pozhen_maze", '^系统回馈：no_more = walkend$', 'Pozhen.Maze()', 12, "pozhen", 0);
--Common.CreateTriggerFunc("pozhen_trigger", '^你向陆乘风打听有关(『pozhen』|『破阵』)的消息。\\n你对陆乘风道：“听闻近来有人冒名桃花岛弟子\\W*布下迷阵行恶，我愿代劳除去此\\W+\\n(:?陆乘风说道：「好吧，这件事就交给你了。」|你的客户端不支持MXP,请直接打开链接查看图片。)\\n.*\\n$', "Pozhen.Init", "pozhen", 0, false, "4");
DeleteTrigger("pozhen_maze_trigger");
DeleteTimer("PozhenMazeTimer");

Pozhen.Init = function(nNum, strLine, tWord)
	Pozhen.bSuccess = true;
	local x,y,n = string.find(tWord[0],"弟子(%W*)布下")
	n = string.gsub(n, "在", "");
	Common_StatusClear();
	SetVariable("Q_name", "破阵");
	SetVariable("Q_location", n);
	Execute("EGS ql");
	local tPlace = Location.GetPlace_Test(n);
	local strPlaceID = Name.TrancelateLocate(tPlace.area..tPlace.room);
	Battle.SetEscape(false);
	if strPlaceID == "gbad" then strPlaceID = "gbad7"; end
	if Way.CantArrive(strPlaceID) then
		SendNoEcho("ask lu about 破阵失败");
	else
		SendNoEcho("yun qi");
		if strPlaceID == "" then
			if GetVariable("PIC_PZ") == "1" then
				Common.ShowCommand("GT ", true);
			else
				SendNoEcho("ask lu about 破阵失败");
			end
		else
			Way.Goto(strPlaceID);
		end
	end
end

Pozhen.Back = function()
	EnableTimer("battle_heal", true);
	DoAfterSpecial(3, 'Way.Goto("pozhen");', 12);
end

Pozhen.Maze = function()
	if GetStatusHPUp() >= GetStatusHPMax() and GetStatusHPUp() > 10000 then
		Execute("E_T");
		SendNoEcho("zhanbu -maze");
	end
end

Pozhen.MazeStart = function()
	Pozhen.tTowardType = {};
	Pozhen.bMaze = true;
	Way.Clear();
	EnablePlugin("c9acd48b7875883527e058d0", false);
	EnableTimer("battle_heal", false);
	Common.CreateTriggerFunc("pozhen_maze_trigger", "^\\S+$", "Pozhen.MazeTrigger", "pozhen");
end

Pozhen.MazeOver = function()
	DeleteTrigger("pozhen_maze_trigger");
	EnablePlugin("c9acd48b7875883527e058d0", true);
	Common.CreateTriggerFunc("pozhen_finish", "^\\s+(?:归云庄庄主「五湖废人」)\\s?(?:陆乘风)\\((Lu chengfeng)\\)(\\s\\[任务发放\\]|)$", "Pozhen.Reply", "pozhen");
	DoAfterSpecial(2, 'Pozhen.Back()', 12);
end

Pozhen.MazeSuccess = function()
	SetVariable("Q_misc2", "破阵成功");
	DoAfter(1.5 , "n")
	Pozhen.MazeOver();
end

Pozhen.MazeFail = function()
	SetVariable("Q_misc2", "破阵失败")
	Pozhen.bSuccess = false;
	Pozhen.MazeOver()
end

Pozhen.MazeTrigger = function(_, strLine, tWord, tStyle)
	if strLine == "这里的迷阵在你眼中如同儿戏一般。" then
		Pozhen.tTowardType = {};
		Pozhen.strToward = "";
		Pozhen.nIndex = 1;
		DeleteTimer("PozhenMazeTimer");
	elseif strLine == "你尝试破阵，可惜选择了错误的方向，损失了一些气血和内力。" then
		Pozhen.strToward = "";
		Pozhen.nIndex = 1;
		DeleteTimer("PozhenMazeTimer");
	elseif strLine == "你彻底破解了这里的迷阵！" then
		Pozhen.bMaze = false;
		DeleteTimer("PozhenMazeTimer");
	elseif strLine == "破阵失败！这里的真相恐怕永远被掩盖。" then
		Pozhen.MazeFail();
		DeleteTimer("PozhenMazeTimer");
	elseif string.find(strLine, "想不到我最终还是失败了！") then
		Pozhen.MazeSuccess();
		DeleteTimer("PozhenMazeTimer");
	elseif Pozhen.bMaze then
		if string.find(strLine, "石") or string.find(strLine, "树") or string.find(strLine, "竹") then
			Pozhen.TowardTrigger(tStyle);
		end
	end 	
end

Pozhen.TowardTrigger = function(tStyle)
	for _,v in pairs(tStyle) do 
		if v.length == 2 and v.textcolour == GetBoldColour(2) then 
			if v.style == 1 then
				Pozhen.SetTowardInit("错误");
			else 
				Pozhen.SetTowardInit("正确");
			end
		end
	end
end

Pozhen.tToward = {};
Pozhen.tToward[1] = "nw";
Pozhen.tToward[2] = "n";
Pozhen.tToward[3] = "ne";
Pozhen.tToward[4] = "w";
Pozhen.tToward[5] = "e";
Pozhen.tToward[6] = "sw";
Pozhen.tToward[7] = "s";
Pozhen.tToward[8] = "se";

Pozhen.SetTowardInit = function(strType)
	if Pozhen.tTowardType[Pozhen.nIndex] ~= "错误" then 
		Pozhen.tTowardType[Pozhen.nIndex] = strType;
	end
	Pozhen.tBuffer[Pozhen.nIndex] = strType;

	if Pozhen.nIndex == 8 then
		for i = 8, 1, -1 do
			if Pozhen.tTowardType[i] == "正确" then
				Pozhen.tTowardType[i] = "错误";
				Pozhen.strToward = Pozhen.tToward[i];	
				Note("走: " .. Pozhen.strToward);
				Common.CreateTimer("PozhenMazeTimer" , 0, 3, "Pozhen.MazeRetry", 0, "pozhen");
				Pozhen.MazeRetry();
				return;
			end
		end
		for i = 1, 8 do
			if Pozhen.tBuffer[i] == "正确" then
				Pozhen.strToward = Pozhen.tToward[i];	
				Note("备用走: " .. Pozhen.strToward);
				Common.CreateTimer("PozhenMazeTimer" , 0, 3, "Pozhen.MazeRetry");
				Pozhen.MazeRetry();
				return;
			end
		end
	else
		Pozhen.nIndex = Pozhen.nIndex + 1;
	end
end

Pozhen.Reply = function (n,strLine,tWord)
	if Pozhen.bSuccess then 
		SendNoEcho("ask lu about 破阵奖励");
	else
		SendNoEcho("ask lu about 破阵失败");
	end
	DoAfterSpecial(0.1, 'DeleteTrigger("pozhen_finish")', 12);
end

Pozhen.MazeRetry = function()
	if Pozhen.strToward ~= "" then
		SendNoEcho(Pozhen.strToward)
	else
		Note("路径为空");
		DeleteTimer("PozhenMazeTimer");
	end
end

-------------------------------------
--             公孙止              --
-------------------------------------
GSZ = {};
GSZ.strName = "";
GSZ.strID = "";
GSZ.tSkill = {};
GSZ.tSkillName1 = {};
GSZ.tSkillName2 = {};
GSZ.nColor1 = 0;
GSZ.nColor2 = 0;
GSZ.strStep1 = "";
GSZ.strStep2 = "";
GSZ.strStep3 = "";
GSZ.nIndex = 1;
GSZ.strTeller = "";
GSZ.bFail = false;
GSZ.bFind = false;

GSZ.skills = {};	
GSZ.skills["emsmd"] = {"临济十二庄","雁行刀","诸天化身法","霹雳弹","天罡指","金顶绵掌","回风拂柳剑","截手九式","大乘涅槃功"};
GSZ.skills["gaibang"] = {"混天气功","逍遥游","蛇形刁手","降龙十八掌","六合刀","打狗棒法"};
GSZ.skills["huashanjiaoxia"] = {"紫霞功","华山内功","混元功","华山剑法","狂风快剑","玉女十九剑","独孤九剑","反两仪刀","养吾剑法","希夷剑法","混元掌","劈石破玉拳","华山身法"};
GSZ.skills["lingxiaoqiaotou"] = {"雪山内功","雪山剑法","金乌刀法","凌霄拳法","飘雪掌法","雁翼身法"};
GSZ.skills["quanzhengongmen"] = {"先天功","金雁功","全真剑法","同归剑法","养心拳","空明拳","一阳指","三花聚顶掌","天罡北斗阵"};
GSZ.skills["2xu"] = {"达摩剑","混元一气功","金刚不坏功","大金刚拳","拈花指","少林身法","修罗刀","易筋神功","大韦陀杵","燃木刀法","日月鞭法","一指禅","慈悲刀","龙爪功","如来千叶手","伏魔剑","罗汉拳","韦陀棍","修罗刀","般若掌","无常杖","鹰爪功","风云手","少林醉棍","普渡杖","散花掌","无影剑法"};
GSZ.skills["tdh"] = {"浩气苍冥功","零丁飘洋","五虎断门刀","九龙鞭","碧血丹心剑","猴拳","乾坤伏龙手","云龙爪"};
GSZ.skills["tianlongsiruihemen"] = {"段氏身法","枯荣禅功","北冥神功","凌波微步","一阳指","六脉神剑","飞花逐月","段家剑法","天南步法"};
GSZ.skills["wudangshanmen"] = {"太极神功","梯云纵","太极拳","太极爪","太极剑法","玄虚刀法"};
GSZ.skills["baituo"] = {"蛤蟆功","灵蛇杖法","蛇形刁手","神驼雪山掌","蟾蜍步法"};
GSZ.skills["dlsdqgc"] = {"龙象般若功","御雪遁形","血刀经","火焰刀","降伏轮","无上大力杵","大手印","天王爪"};
GSZ.skills["riyueheimuyaxia"] = {"日月神功","葵花神功","吸星大法","日月剑法","日月刀法","辟邪剑法","日月闪电锤","判官笔法","鹰爪功","开山掌","飞天身法","马屁神功","大光明心法"};
GSZ.skills["sldwltdm"] = {"神龙心法","神龙鞭法","毒龙匕法","化骨绵掌","意形步法"};
GSZ.skills["xingxiu"] = {"化功大法","摘星手","星宿毒掌","摘星功","天山杖法","冥天九式","小无相功"};
GSZ.skills["lafyhm"] = {"碧血心法","龙凤双翔","太祖长拳","岳家散手","破军刀法","虎钤剑法","格虎戟","杨家梨花枪","太祖盘龙棍","三十六路猛虎鞭法"};
GSZ.skills["gumu"] = {"九阴神功","玉女心法","黯然销魂掌","美女拳","九阴白骨爪","全真剑法","玉女剑法","玄铁剑法","长恨鞭法","千灭银针手","纤云步法"};
GSZ.skills["lingjiu"] = {"八荒六合唯我独尊功","北冥神功","天羽奇剑","长恨剑法","天山六阳掌","天山折梅手","月影舞步","小无相功"};
GSZ.skills["mingjiao"] = {"大腾挪步法","光明圣火功","寒冰绵掌","九阳神功","烈焰刀","乾坤大挪移","七伤拳","圣火令法","太极剑法","太极拳","太极神功","梯云纵","飞花摘叶手法","鹰爪功"};
GSZ.skills["yanziwu"] = {"慕容氏家传剑法","神元功","斗转星移","燕灵身法","慕容剑法","慕容刀法","参合指","星移掌","百家刀法","弹腿"};
GSZ.skills["taohuadaohaitan"] = {"弹指神通","碧海神功","落英身法","玉箫剑法","落英神剑掌","弹指神功","兰花拂穴手","旋风扫叶腿","九阴白骨爪","摧心掌"};

Common.CreateAlias("GSZ_StepOne", "^G (\\S+)$", 'GSZ.StepOne("%1")', 12, "gsz");
Common.CreateTrigger("GSZ_RecordStart", "^这似乎是某种武功造成的伤痕。你脑海中出现了这几个字……$", 'GSZ.RecordStart()', 12, "gsz", 0);
Common.CreateTrigger("GSZ_RecordStop", "^你灵机一动，或许可以到拥有这个武功的门派去看看。$", 'GSZ.RecordStop()', 12, "gsz", 0);
Common.CreateTrigger("GSZ_TimeCheck", "^│\\[16\\]\\[主\\]天珠.*仍需(\\S+)分(\\S+)秒才能接到下个任务。.*$", 'GSZ.TimeCheck("%1", "%2")', 12, "gsz", 0);


DeleteTimer("GSZ_OnWolkOver");
DeleteTrigger("gsz_record");

GSZ.Init = function()
	Common.CloseAllGroup();
	DeleteTimer("GSZ_OnWolkOver");
	DeleteTrigger("gsz_record");
	EnableGroup("gsz", true);
	GSZ.strName = "";
	GSZ.strID = "";
	GSZ.strStep1 = "";
	GSZ.strStep2 = "";
	GSZ.strStep3 = "";
	GSZ.bFail = false;
	GSZ.bFind = false;
	Common_StatusClear();
	SetVariable("Q_name", "公孙止");
	Battle.SetEscape(true);
	SelectCommand();
	PasteCommand("G ");
	Battle.AddPower(0);
	Way.Clear();
	QuestOver.QuestStart();
end

GSZ.TimeCheck = function(strMin, strSec)
	--[[
	local nMin = StrToNum(strMin);
	local nSec = StrToNum(strSec);
	if nMin*60 + nSec > 80 then
		Execute("GSZW");
	end
	]]--
end

GSZ.AskFight = function()
	if GSZ.strID ~= "" then
		SendNoEcho("ask " .. GSZ.strID .. " about fight");
	end
end

GSZ.FightName = function(strName)
	GSZ.strName = strName;
end

GSZ.StepOne = function(strLocation)
	EnableGroup("gsz", true);
	Execute("close_fullme");
	--Execute("GSZQ");
	SendNoEcho("jobquery");
	if Way.CantArrive(strLocation) then
		SendNoEcho("ask gongsun about fail");
	else
		GSZ.strStep1 = strLocation;
		if GSZ.strStep1 then
			if GetVariable("ENABLE_ZHANBU") == "1" then
				SendNoEcho("zhanbu -myself");
				DoAfterSpecial(10, 'Way.Goto(GSZ.strStep1, true)', 12);
			else
				Way.Goto(GSZ.strStep1, true);
			end
		end
	end
end

GSZ.StepOneReturn = function()
	Way.Goto("gsz");
end

GSZ.StepTwo = function(strLocation)
	if GetVariable("GSZ_ONE_STEP") == "1" and strLocation ~= "tianlongsiruihemen" and strLocation ~= "gaibang" and strLocation ~= "huashanjiaoxia" and strLocation ~= "lafyhm" and strLocation ~= "lingxiaoqiaotou" then
		Way.Goto("gsz");
	else
		GSZ.strStep2 = strLocation;
		if GSZ.strStep1 and GSZ.strStep2 then
			Way.Goto(GSZ.strStep2);
		end
	end
end

GSZ.SetTeller = function(strName)
	GSZ.strTeller = strName;
end

GSZ.StepThr = function(strLocation, strName)
	if GSZ.strTeller == strName then
		SetVariable("Q_misc2", "找到门派");
		local tPlace = Location.GetPlace_Test(strLocation);
		GSZ.strStep3 = Name.TrancelateLocate(tPlace.area..tPlace.room);
		SetVariable("Q_location", tPlace.area..tPlace.room);
--		SendNoEcho("unwield all");
--		Execute("E_T");
		if Way.CantArrive(GSZ.strStep3) then
			Way.Goto("gsz");
		else
			if GSZ.strStep2 and GSZ.strStep3 then
				Way.Goto(GSZ.strStep3, true);
			end
		end
	end
end

GSZ.StepOver = function()
	if GSZ.strStep3 then
		GSZ.bFind = false;
		Way.Goto("gsz");
		--SendNoEcho("unwield all");
		--SendNoEcho("wield xuantie sword");
		Execute("E_A");
	end
end

GSZ.NPCCheck = function(strName, strID)
	if strName == GSZ.strName then
		Execute("wks");
		Way.Clear();
		Way.BianliClear();
		GSZ.strID = string.lower(strID);
		GSZ.bFind = true;
		SendNoEcho("follow " .. GSZ.strID);
		SendNoEcho("killall " .. GSZ.strID);
		Way.Finish();
	end
end

GSZ.NPCEscape = function(strName, strToward)
	DoAfterSpecial(1, 'SendNoEcho("killall " .. GSZ.strID)', 12);
end

GSZ.RecordStart = function()
	GSZ.tSkill = {};
	GSZ.tSkillName1 = {};
	GSZ.tSkillName2 = {};
	GSZ.nColor1 = 0;
	GSZ.nColor2 = 0;
	GSZ.nIndex = 1;
	Common.CreateTriggerFunc("gsz_record", "^\\S+$", "GSZ.Record", "gsz");
end

GSZ.Record = function(strName, strLine, tWord, tStyles)
	if GSZ.bRecord == false then return end
	local strLine = GetLinesInBufferCount();
	local nLen = GetLineInfo(strLine, 11);
	local tBuffer = {};
	for i = 1,nLen do
		local strWord = GetStyleInfo(strLine, i, 1);
		if strWord and #strWord == 2 then
			nColor = GetStyleInfo(strLine, i, 14);
			if GSZ.nColor1 == 0 or GSZ.nColor1 == nColor then
				table.insert(GSZ.tSkillName1, strWord);
				GSZ.nColor1 = nColor;
			elseif GSZ.nColor2 == 0 or GSZ.nColor2 == nColor then
				table.insert(GSZ.tSkillName2, strWord);
				GSZ.nColor2 = nColor;
			end
		end
	end
end

GSZ.RecordStop = function()
	DeleteTrigger("gsz_record");
	local nLen1 = table.getn(GSZ.tSkillName1);
	local nLen2 = table.getn(GSZ.tSkillName2);
	local nLen = nLen1;
	local pTable = GSZ.tSkillName1;
	if nLen > nLen2 then
		nLen = nLen2;
		pTable = GSZ.tSkillName2;
	end
	if nLen > 0 then
		for i, v in pairs(GSZ.skills) do
			for j = 1, table.getn(v) do
				local bCompare = true;
				for o = 1, nLen do
					if string.find(v[j], pTable[o]) == nil then
						bCompare = false;
					end
				end
				if bCompare then
					table.insert(GSZ.tSkill, i);
					Note("门派" .. i);
					break;
				end
			end
		end
	end
	if nLen then
		GSZ.nIndex = 1;
		GSZ.StepTwo(GSZ.tSkill[1]);
		SetVariable("Q_location", GSZ.tSkill[1]);
		SetVariable("Q_misc2", "自动门派");
	end
end

GSZ.GoGuild = function()
	if GSZ.strStep1 and GSZ.strStep2 then
		SelectCommand();
		PasteCommand(GSZ.strStep1 .. "," .. GSZ.strStep2);
	elseif GSZ.strStep2 then
		PasteCommand("gt " .. GSZ.strStep2);
	end
end

GSZ.GoNext = function()
	if GSZ.nIndex < table.getn(GSZ.tSkill) then
		GSZ.nIndex = GSZ.nIndex + 1;	
		SelectCommand();
		--PasteCommand(GSZ.strStep2 .. "," .. GSZ.tSkill[GSZ.nIndex]);
		Way.Goto(GSZ.tSkill[GSZ.nIndex]);
		SetVariable("Q_location", GSZ.tSkill[GSZ.nIndex]);
		GSZ.strStep2 = GSZ.tSkill[GSZ.nIndex];
	end
end

GSZ.OnWolkOver = function()
	if GetVariable("Q_misc2") == "自动门派" then
		Common.CreateTimer("GSZ_OnWolkOver " , 0, 5, "GSZ.GoNext", true);
	end
end

GSZ.FindGuild = function()
	DeleteTimer("GSZ_OnWolkOver");
end

-------------------------------------
--              剿匪               --
-------------------------------------
--[[
JF = {};

DeleteTimer("JF_Timer1");
DeleteTimer("JF_Timer2");
DeleteTimer("JF_Timer2Enable");
DeleteTimer("JF_Timer2Disable");

Common.CreateAlias("JF_trigger", "^JF$", 'JF.Start()', 12, "triggers");
Common.CreateAlias("JF_triggerS", "^JFS$", 'JF.Stop()', 12, "triggers");
Common.CreateTrigger("JF_Fight1", "^\\S+ - $", 'JF.Fight()', 12, "jf", 0);
Common.CreateTrigger("JF_Fight2", "^看起来铁掌帮副帮主想杀死你！$", 'DeleteTimer("JF_Timer2Enable");', 12, "jf", 0);
Common.CreateTrigger("JF_Fight3", "^看起来土匪想杀死你！$", 'DeleteTimer("JF_Timer2Disable");', 12, "jf", 0);


JF.Start = function()
	Execute("EGA jf");
end

JF.Stop = function()
	Execute("EGS jf");
	DeleteTimer("JF_Timer1");
	DeleteTimer("JF_Timer2");
	DeleteTimer("JF_Timer2Enable");
	DeleteTimer("JF_Timer2Disable");
end

JF.Fight = function()
	--Note("开始杀人");
	JF.Timer1();
	Common.CreateTimer("JF_Timer1", 0, 0.8, "JF.Timer1");
end

JF.Timer1 = function()
	Note("杀帮主");
	SendNoEcho("kill durer npc");
	Common.CreateTimer("Jf_Timer2Enable", 0, 0.6, "JF.Timer2Enable", 1);
end

JF.Timer2 = function()
	Note("杀土匪");
	SendNoEcho("kill tufei");
	Common.CreateTimer("Jf_Timer2Disable", 0, 0.6, "JF.Timer2Disable", 1);
end

JF.Timer2Enable = function()
	Common.CreateTimer("JF_Timer2", 0, 0.8, "JF.Timer2");
end

JF.Timer2Disable = function()
	--Note("结束");
	DeleteTimer("JF_Timer1");
	DeleteTimer("JF_Timer2");
end
]]--


-------------------------------------
--             韩员外              --
-------------------------------------
HYW = {};
HYW.nType = 0;--1:地图;2:杀;3:抓;4:三窟;5:守
HYW.strName = "";
HYW.strID = "";
HYW.strPlace = "";
HYW.bStart = false;
HYW.bAskFail = false;
HYW.bRecord = false;
HYW.tSkill = {};
HYW.tSkillName1 = {};
HYW.tSkillName2 = {};
HYW.nColor1 = 0;
HYW.nColor2 = 0;
HYW.nIndex = 1;
HYW.bStartBL = false;
HYW.nBianliIndex = 1;
HYW.tBianli = {};

Common.CreateAlias("HYW_TRIGGER", "^HYW$", 'HYW.Trigger()', 12, "trigger");
Common.CreateTrigger("HYW_GET", "^    大善人 韩员外\\(Han yuanwai\\) \\[任务发放\\]$", 'HYW.Ask();', 12, "hyw", 0);
Common.CreateTrigger("HYW_FINISH", "^    大善人 韩员外\\(Han yuanwai\\)$", 'HYW.Finish();', 12, "hyw", 0);
Common.CreateTrigger("HYW_RecordStart", "^韩员外随意指了指地图上一个方位，说道：韩家仇人(\\S+)\\((.*)\\)在此出现，你去把他宰了！$", 'HYW.RecordStart("%1", "%2")', 12, "hyw", 0);
Common.CreateTrigger("HYW_RecordStop", "^你灵机一动，或许可以到拥有这个武功的门派去看看。$", 'HYW.RecordStop()', 12, "hyw", 0);
Common.CreateTrigger("HYW_BL", '^系统回馈：YOU_ARE_HERE = 0$', 'HYW.BL()', 12, "hyw", 0);
Common.CreateTrigger("HYW_NPC_CHECK", '^(.*)\\((.+)\\)$', 'HYW.NpcCheck("%2", "%1")', 12, "hyw", 0);
Common.CreateTrigger("HYW_DEAD_CHECK", '^(\\S+)死了。$', 'HYW.DeadCheck("%1")', 12, "hyw", 0);
Common.CreateTrigger("HYW_NO_FIND", "^系统回馈：BL_NO_FIND = 0$", 'HYW.Fail()', 12, "hyw", 0);
Common.CreateTrigger("HYW_QUEST2", "^韩员外说道：韩家仇人(\\S+)\\((.*)\\)据传在『(\\S+)』出现过，快去帮我杀了他！\\n其人不足为惧，只是真凶的爪牙，你把他就地处决即可。$", 'HYW.SetAim("%1", "%2", "%3", 2);', 12, "hyw", 0, false, 2);
Common.CreateTrigger("HYW_QUEST3", "^韩员外说道：韩家仇人(\\S+)\\((.*)\\)据传在『(\\S+)』出现过，快去帮我杀了他！\\n其人与我家有血海深仇，你必须将其擒回，当着我的面诛杀此獠。$", 'HYW.SetAim("%1", "%2", "%3", 3);', 12, "hyw", 0, false, 2);
Common.CreateTrigger("HYW_QUEST4", "^韩员外说道：韩家仇人(\\S+)\\((.*)\\)据传在(\\S+)、(\\S+)、(\\S+)三处出现过，快去找到他帮我杀了他！$", 'HYW.ThreePlace("%1", "%2", "%3", "%4", "%5")', 12, "hyw", 0);
Common.CreateTrigger("HYW_QUEST5", "^韩员外说道：韩家仇人(\\S+)\\((.*)\\)据传在(\\S+)的(\\S+)出现，你去将其狙杀！$", 'HYW.Wait("%1", "%2", "%3", "%4")', 12, "hyw", 0);
Common.CreateTrigger("HYW_WAIT", "^韩家仇人\\S+将在(\\S+)秒后经过狙击地点。$", 'HYW.Time("%1")', 12, "hyw", 0);


HYW.Trigger = function()
	HYW.Init();
	HYW.Ask();
end

HYW.Init = function()
	SetVariable("Q_name", "韩员外");
	HYW.strName = "";
	HYW.strID = "";
	HYW.strPlace = "";
	HYW.nType = 0;
	HYW.bStart = false;
	HYW.bAskFail = false;
	HYW.bRecord = false;
	HYW.bStartBL = false;
end

HYW.Fail = function()
	if HYW.nType == 4 and HYW.nBianliIndex < 3 then
		HYW.nBianliIndex = HYW.nBianliIndex + 1;
		HYW.SetAim(HYW.strName, HYW.strID, HYW.tBianli[HYW.nBianliIndex], 4);
	else
		Execute("bl off");
		HYW.bAskFail = true;
		HYW.bStartBL = false;
		Way.Goto("hyw");
	end
end

HYW.Finish = function()
	if HYW.bStart == true then
		if HYW.bAskFail == true then
			SendNoEcho("ask han about finish");
			SendNoEcho("ask han about fail");
		else
			SendNoEcho("ask han about finish");
		end
	else
		DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	end
end

HYW.Ask = function()
	SendNoEcho("ask han about job");
end

HYW.SetAim = function(strName, strID, strPlace, nType)
	HYW.bStart = true;
	SetVariable("Q_location", strPlace);
	SetVariable("Q_misc2", nType);
	HYW.strName = strName;
	HYW.strID = string.lower(strID);
	HYW.nType = nType;
	HYW.bStartBL = true;
	Execute("BL " .. strPlace .. " " .. HYW.strName);
end

HYW.ThreePlace = function(strName, strID, strPlace1, strPlace2, strPlace3)
	HYW.bStart = true;
	HYW.strName = strName;
	HYW.strID = string.lower(strID);
	HYW.nBianliIndex = 1;
	HYW.tBianli[1] = strPlace1;
	HYW.tBianli[2] = strPlace2;
	HYW.tBianli[3] = strPlace3;
	HYW.SetAim(HYW.strName, HYW.strID, HYW.tBianli[1], 4);
end

HYW.Wait = function(strName, strID, strPlace, strRoom)
	HYW.bStart = true;
	HYW.strName = strName;
	HYW.strID = string.lower(strID);
	HYW.strPlace = strPlace .. strRoom;
	HYW.nType = 5;
	HYW.bStartBL = false;
	Way.GotoCH(strPlace);
end

HYW.Time = function(strTime)
	if StrToNum(strTime) < 6 then
		Way.Goto(HYW.strPlace);
		Common.CreateTimer("hyl_look", 0, 1, "Common.Look", false, "hyw");
		Common.CreateTimer("hyl_lookcheck", 0, 10, "HYW.TimeOut", true, "hyw");
	end
end

HYW.TimeOut = function()
		DeleteTimer("hyw_look");
		--[[
		HYW.Fail();
		]]--
end

HYW.RecordStart = function(strName, strID)
	HYW.strName = strName;
	HYW.strID = string.lower(strID);
	HYW.bStart = true;
	HYW.tSkill = {};
	HYW.tSkillName1 = {};
	HYW.tSkillName2 = {};
	HYW.nColor1 = 0;
	HYW.nColor2 = 0;
	HYW.nIndex = 1;
	Common.CreateTriggerFunc("hyw_record", "^\\S+$", "HYW.Record", "hyw");
end

HYW.Record = function(strName, strLine, tWord, tStyles)
	if HYW.bRecord == false then return end
	local strLine = GetLinesInBufferCount();
	local nLen = GetLineInfo(strLine, 11);
	local tBuffer = {};
	for i = 1,nLen do
		local strWord = GetStyleInfo(strLine, i, 1);
		nColor = GetStyleInfo(strLine, i, 14);
		if HYW.nColor1 == 0 or HYW.nColor1 == nColor then
			table.insert(HYW.tSkillName1, strWord);
			HYW.nColor1 = nColor;
		elseif HYW.nColor2 == 0 or HYW.nColor2 == nColor then
			table.insert(HYW.tSkillName2, strWord);
			HYW.nColor2 = nColor;
		end
	end
end

HYW.RecordStop = function()
	DeleteTrigger("hyw_record");
	local nLen1 = table.getn(HYW.tSkillName1);
	local nLen2 = table.getn(HYW.tSkillName2);
	local nLen = nLen1;
	local pTable = HYW.tSkillName1;
	Note("Color1:" .. HYW.nColor1);
	if nLen > nLen2 then
		Note("Color2:" .. HYW.nColor2);
		nLen = nLen2;
		pTable = HYW.tSkillName2;
	end
	local strPlace = "";
	for j = 1, table.getn(pTable) do
		strPlace = strPlace .. pTable[j];
	end
	HYW.SetAim(HYW.strName, HYW.strID, strPlace, 1);
end

HYW.BL = function()
	if HYW.bStartBL == true then
		HYW.bStartBL = false;
		DoAfterSpecial(3, "Way.TryBl()", 12);
	end
end

HYW.NpcCheck = function(strID, strName)
	strID = string.lower(strID);
	if HYW.strID == strID and string.find(strName, HYW.strName) then
		DeleteTimer("hyw_look");
		SendNoEcho("follow " .. HYW.strID);
		if HYW.nType == 3 then
			SendNoEcho("hit " .. HYW.strID);
		else
			SendNoEcho("killall " .. HYW.strID);
		end
	end
end

HYW.DeadCheck = function(strName)
	if strName == HYW.strName then
		Way.Goto("hyw");
	end
end


--[[

大约需要至少经历2分钟后，任务奖励可以全额获取。
韩员外说道：韩家仇人危惠林(wei huilin)据传将在湟中的南城门出现，你去将其狙杀！
其人心思缜密，你不到最后五秒不要现身，否则打草惊蛇，悔之晚矣。但也不能迟过他出现的时分，否则其人脱困而去。
韩家仇人危惠林将在九十八秒后经过狙击地点。

你过早地来到的狙击地点，打草惊蛇，危惠林决定改换路线，远走高飞了。

ask han about fail
你向韩员外打听有关『fail』的消息。
韩员外失望极了。
由于你未能帮助韩员外复仇，被扣除：
二千零六十八点实战经验，
九百九十二点潜能，
一百十二点江湖声望作为惩罚。
                             
=======================================================

你向韩员外打听有关『job』的消息。
韩员外说道：「神仙姐姐能为我韩家出头，复仇指日可待！[+1]」
大约需要至少经历2分钟后，任务奖励可以全额获取。
韩员外说道：韩家仇人孙娅(sun ya)据传在建康府南城、嘉兴、南昌三处出现过，快去找到他帮我杀了他！
其人虚虚实实，狡兔三窟，端的不容易被找到。


========================================================
大约需要至少经历2分钟后，任务奖励可以全额获取。
韩员外说道：韩家仇人范涛生(fan taosheng)据传在『西湖』出现过，快去帮我杀了他！
其人不足为惧，只是真凶的爪牙，你把他就地处决即可。

=========================================================
你向韩员外打听有关『job』的消息。
韩员外说道：「神仙姐姐能为我韩家出头，复仇指日可待！[+1]」
大约需要至少经历2分钟后，任务奖励可以全额获取。
韩员外说道：韩家仇人单湘福(shan xiangfu)据传在『姑苏慕容』出现过，快去帮我杀了他！
其人与我家有血海深仇，你必须将其擒回，当着我的面诛杀此獠。

=========================================================
韩员外说道：韩家仇人李婷(li ting)据传在『长江北岸』出现过，快去帮我杀了他！
此人是易容高手，须谨防其走脱。

=========================================================
韩员外说道：韩家仇人樊薇纨(fan weiwan)据传在『白驼山』出现过，快去帮我杀了他！
其人奸诈似鬼，疑心甚重，你须变换容貌前去将其刺杀。

樊薇纨远远看到休尼格，赶紧迅速离去。
【谣言】某人: 樊薇纨被休尼格发现行踪，决定远走天涯，隐姓埋名。

]]


-----------------------------------
--             仆人              --
-----------------------------------
MRPR = {};
MRPR.bStartBL = false;
MRPR.bOnce = false;
MRPR.bAskFail = false;
MRPR.bComplate = false;

Common.CreateAlias("alias_mrpr", "^MRPR([AB]{1})$", 'MRPR.Trigger("%1")', 12, "triggers");
Common.CreateAlias("alias_mrprfail", "^MRPRF$", 'MRPR.Fail()', 12, "mrpr", 0);
Common.CreateAlias("alias_mrprpic", "^MRPR (\\S+)$", 'MRPR.Pic("%1")', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_init", "^    姑苏慕容 仆人\\(Pu ren\\) \\[任务发放\\]$", 'MRPR.Init()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_finish", "^    姑苏慕容 仆人\\(Pu ren\\)$", 'MRPR.Complate()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_cantfind", "^系统回馈：BL_NO_FIND = 0$", 'MRPR.Fail()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_complate", "^你从慕容\\S+的尸体身上搜出一封信件。$", 'MRPR.GoBack()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_bl", '^系统回馈：WALK_FINISH = 0$', 'MRPR.BL()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_npcdead", "^\\S+死了。$", 'MRPR.NpcDead()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_goto", "^仆人叹道：家贼难防，有人偷走了少爷的信件，据传曾在『(.*?)』附近出现，你去把它找回来吧！$", 'MRPR.NoPic("%1")', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_over", "^(由于你没有找回慕容复丢失的信件，被扣除：)|(由于你成功的找回慕容复写给江湖豪杰的信件，被奖励：)$", 'MRPR.Over()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_find", "^.*休\\S{2}格发现的 慕容世家\\S+\\(Suinegy?'s murong jiazei\\)$", 'MRPR.Find()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_wait", "^仆人忙着呢，等会吧。$", 'MRPR.Wait()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_pic", "^仆人叹道：家贼难防，有人偷走了少爷的信件，据传曾在以下地点附近出现，你去把它找回来吧！\\n你的客户端不支持MXP,请直接打开链接查看图片。\\n请注意，忽略验证码中的红色文字。$", 'MRPR.Fullme()', 12, "mrpr", 0, false, 3);

MRPR.Trigger = function(strParam)
	if strParam == "A" then
		Common.CloseAllGroup();
		Execute("EGA mrpr");
		Battle.SetEscape(true);
		Battle.bPerform = true;
		if Common.id == "suineg" then
			SendNoEcho("set adv_quest 50");
		else
			SendNoEcho("unset adv_quest");
		end
		MRPR.bStart = false;
		MRPR.bStartBL = false;
		DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	elseif strParam == "B" then
		Execute("EGS mrpr");
		MRPR.bStartBL = false;
	end
end

MRPR.Over = function()
	QuestOver.MRPR();
end

MRPR.Wait = function()
	DoAfterSpecial(2, 'SendNoEcho("l")', 12);
end

MRPR.Init = function()
	MRPR.bAskFail = false;
	SendNoEcho("ask pu about job");
	SetVariable("Q_name", "慕容仆人");
end

MRPR.Fullme = function()
	SelectCommand();
	PasteCommand("MRPR ");
end

MRPR.Pic = function(strPlaceID)
	if strPlaceID ~= "" and strPlaceID ~= nil then
		strPlaceID = Way.strBlPlaceID[string.lower(strPlaceID)];
	end
	MRPR.Goto(strPlaceID);
	Execute("close_fullme");
end

MRPR.NoPic = function(strPlaceArea)
	local tPlace = Location.GetPlace_Test(strPlaceArea);
	SetVariable("Q_misc2", tPlace.room);
	MRPR.Goto(tPlace.area);
end

MRPR.Goto = function(strPlace)
	MRPR.bStart = true;
	MRPR.bStartBL = true;
	MRPR.bOnce = false;
	MRPR.strID = " 休莱格发现的 慕容世家";
	if Common.id == "suinegy" then
		MRPR.strID = " 休尼格发现的 慕容世家";
	end
	if strPlace ~= "" and strPlace ~= nil then
		Execute("BL " .. strPlace .. MRPR.strID);
		SetVariable("Q_place", strPlace);
	else
		Note("地址输出有误");
	end
end

MRPR.GoBack = function()
	MRPR.bStartBL = false;
	MRPR.bComplate = true;
	DoAfterSpecial(2, 'Way.Goto("szcg")', 12);
end

MRPR.Complate = function()
	if MRPR.bStart == true then
		if MRPR.bAskFail then
			SendNoEcho("give ren xin");
			SendNoEcho("ask pu about fail");
		else
			SendNoEcho("give ren xin");
		end
	else
		DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	end
end

MRPR.Fail = function()
	Execute("bl off");
	MRPR.bAskFail = true;
	MRPR.bStartBL = false;
	Way.Goto("szcg");
end

MRPR.BL = function()
	if MRPR.bStartBL == true then
		DoAfterSpecial(3, "Way.TryBl()", 12);
		MRPR.bOnce = ture;
	end
end

MRPR.Find = function()
	Execute("wks");
	Way.Clear();
	SetVariable("AIM_NPC_ID", "jiazei");
	SendNoEcho("killall jiazei");
end

MRPR.NpcDead = function()
	SendNoEcho("get xin from corpse");
	SendNoEcho("get xin from corpse 2");
	SendNoEcho("get xin from corpse 3");
	SendNoEcho("get xin from corpse 4");
end


-----------------------------------
--             心魔              --
-----------------------------------

XM = {};
XM.strWayBuffer = "";
XM.nStep = 0;
XM.nTry = 0;
XM.tWay = {"n", "s", "e", "w", "ne", "nw", "se", "sw"};

Common.CreateAlias("trigger_xm", "^XMA$", 'Execute("EGA xm;l")', 12, "trigger");
Common.CreateTrigger("xm_init", "^    毗沙门佛像\\(Pishamen foxiang\\)$", 'XM.Init()', 12, "xm", 0);
Common.CreateTrigger("xm_try", "^你漫无目标的走着。$", 'XM.ReTry()', 12, "xm", 0);
Common.CreateTrigger("xm_right", "^仿佛间你感觉离目标更进了一步。$", 'XM.SavePath();', 12, "xm", 0);
Common.CreateTrigger("xm_check", "^系统回馈：XMReWalk = 1$", 'XM.Check();', 12, "xm", 0);
Common.CreateTrigger("xm_step", "^系统回馈：XMReWalk = 2$", 'XM.Step();', 12, "xm", 0);
Common.CreateTrigger("xm_leave", "^你发现一个人出现在你眼前，定眼一看，原来是你自己。$", 'XM.Leave();', 12, "xm", 0);

XM.Init = function()
	if TZ.nShaqi >= tonumber(GetVariable("TZ_XINMO")) then
		XM.strWayBuffer = "";
		XM.nStep = 0;
		XM.nTry = 0;
		SendNoEcho("medbox -u 2");
		DoAfterSpecial(2, 'SendNoEcho("guibai");', 12);
		DoAfterSpecial(3, 'XM.Try()', 12);
	end
end

XM.Try = function()
	XM.nTry = XM.nTry + 1;
	SendNoEcho(XM.tWay[XM.nTry]);
end

XM.ReTry = function()
	XM.CheckSet(false);
	XM.nStep = 0;
	SendNoEcho("response XMReWalk 2");
	--if XM.strWayBuffer and XM.strWayBuffer ~= "" then
	--	Execute(XM.strWayBuffer);
	--end
	--DoAfterSpecial(1, 'SendNoEcho("response XMReWalk 1")', 12);
end

XM.Step = function()
	local t = utils.split(XM.strWayBuffer, ";");
	XM.nStep = XM.nStep + 1;
	if t[XM.nStep] == nil or t[XM.nStep] == "" then
		SendNoEcho("response XMReWalk 1");
		Common.ShowCommand("response XMReWalk 1");
	else
		SendNoEcho(t[XM.nStep]);
		SendNoEcho("response XMReWalk 2");
		Common.ShowCommand(t[XM.nStep] .. ";response XMReWalk 2");
	end
end

XM.SavePath = function()
	if XM.strWayBuffer and XM.strWayBuffer ~= "" then
		XM.strWayBuffer = XM.strWayBuffer .. ";";
		XM.strWayBuffer = XM.strWayBuffer .. XM.tWay[XM.nTry];
	else
		XM.strWayBuffer = XM.tWay[XM.nTry];
	end
	Note("当前路径为:" .. XM.strWayBuffer);
	XM.nTry = 0;
	DoAfterSpecial(1, 'SendNoEcho("response XMReWalk 1")', 12);
	Common.ShowCommand("response XMReWalk 1");
end

XM.Check = function()
	XM.CheckSet(true);
	XM.Try();
end

XM.CheckSet = function(bOpen)
	EnableTrigger("xm_try", bOpen);
	EnableTrigger("xm_right", bOpen);
end

XM.Leave = function()
	SendNoEcho("leave");
	TZ.nShaqi = 0;
	QuestOver.XM();
end


-----------------------------------
--             谍战              --
-----------------------------------

Yujie = {};
Yujie.nStep = 0;
Yujie.strName = "";
Yujie.strSay = "";
Yujie.strPlace = "";

Yujie.tPlace = {};
Yujie.tPlace["凌霄城凌霄城"] = "lxdt";
Yujie.tPlace["杀手帮杀手帮"] = "ssbgc";
Yujie.tPlace["古墓古墓"] = "gmdt";
Yujie.tPlace["白驼山白驼山弟子"] = "btdt";


Common.CreateAlias("YuJieStart", "^YJA$", 'EnableGroup("yujie", true)', 12, "trigger");
Common.CreateAlias("YuJieSet", "^YJB (.*)$", 'Yujie.nStep = %1', 12, "yujie");
Common.CreateAlias("YuJieFail", "^YJF$", 'Yujie.Fail()', 12, "yujie");
Common.CreateTrigger("YuJie_Init", "^    大宋 右丞相兼枢密使 余玠\\(Yu jie\\) \\[任务发放\\]$", 'Yujie.Init()', 12, "yujie", 0);
Common.CreateTrigger("YuJie_Finish", "^    大宋 右丞相兼枢密使 余玠\\(Yu jie\\)$", 'Yujie.Finish()', 12, "yujie", 0);
Common.CreateTrigger("Yujie_walkOver", "^系统回馈：WALK_FINISH = 0$", 'Yujie.WalkOver();', 12, "yujie", 0);
Common.CreateTrigger("YuJie_Accept", "^你向余玠打听有关『job』的消息。\\n余玠说道：「\\S+」\\n余玠在你的耳边悄声说道：现在有份重要情报需要你传递出去。\\n余玠在你的耳边悄声说道：为了保护接头人的安全，接头人的名字不能透露，我只能告诉你某人在(.*)等着你。$", 'Yujie.Step1("%1")', 12, "yujie", 0, false, 4);
Common.CreateTrigger("Yujie_Jietou", "^    .*\\((\\S+) .*\\)$", 'Yujie.Jietou("%1");', 12, "yujie", 0);
Common.CreateTrigger("Yujie_Step3", "^\\S+在你的耳边悄声说道：有人在(\\S+)的(\\S+)留言板给你留下了下一步行动的步骤。$", 'Yujie.Step3("%1%2");', 12, "yujie", 0);
Common.CreateTrigger("YuJie_Step2", "^你向\\S+打听有关『接头』的消息。\\n\\S+说道：「你终于来了。」\\n\\S+在你的耳边悄声说道：有人在(\\S+)的(\\S+)留言板给你留下了下一步行动的步骤。$", 'Yujie.Step3("%1")', 12, "yujie", 0, false, 3);
Common.CreateTrigger("Yujie_Step4", "^\\[(.*)\\]\\s+休\\S{2}格钧鉴：.*$", 'Yujie.Step4("%1");', 12, "yujie", 0);
Common.CreateTrigger("Yujie_Step5", "^(\\S+)正在(\\S+)等着你，暗号是“(\\S+)”。$", 'Yujie.Step5("%1", "%2", "%3");', 12, "yujie", 0);
Common.CreateTrigger("Yujie_Step6", "^.* (\\S+)\\(.+\\)$", 'Yujie.Step6("%1");', 12, "yujie", 0);
Common.CreateTrigger("Yujie_Step7", "^系统回馈：BATTLE = 0$", 'Yujie.Step7();', 12, "yujie", 0);

Yujie.Init = function()
	EnableGroup("yujie", true);
	Yujie.nStep = 0;
	Yujie.strName = "";
	Yujie.strSay = "";
	Yujie.strPlace = "";
	SendNoEcho("ask yu about job");
end

Yujie.Fail = function()
	Execute("bl off");
	Yujie.nStep = 98;
	Way.Goto("cdsczdf");
end

Yujie.Finish = function()
	if Yujie.nStep == 7 then
		Send("ask yu about finish");
		Yujie.nStep = 8;
	elseif Yujie.nStep == 98 then
		Send("ask yu about finish");
		Send("ask yu about fail");
		Yujie.nStep = 99;
	else
		DoAfterSpecial(4, 'SendNoEcho("l")', 12);
	end
end

Yujie.WalkOver = function()
	if Yujie.nStep == 1 or Yujie.nStep == 2 then
		DoAfterSpecial(3, "Way.TryBlW()", 12);
		Yujie.nStep = 2;
	elseif Yujie.nStep == 3 then
		SendNoEcho("l board");
	end
end

Yujie.Step1 = function(strPlace)
	Yujie.nStep = 1;
	Note("第一步:" .. strPlace .. ":" .. Location.tBLID[strPlace]);
	SetVariable("BL_PLACE", strPlace);
	Way.Goto(Location.tBLID[strPlace], false);
end

Yujie.Jietou = function(strID)
	if Yujie.nStep == 2 then
		SendNoEcho("ask " .. string.lower(strID) .. " about 接头");
	end
end

Yujie.Step3 = function(strPlace)
	if Yujie.nStep == 2 then
		Yujie.nStep = 3;
		Execute("bl off");
		Note("第二步:" .. strPlace .. ":" .. Yujie.tPlace[strPlace]);
		Way.Goto(Yujie.tPlace[strPlace], false);
	end
end

Yujie.Step4 = function(strID)
	if Yujie.nStep ~= 3 then return; end
	Yujie.nStep = 4;
	Note("第三步:" .. strID);
	SendNoEcho("1");
	SendNoEcho("2");
	SendNoEcho("3");
	SendNoEcho("4");
	SendNoEcho("read " .. strID);
end

Yujie.Step5 = function(strName, strPlace, strSay)
	if Yujie.nStep ~= 4 then return; end
	Yujie.nStep = 5;
	Yujie.strName = strName;
	Yujie.strSay = strSay;
	local tPlace = Location.GetPlace_Test(strPlace);
	Yujie.strPlace = Name.TrancelateLocate(tPlace.area..tPlace.room);
	SetVariable("Q_location", tPlace.area..tPlace.room);
	Note("第四步:" .. strName .. " " .. strPlace .. ":" .. Yujie.strPlace .. " " .. strSay);
	Way.Goto(Yujie.strPlace, true);
end

Yujie.Step6 = function(strName)
	if Yujie.nStep ~= 5 then return; end
	if Yujie.strName ~= strName then return; end
	Yujie.nStep = 6;
	Note("第五步:say " .. Yujie.strSay);
	SendNoEcho("say " .. Yujie.strSay);
end

Yujie.Step7 = function(strName)
	if Yujie.nStep ~= 6 then return; end
	Yujie.nStep = 7;
	Note("第六步:返回");
	Way.Goto("cdsczdf", false);
end