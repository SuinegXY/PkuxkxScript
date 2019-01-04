--------------------------------------
--             远程控制             --
--------------------------------------

Remote = {};
Remote.strListener = "";
Remote.strID = "";
Remote.bQQ = false;
Remote.strAnswer = "";

Common.CreateTrigger("Remote_Status", "^\\S+\\((\\S+)\\)告诉你：S$", 'Remote.Status("%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_Location", "^\\S+\\((\\S+)\\)告诉你：L$", 'Remote.Location("%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_LogA", "^\\S+\\((\\S+)\\)告诉你：LA$", 'Remote.LogA("%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_LogB", "^\\S+\\((\\S+)\\)告诉你：LB$", 'Remote.LogB("%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_Execute", "^\\S+\\((\\S+)\\)告诉你：E (.*)$", 'Remote.Execute("%1", "%2")', 12, "remote", 1);
Common.CreateTrigger("Remote_Vein", "^\\S+\\((\\S+)\\)告诉你：V$", 'Remote.Vein("%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_FullmeListen", "^\\S+\\((\\S+)\\)告诉你：F$", 'Remote.FullmeListen("%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_FullmeAnswer", "^\\S+\\((\\S+)\\)告诉你：F (.*)$", 'Remote.FullmeAnswer("%1", "%2")', 12, "remote", 1);
Common.CreateTrigger("Remote_FullmeLookAnswer", "^　机器人检查　(.*)$", 'Remote.FullmeLook("%1")', 12, "remote", 1);

Common.CreateTrigger("Remote_Status1", "^【北侠QQ群】古墓新人-休莱：(\\S+) S$", 'Remote.Status("qqSAWS", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_Location1", "^【北侠QQ群】古墓新人-休莱：(\\S+) L$", 'Remote.Location("qqSAWS", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_LogA1", "^【北侠QQ群】古墓新人-休莱：(\\S+) LA$", 'Remote.LogA("qqSAWS", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_LogB1", "^【北侠QQ群】古墓新人-休莱：(\\S+) LB$", 'Remote.LogB("qqSAWS", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_Execute1", "【北侠QQ群】古墓新人-休莱：(\\S+) E (.*)$", 'Remote.Execute("qqSAWS", "%2", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_Vein1", "^【北侠QQ群】古墓新人-休莱：(\\S+) V$", 'Remote.Vein("qqSAWS", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_FullmeListen1", "^【北侠QQ群】古墓新人-休莱：(\\S+) F$", 'Remote.FullmeListen("qqSAWS", "%1")', 12, "remote", 1);
Common.CreateTrigger("Remote_FullmeAnswer1", "^【北侠QQ群】古墓新人-休莱：(\\S+) F (.*)$", 'Remote.FullmeAnswer("qqSAWS", "%2", "%1")', 12, "remote", 1);

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
	SendNoEcho("tell " .. strID .. " 你的本次恶意远程控制行为已记录在按,请不要再犯");
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
		SendNoEcho("tell " .. strID .. " 精神:" .. GetStatusJL() .. "/" .. GetStatusJLUp() .. "/" .. GetStatusJLMax());
		SendNoEcho("tell " .. strID .. " 气血:" .. GetStatusHP() .. "/" .. GetStatusHPUp() .. "/" .. GetStatusHPMax());
		SendNoEcho("tell " .. strID .. " 内力:" .. GetStatusNeili() .. "/" .. GetStatusNeiliMax());
		SendNoEcho("tell " .. strID .. " 真气:" .. GetStatusPower() .. "/" .. GetStatusPowerMax());
		SendNoEcho("tell " .. strID .. " 食物饮水:" .. GetStatusFood() .. "/" .. GetStatusWater());
		SendNoEcho("tell " .. strID .. " 潜能:" .. GetStatusPot());
	elseif Remote.QQCheck(strID) and Common.id == strAnswer then
		SendNoEcho("qq " .. " 精神:" .. GetStatusJL() .. "/" .. GetStatusJLUp() .. "/" .. GetStatusJLMax());
		SendNoEcho("qq " .. " 气血:" .. GetStatusHP() .. "/" .. GetStatusHPUp() .. "/" .. GetStatusHPMax());
		SendNoEcho("qq " .. " 内力:" .. GetStatusNeili() .. "/" .. GetStatusNeiliMax());
		SendNoEcho("qq " .. " 真气:" .. GetStatusPower() .. "/" .. GetStatusPowerMax());
		SendNoEcho("qq " .. " 食物饮水:" .. GetStatusFood() .. "/" .. GetStatusWater());
		SendNoEcho("qq " .. " 潜能:" .. GetStatusPot());
	end
end

Remote.Location = function(strID, strAnswer)
	if Remote.Auth(strID) then
		Way.LocationArea();
	end
	if Remote.QQCheck(strID) and Common.id == strAnswer then
		Way.LocationArea();
		DoAfterSpecial(1, 'SendNoEcho("qq " .. " 当前位置:" .. Way.strArea .. " 的 " .. Way.strPlace)', 12);
	else
		DoAfterSpecial(1, 'SendNoEcho("tell " .. Remote.strID .. " 当前位置:" .. Way.strArea .. " 的 " .. Way.strPlace)', 12);
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
		DoAfterSpecial(1, 'SendNoEcho("tell " .. Remote.strID .. " 通脉剩余次数:" .. Dazuo.strDetail)', 12);
	elseif Remote.QQCheck(strID) and Common.id == strAnswer then
		SendNoEcho("vein detail");
		DoAfterSpecial(1, 'SendNoEcho("qq " .. " 通脉剩余次数:" .. Dazuo.strDetail)', 12);
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
		SendNoEcho("qq " .. " Fullme地址:" .. strUrl);
	elseif Remote.strListener ~= "" then
		SendNoEcho("tell " .. Remote.strListener .. " Fullme地址:" .. strUrl);
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
		Send("qq " .. " Fullme状态:" .. strAnswer);
	elseif Remote.strListener ~= "" then
		SendNoEcho("tell " .. Remote.strListener .. " Fullme状态:" .. strAnswer);
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
	if not string.find(strContent, Remote.strListener) and not string.find(strContent, "【北侠QQ群】") and not string.find(strContent, "#") then
		if Remote.bQQ then
			SendNoEcho("qq " .. " Log状态:" .. strContent);
		else
			SendNoEcho("tell " .. Remote.strListener .. " Log状态:" .. strContent);
		end
	end
end