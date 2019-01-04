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
Common.CreateTrigger("fullme_answer1", "^【\\S+】(\\S+)\\((\\S+)\\): ☆ FMQ (.+) ☆$", 'Fullme.Record("%1", "%2", "%3")', 12, "fullme_answer", 0);
Common.CreateTrigger("fullme_answer2", "^【\\S+】(\\S+)\\((\\S+)\\): FMQ (.+)$", 'Fullme.Record("%1", "%2", "%3")', 12, "fullme_answer", 0);
Common.CreateTrigger("fullme_give_money_accept", "^休莱格\\(suineg\\)告诉你：FMM (\\d+) (\\S+) (.+)$", 'Fullme.GiveMoney("%1", "%2", "%3")', 12, "fullme_quest_suinegy", 1);
Common.CreateTrigger("fullme_fullme_right", "^也许是上天垂青于你的勤奋和努力吧，一个小时之内你不用担心被判为机器人。$", 'Fullme.Right();Fullme.FullmeRightWait()', 12, "fullme_quest", 0);
Common.CreateTrigger("fullme_fullme_wrong", "^好像什么都没有发生，但是又好像有什么事情做错了。再来一次试试！$", 'Fullme.Wrong()', 12, "fullme_quest", 0);
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
			SendNoEcho("chat 昨日得分最高玩家是" .. GetVariable("FULLME_ANSWER_MAX_NAME") .. "!分数为" .. GetVariable("FULLME_ANSWER_MAX_SCORE") .. "!恭喜他夺得100G财宝!!!");
			SendNoEcho("tell suinegy FMM 1 " .. strID .. " 10 cash");
		end
		SetVariable("FULLME_ANSWER_MAX_NAME", "无");
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
	if strQuest ~= "Fullme" and strQuest ~= "天珠" and strQuest ~= "刺杀" then
		return;
	end
	Fullme.GetDigit(Fullme.GetDigit()+1);
	Fullme.nDigitAnswer = 0;
	Fullme.strAnswerBuffer = "";
	Fullme.strAnswerTable = {};
	Fullme.strAnswerNow = "";
	Fullme.nAnswerMax = 0;
	SendNoEcho("chat 答题夺宝活动(测试版),本日第" .. Fullme.GetDigit() .. "题.当前分数最高的人是:" .. Fullme.MaxName() .. " 分数为:" .. Fullme.MaxScore());
	--SendNoEcho("chat 查看Url显示的图片,用(jy FMQ 按规则显示的答题)来答题");
	SendNoEcho("chat 有15-30秒时间来答题,15秒后开始验证答题,所有答对的人+1分,答错-2分,为防止乱答,-11分及以下的人员将被拉入答题黑名单");
	SendNoEcho("chat 第一个答对的人奖10G,第二名奖5G,第三名奖2G,每日答题分数最高的人奖100G");
	--SendNoEcho("chat 活动规则:为防止乱答,-11分及以下的人员将被拉入答题黑名单");
	SendNoEcho("chat 本题Url:" .. strUrl);
	if strQuest == "Fullme" then
		SendNoEcho("chat 答案格式:chat FMQ 图片原文;如chat FMQ 韦小;(特别说明,本题答错-10分)");
	elseif strQuest == "天珠" then
		SendNoEcho("chat 答案格式:chat FMQ 地名;如chat FMQ 扬州北大街");
	elseif strQuest == "刺杀" then
		SendNoEcho("chat 答案格式:chat FMQ 数字,数字;如chat FMQ 2,1,3,3,5,6");
	end
	EnableGroup("fullme_answer", true);
	--Common.CreateTimerFunc("fullme_answer_timer", 0, 30, 'Fullme.TimerOver()', true, "fullme_answer");
	DoAfterSpecial(15, "Fullme.TimerOver()", 12);
	Fullme.bStart = true;
end

Fullme.Record = function(strName, strID, strAnswer)
	if GetVariable("Q_name") == "天珠" then
        strAnswer = Replace(strAnswer, "的", "", ture);
	end
	Note("收到答题:" .. strName .. ":" .. strID .. ":" .. strAnswer);
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
		SendNoEcho("chat 答题时间到,共有" .. Fullme.nDigitAnswer .. "人参加,开始验证结果,最后结果积分会以密语形式给出.");
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
		Note("选择答案:" .. Fullme.strAnswerNow);
		local strQuest = GetVariable("Q_name");
		if strQuest == "Fullme" then
			Execute("FB" .. Fullme.strAnswerNow);
		elseif strQuest == "天珠" then
			TZ.Accept(Fullme.strAnswerNow);
		elseif strQuest == "刺杀" then
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
	SendNoEcho("本次活动结束,正确答案是" .. Fullme.strAnswerNow);
end

Fullme.Wrong = function()
	if Fullme.bStart == false then return; end
	Note("答案:" .. Fullme.strAnswerNow .. ":错误!");
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
					SendNoEcho("tell " .. Fullme.tBuffer[i].id .. " 恭喜您答对了,您现在的积分为:" .. nScore );
				else
					SendNoEcho("tell " .. Fullme.tBuffer[i].id .. " 恭喜您答对了,做为最高分获得者,您现在的积分为:" .. nScore );
				end
				if nDigit < 3 then
					nDigit = nDigit + 1;
					SendNoEcho("tell " .. Fullme.tBuffer[i].id .. " 恭喜您获得第" .. nDigit .. "名,得到" .. Fullme.strMoney[nDigit] );
					SendNoEcho("tell suinegy FMM " .. nDigit .. " " .. Fullme.tBuffer[i].id .. " " .. Fullme.strMoney[nDigit]);
					if nDigit > 1 then
						strName = strName .. " 、 ";
					end
					strName = strName .. Fullme.tBuffer[i].name;
				end
			else
				local nDec = -2;
				if GetVariable("Q_name") == "Fullme" then
					nDec = -10;
				end
				local nScore = Fullme.GetScore(Fullme.tBuffer[i].id, nDec);
				SendNoEcho("tell " .. Fullme.tBuffer[i].id .. " 很遗憾你答错了,你现在的积分为:" .. nScore );
			end
		end
	end
	if Fullme.strAnswerNow ~= "" then
		SendNoEcho("chat 本次活动结束,正确答案为:" .. Fullme.strAnswerNow .. "!获奖人员有" .. strName .. "!恭喜他们!");
	else
		SendNoEcho("chat 本次活动结束,无人生还");
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
