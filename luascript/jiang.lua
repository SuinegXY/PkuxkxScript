require "../MyCode/common"
require "../MyCode/answer"

GiveJiang = GiveJiang or {};
GiveJiang.tName = {};
GiveJiang.nDigit = 0;
GiveJiang.tSave = {};
GiveJiang.tNotGumu = {};
GiveJiang.strName = "";
GiveJiang.strID = "";

GiveJiang.Auth = function(strID)
	if strID == "suinegdls" or strID == "findjiang" or strID == "suineg" or strID == "suinegy" or strID == "jyyx" then
		return true;
	end
	if strID == "cyhcsr" then
		SendNoEcho("tell " .. strID .. " 请不要在这里打坐刷屏");
		return false;
	end
	--SendNoEcho("tell " .. strID .. " 收88级9臂力及以上的朱雀护腕,不在乎几孔");
	--return false;
	return ture;
end

GiveJiang.Delay = function(strID)
	if strID == "ldc" or strID == "ddll" or strID == "oasis" then
		return true;
	end
	return false;
end

Common.CreateAlias("jiang_fix", "^J (\\S+)$", 'GiveJiang.Fix(%1)', 12, "jiang");
Common.CreateTrigger("jiang_add", "^你捡起一瓶玉蜂浆。$", 'GiveJiang.Add()', 12, "jiang", 1);
Common.CreateTrigger("jiang_ask", "^(.*)向你打听有关『.*』的消息。$", 'SendNoEcho("say %1,我可不是NPC哦,要浆就tell我浆")', 12, "jiang", 1);
Common.CreateTrigger("jiang_tell", "^(\\S+)\\((\\S+)\\)告诉你：浆$", 'GiveJiang.Ask("%1", "%2")', 12, "jiang", 1);
Common.CreateTrigger("jiang_tell2", "^(\\S+)\\((\\S+)\\)告诉你：比例$", 'GiveJiang.Machine("%2")', 12, "jiang", 1);
Common.CreateTrigger("jiang_reduce", "^你给\\S+一瓶玉蜂浆。$", 'GiveJiang.Reduce()', 12, "jiang", 1);

GiveJiang.Machine = function(strID)
	if GiveJiang.Auth(strID) == false then return; end
	local strValue = GetVariable("Q_misc2");
	if strValue == nil or strValue == "" then strValue = "无资料" end;
	SendNoEcho("tell " .. strID .. " 目前司天监浑天仪对换比例为:" .. strValue);
end

GiveJiang.Ask = function(strName, strID)
	if GiveJiang.Auth(strID) == false then return; end
	--Note(strName .. " " .. strID);
	--if strContent == "浆" then
		if Common.TableIndex(GiveJiang.tName, strID) == nil then
			GiveJiang.strName = strName;
			GiveJiang.strID = strID;
			if GiveJiang.tSave[strID] == nil and GiveJiang.tNotGumu[strID] == nil then
				SendNoEcho("l " .. strID);
				SendNoEcho("tell " .. strID .. " 确认门派中");
				Common.CreateTrigger("jiang_look", "^\\S{2}是你的(\\S+)。$", 'GiveJiang.Look("%1")', 12, "jiang", 1);
				Common.CreateTimer("jiang_sure", 0, 1, "GiveJiang.Sure", true);
			else
				local bNotGumu = nil;
				GiveJiang.Give(bNotGumu);
			end
		else
			SendNoEcho("tell " .. strID .. " 已经给过你喽,因为数量有限,请过段时间再来");
		end
	--else
	--	SendNoEcho("tell " .. strID .. " 要浆请tell findjiang 浆");
	--end
end

GiveJiang.Look = function(strCall)
	GiveJiang.tSave[GiveJiang.strID] = strCall;
end

GiveJiang.Sure = function()
	DeleteTrigger("jiang_look");
	if GiveJiang.tSave[GiveJiang.strID] then
		GiveJiang.Give();
	else
		if GiveJiang.tNotGumu[GiveJiang.strID] == nil then
			GiveJiang.tSave[GiveJiang.strID] = "异派人";
		end
		GiveJiang.Give(true);
		--SendNoEcho("tell " .. GiveJiang.strID .. " 对不起,浆只有同门可使用,故不提供给别派人士");
	end
end

GiveJiang.Give = function(bNotGumu)
	if Common.TableIndex(GiveJiang.tName, GiveJiang.strID) == nil then
		if GiveJiang.nDigit > 0 then
			Common.TableAdd(GiveJiang.tName, GiveJiang.strID);
			SendNoEcho("give " .. GiveJiang.strID .. " 1 jiang");
			if bNotGumu ~= nil or GiveJiang.Delay(GiveJiang.strID) then
				Common.CreateTimerFunc("jiang_" .. GiveJiang.strID, 30, 0, 'GiveJiang.Time("' .. GiveJiang.strID .. '")', true);
				SendNoEcho("tell " .. GiveJiang.strID .. " " .. GiveJiang.tSave[GiveJiang.strID] .. ",这是您的浆,非古墓门派有30分钟CD");
			else
				Common.CreateTimerFunc("jiang_" .. GiveJiang.strID, 0, 1, 'GiveJiang.Time("' .. GiveJiang.strID .. '")', true);
				SendNoEcho("tell " .. GiveJiang.strID .. " " .. GiveJiang.tSave[GiveJiang.strID] .. ",这是您的浆,注意保命哦,最好领两瓶在身,多了防止死,少了防止不够,喝浆CD5分钟");
			end
		else
			SendNoEcho("tell " .. GiveJiang.strID .. " 现在没浆了，请过会再来吧，此次问不会占用CD");
		end
	else
		SendNoEcho("tell " .. GiveJiang.strID .. " 已经给过你喽,因为数量有限,请半个小时后再来");
	end
end

GiveJiang.Fix = function(nNum)
	Common.CreateTimer("jiang_chat", 59, 1, "GiveJiang.Chat");
	GiveJiang.nDigit = nNum;
	Note("say 库存浆 " .. GiveJiang.nDigit .. "瓶");
end

GiveJiang.Add = function()
	GiveJiang.nDigit = GiveJiang.nDigit + 1;
	--if GiveJiang.nDigit > 3 then GiveJiang.nDigit = 3; end
	--GiveJiang.Chat();
end

GiveJiang.Reduce = function()
	GiveJiang.nDigit = GiveJiang.nDigit - 1;
	SendNoEcho("say 库存浆 " .. GiveJiang.nDigit .. "瓶");
	--GiveJiang.Chat();
end

GiveJiang.Time = function(strID)
	Common.TableDel(GiveJiang.tName, strID);
end

GiveJiang.Chat = function()
	SendNoEcho("chat 古墓侧室提供玉蜂浆,现库存 " .. GiveJiang.nDigit .. " 瓶,目前浑天仪比例:" .. GetVariable("Q_misc2") .. "(可tell我比例查询)");
end

Note("!!!加载完成!!!");