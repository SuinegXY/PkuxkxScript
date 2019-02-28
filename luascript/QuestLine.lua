QuestOver = QuestOver or {};
QuestOver.nQuestTime = 0;
QuestOver.OVER_TIME = 300;
QuestOver.bFail = false;
QuestOver.strFullme = "";
QuestOver.bFullme = false;

DeleteTimer("questtime_digit");

--[[
│[08][主]都府刺杀(640) 93.7%     仍需三分十二秒才能接到下个任务。                              │
│[10][主]胡一刀(312) 97.8%       现在即可接到下个任务。                                        │
│[11][主]萧峰(21) 67.7%          现在即可接到下个任务。                                        │
│[12][主]韩世忠(771) 95.3%       现在即可接到下个任务。                                        │
│[13][主]公孙止(9918) 94.0%      现在即可接到下个任务。                                        │
│[14][主]万安塔(558) 97.4%       现在即可接到下个任务。                                        │
│[16][主]天珠(15696) 96.9%       你的天珠任务正在进行中……                                    │
│[19][主]华山送信任务(91)        现在即可接到下个任务。                                        │
]]--

QuestOver.tQuestTime = {};
QuestOver.tQuestTime["tianzhu"] = 0;
QuestOver.tQuestTime["mzj"] = 0;
QuestOver.tQuestTime["hyd"] = 0;
QuestOver.tQuestTime["lywxl2"] = 0;
QuestOver.tQuestTime["wat"] = 0;
QuestOver.tQuestTime["pozhen"] = 0;
QuestOver.tQuestTime["hsz"] = 0;
QuestOver.tQuestTime["hyw"] = 0;
QuestOver.tQuestTime["mrpr"] = 0;
QuestOver.tQuestTime["gsz"] = 0;
QuestOver.tQuestTime["yujie"] = 0;

QuestOver.tID = {};
QuestOver.tID["06"] = "mrpr";
QuestOver.tID["07"] = "hyw";
QuestOver.tID["08"] = "mzj";
QuestOver.tID["09"] = "hyd";
QuestOver.tID["10"] = "lywxl2";
QuestOver.tID["11"] = "hsz";
QuestOver.tID["12"] = "gsz";
QuestOver.tID["13"] = "wat";
QuestOver.tID["14"] = "pozhen";
QuestOver.tID["15"] = "tianzhu";
--QuestOver.tID["19"] = "yujie";

Common.CreateTrigger("QO1", "^│\\[(\\d+)\\]│\\[主\\].*仍需(\\S+)分(\\S+)秒才能接到下个.*任务。.*$", 'QuestOver.SetTime(QuestOver.tID["%1"], "%2", "%3")', 12, "questTime", 0, 0, nil, 0, 94);
Common.CreateTrigger("QO2", "^│\\[(\\d+)\\]│\\[主\\].*仍需(\\S+)秒才能接到下个.*任务。.*$", 'QuestOver.SetTime(QuestOver.tID["%1"], "0", "%2")', 12, "questTime", 0, 0, nil, 0, 95);
Common.CreateTrigger("QO3", "^│\\[(\\d+)\\]│\\[主\\].*现在即可接到下个.*任务。.*$", 'QuestOver.SetTime(QuestOver.tID["%1"], "0", "0")', 12, "questTime", 0);

QuestOver.Check = function()
	Common.InstanceRun(QuestOver.CheckAction);
end

QuestOver.CheckAction = function()
	QuestOver.bFail = false;
	QuestOver.tQuestTime["tianzhu"] = 0;
	QuestOver.tQuestTime["mzj"] = 0;
	QuestOver.tQuestTime["lywxl2"] = 0;
	QuestOver.tQuestTime["wat"] = 0;
	QuestOver.tQuestTime["pozhen"] = 0;
	QuestOver.tQuestTime["hyd"] = 0;
	Common.CloseAllGroup();
	--if Fullme.IsStart() == true and GetStatusFullmeTime() > 25 then
	--	SetVariable("Q_name", "Fullme");
	--	Execute("fullme");
	--else
		EnableGroup("questTime", true);
		SendNoEcho("jobquery");
		DoAfterSpecial(2, "QuestOver.Chose();", 12);
	--end
end

QuestOver.Chose = function()
	EnableGroup("questTime", false);
	for nIndex = 1, #QuestOver.tQuest do
		if QuestOver.tQuest[nIndex] == "tz" and GetVariable("QL_TZ") == "1" and QuestOver.tQuestTime["tianzhu"] <= 10 then
			--if GetVariable("SA_VALUE") == "0" then
				SendNoEcho("unset adv_quest");
			--end
			Execute("TM1");
			DoAfterSpecial(2, 'Way.Goto("tianzhu")', 12);
			Execute("EGA tz");
			Execute("TZ");
			--Note("1开始TZ");
			return;
		elseif QuestOver.tQuest[nIndex] == "mzj" and GetVariable("QL_MZJ") == "1" and QuestOver.tQuestTime["mzj"] <= 10 then
			DoAfterSpecial(2, 'Way.Goto("mzj")', 12);
			DoAfterSpecial(5, 'MZJA', 10);
			--Note("1开始MZJ");
			Execute("EGA mzj");
			Execute("MZJA");
			return;
		elseif QuestOver.tQuest[nIndex] == "xf" and GetVariable("QL_XF") == "1" and QuestOver.tQuestTime["lywxl2"] <= 10 then
			DoAfterSpecial(2, 'Way.Goto("lywxl2")', 12);
			Execute("EGA xf");
			Execute("XFA");
			DoAfterSpecial(5, 'XFA', 10);
			--if Common.id == "suineg" then
			--	SendNoEcho("set adv_quest 50");
			--end
			--Note("1开始XF");
			return;
		elseif QuestOver.tQuest[nIndex] == "wat" and GetVariable("QL_WAT") == "1" and QuestOver.tQuestTime["wat"] <= 10 then
			DoAfterSpecial(2, 'Way.Goto("wat")', 12);
			Execute("EGA wat");
			Execute("WAT");
			--Note("1开始WAT");
			return;
		elseif QuestOver.tQuest[nIndex] == "hsz" and GetVariable("QL_HSZ") == "1" and QuestOver.tQuestTime["hsz"] <= 10 then
			Way.Goto("hsz");
			Execute("EGA hsz");
			Execute("HSZ");
			return;
		elseif QuestOver.tQuest[nIndex] == "gsz" and GetVariable("QL_GSZ") == "1" and QuestOver.tQuestTime["gsz"] <= 10 then
			Way.Goto("gsz");
			Execute("EGA gsz");
			Execute("GSZ");
			return;
		elseif QuestOver.tQuest[nIndex] == "pz" and GetVariable("QL_PZ") == "1" and QuestOver.tQuestTime["pozhen"] <= 10 then
			Way.Goto("pozhen");
			EnableGroup("pozhen", true);
			Execute("PZ");
			return;
		elseif QuestOver.tQuest[nIndex] == "hyd" and GetVariable("QL_HYD") == "1" and QuestOver.tQuestTime["hyd"] <= 10 then
			Way.Goto("hyd");
			EnableGroup("hyd", true);
			Execute("HYDA");
			return;
		elseif QuestOver.tQuest[nIndex] == "hyw" and GetVariable("QL_HYW") == "1" and QuestOver.tQuestTime["hyw"] <= 10 then
			Way.Goto("hyw");
			Execute("EGA hyw");
			Execute("HYW");
			return;
		elseif QuestOver.tQuest[nIndex] == "mrpr" and GetVariable("QL_MRPR") == "1" and QuestOver.tQuestTime["mrpr"] <= 10 then
			Way.Goto("szcg");
			Execute("MRPRA");
			return;
		elseif QuestOver.tQuest[nIndex] == "yujie" and GetVariable("QL_YUJIE") == "1" and QuestOver.tQuestTime["yujie"] <= 10 then
			Way.Goto("cdsczdf");
			Execute("YJA");
			return;
		end
	end

	if GetVariable("QL_MZJ") == "1" and QuestOver.tQuestTime["tianzhu"] - QuestOver.tQuestTime["mzj"] > 50 then
		Way.Goto("mzj");
		EnableGroup("mzj", true);
		Execute("MZJA");
	elseif GetVariable("QL_XF") == "1" and QuestOver.tQuestTime["tianzhu"] - QuestOver.tQuestTime["lywxl2"] > 50 then
		Way.Goto("lywxl2");
		EnableGroup("xf", true);
		Execute("XFA");
	elseif QuestOver.tQuest[1] == "tz" and GetVariable("QL_TZ") == "1" then
		Way.Goto("tianzhu");
		EnableGroup("tz", true);
		Execute("TZ");
		--Note("2开始TZ");
	elseif QuestOver.tQuest[1] == "mzj" and GetVariable("QL_MZJ") == "1" then
		Way.Goto("mzj");
		EnableGroup("mzj", true);
		Execute("MZJA");
		--Note("2开始MZJ");
	end
end

QuestOver.SetTime = function(strName, strMin, strSec)
	if strName == nil then return; end
	QuestOver.tQuestTime[strName] = StrToNum(strMin)*60 + StrToNum(strSec);
	--Note(strName .. ":" .. QuestOver.tQuestTime[strName]);
end

QuestOver.Digit = function()
	if QuestOver.nQuestTime < QuestOver.OVER_TIME then
		QuestOver.nQuestTime = QuestOver.nQuestTime + 1;
	else
		QuestOver.DigitOver();
		QuestOver.AskFail();
	end
end

QuestOver.AskFail = function()
	QuestOver.bFail = true;
	local strQuestName = GetVariable("Q_name");
	if strQuestName == "刺杀" then
		Execute("MZJF");
	elseif strQuestName == "天珠" then
		Execute("TZF");
	elseif strQuestName == "萧峰" then
		Execute("XFF");
	end
end

QuestOver.DigitStart = function()
	if GetVariable("FULLME_TYPE") == "2" then
		Common.CreateTimer("questtime_digit", 0, 1, "QuestOver.Digit");
	end
	QuestOver.nQuestTime = 0;
end

QuestOver.DigitOver = function()
	DeleteTimer("questtime_digit");
end

QuestOver.TZ = function()
	Execute("EGS tz");
	TZ.Finish();
	Way.Clear();
	--SelectCommand();
	if TZ.nShaqi > tonumber(GetVariable("TZ_XINMO")) then
		Execute("XMA");
		Way.Goto("slqfd");
	elseif GetVariable("TZ_GSZ") == "1" then
		Way.Goto("gsz")
		DoAfterSpecial(4, 'GSZ', 10);
		DoAfterSpecial(4, 'EnableTimer("quest_look", true)', 12);
	elseif GetVariable("TZ_GSZ") == "2" then
		Way.Goto("pozhen");
		DoAfterSpecial(10, 'PZ', 10);
	elseif GetVariable("TZ_GSZ") == "3" then
		Way.Goto("mzj");
		DoAfterSpecial(20, 'MZJA', 10);
		DoAfterSpecial(10, 'EnableTimer("quest_look", true)', 12);
	elseif GetVariable("TZ_GSZ") == "4" then
		Way.Goto("hsz");
		DoAfterSpecial(20, 'HSZ', 10);
	elseif GetVariable("TZ_GSZ") == "5" then
		Execute("TM");
		QuestOver.QuestOver();
		DoAfterSpecial(4, 'QuestOver.Check()', 12);
	elseif GetVariable("TZ_GSZ") == "9" then
		Common.CloseAllGroup();
	elseif GetVariable("TZ_GSZ") == "0" then
		DoAfterSpecial(2, 'Execute("EGA tz")', 12);
		DoAfterSpecial(2.5, 'SendNoEcho("l")', 12);
	end
end

QuestOver.PZ = function()
	if GetStatusHPUp() < GetStatusHPMax() then
		EnableTimer("pozhen_over", true);
	else
		EnableGroup("pozhen", false);
		SendNoEcho("yun recover");
		DoAfterSpecial(2, 'Way.Goto("tianzhu")', 12);
		DoAfterSpecial(2, 'EnableTimer("quest_look", true)', 12);
		DoAfterSpecial(20, "TZ", 10);
	end
	if GetVariable("TZ_GSZ") == "5" then
		QuestOver.QuestOver();
		QuestOver.Check();
	elseif GetVariable("TZ_GSZ") ~= "2" then 
		EnableTimer("quest_look", true);
	elseif GetVariable("TZ_GSZ") ~= "0" then
		Execute("EGS pozhen");
	end
end

QuestOver.GSZ = function()
	DropRubbish();
	Execute("EGS gsz");
	if GetVariable("TZ_GSZ") == "5" then
		QuestOver.QuestOver();
		DoAfterSpecial(2, 'QuestOver.Check()', 12);
	elseif GetVariable("TZ_GSZ") == "0" then
		Execute("EGA gsz");
		Execute("GSZ");
		DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	end
end

QuestOver.MZJ = function()
	Execute("EGS mzj");
	if GetVariable("TZ_GSZ") == "3" then
		DoAfterSpecial(2, 'EnableTimer("quest_look", true)', 12);
		Way.Goto("tianzhu");
		--Execute("ZD3");
		DoAfterSpecial(10, 'TZ', 10);
	elseif GetVariable("TZ_GSZ") == "5" then
		QuestOver.QuestOver();
		DoAfterSpecial(2, 'QuestOver.Check()', 12);
	elseif GetVariable("TZ_GSZ") == "0" then
		DoAfterSpecial(2, 'EnableTimer("quest_look", true)', 12);
		Execute("EGA mzj");
		Execute("MZJA");
	end
end

QuestOver.XF = function()
	DropRubbish();
	Execute("EGS xf");
	if GetVariable("TZ_GSZ") == "5" then
		QuestOver.QuestOver();
		DoAfterSpecial(2, 'QuestOver.Check()', 12);
	elseif GetVariable("TZ_GSZ") == "0" then
		Execute("EGA xf");
		Execute("XFA");
		DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	end
end

QuestOver.MRPR = function()
	DropRubbish();
	Execute("EGS mrpr");
	if GetVariable("TZ_GSZ") == "5" then
		QuestOver.QuestOver();
		DoAfterSpecial(2, 'QuestOver.Check()', 12);
	elseif GetVariable("TZ_GSZ") == "0" then
		Execute("EGA mrpr");
		Execute("MRPRA");
	end
end

QuestOver.HYD = function()
	DropRubbish();
	Execute("EGS hyd");
	if GetVariable("TZ_GSZ") == "5" then
		QuestOver.QuestOver();
		DoAfterSpecial(2, 'QuestOver.Check()', 12);
	elseif GetVariable("TZ_GSZ") == "0" then
		Execute("EGA hyd");
		Way.Goto("hyd");
		Execute("HYDA");
	end
end

QuestOver.WAT = function()
	Execute("EGS wat");
	if GetVariable("TZ_GSZ") == "5" then
		QuestOver.QuestOver();
		DoAfterSpecial(2, 'QuestOver.Check()', 12);
	elseif GetVariable("TZ_GSZ") == "0" then
		Execute("EGA wat");
		DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	end
end

QuestOver.HSZ = function()
	Execute("EGS hsz");
	if GetVariable("TZ_GSZ") == "4" then
	    Way.Goto("tianzhu");
	    DoAfterSpecial(20, 'TZ', 10);
	elseif GetVariable("TZ_GSZ") == "5" then
		QuestOver.QuestOver();
		QuestOver.Check();
	elseif GetVariable("TZ_GSZ") == "0" then
		Execute("EGA hsz");
	end
end

QuestOver.PL = function()
	if GetVariable("TZ_GSZ") == "5" then
		QuestOver.QuestOver();
		QuestOver.Check();
	elseif GetVariable("TZ_GSZ") == "9" then
		Execute("LW");
	end
end

QuestOver.YUJIE = function()
	Execute("EGS yujie");
	if GetVariable("TZ_GSZ") == "5" then
		QuestOver.QuestOver();
		QuestOver.Check();
	elseif GetVariable("TZ_GSZ") == "0" then
		Execute("EGA yujie");
		Execute("YJA");
	end
end

QuestOver.XM = function()
	Execute("EGS xm");
	if GetVariable("TZ_GSZ") == "5" then
		QuestOver.QuestOver();
		QuestOver.Check();
	end
end

QuestOver.QuestStart = function()
	DoAfterSpecial(10, 'EnableTimer("quest_look", false)', 12);
	--QuestOver.DigitStart();
end

QuestOver.QuestOver = function()
	QuestOver.DigitOver();
	--DoAfterSpecial(10, 'EnableTimer("quest_look", true)', 12);
	Note("Fullme时间".. GetStatusFullmeTime());
	--if GetStatusFullmeTime() > 25 and GetVariable("FULLME_BUFFER") ~= "" then
	--	SendNoEcho("fullme " .. GetVariable("FULLME_BUFFER"));
	--elseif GetStatusFullmeTime() > 14 and QuestOver.bFullme == false then
	--	if GetVariable("FULLME_TYPE") == "1" then
	--		SendNoEcho("fullme");
	--		QuestOver.bFullme = true;
	--	else
	--		Execute("WXSend 可以Fullme了");
	--	end
	--end
	QuestOver.nQuestTime = 0;
end

QuestOver.SetFullmeStr = function(strFullme)
	--QuestOver.strFullme = strFullme;
	--SetVariable("FULLME_BUFFER", strFullme);
	Execute("halt;fullme " .. strFullme);
end
