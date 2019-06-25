Way = Way or {};
Way.strTo = "";
Way.nIndex = 1;
Way.timerName = "tiemr_wat_next"
Way.strAreaID = "";
Way.nType = "p2p";
Way.bGotoEnd = false;
Way.bZjc = false;
Way.strPlace = "";
Way.strArea = "";
Way.nFaDaiTime = 0;
Way.bWalk = false;
Way.strBLStep = "";

Common.CreateAlias("way_next", "^W (\\S+)$", 'Way.Roll("%1")', 12, "way");
Common.CreateAlias("way_goto", "^GT (\\S+)$", 'Way.Goto("%1")', 12, "way");
Common.CreateAlias("way_goton", "^GTN (\\S+)$", 'Way.Goto("%1", false)', 12, "way");
Common.CreateTrigger("way_next_trigger", '^系统回馈：WALK_FINISH = 0$', 'Way.Next()', 12, "way", 1, true);
Common.CreateTrigger("way_over_trigger", "^系统回馈：WALK_FINISH = 1$", 'Way.NoWay()', 12, "way", 1, true);
Common.CreateTrigger("way_not_found", '^系统回馈：no_more = not_found$', 'Way.ChangePlaceCheck()', 12, "way", 1, true);
--Common.CreateTrigger("way_over", '^系统回馈：no_more = walkend$', 'Common.InstanceRun(Way.Continue, 5);', 12, "way", 1, true);
Common.CreateTrigger("way_gt_trigger", "^系统回馈：StartGT = 0$", 'Way.Clear()', 12, "way", 1, true);
Common.CreateTrigger("way_here_trigger", "^系统回馈：YOU_ARE_HERE = 0$", 'Way.GotoEnd()', 12, "way", 1, true);
Common.CreateTrigger("way_place", "^(\\S+) - .*$", 'Way.SetPlace("%1")', 12, "way", 1);
Common.CreateTrigger("way_area", "^【(.*)】$", 'Way.strArea = "%1"', 12, "way", 1);
Common.CreateTrigger("way_ry_lou", "^你身上背的东西太多，竹篓负担不下。$", 'Common.InstanceRun(Way.EnterRyLou, 4)', 12, "way", 1);
Common.CreateTimerFunc("way_fadai_timer", 0, 1, "Way.FadaiTimer()", 0, "way");
Common.CreateTrigger("way_walk_start", '^系统回馈：WALK = START$', 'Way.SetWalkStatus(true)', 12, "way", 1, true);
Common.CreateTrigger("way_walk_over", '^系统回馈：WALK = OVER$', 'Way.SetWalkStatus(false)', 12, "way", 1, true);
Common.CreateTrigger("way_walk_bl", '^系统回馈：WALK_BL = (.*)$', 'Way.WalkBL("%1")', 12, "way", 1, true);
--DeleteTrigger("way_walk_OVER");


Way.SetPlace = function(strPlace)
	Way.strPlace = strPlace;
	Way.nFaDaiTime = 0;
	DeleteTimer("way_walk_continue");
	Common.CreateTimer("way_walk_continue", 0, 10, "Way.WalkContinue", true);
	DeleteTimer("way_walk_continue_bl");
end

Way.SetWalkStatus = function(bStatus)
	Way.bWalk = bStatus;
end

Way.WalkContinue = function()
	if Way.bWalk == true and string.find(Way.strPlace, "船") == nil then
		Execute("wkc");
	end
	DeleteTimer("way_walk_continue");
end

Way.WalkBL = function(strStep)
	Way.strBLStep = strStep;
	Common.CreateTimer("way_walk_continue_bl", 0, 10, "Way.WalkContinueBL", true);
end

Way.WalkContinueBL = function()
	Send(Way.strBLStep);
end

Way.ChangePlaceCheck = function()
	if string.find(Way.strPlace, "长江") or string.find(Way.strPlace, "黄河") then
		Send(Battle.strExit);
		DoAfterSpecial(2, 'wkc', 10);
	elseif Way.strPlace == "鸡笼山下" then
		SendNoEcho("n");
		DoAfterSpecial(2, 'wkc', 10);
	elseif Way.strPlace == "兰山脚下" then
		SendNoEcho("wd");
		DoAfterSpecial(2, 'wkc', 10);
	elseif Way.strPlace == "小村" then
		SendNoEcho("ed");
		DoAfterSpecial(2, 'wkc', 10);
	elseif Way.strPlace == "小胡同" then
		SendNoEcho("w");
		DoAfterSpecial(2, 'wkc', 10);
	elseif Way.strPlace == "烟花铺" then
		SendNoEcho("w");
		DoAfterSpecial(2, 'wkc', 10);
	elseif Way.strPlace == "小路" then
		SendNoEcho("w");
		DoAfterSpecial(2, 'wkc', 10);
	elseif Way.strPlace == "五泉山东麓" then
		SendNoEcho("eu");
		DoAfterSpecial(2, 'wkc', 10);
	elseif Way.strPlace == "大沙漠" then
		SendNoEcho("e");
		DoAfterSpecial(2, 'wkc', 10);
	elseif Way.strPlace == "黑沼" then
		Execute("ROAD_HZ_OUT");
		DoAfterSpecial(2, 'wkc', 10);
	else
		Way.WKCTrigger()
	end
end

Way.WKCTrigger = function()
	DoAfterSpecial(1, 'Common.InstanceRun(Way.WKC, 3)', 12);
end

Way.FadaiTimer = function()
	--if GetVariable("TZ_GSZ") ~= "5" or Battle.bBattle == true then return; end
	--Way.nFaDaiTime = Way.nFaDaiTime + 1;
	--if Way.nFaDaiTime > 30 then
	--	Way.nFaDaiTime = 0;
	--	Execute("wkc");
	--end
end

Way.LocationArea = function()
	Way.strArea = "";
	SendNoEcho("localmaps");
	SendNoEcho("look");
	SendNoEcho("look");
	SendNoEcho("look");
	SendNoEcho("look");
	SendNoEcho("look");
end

Way.Clear = function(bQuick)
	Way.strTo = "";
	Way.strAreaID = "";
	Way.nIndex = 1;
	Way.nType = "";
	Way.bZjc = false;
	Way.bGotoEnd = true;
	Way.bStoped = false;
	Way.nType = "over";
	DeleteTimer(Way.timerName);
	if bQuick == nil or bQuick == 1 then
		Execute("quickon");
	end
end
Way.Clear();

Way.Roll = function(strToID)
	Way.Clear();
	Way.nType = "p2p";
	Way.strTo = strToID;
	Way.Step();
end

Way.Goto = function(strToID, bNext)
	if strToID == nil then return; end
	if Way.strTo ~= "" then
		Execute("wks");
	end
	Way.nType = "g2p";
	Way.bGotoEnd = false;
	Way.strTo = strToID;
	if bNext ~= nil then
		Way.nType = "p2p";
		if bNext == true then
			Way.nIndex = 1;
		else
			Way.nIndex = 0;
		end
	end
	if string.sub(strToID, 1, 4) == "btsg" then
		Way.Clear();
		return;
	elseif string.sub(strToID, 1, 3) == "zjc" and false then
		DoAfterSpecial(1, 'Execute("gtn bjtzc")', 12);
		Way.bZjc = true;
	else
		Way.bZjc = false;
		DoAfterSpecial(1, 'Execute("gtn " .. Way.strTo)', 12);
	end
	--SelectCommand();
	--PasteCommand("gtn " .. Way.strTo);
	--SelectCommand();
	Common.Info("gt " .. Way.strTo);
end

Way.GotoCH = function(strArea, bNext)
	local tPlace = Location.GetPlace_Test(strArea);
	local strID = Name.TrancelateLocate(tPlace.area..tPlace.room);
	Way.Goto(strID, bNext);
	SetVariable("Q_location", strArea);
end

Way.To = function(strFromID, strToID, bNext)
	Way.Clear();
	Way.nType = "p2p";
	if Way.strTo ~= "" then
		Execute("wks");
	end
--	Way.strFrom = strFromID;
	Way.strTo = strToID;
	if bNext ~= nil then
		Way.nIndex = 0;
		Way.nType = "g2p";
		Way.bGotoEnd = bNext;
	end
	--Execute(strFromID .. "," .. Way.strTo);
	if strFromID ~= nil and strFromID ~= "" then
		Execute(strFromID .. "," .. Way.strTo)
	else
		Execute("gt " .. Way.strTo)
	end
	Common.Info(strFromID .. "," .. Way.strTo);
	--SelectCommand();
	--PasteCommand(strFromID .. "," .. Way.strTo);
	--SelectCommand();
end

Way.GotoContinue = function()
	--if Way.strTo == nil or Way.strTo == "" then return; end
	--if Way.nIndex > 1 then return; end
	Execute("wks");
	DoAfterSpecial(0.5, "wkc", 10);
	--Execute("gtn " .. Way.strTo);
	--Way.bGotoEnd = false;
end

Way.GotoEnd = function()
	DeleteTimer(Way.timerName);
	Way.bGotoEnd = true;
end

Way.Aim = function(strToID, bNext)
	return Way.To(Way.GetNowID(), strToID, bNext);
end

Way.From = function(strFromID)
	if strFromID == "bjtzc" then
		Way.bZjc = false;
	end
	if strFromID ~= "" and Way.strTo ~= "" then
		if GetVariable("Q_name") == "天珠" then
			return Way.To(strFromID, Way.strTo, false);
		else
			return Way.To(strFromID, Way.strTo);
		end
	end
end

Way.Next = function()
	--Note(Way.nType .. " : " .. Way.strTo .. " : " .. Way.nIndex);
	if Way.bZjc == true then
		Execute("JINGGONG");
	end
	if Way.nType == "p2p" and Way.strTo ~= "" and Way.nIndex > 0 then
		if GetVariable("Q_name") == "天珠" then
			Common.CreateTimer(Way.timerName, 0, 10, "Way.Step", true);
		else
			Common.CreateTimer(Way.timerName, 0, 0.4, "Way.Step", true);
		end
	elseif Way.nType == "g2p" and Way.bGotoEnd == false then
		Execute("gtn " .. Way.strTo);
		Common.InstanceRun(Way.Continue, 2);
		--Common.CreateTimer(Way.timerName, 0, 2, "Way.GotoContinue", true);
	end
end

Way.Continue = function()
	Common.CreateTimer(Way.timerName, 0, 2, "Way.GotoContinue", true);
end

Way.Step = function()
	local nBuffer = Way.nIndex;
	Way.nIndex = Way.nIndex+1;
	local strFrom = Way.strTo;
	if nBuffer ~= 1 then
		strFrom = strFrom .. nBuffer;
	end
	if GetVariable("Q_name") ~= "天珠" then
		Execute("quickoff");
	end
	Execute(strFrom .. "," .. Way.strTo .. Way.nIndex);
end

Way.Finish = function()
	Execute("quickon");
	DeleteTimer(Way.timerName);
	Way.nType = "over";
end

Way.NoWay = function()
	if Way.nIndex == 0 then return; end
	Execute("quickon");
	Way.nIndex = 0;
end

Way.GetNowID = function()
	local strFrom = Way.strTo;
	if Way.nIndex ~= 1 then
		strFrom = strFrom .. Way.nIndex;
	end
	Way.Clear();
	return strFrom;
end

Way.SetAreaID = function(strID)
	Way.strAreaID = strID;
end

--------
--拦路--
--------
Common.CreateAlias("way_lanluon", "^lanluon$", 'EnableTrigger("way_blocker_check", true)', 12, "way");
Common.CreateAlias("way_lanluoff", "^lanluoff$", 'EnableTrigger("way_blocker_check", false)', 12, "way");
Common.CreateTrigger("way_blocker_check", "^(.+)$", 'Way.Stoped("%1")', 12, "way", 1);
Way.tStoped = nil;
Way.bStoped = false;
Way.Stoped = function(strDiscribe)
	Way.tStoped = Way.tBlockers[strDiscribe];
	if Way.tStoped ~= nil then
		Note("被挡路");
		Execute("wks");
		--Execute("bl back");
		Way.GotoEnd();
		Way.bStoped = true;
		if string.find(Way.tStoped.id, "gtn ") then
			Execute(Way.tStoped.id);
		else
			SendNoEcho("killall " .. Way.tStoped.id);
		end
	end
end
Way.StopedOverCheck = function()
	if Way.tStoped ~= nil then
		Way.tStoped = nil;
		DoAfterSpecial(2, "wkc", 10);
	end
end

Way.tRecodes = {};
Way.RecodeClear = function()
	Way.tRecodes = {};
end

Way.Recode = function(strToward)
	table.insert(Way.tRecodes, strToward);
end

Way.Reback = function()
	if table.getn(Way.tRecodes) == 0 then return; end
	local strRoad = "";
	for i = #Way.tRecodes, 1, -1 do
		if i ~= table.getn(Way.tRecodes) then
			strRoad = strRoad .. ";";
		end
		strRoad = strRoad .. Location.Revert[Way.tRecodes[i]];
	end
	Execute(strRoad);
	Way.RecodeClear();
end

Way.strFindTimeName = "way_find_step";
Way.strFindRebackName = "way_find_reback";
Way.strFindBackName = "way_find_back";
Way.nFindIndex = 1;
Way.bStart = false;
Way.strBack = "";
Way.tFindSteps = {"west","east","north","south","southup","southdown","westup","westdown","eastup","eastdown","northup","northdown","northwest","northeast","southwest","southeast","enter","out","up","down"};
Way.strExits = "";
DeleteTrigger(Way.strFindRebackName);
DeleteTimer(Way.strFindTimeName);
DeleteTimer(Way.strFindBackName);
Way.SetExits = function(strExits)
	Battle.Exits(strExits);
	Way.strExits = Way.ExitFix(strExits);
end
Way.FindStart = function()
	--Way.nFindIndex = 1;
	--Note("遍历:" .. Way.strExits);
	--Way.tFindSteps = utils.split(Way.strExits,";");
	--Way.FindWalk();
	--Common.CreateTimer(Way.strFindTimeName, 0, 2, "Way.FindStep");
	--Way.bStart = false;
	DoAfterSpecial(1, "sdbl 1 天珠", 10);
end
Way.FindWalk = function()
	--Note("走" .. Way.nFindIndex);
	if Way.tFindSteps[Way.nFindIndex] == nil or Way.tFindSteps[Way.nFindIndex] == "" then
		Way.FindStop();
		return;
	end
	Way.bStart = true;
	Common.CreateTrigger(Way.strFindRebackName, "^\\S+\\s-\\s$", 'Way.FindCanback()', 12, "way", 1);
	SendNoEcho(Way.tFindSteps[Way.nFindIndex]);
end
Way.FindCanback = function()
	DeleteTrigger(Way.strFindRebackName);
	Common.CreateTimer(Way.strFindBackName, 0, 0.5, "Way.FindReback", true);
	--Way.strBack = Location.Revert[Way.tFindSteps[Way.nFindIndex]];
end
Way.FindReback = function()
	Way.bStart = false;
	--Note("回" .. Way.nFindIndex);
	DeleteTrigger(Way.strFindRebackName);
	SendNoEcho(Location.Revert[Way.tFindSteps[Way.nFindIndex]]);
end
Way.FindStep = function()
	DeleteTrigger(Way.strFindRebackName);
	Way.nFindIndex = Way.nFindIndex + 1;
	if Way.nFindIndex <= table.getn(Way.tFindSteps) then
		Way.FindWalk();
	else
		Way.FindStop();
	end
end
Way.FindStop = function()
	DeleteTimer(Way.strFindTimeName);
	DeleteTimer(Way.strFindBackName);
end
Way.FindOver = function()
--	if Way.bStart then
--		SendNoEcho(Location.Revert[Way.tFindSteps[Way.nFindIndex]]);
--	end
	DeleteTrigger(Way.strFindRebackName);
end

Way.Look = function()
	SendNoEcho("l");
end

Way.strBianliTimeName = "way_bianli_step";
Way.nBianliIndex = 1;
Way.t = nil;
Way.tBianli = {};
Way.tBianli["ad"] = "enter shudong;say 天堂有路你不走;down;1;n;n;s;nw;nw;nw;n;nw;se;s;se;se;se;s;s;2;ne;ne;sw;sw;sw;3;ne;ne;sw;sw;sw;4;w;w;e;e;e;5;sw;sw;ne;ne;ne;7;n;ne;ne;n;s;sw;sw;s;s;9;sw;s;sw;sw;nw;se;sw;ne;ne;ne;n;ne;e";
Way.BianliStart = function(strTag)
	Way.t = Way.tBianli[strTag];
	Way.nBianliIndex = 1;
	if Way.t ~= nil then
		Way.t = Common.Split(Way.t,';');
		Common.CreateTimer(Way.strBianliTimeName, 0, 1, "Way.BianliStep");
	end
end
Way.BianliStep = function()
	if Way.t == nil then return; end
	if Way.nBianliIndex <= table.getn(Way.t) then
		Execute(Way.t[Way.nBianliIndex]);
	else
		Way.t = nil;
		--SendNoEcho("set Way_Bianli_Finish 0");
		Note("遍历完成")
	end
	Way.nBianliIndex = Way.nBianliIndex + 1;
end
Way.BianliStop = function()
	DeleteTimer(Way.strBianliTimeName);
end
Way.BianliOver = function()
	if Way.t ~= nil then
		Common.CreateTimer(Way.strBianliTimeName, 0, 0.1, "Way.BianliStep", true);
	end
end
Way.BianliClear = function()
	Way.BianliStop();
	Way.t = nil;
end

Way.ExitFix = function(strExit)
        strExit = Replace(strExit, "、", ";", ture);
	strExit = Replace(strExit, " 和 ", ";", ture);
	strExit = Replace(strExit, "。", ";", ture);
        strExit = Replace(strExit, " ", "", ture);
	local tNewExits = {};
        local tExits = utils.split(strExit,";");
        local tFullExits = {"up","down","south","east","west","north","southup","southdown","westup","westdown","eastup","eastdown","northup","northdown","northwest","northeast","southwest","southeast","enter","out"}
        for i = 1, table.getn(tFullExits) do
               for j = 1, table.getn(tExits) do
                     if string.len(tFullExits[i]) == string.len(tExits[j]) then
                           local strRightExit = tFullExits[i]
                           local strCheckExit = tExits[j]
			   for o = 1,string.len(strRightExit) do
				if string.find(strRightExit, string.sub(tExits[j],o,o)) then
                                      strCheckExit = string.gsub(strCheckExit, string.sub(tExits[j],o,o), "")
                                end
                           end
                           if strCheckExit == "" then
				table.insert(tNewExits, strRightExit);
			   end
                     end
               end
        end

	local strCorrectExit = "";
	for i, v in pairs(tNewExits) do
	     strCorrectExit = strCorrectExit .. tNewExits[i] .. ";"
	end

        return strCorrectExit;
end

Way.CantArrive = function(strID)
	for i,v in pairs(Way.tCantArrive) do
		if strID == v then
			return true;
		end
	end
	if Common.id == "suinegy" and strID ~= "mzhgsmz" and string.find(strID, "mzh") == 1 then
		return true;
	end
	return false;
end

Way.WKC = function()
	Execute("wkc");
end

--------------
--找周围item--
--------------
Common.CreateAlias("Way_FindItem_Way", "^WF (\\S+)$", 'Way.FindItemWay("%1")', 12, "way");
Common.CreateAlias("Way_FindItem_WayGT1", "^WFGT (\\S+) (\\S+)$", 'Way.FindItemWayGT("%1", "%2", "")', 12, "way");
Common.CreateAlias("Way_FindItem_WayGT2", "^WFGT (\\S+) (\\S+) (\\S+)$", 'Way.FindItemWayGT("%1", "%2", "%3")', 12, "way");
Common.CreateTrigger("way_out_find", "^\\s*这里(明显|唯一)的(方向|出口)(是|有)(.*)$|^\\s*这里没有任何明显的出路\\w*$", 'Way.SetExits("%4");', 12, "way", 1);

DeleteTrigger("way_finditem_record");
DeleteTrigger("way_finditem_toward");
DeleteTrigger("way_finditem_check");
Way.strFindItemWay = "";
Way.strFindItemWayBuffer = "";
Way.strFindItemWay2 = "";
Way.strFindItemWay3 = "";
Way.strFindItemName = "";
Way.strFindItemNo1 = "";
Way.strFindItemNo2 = "";
Way.strFindItemBuffer = "";
Way.strFindItemBuffer2 = "";
Way.bFindItemRandom = false;
Way.bFindItemBlack = false;
Way.bFindItemBlack2 = false;
Way.bFindItemGt = false;
Way.bEscapeWay = "";
Way.bFindEscapeWay = false;

Way.Look = function()
	local bWay = "TRUE";
	if Way.bFindEscapeWay == false then bWay = "FALSE"; end
	Note("Way.Look测试:Item:" .. Way.strFindItemNo1 .. ":Escape:" .. bWay);
	if Way.strFindItemNo1 ~= "" and Way.bFindEscapeWay == false then
		SendNoEcho("drop 1 coin");
	end
	if Way.bFindItemGt == true then
		Execute("wks");
	end
	local tExits = utils.split(Way.strExits,";");
	for i,v in pairs(tExits) do
		if v ~= "" then
			SendNoEcho("say FIND_WAY " .. v);
			SendNoEcho("l " .. v);
		end
	end
	SendNoEcho("say FIND_WAY OVER");
end

Way.FindItemWay = function(strItem)
	Way.bFindItemGt = false;
	Way.bFindItemRandom = false;
	Way.bFindEscapeWay = false;
	Way.FindItemWayN(strItem, "", "");
end

Way.FindItemWayGT = function(strItem, strNo1, strNo2)
	Way.bFindItemGt = true;
	Way.bFindEscapeWay = false;
	Way.bFindItemRandom = false;
	Way.FindItemWayN(strItem, strNo1, strNo2);
end

Way.FindItemWayRandom = function(strItem, strNo1, strNo2)
	Way.bFindItemGt = false;
	Way.bFindEscapeWay = false;
	Way.bFindItemRandom = true;
	Way.FindItemWayN(strItem, strNo1, strNo2);
end

Way.FindWayEscape = function(strItem)
	Way.bEscapeWay = "";
	Way.bFindEscapeWay = true;
	Way.FindItemWayN("-", strItem, "");
end

Way.FindItemWayN = function(strItem, strNo1, strNo2)
	Way.strFindItemWay = "";
	Way.strFindItemWay2 = "";
	Way.strFindItemWay3 = "";
	Way.strFindItemName = strItem;
	Way.strFindItemNo1 = strNo1;
	Way.strFindItemNo2 = strNo2;
	Way.strFindItemBuffer = "";
	Way.strFindItemBuffer2 = "";
	Way.bFindItemBlack = false;
	Way.bFindItemBlack2 = false;
	EnableTrigger("way_out_find", false);
	Common.CreateTriggerFunc("way_finditem_record", "^.+$", "Way.FindItemRecord", "way");
	Common.CreateTrigger("way_finditem_toward", "^你说道：「FIND_WAY (\\S+)」$", 'Way.FindItemToward("%1")', 12, "way", 1);
	Way.Look();
end

Way.FindItemToward = function(strFind)
	if strFind == "OVER" then
		EnableTrigger("way_out_find", true);
		DeleteTrigger("way_finditem_record");
		DeleteTrigger("way_finditem_toward");
		if Way.bFindEscapeWay == true and Way.strFindItemWayBuffer ~= "" and Way.strFindItemWay == "" then
			Way.strFindItemWay = Way.strFindItemWayBuffer;
		elseif Way.bFindItemRandom == true then
			if Way.strFindItemWayBuffer ~= nil and Way.strFindItemWayBuffer ~= "" and (Way.strFindItemWay == "" or Way.strFindItemWay == nil) then
				Way.strFindItemWay = Way.strFindItemWayBuffer;
			elseif Way.strFindItemWayBuffer2 ~= nil and Way.strFindItemWayBuffer2 ~= "" and (Way.strFindItemWay == "" or Way.strFindItemWay == nil) then
				Way.strFindItemWay = Way.strFindItemWayBuffer2;
			end
		end
		if Way.strFindItemWay ~= "" or Way.strFindItemWay2 ~= "" or Way.strFindItemWay3 ~= "" then
			if Way.bFindEscapeWay == true then
				if Way.strFindItemWay ~= "" then
					Way.bEscapeWay = Way.strFindItemWay;
					Note("找到合适出口:" .. Way.bEscapeWay);
				else
					Note("=========警告::未找到合适出口==========");
				end
			else
				Common.CreateTrigger("way_finditem_check", "^你不忙$", "Way.FindItemAction()", 12, "way", 1);
				SendNoEcho("checkbusy");
				Common.CreateTimer("Way_FindItem_Check", 0, 1, "Way.FindItemCheck");
			end
		end
	elseif strFind ~= nil and strFind ~= "" then
		if Way.bFindItemRandom == true then
			if Way.strFindItemWayBuffer ~= "" and (Way.strFindItemWay == "" or Way.strFindItemWay == nil) then
				Way.strFindItemWay = Way.strFindItemWayBuffer;
			elseif Way.strFindItemWayBuffer2 ~= "" and (Way.strFindItemWay == "" or Way.strFindItemWay == nil) then
				Way.strFindItemWay = Way.strFindItemWayBuffer2;
			end
		else
			if Way.strFindItemBuffer ~= nil and Way.bFindItemBlack == false and Way.strFindItemBuffer ~= "" and Way.strFindItemNo1 ~= "" then
				Way.strFindItemWay2 = Way.strFindItemBuffer;
			elseif Way.strFindItemBuffer ~= nil and Way.bFindItemBlack2 == false and Way.strFindItemBuffer ~= "" and Way.strFindItemNo2 ~= "" then
				Way.strFindItemWay3 = Way.strFindItemBuffer;
			end			
			if (Way.bFindEscapeWay == true or Way.bFindItemRandom == true) and Way.strFindItemWayBuffer ~= "" and Way.strFindItemWayBuffer ~= nil then
				Way.strFindItemWay = Way.strFindItemWayBuffer;
			end
		end
		Way.strFindItemWayBuffer = "";
		Way.strFindItemBuffer = strFind;
		Way.bFindItemBlack = false;
		Way.bFindItemBlack2 = false;
	end
end

Way.FindItemRecord = function(strName, strLine, tWord, tStyles)
	if Way.bFindEscapeWay == true then
		if strLine.find(strLine, "锦江 -") or strLine.find(strLine, "城墙 -") or strLine.find(strLine, "西湖 -") then
			Way.bFindItemBlack = true;
			Way.strFindItemWayBuffer = "";
		elseif Way.strFindItemNo1 ~= "" and strLine.find(strLine, Way.strFindItemNo1) then
			Way.bFindItemBlack = true;
			Way.strFindItemWayBuffer = "";
		elseif Way.strFindItemNo2 ~= "" and strLine.find(strLine, Way.strFindItemNo2) then
			Way.bFindItemBlack = true;
			Way.bFindItemBlack2 = true;
			Way.strFindItemWayBuffer = "";
		elseif Way.bFindItemBlack == false and Way.bFindItemBlack2 == false and Way.strFindItemWay == "" and strLine.find(strLine, Way.strFindItemName) then
			Way.strFindItemWayBuffer = Way.strFindItemBuffer;
		end
	elseif Way.bFindItemRandom == true then
		if Way.strFindItemNo1 ~= "" and strLine.find(strLine, Way.strFindItemNo1) then
			Way.bFindItemBlack = true;
			Way.strFindItemWayBuffer = "";
			Way.strFindItemWayBuffer2 = ""
		elseif Way.bFindItemBlack == false and Way.strFindItemNo2 ~= "" and strLine.find(strLine, Way.strFindItemNo2) then
			Way.bFindItemBlack2 = true;
			Way.strFindItemWayBuffer2 = Way.strFindItemBuffer;
		elseif Way.bFindItemBlack == false and Way.strFindItemWay == "" and strLine.find(strLine, Way.strFindItemName) then
			Way.strFindItemWayBuffer = Way.strFindItemBuffer;
		end
	else
		if strLine.find(strLine, "锦江 -") or strLine.find(strLine, "城墙 -") or strLine.find(strLine, "西湖 -") or strLine.find(strLine, "北里湖 -") then
			Way.bFindItemBlack = true;
		elseif Way.strFindItemWay == "" and strLine.find(strLine, Way.strFindItemName) then
			Way.strFindItemWay = Way.strFindItemBuffer;
		elseif Way.strFindItemNo1 ~= "" and strLine.find(strLine, Way.strFindItemNo1) then
			Way.bFindItemBlack = true;
		elseif Way.strFindItemNo2 ~= "" and strLine.find(strLine, Way.strFindItemNo2) then
			Way.bFindItemBlack = true;
			Way.bFindItemBlack2 = true;
		end
	end
end

Way.FindItemCheck = function()
	if Battle.bBattle == false then
		SendNoEcho("checkbusy");
	end
end

Way.FindItemAction = function()
	DeleteTimer("Way_FindItem_Check");
	Note("找路:");
	Note(Way.strFindItemWay);
	if Way.strFindItemWay ~= "" and Way.strFindItemWay ~= nil then
		if Way.bFindItemRandom == true then
			Note("随机走:" .. Way.strFindItemWay);
		end
		Send(Way.strFindItemWay);
		SendNoEcho("response WALK_STEP 1");
	elseif Way.strFindItemWay2 ~= "" then
		Send(Way.strFindItemWay2);
	elseif Way.strFindItemWay3 ~= "" then
		Send(Way.strFindItemWay3);
	end
	Way.strFindItemWay = "";
	Way.strFindItemWay2 = "";
	Way.strFindItemWay3 = "";
	if Way.bFindItemGt == true then
		Way.bFindItemGt = false;
		DoAfterSpecial(0.1, 'wkc', 10);
		Note("继续走");
	end
	DoAfterSpecial(0.1, 'DeleteTrigger("way_finditem_check");', 12);
end

Way.TryBl = function()
	--Note("当前:" .. Way.strPlace .. " ;需要:" .. Way.strBlPlaceName[GetVariable("BL_PLACE")]);
	if Way.strPlace == Way.strBlPlaceName[GetVariable("BL_PLACE")] then
		Common.InstanceRun(Way.BLAction, 5);
		return true;
	end
	return false;
end

Way.BLAction = function()
	DoAfterSpecial(2, 'Execute("BL")', 12);
end

Way.TryBlW = function()
	Note("当前:" .. Way.strPlace .. " ;需要:" .. Way.strBlPlaceName[GetVariable("BL_PLACE")]);
	if Way.strPlace == Way.strBlPlaceName[GetVariable("BL_PLACE")] then
		Common.InstanceRun(Way.BLWAction, 5);
		return true;
	end
	return false;
end

Way.BLWAction = function()
	DoAfterSpecial(2, 'Execute("BLW")', 12);
end

Way.EnterRyLou = function()
	SendNoEcho("drop silver");
	SendNoEcho("enter lou");
end