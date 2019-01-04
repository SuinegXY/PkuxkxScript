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
		SendNoEcho("tell " .. strID .. " �벻Ҫ���������ˢ��");
		return false;
	end
	--SendNoEcho("tell " .. strID .. " ��88��9���������ϵ���ȸ����,���ں�����");
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
Common.CreateTrigger("jiang_add", "^�����һƿ��佬��$", 'GiveJiang.Add()', 12, "jiang", 1);
Common.CreateTrigger("jiang_ask", "^(.*)��������йء�.*������Ϣ��$", 'SendNoEcho("say %1,�ҿɲ���NPCŶ,Ҫ����tell�ҽ�")', 12, "jiang", 1);
Common.CreateTrigger("jiang_tell", "^(\\S+)\\((\\S+)\\)�����㣺��$", 'GiveJiang.Ask("%1", "%2")', 12, "jiang", 1);
Common.CreateTrigger("jiang_tell2", "^(\\S+)\\((\\S+)\\)�����㣺����$", 'GiveJiang.Machine("%2")', 12, "jiang", 1);
Common.CreateTrigger("jiang_reduce", "^���\\S+һƿ��佬��$", 'GiveJiang.Reduce()', 12, "jiang", 1);

GiveJiang.Machine = function(strID)
	if GiveJiang.Auth(strID) == false then return; end
	local strValue = GetVariable("Q_misc2");
	if strValue == nil or strValue == "" then strValue = "������" end;
	SendNoEcho("tell " .. strID .. " Ŀǰ˾�������ǶԻ�����Ϊ:" .. strValue);
end

GiveJiang.Ask = function(strName, strID)
	if GiveJiang.Auth(strID) == false then return; end
	--Note(strName .. " " .. strID);
	--if strContent == "��" then
		if Common.TableIndex(GiveJiang.tName, strID) == nil then
			GiveJiang.strName = strName;
			GiveJiang.strID = strID;
			if GiveJiang.tSave[strID] == nil and GiveJiang.tNotGumu[strID] == nil then
				SendNoEcho("l " .. strID);
				SendNoEcho("tell " .. strID .. " ȷ��������");
				Common.CreateTrigger("jiang_look", "^\\S{2}�����(\\S+)��$", 'GiveJiang.Look("%1")', 12, "jiang", 1);
				Common.CreateTimer("jiang_sure", 0, 1, "GiveJiang.Sure", true);
			else
				local bNotGumu = nil;
				GiveJiang.Give(bNotGumu);
			end
		else
			SendNoEcho("tell " .. strID .. " �Ѿ��������,��Ϊ��������,�����ʱ������");
		end
	--else
	--	SendNoEcho("tell " .. strID .. " Ҫ����tell findjiang ��");
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
			GiveJiang.tSave[GiveJiang.strID] = "������";
		end
		GiveJiang.Give(true);
		--SendNoEcho("tell " .. GiveJiang.strID .. " �Բ���,��ֻ��ͬ�ſ�ʹ��,�ʲ��ṩ��������ʿ");
	end
end

GiveJiang.Give = function(bNotGumu)
	if Common.TableIndex(GiveJiang.tName, GiveJiang.strID) == nil then
		if GiveJiang.nDigit > 0 then
			Common.TableAdd(GiveJiang.tName, GiveJiang.strID);
			SendNoEcho("give " .. GiveJiang.strID .. " 1 jiang");
			if bNotGumu ~= nil or GiveJiang.Delay(GiveJiang.strID) then
				Common.CreateTimerFunc("jiang_" .. GiveJiang.strID, 30, 0, 'GiveJiang.Time("' .. GiveJiang.strID .. '")', true);
				SendNoEcho("tell " .. GiveJiang.strID .. " " .. GiveJiang.tSave[GiveJiang.strID] .. ",�������Ľ�,�ǹ�Ĺ������30����CD");
			else
				Common.CreateTimerFunc("jiang_" .. GiveJiang.strID, 0, 1, 'GiveJiang.Time("' .. GiveJiang.strID .. '")', true);
				SendNoEcho("tell " .. GiveJiang.strID .. " " .. GiveJiang.tSave[GiveJiang.strID] .. ",�������Ľ�,ע�Ᵽ��Ŷ,�������ƿ����,���˷�ֹ��,���˷�ֹ����,�Ƚ�CD5����");
			end
		else
			SendNoEcho("tell " .. GiveJiang.strID .. " ����û���ˣ�����������ɣ��˴��ʲ���ռ��CD");
		end
	else
		SendNoEcho("tell " .. GiveJiang.strID .. " �Ѿ��������,��Ϊ��������,����Сʱ������");
	end
end

GiveJiang.Fix = function(nNum)
	Common.CreateTimer("jiang_chat", 59, 1, "GiveJiang.Chat");
	GiveJiang.nDigit = nNum;
	Note("say ��潬 " .. GiveJiang.nDigit .. "ƿ");
end

GiveJiang.Add = function()
	GiveJiang.nDigit = GiveJiang.nDigit + 1;
	--if GiveJiang.nDigit > 3 then GiveJiang.nDigit = 3; end
	--GiveJiang.Chat();
end

GiveJiang.Reduce = function()
	GiveJiang.nDigit = GiveJiang.nDigit - 1;
	SendNoEcho("say ��潬 " .. GiveJiang.nDigit .. "ƿ");
	--GiveJiang.Chat();
end

GiveJiang.Time = function(strID)
	Common.TableDel(GiveJiang.tName, strID);
end

GiveJiang.Chat = function()
	SendNoEcho("chat ��Ĺ�����ṩ��佬,�ֿ�� " .. GiveJiang.nDigit .. " ƿ,Ŀǰ�����Ǳ���:" .. GetVariable("Q_misc2") .. "(��tell�ұ�����ѯ)");
end

Note("!!!�������!!!");