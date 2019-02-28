-------------------------------------
--             ����              --
-------------------------------------
Wat = {};
Wat.nLevel = 1;
Wat.nMax = 4;
Wat.nOver = false;

Common.CreateTrigger("wat_fightOver", "^�����ķ�����ʿ����һ��ȭ���������¹�Ȼ�书��������$", 'Wat.FightOver()', 12, "wat", 0);
Common.CreateTrigger("wat_questOver", "^    ������������ˣ�����ľ�Ž��ա�Ѱ���˵��ƺ��޷����롣��$", 'Wat.QuestOver()', 12, "wat", 0);
Common.CreateTrigger("wat_startQuest", "^    ��ڤ���� ¹�ȿ�\\(Luzhang ke\\) \\[���񷢷�\\]$", 'Wat.Ask()', 12, "wat", 0);
Common.CreateTrigger("wat_startwait", "^    ��ڤ���� ¹�ȿ�\\(Luzhang ke\\)$", 'DoAfter(2, "l");', 12, "wat", 0);
Common.CreateTrigger("wat_startFighte", "^ϵͳ������BATTLE = 1$", 'DeleteTimer("wat_up");', 12, "wat", 0);
Common.CreateTrigger("wat_setLevel", "^����(\\S+)�� - .*$", 'Wat.SetLevel("%1");', 12, "wat", 0);
Common.CreateTrigger("wat_koulingOK", "^��ϲ�㣬����˿������������뿪�ˣ��㱻�����´ν���������ʱ�䱻��ǰ��һ���ӡ�$", 'SendNoEcho("qiao luo");', 12, "wat", 0);
Common.CreateTrigger("wat_kouling", "^����kouling����ش��������Ŀ��������󣬽��ܵ�һ���ͷ���$", 'Wat.Kouling()', 12, "wat");
Common.CreateTrigger("wat_kouling2", "^�������������б�������.*$", 'Wat.Over()', 12, "wat");
Common.CreateTrigger("wat_box", "^¹�ȿ͸���һ�����С�$", 'Execute("open box;pack gem")', 12, "wat");

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
	SetVariable("Q_name", "����");
	SendNoEcho("ask ke about ����");
	Battle.SetEscape(false);
	Common.CreateTimer("wat_killcmd", 0, 1, "Wat.Kill", 0, "wat");
	--Common.CreateTimer("wat_up", 0, 1, "Wat.Up");
end

Wat.Kill = function()
	if string.find(Way.strPlace, "����") then
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
	if Wat.nLevel < Wat.nMax and Wat.nLevel < 8 and Battle.TryHeal() and string.find(Way.strPlace, "����") == 1 then
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
--              Ư��               --
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
Common.CreateTrigger("PL_BATTLE_OVER", "^ϵͳ������BATTLE = 0$", 'PiaoLiu.FightOver()', 12, "pl", 0);
Common.CreateTrigger("PL_BATTLE_OVER2", "^ϵͳ������BATTLE = 0$", 'PiaoLiu.BattleOver()', 12, "pl", 0);
Common.CreateTrigger("pl_piao", "^С���Ѿ�˳��Ư����(\\S+)�￪���ˡ�$", 'PiaoLiu.Piao("%1")', 12, "pl", 0, true);
Common.CreateTrigger("pl_fight", "^һ��\\S+���������С����$", 'PiaoLiu.Fight()', 12, "pl", 0);
Common.CreateTrigger("pl_hua", "^С��������\\S+������(\\S+)���ˡ�$", 'PiaoLiu.Hua("%1")', 12, "pl", 0);
Common.CreateTrigger("pl_dalao", "^���ê�������£����̿�ʼ����׼������\\(dalao\\)���$", 'PiaoLiu.Dalao()', 12, "pl", 0);
Common.CreateTrigger("pl_over", "^Ҳ������Է����ˡ�����ʹ��hua back���$", 'PiaoLiu.Over()', 12, "pl", 0);
Common.CreateTrigger("pl_nextQuest", "^���Ѿ������\\S+��۶����Ѱ������$", 'QuestOver.PL()', 12, "pl", 0);
Common.CreateTrigger("pl_busy", "^����æ���أ����ڲ��ܻ���?$", 'SendNoEcho(1, "PLH", 2)', 12, "pl", 0);
--Common.CreateTrigger("pl_over", "^�����ڴ�����\\S+�Ĺ�����$", 'PiaoLiu.Over()', 12, "pl", 0);
--Common.CreateTrigger("pl_hua2", "^���۶���ں�ˮ�����������\\S+���顢\\S+��Ǳ�ܡ�$", 'PiaoLiu.Hua(PiaoLiu.strHuaDist)', 12, "pl", 0);
DeleteTrigger("pl_hua2");
DeleteTimer("PL_DALAO_ACTION");

PiaoLiu.Init = function(strLength, strToward, strHua)
	if strLength == "" then
		Common.CloseAllGroup();
		EnableGroup("pl", true);
		Battle.bPerform = true;
		SetVariable("Q_name", "Ư��");
		EnableTrigger("pl_fight", false);
		EnableTrigger("PL_BATTLE_OVER", false);
		local bHard = GetVariable("PL_HARD");
		if bHard == nil then bHard = "0"; end
		if bHard == "1" then
			Note("Ư����ʼ---->����ģʽ");
			SendNoEcho("ask ren about �ر�");
		else
			Note("Ư����ʼ---->��ͨģʽ");
			SendNoEcho("ask ren about job");
		end
	else
		--YunQiJing.ForceQi();
		PiaoLiu.strLength = strLength;
		PiaoLiu.strToward = StrToToward(strToward);
		PiaoLiu.strHua = strHua;
		PiaoLiu.strHuaDist = "";
		Send("answer Ư" .. strLength .. "�����" .. strToward .. "��" .. strHua .. "��");
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
	Note("################ Ư������: " .. strLength .. " / " .. PiaoLiu.strLength .. " ################");
end

PiaoLiu.Fight = function()
	PiaoLiu.bFight = true;
	EnableTrigger("PL_BATTLE_OVER", true);
	--Battle.FightOverAdd(PiaoLiu.FightOver);
end

PiaoLiu.FightOver = function()
	--Note("PL����");
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
--             ��һ��              --
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
Common.CreateTrigger("hyd_init", "^��һ��˵���������յ���Ϣ����˵(\\S+)�е�����(\\S+)\\((\\S+)\\)�ҵ��˴������صĵ�ͼ,��ɷ��æ�һ�������$", 'HYD.Init("%1", "%3", "%2")', 12, "hyd", 0);
Common.CreateTrigger("hyd_accept", "^    \\S*�ɶ����� ��һ��\\(Hu yidao\\)(.*)$", 'HYD.Accept("%1")', 12, "hyd", 0);
Common.CreateTrigger("hyd_nect", "^\\S+˵������������ȥ(\\S+)�����ֵ�(\\S+)\\((\\S+)\\)��������ұ���ģ���$", 'HYD.Init("%1", "%3", "%2")', 12, "hyd", 0);
Common.CreateTrigger("hyd_check", "^.*�� �� �� ��\\S+����(\\S+)\\((.+)\\).*$", 'HYD.Check("%1", "%2")', 12, "hyd", 0);
Common.CreateTrigger("hyd_map", "^    \\S+\\(Sui cong\\)$", 'HYD.Map()', 12, "hyd", 0);
Common.CreateTrigger("hyd_over", "^\\S+��̾���������㲻�����㣬�벻�����ֵ����˶�����������У���$", 'HYD.Combine()', 12, "hyd", 0);
Common.CreateTrigger("hyd_baotu", "^��һ����һ��ע�͹��Ĳر�ͼ�ݸ����㡣$", 'HYD.Baotu()', 12, "hyd", 0);
Common.CreateTrigger("hyd_goto", "^.*�����㣺��.*��Ŀǰ�ڡ�(\\S*)��,��ȥ��������!$", 'HYD.strGotoPlace = "%1";if Battle.bBattle == false then Common.InstanceRun(HYD.Goto, 10); end', 12, "hyd", 0);
Common.CreateTrigger("hyd_startbl", "^ϵͳ������WALK_FINISH = 0$", 'HYD.StartBL()', 12, "hyd", 0);
--Common.CreateTrigger("hyd_gotobl", '^ϵͳ������BL_ID = (\\S+)$', 'HYD.GotoID("%1")', 12, "hyd", 0);
--Common.CreateTrigger("hyd_gotoblerror", "^ϵͳ������BL_ERROR = 0$", 'HYD.Find(HYD.id)', 12, "hyd", 0);
Common.CreateTrigger("hyd_goto2", "^������(\\S+)��(\\S+)$", 'HYD.Goto2("%2", "%1")', 12, "hyd", 0);
Common.CreateTrigger("hyd_xunbaoOver2", "^���ҵ��˴������ص�����$", 'HYD.Over2()', 12, "hyd", 0);
Common.CreateTrigger("hyd_xunbaoOver", "^�����һ��һ�Ŵ������زر�ͼ��$", 'HYD.Over()', 12, "hyd", 0);
Common.CreateTrigger("hyd_getmap", "^���\\S+��ʬ�������ѳ�һƬ���ص�ͼ��Ƭ��$", 'HYD.Digit()', 12, "hyd", 0);
Common.CreateTrigger("hyd_item", "^��\\S+���ϵ��˳���һ��\\S+$", 'SendNoEcho("pack gem")', 12, "hyd", 0);
Common.CreateTrigger("hyd_mapstart", "^�ҷ��ָ�����С�����������һ������ˣ����������Ͽ��ܻ�������������ʹ����ȥ��$|^ϵͳ������WALK_STEP = 1$", 'DoAfterSpecial(2, "HYD.MapStep()", 12)', 12, "hyd", 0);
DeleteTrigger("hyd_mapstart");

EnableGroup("hyd", false);

HYD.Trigger = function(strParam)
	Common.CloseAllGroup();
	Battle.bPerform = true;
	EnableGroup("hyd", true);
	SetVariable("Q_name", "��һ��");
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
		SendNoEcho("ask hu about ����");
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
			Way.FindItemWayRandom("�� �� ��", "��", "ͭ��");
		else
			Way.FindItemWayRandom("�� �� ��", "", "ͭ��");
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
	Note("��һ��:" .. strPlaceID .. " ID:" .. strPlaceID .. " �� " .. strID );
	HYD.nNum = HYD.nNum + 1;
	SetVariable("Q_location", HYD.nNum);
end

HYD.Map = function()
	if HYD.bMap == true then
		SendNoEcho("ask sui cong about �ر�ͼ");
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
	Note("����:HYD��NPC��ַ:" .. strPlace);
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
		Note("==����==");
		Note("========");
	end
end

HYD.Combine = function()
	HYD.complate = true;
	SendNoEcho("combine");
	--DoAfterSpecial(2, 'Way.Goto("hyd")', 12);
	Common.SetID(nil);
	SetVariable("Q_misc", "���");
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
--             ��֮��              --
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
Common.CreateTrigger("mzj_finish", "^    ���� ������ͳ�Ƹ��޻� ��֮��\\(Meng zhijing\\)$", 'MZJ.Complate()', 12, "mzj", 0);
Common.CreateTrigger("mzj_findout", "^�㶨��һ����(\\S+)������Ҫ�ҵĺ�����������$", 'MZJ.Findout("%1")', 12, "mzj", 0);
Common.CreateTrigger("mzj_check", "^.*��Ԫ �������ϳ�·\\S+ʹ (\\S+)\\((\\S+ \\S+)\\).*$", 'MZJ.Check("%1", "%2")', 12, "mzj", 0);
Common.CreateTrigger("mzj_escape", "^(\\S+)��(\\S+)��Ķ����ˡ�$", 'MZJ.Escape("%1", "%2")', 12, "mzj", 0);
Common.CreateTrigger("mzj_decode2", "^[0-9 ]{2,4}(\\S+)$", 'MZJ.Decode("%1")', 12, "mzj", 0);
Common.CreateTrigger("mzj_complate", "^��ϲ��������˶�ͳ�Ƹ��д�����$", 'MZJ.GoBack()', 12, "mzj", 0);
Common.CreateTrigger("mzj_code1", "^��֮��\\(meng zhijing\\)�����㣺��һ�����ڣ���(\\S{2,4})�У���(\\S{2,4})�С��ڶ������ڣ���(\\S{2,4})�У���(\\S{2,4})�С�����\\(duizhao\\)��ҳ�����֪����Ҫ��ɱ���������ˡ�$", 'MZJ.Code("%1", "%2", "%3", "%4")', 12, "mzj", 0);
Common.CreateTrigger("mzj_code2", "^��֮��\\(meng zhijing\\)�����㣺��һ�����ڣ���(\\S{2,4})�У���(\\S{2,4})�С��ڶ������ڣ���(\\S{2,4})�У���(\\S{2,4})�С����������ڣ���(\\S{2,4})�У���(\\S{2,4})�С�����\\(duizhao\\)��ҳ�����֪����Ҫ��ɱ���������ˡ�$", 'MZJ.Code("%1", "%2", "%3", "%4", "%5", "%6")', 12, "mzj", 0);
Common.CreateTrigger("mzj_code3", "^��֮��\\(meng zhijing\\)�����㣺��һ�����ڣ���(\\S{2,4})�У���(\\S{2,4})�С��ڶ������ڣ���(\\S{2,4})�У���(\\S{2,4})�С����������ڣ���(\\S{2,4})�У���(\\S{2,4})�С����ĸ����ڣ���(\\S{2,4})�У���(\\S{2,4})�С�����\\(duizhao\\)��ҳ�����֪����Ҫ��ɱ���������ˡ�$", 'MZJ.Code("%1", "%2", "%3", "%4", "%5", "%6", "%7", "%8")', 12, "mzj", 0);
Common.CreateTrigger("mzj_code4", "^��֮��\\(meng zhijing\\)�����㣺��һ�����ڣ���(\\S{2,4})�У���(\\S{2,4})�С��ڶ������ڣ���(\\S{2,4})�У���(\\S{2,4})�С����������ڣ���(\\S{2,4})�У���(\\S{2,4})�С����ĸ����ڣ���(\\S{2,4})�У���(\\S{2,4})�С���������ڣ���(\\S{2,4})�У���(\\S{2,4})�С�����\\(duizhao\\)��ҳ�����֪����Ҫ��ɱ���������ˡ�$", 'MZJ.Code("%1", "%2", "%3", "%4", "%5", "%6", "%7", "%8", "%9", "%<10>")', 12, "mzj", 0);
Common.CreateTrigger("mzj_wait", "^������֮�������йء�job������Ϣ��\\n��֮��˵�����������˶����ӣ����ȵ�(\\S+)�Ⱥ����Ի�֪ͨ�㡣��$", 'MZJ.Wait("%1");MZJ.bZhanbu = true', 12, "mzj", 0, false, 2);
Common.CreateTrigger("mzj_wait2", "^��֮��\\(meng zhijing\\)�����㣺���㵽(\\S+)�Ⱥ��㻹�����ڵ��й䣬�Ͻ��㡣$", 'MZJ.Wait("%1")', 12, "mzj", 0, false, 2);
Common.CreateTrigger("mzj_init", "^    ���� ������ͳ�Ƹ��޻� ��֮��\\(Meng zhijing\\) \\[���񷢷�\\]$", 'SendNoEcho("ask meng about job")', 12, "mzj", 0);
Common.CreateTrigger("mzj_cantfind", "^ϵͳ������BL_NO_FIND = 0$", 'MZJ.Fail()', 12, "mzj", 0);
Common.CreateTrigger("mzj_blstart", "^ϵͳ������WALK_FINISH = 0$", 'MZJ.BL();', 12, "mzj", 0);
Common.CreateTrigger("mzj_start", "^�㱳�����ˣ����ĵش��˾�ֽ��$", 'MZJ.StartRecode()', 12, "mzj", 0);
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
	SetVariable("Q_name", "��ɱ");
	--Note("MZJ���:" .. MZJ.strWaitID);
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
	MZJ.strWaitPlace = "����" .. strPlace;
	MZJ.strWaitID = Name.TrancelateLocate(MZJ.strWaitPlace);
	--if GetVariable("ENABLE_ZHANBU") == "1" then
	--	Execute("w;zhanbu -myself");
	--	DoAfterSpecial(10, 'Way.Goto(MZJ.strWaitID)', 12);
	--else
		Way.Goto(MZJ.strWaitID);
	--end
	
	SetVariable("Q_place", strPlace);
	SetVariable("Q_misc2", MZJ.strWaitID);
	--Note("MZJ����:" .. MZJ.strWaitID);
	QuestOver.QuestStart();
end

MZJ.Pic = function(strParam)
	--Note(strParam .. ":" .. #strParam);
	MZJ.tDecode = {};
	MZJ.tCode.x = {};
	MZJ.tCode.y = {};
    local tCode = utils.split(strParam,",");
	if #tCode%2 == 1 then
		Note("��������");
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
			SetVariable("BL_NAME", "����δ֪Ŀ���ȷ��");
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
	Note("====�ҵ�====");
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
--              ����               --
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
Common.CreateAlias("alias_tzCha", "^TZC$", 'SendNoEcho("ask lianhua about ɷ��");', 12, "tz", 0);
Common.CreateTrigger("TZ_FIND", "^�ƺ���ʲô����һ������$", 'TZ.Find()', 12, "tz", 0);
Common.CreateTrigger("TZ_YOU_ARE_HERE", "^ϵͳ������YOU_ARE_HERE = 0$", 'TZ.AddNext()', 12, "tz", 0);
Common.CreateTrigger("TZ_BATTLE_OVER", "^ϵͳ������BATTLE = 0$", 'TZ.BattleOver()', 12, "tz", 0);
Common.CreateTrigger("TZ_BATTLE_START", "^.*���֣���ݺݵؿ����㡣$", 'TZ.BattleStart()', 12, "tz", 0);
Common.CreateTrigger("TZ_PIC", "^��������ʿ\\(lianhuasheng dashi\\)�����㣺���鼴��������$", 'TZ.Pic()', 12, "tz", 0);
Common.CreateTrigger("TZ_SHAQI", "^��������ʿ\\(lianhuasheng dashi\\)�����㣺���������ɷ��Ϊ(\\S+)��$", 'TZ.Shaqi("%1")', 12, "common", 1);
Common.CreateTrigger("TZ_over", "^��������ʿĬĬ�ӹ������е����飬���ḧ���š�$", 'QuestOver.TZ()', 12, "tz", 1);

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
	--Note("����ɷ���ȼ�:" .. nShaqi);
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
	SetVariable("Q_name", "����");
	SendNoEcho("unset adv_quest");
	SendNoEcho("ask dashi about job");
	TZ.bAskFail = false;
	TZ.bOver = false;
	TZ.bStart = false;
	--Battle.SetOnePfm(true);
end

TZ.Accept = function(strPlace)
	SendNoEcho("ask lianhua about ɷ��");
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
	SendNoEcho("ask lianhua about ɷ��");
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
		Note("��������");
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
	Note("��ʼ����");
	Way.Roll(TZ.strPlaceID);
end

TZ.Finish = function()
	SendNoEcho("ask lianhua about ɷ��");
	--TZ.Action();
	TZ.strPlaceID = "";
	Battle.SetEscape(false);
	Battle.AddPower(0);
--	EnableGroup("tz", false);
end

TZ.BattleStart = function()
	Common.InstanceRun(Way.FindWayEscape, 5, "����");
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
	Common.CreateTriggerFunc("tz_kill", "^\\S+���ˡ�$", "TZ.KillDigit", "tz");
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
--             ������              --
-------------------------------------
HSZ = {};
HSZ.strArea = "";
HSZ.bCanBack = false;

Common.CreateTrigger("HSZ_BATTLE_OVER", "^ϵͳ������BATTLE = 0$", 'HSZ.Leave()', 12, "hsz", 0);
--Common.CreateTrigger("HSZ_ROAD", "^��ע�⣬������֤���еĺ�ɫ���֡�\\nhttp://pkuxkx.*/antirobot/robot.*\\n(��.*)$", 'HSZ.Road("%1")', 12, "hsz", 0, false, 3);
Common.CreateTrigger("HSZ_ROAD", "^��\\S+����\\S+��.*$", 'HSZ.Road("%0")', 12, "hsz", 0);

HSZ.Road = function(strRoad)
	strRoad, _ = strRoad:match'(.*)(��.*)'
	strRoad = string.gsub(strRoad , "��", "");
	strRoad = string.gsub(strRoad , "��", ";");
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
	SetVariable("Q_name", "������");
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
--             �Ž���              --
-------------------------------------
ZJA = {}
ZJA.nStep = 0;
ZJA.strID = "";
ZJA.bFirst = true;

Common.CreateAlias("ZJA_ALIAS", "^ZJA\\s?(\\S*)$", 'ZJA.Alias("%1")', 12, "triggers");
Common.CreateAlias("ZJA_ALIAS_END", "^ZJS$", 'ZJA.Stop();SendNoEcho("ask zhang about fail");', 12, "triggers");
Common.CreateTrigger("ZJA_GIVE", "^    ؤ�︱���� �Ž���\\(Zhang jinao\\)$", 'SendNoEcho("give zhang core")', 12, "zja", 0);
Common.CreateTrigger("ZJA_KILL", "^    ľ��\\(Mu ren\\)$", 'SendNoEcho("killall mu ren")', 12, "zja", 0);
Common.CreateTrigger("ZJA_XIANSUO", "^����һ��ֽ���ƺ����Ž����ᵽ��������ľ���ƺ�����(\\S+)������ȥ�������ɡ�$", 'ZJA.Go("%1")', 12, "zja", 0);
Common.CreateTrigger("ZJA_OVER", "^������һö���غ��ģ����Ի�ȥ�������ˡ�$", 'ZJA.Back()', 12, "zja", 0);
Common.CreateTrigger("ZJA_INIT", "^��ĬĬѰ˼����˵�Ž��˼��ȳ��Ի�����Ϣ��Ҳ���ܴ�����Ū��ô���\\n������Ž�����������֪��������ʲô����Ч�͵ĵط�����\\n�Ž��������̾�˿�����\\n�Ž���˵��������֮ǰ�Ѿ�ǧ����࣬��������Ū��һ��ľ�ˣ���ȥ���ҿ����ɡ���\\n�Ž���˵��������ȥ��(\\S+)֮����\\(walk\\)(\\S+)�����ɷ��������µ�������һ�����з�������\\n�㰵���뵽������\\S+�����Ǻ������߹��ģ��ҿ�Ҫ��ʱͣ����\\(walk -p\\)����", 'ZJA.Init("%1", "%2")', 12, "zja", 0, false, 6);
Common.CreateTrigger("ZJA_FOUND", "^�������۾���ϸһ�������ƺ������Ž����ᵽ��������$", 'DoAfter(1, "get xian suo");DoAfter(1.2, "l xian suo");', 12, "zja", 0);
Common.CreateTrigger("ZJA_WAIT", "^�����Ž��������йء�job������Ϣ��\\n��ĬĬѰ˼����˵�Ž��˼��ȳ��Ի�����Ϣ��Ҳ���ܴ�����Ū��ô���\\n������Ž�����������֪��������ʲô����Ч�͵ĵط�����\\n�Ž���˵������������ҵ��˲��٣�����������ɡ���$", 'ZJA.Wait()', 12, "zja", 0, false, 4);
Common.CreateTrigger("ZJA_FINISH", "^���ܹ������\\S+���Ž���������$", 'ZJA.Stop()', 12, "zja", 0);
Common.CreateTrigger("ZJA_ARRIVE", "^ϵͳ������WALK_FINISH = 0$", 'ZJA.Alias()', 12, "zja", 0);

ZJA.tPlace = {
["̩ɽ"] = "tsdzf",
["�żҿ�"] = "zjk",
["������"] = "tlsrhm",
["����"] = "ly",
["����"] = "xiny",
["Ľ�ݼ������"] = "jxthb",
["����"] = "lz",
["Ȫ��"] = "qzh",
["������"] = "dlssm",
["����"] = "xyjz",
["�򽭳����ɿ�"] = "cjndk4",
["����"] = "jygc",
["�ٰ���"] = "hz",
["�����"] = "qlc",
["����Ĺ"] = "yfm",
--["�����"] = "yzj",
["��ɽ"] = "hsqcc",
["����"] = "yy",
["ƽ������"] = "pingxiwang",
["����"] = "lzh",
["����"] = "szclt",
["����"] = "qfgl",
["�ؽ�С��"] = "hzxz",
["������������"] = "bj",
["�����ƺӶɿ�"] = "hhnamjd",
["����ׯ"] = "gyz",
["����"] = "gwllt",
["������������"] = "bjadm",
["�����㰲��"] = "bjgam",
["������ʤ��"] = "bjdsm",
["���"] = "py",
["����ƺӶɿ�"] = "hhbdk3",
["ͭȸ̨"] = "tqt2",
["�ɹ�"] = "mgtl",
["�������"] = "ry",
["�����ƺӶɿ�"] = "hhbafld",
["���ݻƺӶɿ�"] = "hhbgd",
["����"] = "hzzx",
["���ݻƺӶɿ�"] = "hhngd",
["�����ƺӶɿ�"] = "hhnamjd",
["�����ƺӶɿ�"] = "hhndk",
["���չ�"] = "lingjiu",
["���������"] = "cajgm",
["����ͨ����"] = "cathm",
["����������"] = "camdm",
["����"] = "nanyang",
["����"] = "ruzhou",
["���"] = "xuchang",
["��ɽ��"] = "xc",
["����"] = "xy",
["����"] = "xiny",
["�䵱ɽ"] = "wdsm",
["����"] = "yz",
["ɱ�ְ�"] = "ssbgc",
["����ؤ��ֶ�"] = "gb",
["����"] = "huaibei",
["ȫ����"] = "qzgm",
["��Ĺ��"] = "gm",
["�������ݶ��ɿ�"] = "yzj",
["�����������ɿ�"] = "cjbdk",
["���������ɿ�"] = "cjbdk2",
["���ݳ����ɿ�"] = "lj",
["���չ㳡"] = "zp",
["������"] = "lx",
["�ɶ�"] = "cd",
["�����"] = "dl",
["��üɽ"] = "emsm",
["����"] = "km",
["�����置���"] = "kmsl3",
["���������ɿ�"] = "cjnlj",
["���ݳ����ɿ�"] = "cjndk2",
["�����"] = "cjnyzj",
["�ϲ��置���"] = "miaoling",
["�ϲ�"] = "nc",
["����"] = "jz",
["������������"] = "jkqlm",
["������������"] = "jkzym",
["�����������"] = "jkscm",
["������������"] = "jkcym",
["��"] = "zj",
["Ľ���������"] = "mr",
["������"] = "zjyxxc",
["����"] = "jx",
["½��ׯ"] = "jxljz",
["����"] = "fz",
["����"] = "putian",
["����÷ׯ"] = "xhmzgsmz",
["����Ĺ"] = "yfm",
["��ɽ"] = "ys",
["���ݸ�"] = "mzqyg",
["������"] = "2xu",
["���޺�"] = "xx",
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
	Note("����:" .. ZJA.nStep);
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
	Note("����:" .. ZJA.nStep);
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
	Common.CreateTriggerFunc("ZJA_record", "^\\��\\S+\\s+\\��(.+)\\s+\\��$", "ZJA.Record", "zja");
	Common.CreateTriggerFunc("ZJA_record_end", "^�����������������������������ة������� ���������� �򩤩���$", "ZJA.RecordEnd", "zja");
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
		Note("==�ҵ�TASK��Ʒ==");
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
--             ɱ�ְ�             --
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
Common.CreateTrigger("SSB_FIND", "^��Ȼ�䣬�������ĸ����㣬\\S+������(\\S+)���ֹ���$", 'SSB.Location("%1")', 12, "ssb", 0);
Common.CreateTrigger("SSB_BIANLI", "^ϵͳ������YOU_ARE_HERE = 0$", 'SSB.Bianli()', 12, "ssb", 0);
Common.CreateTrigger("SSB_AIM", "^.*?(\\S+)\\((\\S+) daxia\\).*$", 'SSB.FindNpc("%1", "%2")', 12, "ssb", 0);
Common.CreateTrigger("SSB_OVER", "^\\S+�е���������������~~~~���վ������ⲻ�˱�����������$", 'SSB.Over()', 12, "ssb", 0);
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
--             �ؾ���             --
------------------------------------

CJG = {};
CJG.nTime = 0;
CJG.nFight = 0;

DeleteTimer("CJG_TIME_COUNT");
Common.CreateTrigger("CJG_OVER", "^�ؾ���СԺ - $", 'CJG.Over()', 12, "cjg", 0);
Common.CreateTrigger("CJG_FIGHT", "^ϵͳ������BATTLE = 1$", 'CJG.Fight()', 12, "cjg", 0);

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
	SendNoEcho("ask huangmei seng about ����");
	--SendNoEcho("unset adv_quest")
end

CJG.Fight = function()
	CJG.nFight = CJG.nFight + 1;
	SetVariable("Q_misc2", CJG.nFight);
end

------------------------------------
--             ����              ---
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
Common.CreateTrigger("XF_INIT1", "^������������йء�job������Ϣ��\\n������˵�ͷ���ã�\\n�����������������һƷ���ɳ�����������ɱ�֣����������(\\S+)������(.+)��\\n *��������ԭ������Ϊ���ã���ȥ�����ܻ����ｻ���ҡ�������֮����������������ֱ�ӵ���\\(dian\\)����\\n.*\\n����������ļ磬˵���������ֵܣ��ͽ������ˣ����أ���$", 'XF.Init1("%1", "%2")', 12, "xf", 0, false, 6);
Common.CreateTrigger("XF_INIT2", "^������������йء�job������Ϣ��\\n������˵�ͷ���ã�\\n�����������������һƷ���ɳ�����������ɱ�֣����������(\\S+)������(.+)��\\n *����Ϊ�����������Ѷ����ӯ����ȥ����������ȡ���׼�������\\n.*\\n����������ļ磬˵���������ֵܣ��ͽ������ˣ����أ���$", 'XF.Init2("%1", "%2")', 12, "xf", 0, false, 6);
Common.CreateTrigger("XF_INIT3", "^������������йء�job������Ϣ��\\n������˵�ͷ���ã�\\n�����������������һƷ���ɳ�����������ɱ�֣����������(\\S+)������(.+)��\\n *���˼�������һƷ�ò��ã��пɽ̻�����ȥȰȰ\\(quan\\)���ɡ�\\n.*\\n����������ļ磬˵���������ֵܣ��ͽ������ˣ����أ���$", 'XF.Init3("%1", "%2")', 12, "xf", 0, false, 6);
Common.CreateTrigger("XF_INIT4", "^������������йء�job������Ϣ��\\n������˵�ͷ���ã�\\n�����������������һƷ���ɳ�����������ɱ�֣����������(\\S+)������(.+)��\\n *���������������ţ���ȥ��������ɫ���ƣ���������ͺá�\\n.*\\n����������ļ磬˵���������ֵܣ��ͽ������ˣ����أ���$", 'XF.Init4("%1", "%2")', 12, "xf", 0, false, 6);
Common.CreateTrigger("XF_PIC", "^������������йء�job������Ϣ��\\n������˵�ͷ���ã�\\n��Ŀͻ��˲�֧��MXP,��ֱ�Ӵ����Ӳ鿴ͼƬ��$", 'XF.Pic()', 12, "xf", 0, false, 3);
--end
Common.CreateTrigger("XF_WAIT", "^������������йء�job������Ϣ��\\n����˵�������ո��Ѿ�����ǰȥ�ˣ���л\\S+���⡣��$", 'DoAfter(3, "l");', 12, "xf", 0, false, 2);
Common.CreateTrigger("XF_WAIT2", "(^��1�������ʰɡ�$)|(^����˵����������æ���������ɡ���$)", 'DoAfter(3, "l");', 12, "xf", 0);
Common.CreateTrigger("XF_TRIP", "(^����ɱ��һ���������ݺݰ���һ�ӡ�$)|(^������ѵ��ѵ�������ԣ�����Ч������á�$)", 'SendNoEcho("l");SendNoEcho("follow mengmian shashou")', 12, "xf", 0);
Common.CreateTrigger("XF_FINISH", "^    ؤ��ڰ˴����� ����\\(Xiao feng\\)$", 'XF.Finish()', 12, "xf", 0);
Common.CreateTrigger("XF_NEXTSTEP", '^ϵͳ������WALK_FINISH = 0$', 'XF.NextStep()', 12, "xf", 0);
Common.CreateTrigger("XF_FindNpc", "^(.*)����һƷ�� (\\S+)\\((\\S* \\S+)\\)(.*)$", 'XF.FindNpc("%3", "%4", "%2", "%1")', 12, "xf", 0);
Common.CreateTrigger("XF_BATTLE_OVER", "^ϵͳ������BATTLE = 0$", 'XF.BattleOver()', 12, "xf", 0);
Common.CreateTrigger("XF_OVER2", "^���Ѿ������\\S+ɱ�ֵĹ�����$", 'XF.Over()', 12, "xf", 0);
Common.CreateTrigger("XF_DAMAGE", "^\\(.*������ɱ��\\( *��Ѫ:(\\d+)%/(\\d+)%\\).*$", 'XF.Damage("%1", "%2")', 12, "xf", 0);
Common.CreateTrigger("XF_QUAN", "^����ɱ������ԶԶ��ȥ�ˡ�$|^����ɱ�������̾�˿�����$", 'XF.Quan()', 12, "xf", 0);
Common.CreateTrigger("XF_QUAN2", "^��һ�ٹ������ᣬ����ɱ���е������ˡ�$", 'Execute("halt;quan")', 12, "xf", 0);
Common.CreateTrigger("XF_DIAN", "^(���߽�����ɱ�֣�ֻ������ɱ�������ϼ���ӬͷС�֣���������ɱ��������)|(����ʱ����ɱ���촽��ڣ����о綾���ۼ������ˡ�)$", 'XF.Dian()', 12, "xf", 0);
--Common.CreateTrigger("XF_RENSHU1", "^����ɱ��������˼�����˵�������ⳡ�����������ˣ��»ؿ�����ô��ʰ�㣡��$", 'XF.RenShu()', 12, "xf", 0);
Common.CreateTrigger("XF_RENSHU2", "^����ɱ�������̾�˿�����$", 'XF.RenShu()', 12, "xf", 0);
Common.CreateTrigger("XF_SHOUJI", "^�����һ��(\\S+)���׼���$", 'XF.Shouji("%1")', 12, "xf", 0);
Common.CreateTrigger("XF_SHOUJI2", "^��ץס(\\S+)��ʬ�壬���Ϸ�����Ӳ�����Ľ�\\S+��ͷ­��ʬ���ϳ����������������У�$", 'XF.Shouji("%1")', 12, "xf", 0);
Common.CreateTrigger("XF_SHOUJI3", "^���������е�.*����׼(\\S+)��ʬ��Ĳ�������ն����ȥ����Ѫ���ܵ��׼��������С�$", 'XF.Shouji("%1")', 12, "xf", 0);
Common.CreateTrigger("XF_INIT", "^    ؤ��ڰ˴����� ����\\(Xiao feng\\) \\[���񷢷�\\]$", 'XF.Accept()', 12, "xf", 0);
Common.CreateTrigger("XF_FAIL", "^���ڷ��������㱻���˾���.*$", 'XF.Over()', 12, "xf", 0);
Common.CreateTrigger("XF_ASKFAIL", "^ϵͳ������BL_NO_FIND = 0$", 'XF.Fail()', 12, "xf", 0);
Common.CreateTrigger("XF_INIT4_WAIT", "^����ɱ��˵�������Ҳ�����������Ϣһ�£������ٴ������$|^����ɱ��˵�������һ�û�ָ��ã��������֮Σô����$|^����������ɱ�ֲ�������������$", 'XF.Wait()', 12, "xf", 0);
Common.CreateTrigger("XF_SUREAIM", "^����ɱ��˵����������Ҳ������ֽ̹��򣿣���$", 'XF.bKill = true;SendNoEcho("killall mengmian shashou")', 12, "xf", 0);
Common.CreateTrigger("XF_NPCDEAD", "(^����ɱ�����ˡ�$)|(.*����ɱ�ֵ�ʬ��\\(Corpse\\)$)", 'XF.NpcDead()', 12, "xf", 0);
Common.CreateTrigger("XF_SEARCH", "^����û�� mengmian shashou��$", 'Common.InstanceRun(XF.Sure, 2)', 12, "xf", 0);
DeleteTrigger("XF_RENSHU1");

DeleteTimer("XF_SEARCH");
DeleteTimer("XF_CUT");

XF.Accept = function()
	Common.CloseAllGroup();
	EnableGroup("xf", true);
	SetVariable("Q_name", "����");
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
		Execute("BL " .. strPlace .. " ����һƷ�� ����ɱ��");
		SetVariable("Q_place", strPlace);
	else
		Note("��ַ�������");
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
	SetVariable("Q_misc2", "��:1 ɱ:2 Ȱ:3 ��:4");
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
	Execute("BL " .. strPlace .. " ����һƷ�� ����ɱ��");
	--Way.GotoCH(strPlace);
	SetVariable("Q_misc2", "��");--��
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
	Execute("BL " .. strPlace .. " ����һƷ�� ����ɱ��");
	--Way.GotoCH(strPlace);
	SetVariable("Q_misc2", "ɱ");
	SetVariable("Q_status", strRoom);
	SetVariable("Q_place", strPlace);
end

XF.Init3 = function(strPlace, strRoom)
	QuestOver.QuestStart();
	XF.nType = 3;
	XF.nStep = 0;
	Battle.bPerform = false;
	Execute("E_Q");
	Execute("BL " .. strPlace .. " ����һƷ�� ����ɱ��");
	--Way.GotoCH(strPlace);
	SetVariable("Q_misc2", "Ȱ");
	SetVariable("Q_status", strRoom);
	SetVariable("Q_place", strPlace);
end

XF.Init4 = function(strPlace, strRoom)
	QuestOver.QuestStart();
	XF.nType = 4;
	XF.nStep = 0;
	Battle.bPerform = false;
	Execute("E_Q");
	Execute("BL " .. strPlace .. " ����һƷ�� ����ɱ��");
	--Way.GotoCH(strPlace);
	SetVariable("Q_misc2", "ʤ");--��
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
	Way.FindItemWay("����һƷ�� ����ɱ��");
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
			if string.find(strPrefix, "���ָ���") or string.find(strPrefix, "��������") then
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
			--if string.find(strPrefix, "���ָ���") or string.find(strPrefix, "��������") then
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
			--if string.find(strPrefix, "���ָ���") or string.find(strPrefix, "��������") then
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
		Way.FindItemWay("����һƷ�� ����ɱ��");
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
			Execute("ask shashou about ����");
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
	if strName == "����ɱ��" then
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
	local strContant = "BL " .. GetVariable("Q_place") .. " ����һƷ�� ����ɱ��";
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
--             ����              --
-----------------------------------

Pozhen = {}
Pozhen.bSuccess = true;
Pozhen.bMaze = false;
Pozhen.strToward = "";
Pozhen.nIndex = 1;
Pozhen.tBuffer = {};

Common.CreateTrigger("pozhen_kill", "^��սʤ��\\S+!$", 'SendNoEcho("l")', 12, "pozhen", 0);
Common.CreateTrigger("pozhen_start", "^�����ƺ����������µĵص��ˡ�$", 'Pozhen.MazeStart()', 12, "pozhen", 0);
Common.CreateTrigger("pozhen_maze", '^ϵͳ������no_more = walkend$', 'Pozhen.Maze()', 12, "pozhen", 0);
--Common.CreateTriggerFunc("pozhen_trigger", '^����½�˷�����й�(��pozhen��|������)����Ϣ��\\n���½�˷���������Ž�������ð���һ�������\\W*���������ж���Ը���ͳ�ȥ��\\W+\\n(:?½�˷�˵�������ðɣ�����¾ͽ������ˡ���|��Ŀͻ��˲�֧��MXP,��ֱ�Ӵ����Ӳ鿴ͼƬ��)\\n.*\\n$', "Pozhen.Init", "pozhen", 0, false, "4");
DeleteTrigger("pozhen_maze_trigger");
DeleteTimer("PozhenMazeTimer");

Pozhen.Init = function(nNum, strLine, tWord)
	Pozhen.bSuccess = true;
	local x,y,n = string.find(tWord[0],"����(%W*)����")
	n = string.gsub(n, "��", "");
	Common_StatusClear();
	SetVariable("Q_name", "����");
	SetVariable("Q_location", n);
	Execute("EGS ql");
	local tPlace = Location.GetPlace_Test(n);
	local strPlaceID = Name.TrancelateLocate(tPlace.area..tPlace.room);
	Battle.SetEscape(false);
	if strPlaceID == "gbad" then strPlaceID = "gbad7"; end
	if Way.CantArrive(strPlaceID) then
		SendNoEcho("ask lu about ����ʧ��");
	else
		SendNoEcho("yun qi");
		if strPlaceID == "" then
			if GetVariable("PIC_PZ") == "1" then
				Common.ShowCommand("GT ", true);
			else
				SendNoEcho("ask lu about ����ʧ��");
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
	Common.CreateTriggerFunc("pozhen_finish", "^\\s+(?:����ׯׯ����������ˡ�)\\s?(?:½�˷�)\\((Lu chengfeng)\\)(\\s\\[���񷢷�\\]|)$", "Pozhen.Reply", "pozhen");
	DoAfterSpecial(2, 'Pozhen.Back()', 12);
end

Pozhen.MazeSuccess = function()
	SetVariable("Q_misc2", "����ɹ�");
	DoAfter(1.5 , "n")
	Pozhen.MazeOver();
end

Pozhen.MazeFail = function()
	SetVariable("Q_misc2", "����ʧ��")
	Pozhen.bSuccess = false;
	Pozhen.MazeOver()
end

Pozhen.MazeTrigger = function(_, strLine, tWord, tStyle)
	if strLine == "�������������������ͬ��Ϸһ�㡣" then
		Pozhen.tTowardType = {};
		Pozhen.strToward = "";
		Pozhen.nIndex = 1;
		DeleteTimer("PozhenMazeTimer");
	elseif strLine == "�㳢�����󣬿�ϧѡ���˴���ķ�����ʧ��һЩ��Ѫ��������" then
		Pozhen.strToward = "";
		Pozhen.nIndex = 1;
		DeleteTimer("PozhenMazeTimer");
	elseif strLine == "�㳹���ƽ������������" then
		Pozhen.bMaze = false;
		DeleteTimer("PozhenMazeTimer");
	elseif strLine == "����ʧ�ܣ���������������Զ���ڸǡ�" then
		Pozhen.MazeFail();
		DeleteTimer("PozhenMazeTimer");
	elseif string.find(strLine, "�벻�������ջ���ʧ���ˣ�") then
		Pozhen.MazeSuccess();
		DeleteTimer("PozhenMazeTimer");
	elseif Pozhen.bMaze then
		if string.find(strLine, "ʯ") or string.find(strLine, "��") or string.find(strLine, "��") then
			Pozhen.TowardTrigger(tStyle);
		end
	end 	
end

Pozhen.TowardTrigger = function(tStyle)
	for _,v in pairs(tStyle) do 
		if v.length == 2 and v.textcolour == GetBoldColour(2) then 
			if v.style == 1 then
				Pozhen.SetTowardInit("����");
			else 
				Pozhen.SetTowardInit("��ȷ");
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
	if Pozhen.tTowardType[Pozhen.nIndex] ~= "����" then 
		Pozhen.tTowardType[Pozhen.nIndex] = strType;
	end
	Pozhen.tBuffer[Pozhen.nIndex] = strType;

	if Pozhen.nIndex == 8 then
		for i = 8, 1, -1 do
			if Pozhen.tTowardType[i] == "��ȷ" then
				Pozhen.tTowardType[i] = "����";
				Pozhen.strToward = Pozhen.tToward[i];	
				Note("��: " .. Pozhen.strToward);
				Common.CreateTimer("PozhenMazeTimer" , 0, 3, "Pozhen.MazeRetry", 0, "pozhen");
				Pozhen.MazeRetry();
				return;
			end
		end
		for i = 1, 8 do
			if Pozhen.tBuffer[i] == "��ȷ" then
				Pozhen.strToward = Pozhen.tToward[i];	
				Note("������: " .. Pozhen.strToward);
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
		SendNoEcho("ask lu about ������");
	else
		SendNoEcho("ask lu about ����ʧ��");
	end
	DoAfterSpecial(0.1, 'DeleteTrigger("pozhen_finish")', 12);
end

Pozhen.MazeRetry = function()
	if Pozhen.strToward ~= "" then
		SendNoEcho(Pozhen.strToward)
	else
		Note("·��Ϊ��");
		DeleteTimer("PozhenMazeTimer");
	end
end

-------------------------------------
--             ����ֹ              --
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
GSZ.skills["emsmd"] = {"�ټ�ʮ��ׯ","���е�","���컯��","������","���ָ","������","�ط������","���־�ʽ","���������"};
GSZ.skills["gaibang"] = {"��������","��ң��","���ε���","����ʮ����","���ϵ�","�򹷰���"};
GSZ.skills["huashanjiaoxia"] = {"��ϼ��","��ɽ�ڹ�","��Ԫ��","��ɽ����","���콣","��Ůʮ�Ž�","���¾Ž�","�����ǵ�","���ὣ��","ϣ�Ľ���","��Ԫ��","��ʯ����ȭ","��ɽ��"};
GSZ.skills["lingxiaoqiaotou"] = {"ѩɽ�ڹ�","ѩɽ����","���ڵ���","����ȭ��","Ʈѩ�Ʒ�","������"};
GSZ.skills["quanzhengongmen"] = {"���칦","���㹦","ȫ�潣��","ͬ�齣��","����ȭ","����ȭ","һ��ָ","�����۶���","�������"};
GSZ.skills["2xu"] = {"��Ħ��","��Ԫһ����","��ղ�����","����ȭ","�黨ָ","������","���޵�","�׽���","��Τ����","ȼľ����","���±޷�","һָ��","�ȱ���","��צ��","����ǧҶ��","��ħ��","�޺�ȭ","Τ�ӹ�","���޵�","������","�޳���","ӥצ��","������","�������","�ն���","ɢ����","��Ӱ����"};
GSZ.skills["tdh"] = {"������ڤ��","�㶡Ʈ��","�廢���ŵ�","������","��Ѫ���Ľ�","��ȭ","Ǭ��������","����צ"};
GSZ.skills["tianlongsiruihemen"] = {"������","��������","��ڤ��","�貨΢��","һ��ָ","������","�ɻ�����","�μҽ���","���ϲ���"};
GSZ.skills["wudangshanmen"] = {"̫����","������","̫��ȭ","̫��צ","̫������","���鵶��"};
GSZ.skills["baituo"] = {"��󡹦","�����ȷ�","���ε���","����ѩɽ��","��ܲ���"};
GSZ.skills["dlsdqgc"] = {"���������","��ѩ����","Ѫ����","���浶","������","���ϴ�����","����ӡ","����צ"};
GSZ.skills["riyueheimuyaxia"] = {"������","������","���Ǵ�","���½���","���µ���","��а����","�������紸","�йٱʷ�","ӥצ��","��ɽ��","������","��ƨ��","������ķ�"};
GSZ.skills["sldwltdm"] = {"�����ķ�","�����޷�","����ذ��","��������","���β���"};
GSZ.skills["xingxiu"] = {"������","ժ����","���޶���","ժ�ǹ�","��ɽ�ȷ�","ڤ���ʽ","С���๦"};
GSZ.skills["lafyhm"] = {"��Ѫ�ķ�","����˫��","̫�泤ȭ","����ɢ��","�ƾ�����","���Խ���","���","����滨ǹ","̫��������","��ʮ��·�ͻ��޷�"};
GSZ.skills["gumu"] = {"������","��Ů�ķ�","��Ȼ������","��Ůȭ","�����׹�צ","ȫ�潣��","��Ů����","��������","���ޱ޷�","ǧ��������","���Ʋ���"};
GSZ.skills["lingjiu"] = {"�˻�����Ψ�Ҷ���","��ڤ��","�����潣","���޽���","��ɽ������","��ɽ��÷��","��Ӱ�貽","С���๦"};
GSZ.skills["mingjiao"] = {"����Ų����","����ʥ��","��������","������","���浶","Ǭ����Ų��","����ȭ","ʥ���","̫������","̫��ȭ","̫����","������","�ɻ�ժҶ�ַ�","ӥצ��"};
GSZ.skills["yanziwu"] = {"Ľ���ϼҴ�����","��Ԫ��","��ת����","������","Ľ�ݽ���","Ľ�ݵ���","�κ�ָ","������","�ټҵ���","����"};
GSZ.skills["taohuadaohaitan"] = {"��ָ��ͨ","�̺���","��Ӣ��","���｣��","��Ӣ����","��ָ��","������Ѩ��","����ɨҶ��","�����׹�צ","������"};

Common.CreateAlias("GSZ_StepOne", "^G (\\S+)$", 'GSZ.StepOne("%1")', 12, "gsz");
Common.CreateTrigger("GSZ_RecordStart", "^���ƺ���ĳ���书��ɵ��˺ۡ����Ժ��г������⼸���֡���$", 'GSZ.RecordStart()', 12, "gsz", 0);
Common.CreateTrigger("GSZ_RecordStop", "^�����һ����������Ե�ӵ������书������ȥ������$", 'GSZ.RecordStop()', 12, "gsz", 0);
Common.CreateTrigger("GSZ_TimeCheck", "^��\\[16\\]\\[��\\]����.*����(\\S+)��(\\S+)����ܽӵ��¸�����.*$", 'GSZ.TimeCheck("%1", "%2")', 12, "gsz", 0);


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
	SetVariable("Q_name", "����ֹ");
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
		SetVariable("Q_misc2", "�ҵ�����");
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
					Note("����" .. i);
					break;
				end
			end
		end
	end
	if nLen then
		GSZ.nIndex = 1;
		GSZ.StepTwo(GSZ.tSkill[1]);
		SetVariable("Q_location", GSZ.tSkill[1]);
		SetVariable("Q_misc2", "�Զ�����");
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
	if GetVariable("Q_misc2") == "�Զ�����" then
		Common.CreateTimer("GSZ_OnWolkOver " , 0, 5, "GSZ.GoNext", true);
	end
end

GSZ.FindGuild = function()
	DeleteTimer("GSZ_OnWolkOver");
end

-------------------------------------
--              �˷�               --
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
Common.CreateTrigger("JF_Fight2", "^���������ư︱������ɱ���㣡$", 'DeleteTimer("JF_Timer2Enable");', 12, "jf", 0);
Common.CreateTrigger("JF_Fight3", "^������������ɱ���㣡$", 'DeleteTimer("JF_Timer2Disable");', 12, "jf", 0);


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
	--Note("��ʼɱ��");
	JF.Timer1();
	Common.CreateTimer("JF_Timer1", 0, 0.8, "JF.Timer1");
end

JF.Timer1 = function()
	Note("ɱ����");
	SendNoEcho("kill durer npc");
	Common.CreateTimer("Jf_Timer2Enable", 0, 0.6, "JF.Timer2Enable", 1);
end

JF.Timer2 = function()
	Note("ɱ����");
	SendNoEcho("kill tufei");
	Common.CreateTimer("Jf_Timer2Disable", 0, 0.6, "JF.Timer2Disable", 1);
end

JF.Timer2Enable = function()
	Common.CreateTimer("JF_Timer2", 0, 0.8, "JF.Timer2");
end

JF.Timer2Disable = function()
	--Note("����");
	DeleteTimer("JF_Timer1");
	DeleteTimer("JF_Timer2");
end
]]--


-------------------------------------
--             ��Ա��              --
-------------------------------------
HYW = {};
HYW.nType = 0;--1:��ͼ;2:ɱ;3:ץ;4:����;5:��
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
Common.CreateTrigger("HYW_GET", "^    ������ ��Ա��\\(Han yuanwai\\) \\[���񷢷�\\]$", 'HYW.Ask();', 12, "hyw", 0);
Common.CreateTrigger("HYW_FINISH", "^    ������ ��Ա��\\(Han yuanwai\\)$", 'HYW.Finish();', 12, "hyw", 0);
Common.CreateTrigger("HYW_RecordStart", "^��Ա������ָ��ָ��ͼ��һ����λ��˵�������ҳ���(\\S+)\\((.*)\\)�ڴ˳��֣���ȥ�������ˣ�$", 'HYW.RecordStart("%1", "%2")', 12, "hyw", 0);
Common.CreateTrigger("HYW_RecordStop", "^�����һ����������Ե�ӵ������书������ȥ������$", 'HYW.RecordStop()', 12, "hyw", 0);
Common.CreateTrigger("HYW_BL", '^ϵͳ������YOU_ARE_HERE = 0$', 'HYW.BL()', 12, "hyw", 0);
Common.CreateTrigger("HYW_NPC_CHECK", '^(.*)\\((.+)\\)$', 'HYW.NpcCheck("%2", "%1")', 12, "hyw", 0);
Common.CreateTrigger("HYW_DEAD_CHECK", '^(\\S+)���ˡ�$', 'HYW.DeadCheck("%1")', 12, "hyw", 0);
Common.CreateTrigger("HYW_NO_FIND", "^ϵͳ������BL_NO_FIND = 0$", 'HYW.Fail()', 12, "hyw", 0);
Common.CreateTrigger("HYW_QUEST2", "^��Ա��˵�������ҳ���(\\S+)\\((.*)\\)�ݴ��ڡ�(\\S+)�����ֹ�����ȥ����ɱ������\\n���˲���Ϊ�壬ֻ�����׵�צ����������͵ش������ɡ�$", 'HYW.SetAim("%1", "%2", "%3", 2);', 12, "hyw", 0, false, 2);
Common.CreateTrigger("HYW_QUEST3", "^��Ա��˵�������ҳ���(\\S+)\\((.*)\\)�ݴ��ڡ�(\\S+)�����ֹ�����ȥ����ɱ������\\n�������Ҽ���Ѫ���������뽫���ܻأ������ҵ�����ɱ��ⲡ�$", 'HYW.SetAim("%1", "%2", "%3", 3);', 12, "hyw", 0, false, 2);
Common.CreateTrigger("HYW_QUEST4", "^��Ա��˵�������ҳ���(\\S+)\\((.*)\\)�ݴ���(\\S+)��(\\S+)��(\\S+)�������ֹ�����ȥ�ҵ�������ɱ������$", 'HYW.ThreePlace("%1", "%2", "%3", "%4", "%5")', 12, "hyw", 0);
Common.CreateTrigger("HYW_QUEST5", "^��Ա��˵�������ҳ���(\\S+)\\((.*)\\)�ݴ���(\\S+)��(\\S+)���֣���ȥ�����ɱ��$", 'HYW.Wait("%1", "%2", "%3", "%4")', 12, "hyw", 0);
Common.CreateTrigger("HYW_WAIT", "^���ҳ���\\S+����(\\S+)��󾭹��ѻ��ص㡣$", 'HYW.Time("%1")', 12, "hyw", 0);


HYW.Trigger = function()
	HYW.Init();
	HYW.Ask();
end

HYW.Init = function()
	SetVariable("Q_name", "��Ա��");
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

��Լ��Ҫ���پ���2���Ӻ�����������ȫ���ȡ��
��Ա��˵�������ҳ���Σ����(wei huilin)�ݴ��������е��ϳ��ų��֣���ȥ�����ɱ��
������˼���ܣ��㲻��������벻Ҫ���������ݾ��ߣ���֮���ӡ���Ҳ���ܳٹ������ֵ�ʱ�֣���������������ȥ��
���ҳ���Σ���ֽ��ھ�ʮ����󾭹��ѻ��ص㡣

�����������ľѻ��ص㣬��ݾ��ߣ�Σ���־����Ļ�·�ߣ�Զ�߸߷��ˡ�

ask han about fail
����Ա������йء�fail������Ϣ��
��Ա��ʧ�����ˡ�
������δ�ܰ�����Ա�⸴�𣬱��۳���
��ǧ����ʮ�˵�ʵս���飬
�Űپ�ʮ����Ǳ�ܣ�
һ��ʮ���㽭��������Ϊ�ͷ���
                             
=======================================================

����Ա������йء�job������Ϣ��
��Ա��˵���������ɽ����Ϊ�Һ��ҳ�ͷ������ָ�տɴ���[+1]��
��Լ��Ҫ���پ���2���Ӻ�����������ȫ���ȡ��
��Ա��˵�������ҳ������(sun ya)�ݴ��ڽ������ϳǡ����ˡ��ϲ��������ֹ�����ȥ�ҵ�������ɱ������
��������ʵʵ���������ߣ��˵Ĳ����ױ��ҵ���


========================================================
��Լ��Ҫ���پ���2���Ӻ�����������ȫ���ȡ��
��Ա��˵�������ҳ��˷�����(fan taosheng)�ݴ��ڡ����������ֹ�����ȥ����ɱ������
���˲���Ϊ�壬ֻ�����׵�צ����������͵ش������ɡ�

=========================================================
����Ա������йء�job������Ϣ��
��Ա��˵���������ɽ����Ϊ�Һ��ҳ�ͷ������ָ�տɴ���[+1]��
��Լ��Ҫ���پ���2���Ӻ�����������ȫ���ȡ��
��Ա��˵�������ҳ��˵��渣(shan xiangfu)�ݴ��ڡ�����Ľ�ݡ����ֹ�����ȥ����ɱ������
�������Ҽ���Ѫ���������뽫���ܻأ������ҵ�����ɱ��ⲡ�

=========================================================
��Ա��˵�������ҳ�������(li ting)�ݴ��ڡ��������������ֹ�����ȥ����ɱ������
���������ݸ��֣�����������ѡ�

=========================================================
��Ա��˵�������ҳ��˷�ޱ��(fan weiwan)�ݴ��ڡ�����ɽ�����ֹ�����ȥ����ɱ������
���˼�թ�ƹ��������أ�����任��òǰȥ�����ɱ��

��ޱ��ԶԶ��������񣬸Ͻ�Ѹ����ȥ��
��ҥ�ԡ�ĳ��: ��ޱ��������������٣�����Զ�����ģ�����������

]]


-----------------------------------
--             ����              --
-----------------------------------
MRPR = {};
MRPR.bStartBL = false;
MRPR.bOnce = false;
MRPR.bAskFail = false;
MRPR.bComplate = false;

Common.CreateAlias("alias_mrpr", "^MRPR([AB]{1})$", 'MRPR.Trigger("%1")', 12, "triggers");
Common.CreateAlias("alias_mrprfail", "^MRPRF$", 'MRPR.Fail()', 12, "mrpr", 0);
Common.CreateAlias("alias_mrprpic", "^MRPR (\\S+)$", 'MRPR.Pic("%1")', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_init", "^    ����Ľ�� ����\\(Pu ren\\) \\[���񷢷�\\]$", 'MRPR.Init()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_finish", "^    ����Ľ�� ����\\(Pu ren\\)$", 'MRPR.Complate()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_cantfind", "^ϵͳ������BL_NO_FIND = 0$", 'MRPR.Fail()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_complate", "^���Ľ��\\S+��ʬ�������ѳ�һ���ż���$", 'MRPR.GoBack()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_bl", '^ϵͳ������WALK_FINISH = 0$', 'MRPR.BL()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_npcdead", "^\\S+���ˡ�$", 'MRPR.NpcDead()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_goto", "^����̾���������ѷ�������͵������ү���ż����ݴ����ڡ�(.*?)���������֣���ȥ�����һ����ɣ�$", 'MRPR.NoPic("%1")', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_over", "^(������û���һ�Ľ�ݸ���ʧ���ż������۳���)|(������ɹ����һ�Ľ�ݸ�д���������ܵ��ż�����������)$", 'MRPR.Over()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_find", "^.*��\\S{2}���ֵ� Ľ������\\S+\\(Suinegy?'s murong jiazei\\)$", 'MRPR.Find()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_wait", "^����æ���أ��Ȼ�ɡ�$", 'MRPR.Wait()', 12, "mrpr", 0);
Common.CreateTrigger("mrpr_pic", "^����̾���������ѷ�������͵������ү���ż����ݴ��������µص㸽�����֣���ȥ�����һ����ɣ�\\n��Ŀͻ��˲�֧��MXP,��ֱ�Ӵ����Ӳ鿴ͼƬ��\\n��ע�⣬������֤���еĺ�ɫ���֡�$", 'MRPR.Fullme()', 12, "mrpr", 0, false, 3);

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
	SetVariable("Q_name", "Ľ������");
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
	MRPR.strID = " �������ֵ� Ľ������";
	if Common.id == "suinegy" then
		MRPR.strID = " ������ֵ� Ľ������";
	end
	if strPlace ~= "" and strPlace ~= nil then
		Execute("BL " .. strPlace .. MRPR.strID);
		SetVariable("Q_place", strPlace);
	else
		Note("��ַ�������");
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
--             ��ħ              --
-----------------------------------

XM = {};
XM.strWayBuffer = "";
XM.nStep = 0;
XM.nTry = 0;
XM.tWay = {"n", "s", "e", "w", "ne", "nw", "se", "sw"};

Common.CreateAlias("trigger_xm", "^XMA$", 'Execute("EGA xm;l")', 12, "trigger");
Common.CreateTrigger("xm_init", "^    ��ɳ�ŷ���\\(Pishamen foxiang\\)$", 'XM.Init()', 12, "xm", 0);
Common.CreateTrigger("xm_try", "^������Ŀ������š�$", 'XM.ReTry()', 12, "xm", 0);
Common.CreateTrigger("xm_right", "^�·����о���Ŀ�������һ����$", 'XM.SavePath();', 12, "xm", 0);
Common.CreateTrigger("xm_check", "^ϵͳ������XMReWalk = 1$", 'XM.Check();', 12, "xm", 0);
Common.CreateTrigger("xm_step", "^ϵͳ������XMReWalk = 2$", 'XM.Step();', 12, "xm", 0);
Common.CreateTrigger("xm_leave", "^�㷢��һ���˳���������ǰ������һ����ԭ�������Լ���$", 'XM.Leave();', 12, "xm", 0);

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
	Note("��ǰ·��Ϊ:" .. XM.strWayBuffer);
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
--             ��ս              --
-----------------------------------

Yujie = {};
Yujie.nStep = 0;
Yujie.strName = "";
Yujie.strSay = "";
Yujie.strPlace = "";

Yujie.tPlace = {};
Yujie.tPlace["������������"] = "lxdt";
Yujie.tPlace["ɱ�ְ�ɱ�ְ�"] = "ssbgc";
Yujie.tPlace["��Ĺ��Ĺ"] = "gmdt";
Yujie.tPlace["����ɽ����ɽ����"] = "btdt";


Common.CreateAlias("YuJieStart", "^YJA$", 'EnableGroup("yujie", true)', 12, "trigger");
Common.CreateAlias("YuJieSet", "^YJB (.*)$", 'Yujie.nStep = %1', 12, "yujie");
Common.CreateAlias("YuJieFail", "^YJF$", 'Yujie.Fail()', 12, "yujie");
Common.CreateTrigger("YuJie_Init", "^    ���� ��ة�������ʹ ��d\\(Yu jie\\) \\[���񷢷�\\]$", 'Yujie.Init()', 12, "yujie", 0);
Common.CreateTrigger("YuJie_Finish", "^    ���� ��ة�������ʹ ��d\\(Yu jie\\)$", 'Yujie.Finish()', 12, "yujie", 0);
Common.CreateTrigger("Yujie_walkOver", "^ϵͳ������WALK_FINISH = 0$", 'Yujie.WalkOver();', 12, "yujie", 0);
Common.CreateTrigger("YuJie_Accept", "^������d�����йء�job������Ϣ��\\n��d˵������\\S+��\\n��d����Ķ�������˵���������з���Ҫ�鱨��Ҫ�㴫�ݳ�ȥ��\\n��d����Ķ�������˵����Ϊ�˱�����ͷ�˵İ�ȫ����ͷ�˵����ֲ���͸¶����ֻ�ܸ�����ĳ����(.*)�����㡣$", 'Yujie.Step1("%1")', 12, "yujie", 0, false, 4);
Common.CreateTrigger("Yujie_Jietou", "^    .*\\((\\S+) .*\\)$", 'Yujie.Jietou("%1");', 12, "yujie", 0);
Common.CreateTrigger("Yujie_Step3", "^\\S+����Ķ�������˵����������(\\S+)��(\\S+)���԰������������һ���ж��Ĳ��衣$", 'Yujie.Step3("%1%2");', 12, "yujie", 0);
Common.CreateTrigger("YuJie_Step2", "^����\\S+�����йء���ͷ������Ϣ��\\n\\S+˵���������������ˡ���\\n\\S+����Ķ�������˵����������(\\S+)��(\\S+)���԰������������һ���ж��Ĳ��衣$", 'Yujie.Step3("%1")', 12, "yujie", 0, false, 3);
Common.CreateTrigger("Yujie_Step4", "^\\[(.*)\\]\\s+��\\S{2}�������.*$", 'Yujie.Step4("%1");', 12, "yujie", 0);
Common.CreateTrigger("Yujie_Step5", "^(\\S+)����(\\S+)�����㣬�����ǡ�(\\S+)����$", 'Yujie.Step5("%1", "%2", "%3");', 12, "yujie", 0);
Common.CreateTrigger("Yujie_Step6", "^.* (\\S+)\\(.+\\)$", 'Yujie.Step6("%1");', 12, "yujie", 0);
Common.CreateTrigger("Yujie_Step7", "^ϵͳ������BATTLE = 0$", 'Yujie.Step7();', 12, "yujie", 0);

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
	Note("��һ��:" .. strPlace .. ":" .. Location.tBLID[strPlace]);
	SetVariable("BL_PLACE", strPlace);
	Way.Goto(Location.tBLID[strPlace], false);
end

Yujie.Jietou = function(strID)
	if Yujie.nStep == 2 then
		SendNoEcho("ask " .. string.lower(strID) .. " about ��ͷ");
	end
end

Yujie.Step3 = function(strPlace)
	if Yujie.nStep == 2 then
		Yujie.nStep = 3;
		Execute("bl off");
		Note("�ڶ���:" .. strPlace .. ":" .. Yujie.tPlace[strPlace]);
		Way.Goto(Yujie.tPlace[strPlace], false);
	end
end

Yujie.Step4 = function(strID)
	if Yujie.nStep ~= 3 then return; end
	Yujie.nStep = 4;
	Note("������:" .. strID);
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
	Note("���Ĳ�:" .. strName .. " " .. strPlace .. ":" .. Yujie.strPlace .. " " .. strSay);
	Way.Goto(Yujie.strPlace, true);
end

Yujie.Step6 = function(strName)
	if Yujie.nStep ~= 5 then return; end
	if Yujie.strName ~= strName then return; end
	Yujie.nStep = 6;
	Note("���岽:say " .. Yujie.strSay);
	SendNoEcho("say " .. Yujie.strSay);
end

Yujie.Step7 = function(strName)
	if Yujie.nStep ~= 6 then return; end
	Yujie.nStep = 7;
	Note("������:����");
	Way.Goto("cdsczdf", false);
end