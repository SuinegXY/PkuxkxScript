-------------------------------------
--              打坐               --
-------------------------------------

Dazuo = {};
Dazuo.ActionDazuo = function()
	local nDazuo = GetStatusHP()
	nDazuo = nDazuo * 0.9;
	nDazuo = nDazuo - nDazuo%10;
	if nDazuo < 500 then
		SendNoEcho("yun recover");
		DoAfterSpecial(1, "Dazuo.ActionDazuo()", 12);
	else
		local nNeili = GetStatusNeiliMax()*2 - GetStatusNeili();
		nNeili = nNeili - nNeili%10 + 10;
		if nNeili < nDazuo then
			nDazuo = nNeili;
		end
		if nDazuo < 10 then
			nDazuo = 10;
		end
		SendNoEcho("dazuo " .. nDazuo);
	end
end

Dazuo.ActionNeiliFull = function()
	local nDazuo = GetStatusHP();
	nDazuo = nDazuo * 0.9;
	nDazuo = nDazuo - nDazuo%10;
	if nDazuo > 20 then
		local nNeili = GetStatusNeiliMax() - GetStatusNeili();
		nNeili = nNeili - nNeili%10;
		if nNeili < nDazuo then
			nDazuo = nNeili;
		end
		if nDazuo < 10 then
			nDazuo = 10;
		end
		SendNoEcho("dazuo " .. nDazuo);
	end
end

Dazuo.ActionNeiliDouble = function()
	local nDazuo = GetStatusHP();
	nDazuo = nDazuo * 0.9;
	nDazuo = nDazuo - nDazuo%10;
	if nDazuo > 20 then
		local nNeili = GetStatusNeiliMax()*2 - GetStatusNeili();
		nNeili = nNeili - nNeili%10;
		if nNeili < nDazuo then
			nDazuo = nNeili;
		end
		if nDazuo < 10 then
			nDazuo = 10;
		end
		SendNoEcho("dazuo " .. nDazuo);
	end
end

Dazuo.nLJ = 0;
Dazuo.ActionTuna = function()
	local nDazuo = GetStatusJL();
	nDazuo = nDazuo * 0.9;
	nDazuo = nDazuo - nDazuo%10;
	if nDazuo < 5000 then
--		SendNoEcho("sleep");
		Common.RestoreLJ();
		DoAfterSpecial(1, "Dazuo.ActionTuna()", 12);
	else
		local nNeili = GetStatusJingliMax()*2 - GetStatusJingli();
		nNeili = nNeili - nNeili%10 + 10;
		if nNeili < nDazuo then
			nDazuo = nNeili;
		end
		if nDazuo < 10 then
			nDazuo = 10;
		end
		SendNoEcho("tuna " .. nDazuo)
	end
end



-------------------------------------
--              通脉               --
-------------------------------------

Common.CreateAlias("VEIN_ALIAS", "^VEIN$", 'EnableGroup("vein", true);Dazuo.FindStart();', 12, "triggers");
Common.CreateAlias("VEIN_ALIAS_OVER", "^VEINS$", 'Execute("EGS vein");', 12, "triggers");
Common.CreateTrigger("VEIN_DAZUO", "^你现在内力不足，强行通脉，有害无益。$", 'SendNoEcho("yun recover");SendNoEcho("dazuo max")', 12, "vein", 0);
Common.CreateTrigger("VEIN_THROUGH", "^你已将内力纳入\\S+穴。$", 'Dazuo.VeinAction()', 12, "vein", 0);
Common.CreateTrigger("VEIN_CONTINUE", "^你运功完毕，深深吸了口气，站了起来。$", 'Dazuo.VeinAction()', 12, "vein", 0);
Common.CreateTrigger("VEIN_FIND1", "^\\s*(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s*$", 'Dazuo.VeinFind("%2", %3, "%1")', 12, "vein", 0, 0, nil, 0, 96);
Common.CreateTrigger("VEIN_FIND2", "^\\s*(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s*$", 'Dazuo.VeinFind("%2", %3, "%1");Dazuo.VeinFind("%5", %6, "%4");', 12, "vein", 0, 0, nil, 0, 95);
Common.CreateTrigger("VEIN_FIND3", "^\\s*(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s*$", 'Dazuo.VeinFind("%2", %3, "%1");Dazuo.VeinFind("%5", %6, "%4");Dazuo.VeinFind("%8", %9, "%7");', 12, "vein", 0, 0, nil, 0, 94);
Common.CreateTrigger("VEIN_FIND4", "^\\s*(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s*$", 'Dazuo.VeinFind("%2", %3, "%1");Dazuo.VeinFind("%5", %6, "%4");Dazuo.VeinFind("%8", %9, "%7");Dazuo.VeinFind("%<11>", %<12>, "%<10>");', 12, "vein", 0, 0, nil, 0, 94);
Common.CreateTrigger("VEIN_FIND5", "^\\s*(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s*$", 'Dazuo.VeinFind("%2", %3, "%1");Dazuo.VeinFind("%5", %6, "%4");Dazuo.VeinFind("%8", %9, "%7");Dazuo.VeinFind("%<11>", %<12>, "%<10>");Dazuo.VeinFind("%<14>", %<15>, "%<13>");', 12, "vein", 0, 0, nil, 0, 94);
Common.CreateTrigger("VEIN_FIND", "^你\\S+上\\S+穴已经充盈，你可以尝试下一个穴道\\S+穴了。$", 'Dazuo.FindStart()', 12, "vein", 0);
Common.CreateTrigger("VEIN_ACTION", "^     ○：未尝试穴道，◎：正在贯通穴道，⊕：受损穴道，●：已贯通穴道。金色为经脉全部贯通。     $", 'Dazuo.VeinAction()', 12, "vein", 0);
Common.CreateTrigger("VEIN_ACTION2", "^你有处穴道，内力导入，竟似泥牛入海。$", 'Dazuo.EnforceStart()', 12, "vein", 0);
Common.CreateTrigger("VEIN_OVER", "^过多尝试通脉次数，有害无益。今天就到此为止吧。*$|^你的\\S+已经贯通成功了。$", 'Dazuo.Over()', 12, "vein", 0);
Common.CreateTrigger("VEIN_Detail", "^ +单次冲穴.+秒|通脉预计.+|当日剩余(.*)次 *$", 'Dazuo.strDetail = "%1"', 12, "common", 1);

Dazuo.strDetail = "1000";
Dazuo.nDigit = 0;
Dazuo.bFind = false;
Dazuo.tName = {};
Dazuo.tBool = {};
Dazuo.bEnforce = false;
Dazuo.bSunxu = 1;
Dazuo.VeinAction = function()
	if Dazuo.bEnforce == false then
		EatAndDrink();
		--Note(GetVariable("VEIN_NAME"));
		Send("vein through " .. GetVariable("VEIN_NAME"));
		DoAfterSpecial(20, 'SendNoEcho("vein through " .. GetVariable("VEIN_NAME"))', 12);
	else
		for i = 1, #Dazuo.tName do
			if Dazuo.tBool[i] == nil and Dazuo.tName[i] ~= nil then
				Send("vein enforce " .. Dazuo.tName[i]);
				Dazuo.bEnforce = false;
				SendNoEcho("vein overall");
				return;
			end
		end
	end
end

Dazuo.FindStart = function()
	if GetVariable("VEIN_TYPE") == "1" then
		Dazuo.bSunxu = -1;
	end
	Dazuo.bFind = false;
	Dazuo.nDigit = 500*(1+Dazuo.bSunxu);
	Dazuo.tName = {};
	Dazuo.tBool = {};
	Dazuo.bEnforce = false;
	SendNoEcho("vein overall");
	SendNoEcho("vein detail");
	Execute("hps on");
end

Dazuo.EnforceStart = function()
	Dazuo.tBool = {};
	Dazuo.bEnforce = true;
	SendNoEcho("vein overall");
end

Dazuo.VeinFind = function(strName, nNum, strType)
	--if Dazuo.bFind == true then return; end
	--Dazuo.bFind = true;
	if Dazuo.bEnforce == false then
		Dazuo.tName[nNum] = strName;
		if strType ~= "○" and strType ~= "◎" then return; end
		--Note("V:" .. Dazuo.nDigit .. "/" .. nNum .. ":" .. strName);
		if ( Dazuo.nDigit > nNum*Dazuo.bSunxu ) then
			Dazuo.nDigit = nNum*Dazuo.bSunxu;
			SetVariable("VEIN_NAME", strName);
		end
	else
		if Dazuo.tBool[nNum] == nil then
			Dazuo.tBool[nNum] = 1;
		end
	end
end

Dazuo.Over = function()
	Execute("hps off");
	Execute("EGS vein");
	Execute(GetVariable("VEIN_OVER_DO"));
end


Canwu = {};
DeleteTimer("canwu_check");
Canwu.Next = function()
	Send("canwu");
	Common.CreateTimer("canwu_check", 0, 10, "Canwu.OverCheck", true, "canwu");
end
Canwu.OverCheck = function()
	Execute("VEIN;EGS canwu");
end

-------------------------------------
--              拜祭               --
-------------------------------------

Baiji = {}
Baiji.bCan = true;
Baiji.bOnce = true;
Baiji.strTimerName = "timer_baiji";

Common.CreateAlias("alias_bj", "^BJ(.*)$", 'Baiji.Start("%1")', 12, "triggers");
Common.CreateTrigger("bj_restore", "^你的精不够，无法继续拜祭。$", 'Baiji.Restore()', 12, "baiji", 0, true);
Common.CreateTrigger("bj_sleep", "^你一觉醒来，精神抖擞地活动了几下手脚。$", 'Baiji.Sleep()', 12, "baiji", 0, true);
Common.CreateTrigger("bj_action", "^你对着孔子像拜祭之后，突然福至心灵，对论语中的道理有所领悟。$", 'Baiji.Action()', 12, "baiji", 0, true);
DeleteTimer(Baiji.strTimerName);
EnableGroup("baiji", false);

Baiji.Start = function(strParam)
	if strParam == "A" then	
		Baiji.bCan = true;
		Baiji.bOnce = true;
		EnableGroup("baiji", true);
		Common.CreateTimer(Baiji.strTimerName, 0, 0.5, "Baiji.Action");
	elseif strParam == "B" then		
		DeleteTimer(Baiji.strTimerName);
		EnableGroup("baiji", false);
	end
end

Baiji.Restore = function()
	if Baiji.bOnce then
		Baiji.bOnce = false;
		SendNoEcho("yun regenerate");
		DoAfterSpecial(1, 'SendNoEcho("baiji xiang")', 12);
		DoAfterSpecial(1, 'Baiji.bOnce = true', 12);
	end
end

Baiji.Action = function()
	if Baiji.bCan then
		SendNoEcho("baiji xiang");
		Baiji.Check();
	end
end

Baiji.Check = function()
	if GetStatusNeili() < 50 then
		Baiji.bCan = false;
		DoAfterSpecial(1, 'Execute("out;out;e;do 8 s;e;e;u;u;u;enter;enter;enter;sleep;sleep;sleep;sleep")', 12);
	end
end

Baiji.Sleep = function()
	Execute("out;out;out;out;d;d;d;d;d;w;do 8 n;w;enter;enter;enter");
	DoAfterSpecial(2, "EatAndDrink()", 12);
	DoAfter(2, "drink jiang");
	DoAfterSpecial(2, "Baiji.bCan = true", 12);
end