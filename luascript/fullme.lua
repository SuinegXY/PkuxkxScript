Fullme = {};

Fullme.tBuffer = {};
Fullme.strData = "";
Fullme.nDigitQuest = 0;
Fullme.nDigitAnswer = 0;
Fullme.strMaxName = "";
Fullme.strMaxScore = 0;
Fullme.strAnswerBuffer = "";
Fullme.strAnswerTable = {};
Fullme.strAnswerNow = "";
Fullme.nAnswerMax = 0;
Fullme.strMoney = {};
Fullme.strMoney[1] = "1 cash";
Fullme.strMoney[2] = "5 gold";
Fullme.strMoney[3] = "2 gold";
Fullme.bStart = false;

Common.CreateAlias("alias_fullme_answer", "^FM(A|S)$", 'Fullme.Start("%1")', 12, "triggers");
Common.CreateTrigger("fullme_answer1", "^��\\S+��(\\S+)\\((\\S+)\\): �� FMQ (.+) ��$", 'Fullme.Record("%1", "%2", "%3")', 12, "fullme_answer", 0);
Common.CreateTrigger("fullme_answer2", "^��\\S+��(\\S+)\\((\\S+)\\): FMQ (.+)$", 'Fullme.Record("%1", "%2", "%3")', 12, "fullme_answer", 0);
Common.CreateTrigger("fullme_give_money_accept", "^������\\(suineg\\)�����㣺FMM (\\d+) (\\S+) (.+)$", 'Fullme.GiveMoney("%1", "%2", "%3")', 12, "fullme_quest_suinegy", 1);
Common.CreateTrigger("fullme_fullme_right", "^Ҳ�������촹��������ڷܺ�Ŭ���ɣ�һ��Сʱ֮���㲻�õ��ı���Ϊ�����ˡ�$", 'Fullme.Right();Fullme.FullmeRightWait()', 12, "fullme_quest", 0);
Common.CreateTrigger("fullme_fullme_wrong", "^����ʲô��û�з����������ֺ�����ʲô���������ˡ�����һ�����ԣ�$", 'Fullme.Wrong()', 12, "fullme_quest", 0);
Common.CreateTrigger("fullme_fullme_quest", "^http://pkuxkx.net/antirobot/.+$", 'Fullme.Quest("%0")', 12, "fullme_quest", 0);

EnableGroup("fullme_answer", false);
DeleteTimer("fullme_answer_timer");

Fullme.Start = function(strStart)
	local strDataBuffer = os.date("%m_%d", os.time());
	if Fullme.GetData() ~= strDataBuffer then
		Fullme.GetData(strDataBuffer);
		Fullme.nDigitQuest = 0;
		local strID = Fullme.MaxID();
		if strID ~= nil and strID ~= "" then
			SendNoEcho("chat ���յ÷���������" .. GetVariable("FULLME_ANSWER_MAX_NAME") .. "!����Ϊ" .. GetVariable("FULLME_ANSWER_MAX_SCORE") .. "!��ϲ�����100G�Ʊ�!!!");
			SendNoEcho("tell suinegy FMM 1 " .. strID .. " 10 cash");
		end
		SetVariable("FULLME_ANSWER_MAX_NAME", "��");
		SetVariable("FULLME_ANSWER_MAX_SCORE", 0);
		SetVariable("FULLME_ANSWER_MAX_ID", "");
	end
	SetVariable("FULLME_ANSWER", strStart);
	EnableGroup("fullme_quest", strStart == "A");
	Fullme.bStart = false;
end

Fullme.IsStart = function()
	return GetVariable("FULLME_ANSWER") == "A";
end

Fullme.GetData = function(strData)
	if strData ~= nil then
		SetVariable("FULLME_ANSWER_DATA", strData);
	end
	return GetVariable("FULLME_ANSWER_DATA");
end

Fullme.GetDigit = function(nData)
	if nData ~= nil then
		SetVariable("FULLME_ANSWER_DIGIT", tostring(nData));
	end
	return tonumber(GetVariable("FULLME_ANSWER_DIGIT"));
end

Fullme.MaxName = function(strName)
	if strName ~= nil then
		SetVariable("FULLME_ANSWER_MAX_NAME", strName);
	end
	return GetVariable("FULLME_ANSWER_MAX_NAME");
end

Fullme.MaxID = function(strName)
	if strName ~= nil then
		SetVariable("FULLME_ANSWER_MAX_ID", strName);
	end
	return GetVariable("FULLME_ANSWER_MAX_ID");
end

Fullme.MaxScore = function(nScore)
	if nScore ~= nil then
		SetVariable("FULLME_ANSWER_MAX_SCORE", tostring(nScore));
	end
	return tonumber(GetVariable("FULLME_ANSWER_MAX_SCORE"));
end

Fullme.Quest = function(strUrl)
	local strQuest = GetVariable("Q_name");
	if strQuest ~= "Fullme" and strQuest ~= "����" and strQuest ~= "��ɱ" then
		return;
	end
	Fullme.GetDigit(Fullme.GetDigit()+1);
	Fullme.nDigitAnswer = 0;
	Fullme.strAnswerBuffer = "";
	Fullme.strAnswerTable = {};
	Fullme.strAnswerNow = "";
	Fullme.nAnswerMax = 0;
	SendNoEcho("chat ����ᱦ�(���԰�),���յ�" .. Fullme.GetDigit() .. "��.��ǰ������ߵ�����:" .. Fullme.MaxName() .. " ����Ϊ:" .. Fullme.MaxScore());
	--SendNoEcho("chat �鿴Url��ʾ��ͼƬ,��(jy FMQ ��������ʾ�Ĵ���)������");
	SendNoEcho("chat ��15-30��ʱ��������,15���ʼ��֤����,���д�Ե���+1��,���-2��,Ϊ��ֹ�Ҵ�,-11�ּ����µ���Ա����������������");
	SendNoEcho("chat ��һ����Ե��˽�10G,�ڶ�����5G,��������2G,ÿ�մ��������ߵ��˽�100G");
	--SendNoEcho("chat �����:Ϊ��ֹ�Ҵ�,-11�ּ����µ���Ա����������������");
	SendNoEcho("chat ����Url:" .. strUrl);
	if strQuest == "Fullme" then
		SendNoEcho("chat �𰸸�ʽ:chat FMQ ͼƬԭ��;��chat FMQ ΤС;(�ر�˵��,������-10��)");
	elseif strQuest == "����" then
		SendNoEcho("chat �𰸸�ʽ:chat FMQ ����;��chat FMQ ���ݱ����");
	elseif strQuest == "��ɱ" then
		SendNoEcho("chat �𰸸�ʽ:chat FMQ ����,����;��chat FMQ 2,1,3,3,5,6");
	end
	EnableGroup("fullme_answer", true);
	--Common.CreateTimerFunc("fullme_answer_timer", 0, 30, 'Fullme.TimerOver()', true, "fullme_answer");
	DoAfterSpecial(15, "Fullme.TimerOver()", 12);
	Fullme.bStart = true;
end

Fullme.Record = function(strName, strID, strAnswer)
	if GetVariable("Q_name") == "����" then
        strAnswer = Replace(strAnswer, "��", "", ture);
	end
	Note("�յ�����:" .. strName .. ":" .. strID .. ":" .. strAnswer);
	strID = string.lower(strID);
	local nScore = Fullme.GetScore(strID);
	if nScore < -11 then return; end
	if Fullme.nDigitAnswer > 0 then
		for i = 1, Fullme.nDigitAnswer do
			if Fullme.tBuffer[i].id == strID then
				Fullme.tBuffer[i].answer = strAnswer;
				return;
			end
		end
	end
	Fullme.nDigitAnswer = Fullme.nDigitAnswer + 1;
	Fullme.tBuffer[Fullme.nDigitAnswer] = {};
	Fullme.tBuffer[Fullme.nDigitAnswer].id = strID;
	Fullme.tBuffer[Fullme.nDigitAnswer].name = strName;
	Fullme.tBuffer[Fullme.nDigitAnswer].answer = strAnswer;
end

Fullme.TimerOver = function()
	if Fullme.nDigitAnswer < 1 then
		DoAfterSpecial(15, "Fullme.TimerOver()", 12);
	else
		SendNoEcho("chat ����ʱ�䵽,����" .. Fullme.nDigitAnswer .. "�˲μ�,��ʼ��֤���,��������ֻ���������ʽ����.");
		EnableGroup("fullme_answer", false);
		Fullme.ExeAnswer();
	end
end

Fullme.ExeAnswer = function()
	if Fullme.nDigitAnswer > 0 then
		for i = 1, Fullme.nDigitAnswer do
			Note("ID:" .. Fullme.tBuffer[i].id .. ";Name:" .. Fullme.tBuffer[i].name .. ";Answer:" .. Fullme.tBuffer[i].answer);
			if Fullme.strAnswerTable[Fullme.tBuffer[i].answer] == nil then
				Fullme.strAnswerTable[Fullme.tBuffer[i].answer] = 0;
			end
			Fullme.strAnswerTable[Fullme.tBuffer[i].answer] = Fullme.strAnswerTable[Fullme.tBuffer[i].answer] + 1;
			Note("Answer:" .. Fullme.tBuffer[i].answer .. ";Count:" .. Fullme.strAnswerTable[Fullme.tBuffer[i].answer]);
			if Fullme.strAnswerTable[Fullme.tBuffer[i].answer] > Fullme.nAnswerMax then
				Fullme.strAnswerNow = Fullme.tBuffer[i].answer;
				Fullme.nAnswerMax = Fullme.strAnswerTable[Fullme.tBuffer[i].answer];
			end
		end
	end
	if Fullme.nAnswerMax > 0 and Fullme.strAnswerNow ~= "" then
		Note("ѡ���:" .. Fullme.strAnswerNow);
		local strQuest = GetVariable("Q_name");
		if strQuest == "Fullme" then
			Execute("FB" .. Fullme.strAnswerNow);
		elseif strQuest == "����" then
			TZ.Accept(Fullme.strAnswerNow);
		elseif strQuest == "��ɱ" then
			Execute("MZJ " .. Fullme.strAnswerNow);
		end
	else
		Fullme.Over();
	end
end

Fullme.Right = function()
	if Fullme.bStart == false then return; end
	Fullme.bStart = false;
	Fullme.Over();
	SendNoEcho("���λ����,��ȷ����" .. Fullme.strAnswerNow);
end

Fullme.Wrong = function()
	if Fullme.bStart == false then return; end
	Note("��:" .. Fullme.strAnswerNow .. ":����!");
	Fullme.strAnswerTable[Fullme.strAnswerNow] = -999;
	Fullme.nAnswerMax = 0;
	Fullme.strAnswerNow = "";
	Fullme.ExeAnswer();
end

Fullme.GetScore = function(strID, nChange)
	if strID == nil then return; end
	local strValue = GetVariable("ZZFULLME_C_" .. strID);
	local nScore = 0;
	if strValue == nil then
		nScore = 0;
	else
		local tCode = utils.split(strValue,";");
		if tCode[2] ~= Fullme.GetData() then
			tCode[1] = "0";
		end
		nScore = tonumber(tCode[1]);
	end
	if nChange ~= nil then
		nScore = nScore + nChange;
	end
	SetVariable("ZZFULLME_C_" .. strID, nScore .. ";" .. Fullme.GetData());
	return nScore;
end

Fullme.Over = function()
	local nDigit = 0;
	local strName = "";
	if Fullme.nDigitAnswer > 0 then
		for i = 1, Fullme.nDigitAnswer do
			if Fullme.tBuffer[i].answer == Fullme.strAnswerNow then
				local nScore = Fullme.GetScore(Fullme.tBuffer[i].id, 1);
				if Fullme.MaxScore() < nScore then
					Fullme.MaxScore(nScore);
					Fullme.MaxName(Fullme.tBuffer[i].name);
					Fullme.MaxID(Fullme.tBuffer[i].id);
					SendNoEcho("tell " .. Fullme.tBuffer[i].id .. " ��ϲ�������,�����ڵĻ���Ϊ:" .. nScore );
				else
					SendNoEcho("tell " .. Fullme.tBuffer[i].id .. " ��ϲ�������,��Ϊ��߷ֻ����,�����ڵĻ���Ϊ:" .. nScore );
				end
				if nDigit < 3 then
					nDigit = nDigit + 1;
					SendNoEcho("tell " .. Fullme.tBuffer[i].id .. " ��ϲ����õ�" .. nDigit .. "��,�õ�" .. Fullme.strMoney[nDigit] );
					SendNoEcho("tell suinegy FMM " .. nDigit .. " " .. Fullme.tBuffer[i].id .. " " .. Fullme.strMoney[nDigit]);
					if nDigit > 1 then
						strName = strName .. " �� ";
					end
					strName = strName .. Fullme.tBuffer[i].name;
				end
			else
				local nDec = -2;
				if GetVariable("Q_name") == "Fullme" then
					nDec = -10;
				end
				local nScore = Fullme.GetScore(Fullme.tBuffer[i].id, nDec);
				SendNoEcho("tell " .. Fullme.tBuffer[i].id .. " ���ź�������,�����ڵĻ���Ϊ:" .. nScore );
			end
		end
	end
	if Fullme.strAnswerNow ~= "" then
		SendNoEcho("chat ���λ����,��ȷ��Ϊ:" .. Fullme.strAnswerNow .. "!����Ա��" .. strName .. "!��ϲ����!");
	else
		SendNoEcho("chat ���λ����,��������");
	end
end

Fullme.tGiveMoneyBuffer = {};
Fullme.GiveMoney = function(strIndex, strID, strMoney)
	Note("Time:" .. strIndex .. ";ID:" .. strID .. ";Money:" .. strMoney);
	local nTime = tonumber(strIndex) - 1;
	if nTime == 0 then
		SendNoEcho("zhuan " .. strID .. " " .. strMoney);
	else
		Fullme.tGiveMoneyBuffer[nTime] = "zhuan " .. strID .. " " .. strMoney;
		if nTime == 1 then
			DoAfterSpecial(5, 'SendNoEcho(Fullme.tGiveMoneyBuffer[1])', 12);
		else
			DoAfterSpecial(10, 'SendNoEcho(Fullme.tGiveMoneyBuffer[2])', 12);
		end
	end
end

Fullme.FullmeRightWait = function()
	DoAfterSpecial(2, "QS", 10);
end

Fullme.Start("S");
