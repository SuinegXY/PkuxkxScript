

Answer = {};
Answer.tList = {};
Answer.tAsker = {};
Answer.bOpen = false;
Answer.bCode = false;

Common.CreateAlias("Answer_AS", "^AS$", 'EnableTrigger("Answer_Recoad", true);', 12, "answer");
Common.CreateTrigger("Answer_OpenClose", "^������������������������������������������������������������������������$", 'Answer.OpenClose()', 12, "answer");
Common.CreateTrigger("Answer_Recoad", "^(.*?\\(.+\\))\\s*\\<*\\S*\\>*$", 'Answer.Record("%1")', 12, "answer", 0);
Common.CreateTrigger("Answer_AnswerTeller", "^\\S+\\((\\S+)\\)�����㣺AS (\\S+)$", 'Answer.AnswerTeller("%1", "%2")', 12, "answer", 1);
Common.CreateTrigger("Answer_Cant", "^��ľ���̫���ˣ�û�а취��֪������ҵ���ϸ���ϡ�$", 'Answer.Error()', 12, "answer", 1);

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
	SendNoEcho("tell " .. strID .. " ��ѯ��,���Ժ�...(��ʱ��ѯ����)");
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
				Note("tell " .. strAsker .. " δ�ҵ�");
			else
				SendNoEcho("tell " .. strAsker .. " δ�ҵ�");
			end
		else
			if strAsker == "findjiang" then
				Note("tell " .. strAsker .. " ��ѯ��,���Ժ�...(��ʱ��ѯ����)");
			else
				SendNoEcho("tell " .. strAsker .. " ��ѯ��,���Ժ�...(��ʱ��ѯ����)");
			end
			if Answer.bCode == false then
				SendNoEcho("who -l");
				tBuffer = {};
				tBuffer.strAskerBuffer = strAsker;
				tBuffer.strContentBuffer = strContent;
				Common.TableAdd(Answer.tAsker, tBuffer);
				SendNoEcho("tell " .. strAsker .. " ��ѯ��,���Ժ�...");
			else
				SendNoEcho("tell " .. strAsker .. " ��������,��������ֹͣ��������");
			end
		end
	end
end

Answer.Error = function()
	if table.getn(Answer.tAsker) then
		for i,v in pairs(Answer.tAsker) do
			if v.strAskerBuffer == "findjiang" then
				Note("tell " .. v.strAskerBuffer .. " ������,�޷���ѯ");
			else
				SendNoEcho("tell " .. v.strAskerBuffer .. " ������,�޷���ѯ");
			end
		end
	end
	Answer.tAsker = {};
end

Common.CreateTrigger("Answer_MPOpenClose", "^������������������������������������������������������������������������$", 'Answer.MPOpenClose()', 12, "answer", 0);
Common.CreateTrigger("Answer_MPRecoad", "^(.*)$", 'Answer.MPRecord("%1")', 12, "answer", 0);
Common.CreateTrigger("Answer_MPAnswerTeller", "^������\\(suineg\\)�����㣺MPA (\\S+)$", 'Answer.MP("%1")', 12, "answer", 1);
Common.CreateTrigger("Answer_MPAnswer", "^������\\(suineg\\)�����㣺MPB A\\.(.+?)\\s+B\\.(.+?)\\s+C\\.(.+?)\\s+D\\.(.+?)\\s*$", 'Answer.MPAnswer("%1", "%2", "%3", "%4")', 12, "answer", 0);

Answer.tMenPaiID = {
["������"] = "shaolin",
["�䵱��"] = "wudang",
["������"] = "emei",
["��ɽ��"] = "huashan",
["ȫ����"] = "quanzhen",
["������"] = "tianlong",
["������"] = "xingxiu",
["�������"] = "riyue",
["����"] = "mingjiao",
["ؤ��"] = "gaibang",
["�һ���"] = "taohua",
["��Ĺ��"] = "gumu",
["ѩɽ��"] = "xueshan",
["��ػ�"] = "tiandihui",
["����ɽ"] = "baituo",
["������"] = "dalunsi",
["������"] = "shenlong",
["��͢"] = "chaoting",
["���չ�"] = "lingjiu",
["����Ľ��"] = "murong",
["�����"] = "jueqinggu",
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
		--Note("�ر�");
	else
		--Note("����");
	end
end

Answer.MPRecord = function(strContent)
	if Answer.tMPList[strContent] == nil then
		strContent = string.lower(strContent);
		Answer.tMPList[strContent] = 1;
		--Note("�б����");
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
	--Note("�ش�");
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
