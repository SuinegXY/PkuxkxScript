-------------------------------------
--              ����               --
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
--              ͨ��               --
-------------------------------------

Common.CreateAlias("VEIN_ALIAS", "^VEIN$", 'EnableGroup("vein", true);Dazuo.FindStart();', 12, "triggers");
Common.CreateAlias("VEIN_ALIAS_OVER", "^VEINS$", 'Execute("EGS vein");', 12, "triggers");
Common.CreateTrigger("VEIN_DAZUO", "^�������������㣬ǿ��ͨ�����к����档$", 'SendNoEcho("yun recover");SendNoEcho("dazuo max")', 12, "vein", 0);
Common.CreateTrigger("VEIN_THROUGH", "^���ѽ���������\\S+Ѩ��$", 'Dazuo.VeinAction()', 12, "vein", 0);
Common.CreateTrigger("VEIN_CONTINUE", "^���˹���ϣ��������˿�����վ��������$", 'Dazuo.VeinAction()', 12, "vein", 0);
Common.CreateTrigger("VEIN_FIND1", "^\\s*(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s*$", 'Dazuo.VeinFind("%2", %3, "%1")', 12, "vein", 0, 0, nil, 0, 96);
Common.CreateTrigger("VEIN_FIND2", "^\\s*(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s*$", 'Dazuo.VeinFind("%2", %3, "%1");Dazuo.VeinFind("%5", %6, "%4");', 12, "vein", 0, 0, nil, 0, 95);
Common.CreateTrigger("VEIN_FIND3", "^\\s*(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s*$", 'Dazuo.VeinFind("%2", %3, "%1");Dazuo.VeinFind("%5", %6, "%4");Dazuo.VeinFind("%8", %9, "%7");', 12, "vein", 0, 0, nil, 0, 94);
Common.CreateTrigger("VEIN_FIND4", "^\\s*(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s*$", 'Dazuo.VeinFind("%2", %3, "%1");Dazuo.VeinFind("%5", %6, "%4");Dazuo.VeinFind("%8", %9, "%7");Dazuo.VeinFind("%<11>", %<12>, "%<10>");', 12, "vein", 0, 0, nil, 0, 94);
Common.CreateTrigger("VEIN_FIND5", "^\\s*(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s+(\\S{2})(\\S+?)\\[(\\S+?)\\]\\s*$", 'Dazuo.VeinFind("%2", %3, "%1");Dazuo.VeinFind("%5", %6, "%4");Dazuo.VeinFind("%8", %9, "%7");Dazuo.VeinFind("%<11>", %<12>, "%<10>");Dazuo.VeinFind("%<14>", %<15>, "%<13>");', 12, "vein", 0, 0, nil, 0, 94);
Common.CreateTrigger("VEIN_FIND", "^��\\S+��\\S+Ѩ�Ѿ���ӯ������Գ�����һ��Ѩ��\\S+Ѩ�ˡ�$", 'Dazuo.FindStart()', 12, "vein", 0);
Common.CreateTrigger("VEIN_ACTION", "^     ��δ����Ѩ���������ڹ�ͨѨ������������Ѩ�������ѹ�ͨѨ������ɫΪ����ȫ����ͨ��     $", 'Dazuo.VeinAction()', 12, "vein", 0);
Common.CreateTrigger("VEIN_ACTION2", "^���д�Ѩ�����������룬������ţ�뺣��$", 'Dazuo.EnforceStart()', 12, "vein", 0);
Common.CreateTrigger("VEIN_OVER", "^���ೢ��ͨ���������к����档����͵���Ϊֹ�ɡ�*$|^���\\S+�Ѿ���ͨ�ɹ��ˡ�$", 'Dazuo.Over()', 12, "vein", 0);
Common.CreateTrigger("VEIN_Detail", "^ +���γ�Ѩ.+��|ͨ��Ԥ��.+|����ʣ��(.*)�� *$", 'Dazuo.strDetail = "%1"', 12, "common", 1);

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
		if strType ~= "��" and strType ~= "��" then return; end
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
--              �ݼ�               --
-------------------------------------

Baiji = {}
Baiji.bCan = true;
Baiji.bOnce = true;
Baiji.strTimerName = "timer_baiji";

Common.CreateAlias("alias_bj", "^BJ(.*)$", 'Baiji.Start("%1")', 12, "triggers");
Common.CreateTrigger("bj_restore", "^��ľ��������޷������ݼ���$", 'Baiji.Restore()', 12, "baiji", 0, true);
Common.CreateTrigger("bj_sleep", "^��һ�������������ӵػ�˼����ֽš�$", 'Baiji.Sleep()', 12, "baiji", 0, true);
Common.CreateTrigger("bj_action", "^����ſ�����ݼ�֮��ͻȻ�������飬�������еĵ�����������$", 'Baiji.Action()', 12, "baiji", 0, true);
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