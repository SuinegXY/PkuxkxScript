--------------------------------------
--             Զ�̿���             --
--------------------------------------

Remote = {};
Remote.strListener = "";
Remote.strID = "";
Remote.bQQ = false;
Remote.strAnswer = "";

Common.CreateTrigger("Remote_Status", "^\\S+\\((\\S+)\\)�����㣺S$", 'Remote.Status("%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_Location", "^\\S+\\((\\S+)\\)�����㣺L$", 'Remote.Location("%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_LogA", "^\\S+\\((\\S+)\\)�����㣺LA$", 'Remote.LogA("%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_LogB", "^\\S+\\((\\S+)\\)�����㣺LB$", 'Remote.LogB("%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_Execute", "^\\S+\\((\\S+)\\)�����㣺E (.*)$", 'Remote.Execute("%1", "%2")', 12, "remote", 1);
Common.CreateTrigger("Remote_Vein", "^\\S+\\((\\S+)\\)�����㣺V$", 'Remote.Vein("%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_FullmeListen", "^\\S+\\((\\S+)\\)�����㣺F$", 'Remote.FullmeListen("%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_FullmeAnswer", "^\\S+\\((\\S+)\\)�����㣺F (.*)$", 'Remote.FullmeAnswer("%1", "%2")', 12, "remote", 1);
Common.CreateTrigger("Remote_FullmeLookAnswer", "^�������˼�顡(.*)$", 'Remote.FullmeLook("%1")', 12, "remote", 1);

Common.CreateTrigger("Remote_Status1", "^������QQȺ����Ĺ����-������(\\S+) S$", 'Remote.Status("qqSAWS", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_Location1", "^������QQȺ����Ĺ����-������(\\S+) L$", 'Remote.Location("qqSAWS", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_LogA1", "^������QQȺ����Ĺ����-������(\\S+) LA$", 'Remote.LogA("qqSAWS", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_LogB1", "^������QQȺ����Ĺ����-������(\\S+) LB$", 'Remote.LogB("qqSAWS", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_Execute1", "������QQȺ����Ĺ����-������(\\S+) E (.*)$", 'Remote.Execute("qqSAWS", "%2", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_Vein1", "^������QQȺ����Ĺ����-������(\\S+) V$", 'Remote.Vein("qqSAWS", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_FullmeListen1", "^������QQȺ����Ĺ����-������(\\S+) F$", 'Remote.FullmeListen("qqSAWS", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_FullmeAnswer1", "^������QQȺ����Ĺ����-������(\\S+) F (.*)$", 'Remote.FullmeAnswer("qqSAWS", "%2", "%1")', 12, "remote", 1);

DeleteTrigger("Remote_Fullme");
DeleteTrigger("Remote_Log");

if Common.id == "suineg" then
	EnableGroup("remote", false);
else
	EnableGroup("remote", true);
end

Remote.Auth = function(strID)
	if strID == "suinegdls" or strID == "findjiang" or strID == "suineg" then
		Remote.strID = strID;
		return true;
	end
	SendNoEcho("tell " .. strID .. " ��ı��ζ���Զ�̿�����Ϊ�Ѽ�¼�ڰ�,�벻Ҫ�ٷ�");
	return false;
end

Remote.QQCheck = function(strID)
	if strID == "qqSAWS" then
		Remote.bQQ = true;
		return true;
	end
	return false;
end

Remote.Status = function(strID, strAnswer)
	if Remote.Auth(strID) then
		SendNoEcho("tell " .. strID .. " ����:" .. GetStatusJL() .. "/" .. GetStatusJLUp() .. "/" .. GetStatusJLMax());
		SendNoEcho("tell " .. strID .. " ��Ѫ:" .. GetStatusHP() .. "/" .. GetStatusHPUp() .. "/" .. GetStatusHPMax());
		SendNoEcho("tell " .. strID .. " ����:" .. GetStatusNeili() .. "/" .. GetStatusNeiliMax());
		SendNoEcho("tell " .. strID .. " ����:" .. GetStatusPower() .. "/" .. GetStatusPowerMax());
		SendNoEcho("tell " .. strID .. " ʳ����ˮ:" .. GetStatusFood() .. "/" .. GetStatusWater());
		SendNoEcho("tell " .. strID .. " Ǳ��:" .. GetStatusPot());
	elseif Remote.QQCheck(strID) and Common.id == strAnswer then
		SendNoEcho("qq " .. " ����:" .. GetStatusJL() .. "/" .. GetStatusJLUp() .. "/" .. GetStatusJLMax());
		SendNoEcho("qq " .. " ��Ѫ:" .. GetStatusHP() .. "/" .. GetStatusHPUp() .. "/" .. GetStatusHPMax());
		SendNoEcho("qq " .. " ����:" .. GetStatusNeili() .. "/" .. GetStatusNeiliMax());
		SendNoEcho("qq " .. " ����:" .. GetStatusPower() .. "/" .. GetStatusPowerMax());
		SendNoEcho("qq " .. " ʳ����ˮ:" .. GetStatusFood() .. "/" .. GetStatusWater());
		SendNoEcho("qq " .. " Ǳ��:" .. GetStatusPot());
	end
end

Remote.Location = function(strID, strAnswer)
	if Remote.Auth(strID) then
		Way.LocationArea();
	end
	if Remote.QQCheck(strID) and Common.id == strAnswer then
		Way.LocationArea();
		DoAfterSpecial(1, 'SendNoEcho("qq " .. " ��ǰλ��:" .. Way.strArea .. " �� " .. Way.strPlace)', 12);
	else
		DoAfterSpecial(1, 'SendNoEcho("tell " .. Remote.strID .. " ��ǰλ��:" .. Way.strArea .. " �� " .. Way.strPlace)', 12);
	end
end

Remote.Execute = function(strID, strAction, strAnswer)
	if Remote.Auth(strID) or (Remote.QQCheck(strID) and Common.id == strAnswer) then
		Remote.strAnswer = strAnswer;
		Execute(strAction);
	end
end

Remote.Vein = function(strID, strAnswer)
	if Remote.Auth(strID) then
		SendNoEcho("vein detail");
		DoAfterSpecial(1, 'SendNoEcho("tell " .. Remote.strID .. " ͨ��ʣ�����:" .. Dazuo.strDetail)', 12);
	elseif Remote.QQCheck(strID) and Common.id == strAnswer then
		SendNoEcho("vein detail");
		DoAfterSpecial(1, 'SendNoEcho("qq " .. " ͨ��ʣ�����:" .. Dazuo.strDetail)', 12);
	end
end

Remote.FullmeListen = function(strID, strAnswer)
	if Remote.Auth(strID) or (Remote.QQCheck(strID) and Common.id == strAnswer) then
		Remote.strListener = strID;
		Remote.strAnswer = strAnswer;
		SendNoEcho("status_me");
		Common.CreateTrigger("Remote_Fullme", "^http://pkuxkx.net/antirobot/.+$", 'Remote.Fullme("%0")', 12, "remote", 1);
	end
end

Remote.Fullme = function(strUrl)
	if Remote.bQQ and Common.id == Remote.strAnswer then
		SendNoEcho("qq " .. " Fullme��ַ:" .. strUrl);
	elseif Remote.strListener ~= "" then
		SendNoEcho("tell " .. Remote.strListener .. " Fullme��ַ:" .. strUrl);
	end
end

Remote.FullmeAnswer = function(strID, strAnswer, strAnswerer)
	if Remote.Auth(strID) then
		Execute("halt;fullme " .. strAnswer);
	elseif Remote.QQCheck(strID) and Common.id == strAnswerer  then
		Execute("halt;fullme " .. strAnswer);
	end
end

Remote.FullmeLook = function(strAnswer)
	if Remote.bQQ and Common.id == Remote.strAnswer then
		Send("qq " .. " Fullme״̬:" .. strAnswer);
	elseif Remote.strListener ~= "" then
		SendNoEcho("tell " .. Remote.strListener .. " Fullme״̬:" .. strAnswer);
	end
end

Remote.LogA = function(strID, strAnswer)
	if Remote.bQQ and Common.id == strAnswer then
		Common.CreateTrigger("Remote_Log", "^(.*)$", 'Remote.Log("%1")', 12, "remote", 1);
	elseif Remote.Auth(strID) then
		Common.CreateTrigger("Remote_Log", "^(.*)$", 'Remote.Log("%1")', 12, "remote", 1);
	end
end

Remote.LogB = function(strID, strAnswer)
	if Remote.bQQ and Common.id == strAnswer then
		DeleteTrigger("Remote_Log");
	elseif Remote.Auth(strID) or Remote.Auth(strID) then
		DeleteTrigger("Remote_Log");
	end
end

Remote.Log = function(strContent)
	if not string.find(strContent, Remote.strListener) and not string.find(strContent, "������QQȺ��") and not string.find(strContent, "#") then
		if Remote.bQQ then
			SendNoEcho("qq " .. " Log״̬:" .. strContent);
		else
			SendNoEcho("tell " .. Remote.strListener .. " Log״̬:" .. strContent);
		end
	end
end