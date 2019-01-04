

Answer = {};
Answer.tList = {};
Answer.tAsker = {};
Answer.bOpen = false;
Answer.bCode = false;

Common.CreateAlias("Answer_AS", "^AS$", 'EnableTrigger("Answer_Recoad", true);', 12, "answer");
Common.CreateTrigger("Answer_OpenClose", "^————————————————————————————————————$", 'Answer.OpenClose()', 12, "answer");
Common.CreateTrigger("Answer_Recoad", "^(.*?\\(.+\\))\\s*\\<*\\S*\\>*$", 'Answer.Record("%1")', 12, "answer", 0);
Common.CreateTrigger("Answer_AnswerTeller", "^\\S+\\((\\S+)\\)告诉你：AS (\\S+)$", 'Answer.AnswerTeller("%1", "%2")', 12, "answer", 1);
Common.CreateTrigger("Answer_Cant", "^你的精神太差了，没有办法得知其他玩家的详细资料。$", 'Answer.Error()', 12, "answer", 1);

Answer.OpenClose = function()
	Answer.bOpen = not Answer.bOpen;
	EnableTrigger("Answer_Recoad", Answer.bOpen);
	if not Answer.bOpen and table.getn(Answer.tAsker) then
		for i,v in pairs(Answer.tAsker) do
			Answer.AnswerTeller(v.strAskerBuffer, v.strContentBuffer)
		end
	end
end

Answer.Record = function(strContent)
	Answer.bCode = true;
	--Note(strContent);
	strContent = string.lower(strContent);
	if Answer.tList[strContent] == nil then
		Answer.tList[strContent] = 1;
	end
end

Answer.Auth = function(strID)
	if strID == "suinegdls" or strID == "findjiang" or strID == "suineg" or strID == "suinegy" or strID == "jyyx" then
		return true;
	end
	SendNoEcho("tell " .. strID .. " 查询中,请稍候...(暂时查询功能)");
	return false;
end

Answer.AnswerTeller = function(strAsker, strContent)
	if Answer.Auth(strAsker) == false then return; end
	local bFind = false;
	local bSearchOver = false;
	strContent = string.gsub(strContent, "%-", "\%%-");
	strContent = string.gsub(strContent, "%+", "\%%+");
	strContent = string.lower(strContent);
	if table.getn(Answer.tAsker) then
		for i,v in pairs(Answer.tAsker) do
			if v.strAskerBuffer == strAsker and v.strContentBuffer == strContent then
				bSearchOver = true;
				Common.TableDel(Answer.tAsker, v);
				break;
			end
		end
	end
	Answer.strAskerBuffer = "";
	Answer.strContentBuffer = "";
	for i,v in pairs(Answer.tList) do
		if string.find(i, strContent) then
			bFind = true;
			if strAsker == "findjiang" then
				Note("tell " .. strAsker .. " " .. i);
			else
				SendNoEcho("tell " .. strAsker .. " " .. i);
			end
		end
	end
	if not bFind then
		if bSearchOver then
			if strAsker == "findjiang" then
				Note("tell " .. strAsker .. " 未找到");
			else
				SendNoEcho("tell " .. strAsker .. " 未找到");
			end
		else
			if strAsker == "findjiang" then
				Note("tell " .. strAsker .. " 查询中,请稍候...(暂时查询功能)");
			else
				SendNoEcho("tell " .. strAsker .. " 查询中,请稍候...(暂时查询功能)");
			end
			if Answer.bCode == false then
				SendNoEcho("who -l");
				tBuffer = {};
				tBuffer.strAskerBuffer = strAsker;
				tBuffer.strContentBuffer = strContent;
				Common.TableAdd(Answer.tAsker, tBuffer);
				SendNoEcho("tell " .. strAsker .. " 查询中,请稍候...");
			else
				SendNoEcho("tell " .. strAsker .. " 已有数据,防体力空停止更新数据");
			end
		end
	end
end

Answer.Error = function()
	if table.getn(Answer.tAsker) then
		for i,v in pairs(Answer.tAsker) do
			if v.strAskerBuffer == "findjiang" then
				Note("tell " .. v.strAskerBuffer .. " 精神不足,无法查询");
			else
				SendNoEcho("tell " .. v.strAskerBuffer .. " 精神不足,无法查询");
			end
		end
	end
	Answer.tAsker = {};
end

Common.CreateTrigger("Answer_MPOpenClose", "^————————————————————————————————————$", 'Answer.MPOpenClose()', 12, "answer", 0);
Common.CreateTrigger("Answer_MPRecoad", "^(.*)$", 'Answer.MPRecord("%1")', 12, "answer", 0);
Common.CreateTrigger("Answer_MPAnswerTeller", "^休莱格\\(suineg\\)告诉你：MPA (\\S+)$", 'Answer.MP("%1")', 12, "answer", 1);
Common.CreateTrigger("Answer_MPAnswer", "^休莱格\\(suineg\\)告诉你：MPB A\\.(.+?)\\s+B\\.(.+?)\\s+C\\.(.+?)\\s+D\\.(.+?)\\s*$", 'Answer.MPAnswer("%1", "%2", "%3", "%4")', 12, "answer", 0);

Answer.tMenPaiID = {
["少林派"] = "shaolin",
["武当派"] = "wudang",
["峨嵋派"] = "emei",
["华山派"] = "huashan",
["全真派"] = "quanzhen",
["天龙寺"] = "tianlong",
["星宿派"] = "xingxiu",
["日月神教"] = "riyue",
["明教"] = "mingjiao",
["丐帮"] = "gaibang",
["桃花岛"] = "taohua",
["古墓派"] = "gumu",
["雪山派"] = "xueshan",
["天地会"] = "tiandihui",
["白驼山"] = "baituo",
["大轮寺"] = "dalunsi",
["神龙教"] = "shenlong",
["朝廷"] = "chaoting",
["灵鹫宫"] = "lingjiu",
["姑苏慕容"] = "murong",
["绝情谷"] = "jueqinggu",
};

Answer.tMPList = {};
Answer.bOpenMP = false;
Answer.tAnswers = {};

Answer.MP = function(strName)
	if Answer.tMenPaiID[strName] ~= nil then
		EnableTrigger("Answer_MPAnswer", true);
		EnableTrigger("Answer_MPOpenClose", true);
		Answer.tMPList = {};
		SendNoEcho("who -l -" .. Answer.tMenPaiID[strName]);
	end
end

Answer.MPOpenClose = function(strContent)
	Answer.bOpenMP = not Answer.bOpenMP;
	EnableTrigger("Answer_MPRecoad", Answer.bOpenMP);
	if not Answer.bOpenMP then
		DoAfterSpecial(2, "Answer.MPSolver()", 12);
		EnableTrigger("Answer_MPOpenClose", Answer.bOpenMP);
		--Note("关闭");
	else
		--Note("开启");
	end
end

Answer.MPRecord = function(strContent)
	if Answer.tMPList[strContent] == nil then
		strContent = string.lower(strContent);
		Answer.tMPList[strContent] = 1;
		--Note("列表添加");
	end
end

Answer.MPAnswer = function(strA, strB, strC, strD)
	EnableTrigger("Answer_MPAnswer", false);
	Answer.tAnswers = {};
	Answer.tAnswers["a"] = string.lower(strA);
	Answer.tAnswers["b"] = string.lower(strB);
	Answer.tAnswers["c"] = string.lower(strC);
	Answer.tAnswers["d"] = string.lower(strD);
end

Answer.MPSolver = function()
	--Note("回答");
	for i, v in pairs(Answer.tAnswers) do
		for j, k in pairs(Answer.tMPList) do
			--Note(j .. " : " .. v);
			if string.find(j, v) then
				SendNoEcho("tell suineg MP " .. i);
				Answer.tAnswers = {};
				return;
			end
		end
	end
	Answer.tAnswers = {};
end
