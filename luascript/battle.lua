Battle = {}
Battle.bWeapon = true;
Battle.bQiankun = false;
Battle.strWarnName = "";
Battle.nPower = 0;
Battle.bPerform = true;
Battle.bEscape = false;
Battle.strExit = "";
Battle.strExitBack = "";
Battle.nExitTimes = 0;
Battle.bEscapeBack = false;
Battle.bOnePfm = false;
Battle.nHP = 100;
Battle.strPfmNpcID	= "";
Battle.strPfmName	= "";
Battle.bPfmChan		= false;
Battle.strPfmNpcID2	= "";
Battle.strPfmName2	= "";
Battle.bPfmChan2	= false;
Battle.nJiang = 0;
Battle.bBattle = false;

Common.CreateAlias("alias_pfm", "^PFM$", 'Battle.BattlePerformSwtich()', 12, "triggers");
Common.CreateTrigger("battle_removebyweapon", "^(\\S+)卸除了你的兵器.+$", 'Battle.RemoveByWeapon("%1")', 12, "battle", 1);
Common.CreateTrigger("battle_setjiang", "^│.*?(\\S+)瓶玉蜂浆\\(Yufeng jiang\\).*│$", 'Battle.SetJiangNum(StrToNum("%1"))', 12, "battle", 1);
Common.CreateTrigger("battle_battleovercheck", "^【 食物 】.+【 潜能 】.+$", 'Battle.FightOverAction()', 12, "battle", 1);

DeleteTimer("timer_healseft");

Battle.CorpseCheck = function(strName)
	if Battle.strPfmName == strName then
		Battle.strPfmName = "";
		Battle.strPfmNpcID = "";
		Battle.bPfmChan = false;
	end
	if Battle.strPfmName2 == strName then
		Battle.strPfmName2 = "";
		Battle.strPfmNpcID2 = "";
		Battle.bPfmChan2 = false;
	end
	Battle.WarnQiankunOver(strName);
	SendNoEcho("l corpse");
	if GetVariable("Q_name") == "萧峰" and XF.nType == 2 then
		SendNoEcho("l corpse 2");
		SendNoEcho("l corpse 3");
		SendNoEcho("l corpse 4");
	end
	--if GetVariable("Q_name") == "送信" then
		SendNoEcho("get han from corpse");
	--end
	--SendNoEcho("get xin from corpse");
	--SendNoEcho("get map from corpse");
	SendNoEcho("get gold from corpse");
	SendNoEcho("get gem from corpse");
	--SendNoEcho("get silver from corpse");
end

Battle.SetJiangNum = function(nNum)
	Battle.nJiang = nNum;
	--Note("战斗检查:" .. nNum .. "瓶浆");
end

Battle.PfmOn = function(strName)
	if strName ~= nil and strName ~= "" then
		if Battle.strPfmName ~= strName then
			Battle.bPfmChan = false;
		end
		Battle.strPfmName = strName;
		Battle.strPfmNpcID = Name.TrancelateName(strName);
		SendNoEcho("zhuanzhu " .. Battle.strPfmNpcID);
		--Note("集火:" .. Battle.strPfmNpcID);
		if GetVariable("Q_name") == "天珠" then
			SendNoEcho("huanying");
		end
	else
		Battle.strPfmNpcID = "";
	end
end

Battle.PfmOn2 = function(strName)
	if strName ~= nil and strName ~= "" then
		if Battle.strPfmName2 ~= strName then
			Battle.bPfmChan2 = false;
		end
		Battle.strPfmName2 = strName;
		Battle.strPfmNpcID2 = Name.TrancelateName(strName);
		if Battle.strPfmNpcID == "" then
			SendNoEcho("zhuanzhu " .. Battle.strPfmNpcID2);
			--Note("集火:" .. Battle.strPfmNpcID);
		end
		if GetVariable("Q_name") == "天珠" then
			SendNoEcho("huanying");
		end
	else
		Battle.strPfmNpcID2 = "";
	end
end

Battle.RemoveByWeapon = function(strName)
	--Battle.PfmOn(strName);
	--if Common.id == "suineg" then

	if GetVariable("Q_name") ~= "萧峰" or XF.nType == 2 then
		SendNoEcho("wield " .. GetVariable("W_1") .. " at right");
		SendNoEcho("wield " .. GetVariable("W_2") .. " at right");
		SendNoEcho("wield " .. GetVariable("W_3") .. " at right");
		--SendNoEcho("jianyi");
		--DoAfterSpecial(0.5, 'SendNoEcho("jianyi")', 12);
		--DoAfterSpecial(1, 'SendNoEcho("jianyi")', 12);
		--DoAfterSpecial(1.5, 'SendNoEcho("jianyi")', 12);
		--Note("剑意");
		SendNoEcho("jiali 1");
		Note("切换掌法");
		Battle.bWeapon = false;
	end
	--else
	--	SendNoEcho("jiali max");
	--	Note("切换掌法");
	--	Battle.bWeapon = false;
	--end
end

Battle.AddPower = function(strPower)
	SendNoEcho("jiali " .. strPower);
end

Battle.WeaponOn = function()
	Battle.bWeapon = true;
	Execute("E_W");
end

Battle.WeaponOff = function()
	Battle.bWeapon = false;
	SendNoEcho("unwield all");
end

Battle.WarnQiankun = function(strName)
	--Battle.PfmOn(strName);
	if GetVariable("NO_ARMER") == nil or GetVariable("NO_ARMER") == "1" then return; end
	if Battle.bQiankun == false then
		Battle.bQiankun = true
		Battle.strWarnName = strName;
		Battle.WeaponOff();
		Battle.AddPower("max");
		Note("****防乾坤****");
	end
end

Battle.WarnQiankunOver = function(strName)
	if GetVariable("NO_ARMER") == nil or GetVariable("NO_ARMER") == "1" then return; end
	if Battle.bQiankun == true and Battle.strWarnName == strName then
		Battle.strPfmNpcID = "";
		Battle.bQiankun = false;
		Battle.WeaponOn();
		Battle.AddPower("0");
		Note("++++乾坤死++++");
	end
end

Battle.SetPower = function(nPower)
--	Note("||气势: " .. nPower .. "||")
	SetVariable("Q_qishi", tostring(nPower));
	Battle.nPower = nPower;
	Battle.FightStart();
	EnableGroup("nobattle", false);
	SendNoEcho("yun qi");
	if Battle.bPerform == true then
		EnableTimer("BattlePerform", true);
	end
end

Battle.ChanOver = function(strName)
	if Battle.strPfmName == strName then
		Battle.bPfmChan = true;
	end
	if Battle.strPfmName2 == strName then
		Battle.bPfmChan2 = true;
	end
end

Battle.Chan = function()
	if GetVariable("Q_name") ~= "天珠" then return; end
	if Battle.strPfmNpcID ~= "" and not Battle.bPfmChan then
		SendNoEcho("weapons use " .. GetVariable("W_1") .. " as whip");
		SendNoEcho("weapons use bing as whip");
		--SendNoEcho("bianying");
		--SendNoEcho("checkbusy");
		Note("缠:" .. Battle.strPfmName);
		Send("perform changhen-bian.chan " .. Battle.strPfmNpcID);
		Execute("E_T");
	elseif Battle.strPfmNpcID2 ~= "" and not Battle.bPfmChan2 then
		SendNoEcho("weapons use " .. GetVariable("W_1") .. " as whip");
		SendNoEcho("weapons use bing as whip");
		--SendNoEcho("bianying");
		--SendNoEcho("checkbusy");
		Note("缠:" .. Battle.strPfmName2);
		Send("perform changhen-bian.chan " .. Battle.strPfmNpcID2);
		Execute("E_T");
	end
end

Battle.PfmAimClear = function()
	Battle.strPfmName = "";
	Battle.strPfmNpcID = "";
	Battle.bPfmChan = false;
	Battle.strPfmName2 = "";
	Battle.strPfmNpcID2 = "";
	Battle.bPfmChan2 = false;
end

Battle.PFM = function(strSkillName)
	if Battle.strPfmNpcID and Battle.strPfmNpcID ~= "" then
		SendNoEcho("perform " .. strSkillName .. " " .. Battle.strPfmNpcID);
	end
	if Battle.strPfmNpcID2 and Battle.strPfmNpcID2 ~= "" then
		SendNoEcho("perform " .. strSkillName .. " " .. Battle.strPfmNpcID2);
	--	SendNoEcho("zhuanzhu " .. Battle.strPfmNpcID2);
	end
	--if Battle.strPfmNpcID and Battle.strPfmNpcID ~= "" then
	--	SendNoEcho("zhuanzhu " .. Battle.strPfmNpcID);
	--end
	SendNoEcho("perform " .. strSkillName);
--	Note(strSkillName);
--	SendNoEcho("checkbusy");
end

Battle.Perform = function()
	--Execute("E_W");
	
	if GetVariable("Q_name") == "天珠" then
		Battle.PFM("xuantie-jian.xiongyong");
		Battle.PFM("xiaohun-zhang.anran");
		--Battle.PFM("yunu-jianfa.suxin");
	elseif Battle.bWeapon == true then
		--if GetVariable("Q_name") ~= "天珠" then
		--	if Battle.nPower >= 8 then
		--		Battle.PFM("xunlei-jian.qishou");
		--	end
		--	if Battle.nPower >= 4 then
		--		Battle.PFM("xunlei-jian.juli");
		--	end
		--end
		if Battle.bPerform == true then
			--if Battle.nPower >= 8 then
			--	Battle.PFM("xunlei-jian.shiliu");
			--end
			if Common.id == "suineg" and Battle.nPower >= 12 and GetVariable("Q_name") ~= "萧峰" then
				Battle.PFM("xiaohun-zhang.anran");
			end
			if Battle.nPower >= 16 then
				Battle.PFM("xuantie-jian.xiongyong");
				if Battle.bOnePfm == true then
					Common.CreateTimer("timer_escape" , 0, 0.2, "Battle.EscapeAction", true);
					Battle.SetBack(true);
				end
			end
			Battle.PFM("yunu-jianfa.suxin");
			--if Common.id == "suineg" and Battle.bPerform and Battle.nPower > 18 then
			--	Battle.Chan();
			--end
		end
	else
		local bZQLingwu = GetVariable("ZQ_Lingwu");
		if bZQLingwu == nil or bZQLingwu == "0" then
			if Common.id == "suineg" and Battle.nPower >= 12 then
				if Battle.bQiankun == true or Battle.bWeapon == true then
					Battle.AddPower("max");
				end
				Battle.PFM("xiaohun-zhang.anran");
				if Battle.bQiankun == true or Battle.bWeapon == true then
					Battle.AddPower("0");
				end
			end
			if Common.id == "suinegy" and Battle.nPower >= 10 then
				Battle.PFM("meinu-quan.shexin");
			end
			if Battle.nPower >= 12 then
				Battle.PFM("jiuyin-baiguzhao.zhua");
			end
		else
			Battle.PFM("zui-quan.lingwu");
		end
	end
end

Battle.Exits = function(strParam)
	if strParam ~= "" then
		strParam = Way.ExitFix(strParam);
		Battle.strExit = utils.split(strParam, ";")[1];
	else
		Battle.strExit = "";
	end
	--Note("逃离:" .. Battle.strExit);
end

Battle.EscapseBack = function()
	--Battle.WeaponOn();
	Battle.nExitTimes = Battle.nExitTimes + 1;
	if Common.id == "suineg" then
		Battle.nExitTimes = 0;
	end
	if Battle.nExitTimes < 3 then
		Execute("halt;BUFF;yun qi");
		DoAfterSpecial(1, 'SendNoEcho(Battle.strExitBack);Battle.strExitBack = "";', 12);
	end
end

Battle.SetEscape = function(bEscape, bBack)
	Battle.bEscape = bEscape;
	if bEscape == false then
		Battle.strExitBack = "";
	else
		Battle.nExitTimes = 0;
		Battle.bEscapeBack = true;
	end
--	if bBack == true then
--		Battle.bEscapeBack = true;
--	else
--		Battle.bEscapeBack = false;
--	end
--	if bEscape then
--		Note("逃离开启");
--	else
--		Note("逃离关闭");
--	end
end

Battle.SetBack = function(bBack)
	Battle.bEscapeBack = bBack;
end

Battle.EscapeContinue = function()
	--Common.CreateTimer("timer_escape" , 0, 0.1, "Battle.EscapeAction", true);
	Common.InstanceRun(Battle.EscapeAction, 1);
end

Battle.EscapeTry = function()
	Way.Clear(0);
	if Battle.bEscape and Battle.strExit ~= "" then
		Common.InstanceRun(Battle.EscapeAction, 0.5);
		--Common.CreateTimer("timer_escape" , 0, 0.1, "Battle.EscapeAction", true);
	end
end

Battle.EscapeAction = function()
	SendNoEcho("sp chainless");
	SendNoEcho("displace");
	SendNoEcho("halt");
	if Way.strPlace == "大沙漠" then
		Battle.strExit = "east";
	elseif Way.strPlace == "深谷" then
		Battle.strExit = "enter hole";
	elseif Way.strPlace == "大树上" then
		Battle.strExit = "jump down";
	elseif Way.strPlace == "树杈上" then
		Battle.strExit = "climb down";
	elseif Way.strPlace == "海中" or Way.strPlace == "泉水中" then
		Battle.strExit = "jump out";
	elseif Way.strPlace == "山洞" then
		Battle.strExit = "swim";
	elseif Way.strPlace == "茅厕" then
		Battle.strExit = "out";
	elseif Way.strPlace == "孤山" then
		Battle.strExit = "nw";
	elseif Way.strPlace == "临海楼" then
		Battle.strExit = "w";
	end
	if Way.bEscapeWay ~= "" then
		SendNoEcho(Way.bEscapeWay);
		if GetVariable("BATTLE_ESCAPE_BACK") == "1" then
			Battle.strExitBack = Location.Revert[Way.bEscapeWay];
		else
			Battle.strExitBack = "";
		end
		Note("逃向1:" .. Way.bEscapeWay .. ":" .. Battle.strExit);
	else
		SendNoEcho(Battle.strExit);
		if GetVariable("BATTLE_ESCAPE_BACK") == "1" then
			Battle.strExitBack = Location.Revert[Battle.strExit];
		else
			Battle.strExitBack = "";
		end
		Note("逃向2:" .. Battle.strExit .. ":" .. Way.bEscapeWay);
	end
	SendNoEcho("sp chainless");
	SendNoEcho("displace");
	SendNoEcho("halt");
	if Way.bEscapeWay ~= "" then
		SendNoEcho(Way.bEscapeWay);
	else
		SendNoEcho(Battle.strExit);
	end
end

Battle.HealSelf = function()
	--if GetStatusHPUp() < GetStatusHPMax() then
	--	SendNoEcho("yun heal");
	--else
	--	DeleteTimer("timer_healseft");
	--end
end

Battle.Damaged = function(num, str, args)
	Note("============== HP: " .. args[2] .. "\% / " .. args[3] .. "\% ===== 受伤:" .. args[1] .. " ==============");
	Battle.FightStart();
	local nHp = tonumber(args[2]);
	local nMax = tonumber(args[3]);
	Battle.nHP = nHp * nMax / 100;
	if Battle.nHP < 10 and GetVariable("FULLME_BUFFER") ~= "" then
		Execute("halt;fullme " .. GetVariable("FULLME_BUFFER"));
	end
	if Battle.nHP < 40 then
		Battle.DrinkJiang();
	end
	if Battle.nHP < 60 and Battle.bBattle == true then
		Battle.EscapeTry();
	end
end

Battle.Damaged1 = function(num, str, args)
	Note("============== HP: " .. args[1] .. "\% / " .. args[2] .. "\% =============");
	--Battle.FightStart();
	local nHp = tonumber(args[1]);
	local nMax = tonumber(args[2]);
	Battle.nHP = nHp * nMax / 100;
	if Battle.nHP < 10 and GetVariable("FULLME_BUFFER") ~= "" then
		Execute("halt;fullme " .. GetVariable("FULLME_BUFFER"));
	end
	if Battle.nHP < 10 then
		Battle.DrinkJiang();
	end
	if Battle.bBattle == true then
		if Battle.nHP < 20 and Common.id == "suineg" then
			Battle.EscapeTry();
		elseif Battle.nHP < 40 then
			Battle.EscapeTry();
		end
	end
end

Battle.Poison = function(num, str, args)
	--Note("============== HP: " .. args[3] .. "\% / " .. args[4] .. "\% ===== 中毒-" .. args[2] .. ":" .. args[1] .. " ==============");
	Common.InstanceRun(Battle.Hpbrief, 1);
end

Battle.DrinkJiang = function()
	SendNoEcho("drink jiang");
	DoAfterSpecial(0.5, 'SendNoEcho("drink jiang")', 12);
	DoAfterSpecial(1, 'SendNoEcho("drink jiang")', 12);
	--Battle.SetJiangNum(Battle.nJiang - 1);
end

Battle.Levelup = function()
	if nLocal < 2 and Battle.bEscape then
		SendNoEcho("levelup;y");
	end
end

Battle.SetOnePfm = function(bTrue)
	Battle.bOnePfm = bTrue;
end

Battle.BattlePerformSwtich = function(bOpen)
	if bOpen == nil then
		Battle.bPerform = not Battle.bPerform;
	else
		Battle.bPerform = bOpen;
	end
	local strOutput = "关";
	if Battle.bPerform == true then 
		strOutput = "开";
		if Battle.nPower > 0 then
			EnableTimer("BattlePerform", Battle.bPerform);
			Battle.Perform();
		end
	else
		EnableTimer("BattlePerform", Battle.bPerform);
	end
	Note("特技:" .. strOutput);
end

Battle.BattlePerformOn = function()
	Battle.bPerform = true;
	Note("特技:开");
end

Battle.tFightStartCallback = {};
Battle.FightStartAdd = function(func)
	return Common.TableAdd(Battle.tFightStartCallback, func);
end
Battle.FightStartDel = function(func)
	return Common.TableDel(Battle.tFightStartCallback, func);
end
Battle.FightStart = function()
	if Battle.bBattle == false then
		Note("战斗开始");
		Execute("hps on");
		if GetVariable("Q_name") ~= "天珠" and GetVariable("Q_name") ~= "萧峰" then
			Execute("E_A");
		elseif GetVariable("Q_name") ~= "慕容仆人" and GetVariable("Q_name") ~= "萧峰" and GetVariable("Q_name") ~= "刺杀" and GetVariable("Q_name") ~= "胡一刀" then
			SendNoEcho("l");
		end
		--SendNoEcho("jianyi");
		--DoAfterSpecial(0.5, 'SendNoEcho("jianyi")', 12);
		--DoAfterSpecial(2, 'SendNoEcho("jianyi")', 12);
		SendNoEcho("perform yunu-jianfa.suxin");
		DoAfterSpecial(0.5, 'SendNoEcho("perform yunu-jianfa.suxin")', 12);
		SendNoEcho("response BATTLE 1");
		--SendNoEcho("unset BATTLE");
		if Battle.strPfmNpcID ~= "" then
			SendNoEcho("zhuanzhu " .. Battle.strPfmNpcID);
		end
		SendNoEcho("yun qi");
		Common.CheckBusy();
	end
	Battle.bBattle = true;
end

Battle.tFightOverCallback = {};
Battle.FightOverAdd = function(func)
	return Common.TableAdd(Battle.tFightOverCallback, func);
end
Battle.FightOverDel = function(func)
	return Common.TableDel(Battle.tFightOverCallback, func);
end
Battle.FightOverAction = function()
	if Battle.bBattle == true then
		Note("战斗结束");
		Execute("hps off");
		SendNoEcho("response BATTLE 0");
		--SendNoEcho("unset BATTLE");
		SendNoEcho("drop shi zi");
		Battle.bBattle = false;
		EnableTimer("BattlePerform", false);
		EnableGroup("nobattle", true);
		Battle.bQiankun = false;
		Battle.nPower = 0;
		if Way.bStoped == true then
			Execute("wkc");
		end
	end
end

Battle.TryHeal = function()
	local nHpMax = GetStatusHPMax();
	local nHpUp = GetStatusHPUp();
	local nJlMax = GetStatusJLMax();
	local nJlUp = GetStatusJLUp();
	local nHp = GetStatusHP();
	local bHeal = false;
	if nHpUp < nHpMax/5 then
		--SendNoEcho("gf bosss");
		bHeal = true;
	elseif nHpUp < nHpMax/2 then
		if GetVariable("Q_name") ~= "破阵" then
			SendNoEcho("yun lifeheal " .. Common.id);
			bHeal = true;
		end
	elseif nHpUp < nHpMax then
		local nNum = math.ceil((nHpMax - nHpUp)/400);
		if nNum > 8 then nNum = 8; end
		for i = 1, nNum do
			bHeal = true;
			SendNoEcho("yun heal");
		end
	end
	if nJlUp < nJlMax then
	--[[
		local nNum = math.ceil((nJlMax - nJlUp)/400);
		for i = 1, nNum do
	]]--有Busy
			SendNoEcho("yun inspire");
			bHeal = true;
		--end
	end
	if Battle.bBattle == true then
		Common.InstanceRun(Battle.SetHpEcho, 5);
	elseif Battle.strExitBack ~= "" then
		if nHpUp >= nHpMax and nHpUp == nHp then
			Battle.EscapseBack();
		end
	end
	if nHp < nHpMax or GetStatusJL() < nJlMax then
		SendNoEcho("hpbrief");
	end
	return nHp >= nHpMax;
end

Battle.SetHpEcho = function()
	SendNoEcho("hp");
end

Battle.Hpbrief = function()
	SendNoEcho("hpbrief");
end