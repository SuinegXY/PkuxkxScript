-------------------------------------
--              护镖               --
-------------------------------------


HuBiao = {}

HuBiao.id = "";
HuBiao.place = "";
HuBiao.kill = true
HuBiao.go = true
HuBiao.over = false
HuBiao.robberMove = false
HuBiao.stop = false
HuBiao.areaId = ""

HuBiao.Clear = function()
	HuBiao.id = "";
	HuBiao.place = "";
	HuBiao.kill = true
	HuBiao.go = true
	HuBiao.over = false
	HuBiao.robberMove = false
	HuBiao.areaId = "";
end

HuBiao.Aliase = function(param)
	if param == "s" then
		Common.CloseAllGroup();
		EnableGroup("hubiao", true);
		SendNoEcho("ask zuo about job");
		Execute("gancheon");
		Execute("pathon");
	elseif param == "d" then
		Execute("gt szclbj")
	elseif param == "x" then
		HuBiao.robberMove = false
		Execute("wkg")
	elseif param == "b" then
		Execute("gt szclbj");
	end
end

HuBiao.RobberMove = function()
	Note("===========================")
	Note("=======镖被动,需修复=======")
	Note("===========================")
	Execute("wks")
	DeleteTimer("HUBIAO_ROBBER_SEARCH")
	HuBiao.robberMove = true
end

HuBiao.Stop = function()
	Execute("wks")
	DeleteTimer("HUBIAO_ROBBER_SEARCH")
	HuBiao.robberMove = true
end

HuBiao.AcceptFail = function()
	HuBiao.place = "";
end

HuBiao.Init = function(area, place, name)
	Common_StatusClear();
	HuBiao.Clear();
	local tPlace = Location.GetPlace_Test(place);
	Common.SetID(Name.TrancelateName(name));
	Common.FindAgain();
	SetVariable("Q_status", name);
	SetVariable("Q_name", tPlace.area);
	SetVariable("Q_misc2", area);
	Common.CreateTimer("hubiao_find", 0, 15, "HuBiao.Find");
end

HuBiao.Find = function(strName)
	Common.SetID(Name.TrancelateName(strName));
	Common.FindAgain();
end

HuBiao.Goto = function(strPlace)
	DeleteTimer("hubiao_find");
	local tPlace = Location.GetPlace_Test(strPlace);
	HuBiao.areaId = Name.TrancelateLocate(tPlace.area..tPlace.room);
	SetVariable("Q_place", strPlace);
	DoAfterSpecial(0.5, 'Execute("gt " .. HuBiao.areaId)', 12);
	SelectCommand();
	PasteCommand("gtn " .. HuBiao.areaId);
	SelectCommand();
end

HuBiao.GotoID = function(strID)
	HuBiao.areaId = strID;
	Execute("gt " .. HuBiao.areaId);
end

HuBiao.RobberAppear = function()
	Execute("wks");
	SendNoEcho("yun xinjing");
	HuBiao.RobberSearch();
end

HuBiao.RobberSearch = function()
	SendNoEcho("shou " .. Common.id .. " robber");
end

HuBiao.Continue = function()
	--if HuBiao.areaId ~= "" then
	--	Execute("gt " .. HuBiao.areaId);
	--end
end

HuBiao.RobberFinded = function()
	Execute("wks");
	DeleteTimer("HUBIAO_ROBBER_SEARCH");
	HuBiao.go = false;
	--Send("hit suineg robber");
	--SendNoEcho("shou " .. Common.id .. " robber");
end

HuBiao.Finish = function()
	Execute("pathoff");
	Execute("gancheoff");
	HuBiao.over = true;
	HuBiao.place = "";
	Execute("gt szclbj");
end

HuBiao.AskLin = function()
	if HuBiao.over == true then
		HuBiao.over = false;
		Send("ask zuo about 完成");
		Execute("EGS hubiao");
	end
end

HuBiao.Try = function()
	if HuBiao.place == "" then
		DoAfterSpecial(2, 'SendNoEcho("l")', 12);
	end
end

-------------------------------------
--            护镖other            --
-------------------------------------
HuBiao.nOtherDigit = 0;
HuBiao.nOtherDigitAll = 0;
HuBiao.AddTime = function()
	HuBiao.nOtherDigit = HuBiao.nOtherDigit + 1;
	Note("====已完成 " .. HuBiao.nOtherDigitAll .. " 轮护镖,当前第 " .. HuBiao.nOtherDigit .. "轮 ====");
end
HuBiao.CheckTime = function()
	HuBiao.nOtherDigitAll = HuBiao.nOtherDigitAll + 1;
	Note("====已完成 " .. HuBiao.nOtherDigit .. " 轮护镖====");
	if HuBiao.nOtherDigit > 10 then
		SendNoEcho("ask zuo about 重置任务");
		HuBiao.nOtherDigit = 0;
	end
end

HuBiao.CreateHelper = function()
	Common.CreateTimer("HuBiaoForOther", 0, 5, "HuBiao.ForOtherFindAgain");
end

HuBiao.ForOtherFindAgain = function()
	local strID = GetVariable("HB_id");
	SendNoEcho("shou " .. strID .. " robber");
end

HuBiao.DeleteHelper = function()
	DeleteTimer("HuBiaoForOther");
end

HuBiao.CreateHelperLong = function()
	Common.CreateTimer("HuBiaoForOther_Long", 1, 0, "HuBiao.ForOtherFindAgain");
end

HuBiao.DeleteHelperLong = function()
	DeleteTimer("HuBiaoForOther_Long");
end

HuBiao.InitOther = function(str1, str2)
	local HB_start=GetVariable("HB_start")
	local t={}
	local p={}

	t[1]="归云庄太湖街1"
	p[1]="s;s;w;n;n;n;nu;nw;nw;n;n;n;n;n;n;n;nw;w;w;w;w;w;w;nw;ne;se;n;w;n;e;e;e;e;e;s;s;s;n;n;n;nu;nu;sd;sd;e;n;s;s;e;w;n;e;s;n;n;u;d;s;e;e"

	t[2]="嘉兴陆家庄大厅"
	p[2]="s;s;w;n;n;n;nu;nw;nw;n;n;w;e;s;sw;w;nw;se;e;sw;e;w;s;enter;enter;s"

	t[3]="泉州当铺"
	p[3]="s;s;w;n;n;n;nu;nw;nw;s;nw;n;nw;n;s;se;s;se;s;s;e;n;s;s;n;ne;ne;ne;n;w;e;n;ne;ne;sw;sw;s;s;sw;sw;sw;ed;n;s;s;n;wu;w;s;s;e;w;n;n;w;s;n;n;s;nw;w"

	t[4]="嘉兴钱庄"
	p[4]="s;s;w;n;n;n;nu;nw;nw;n;sw;w;nw;se;e;sw;e;w;s;n;ne;ne;e;s;n;w;n;w;nu;sd;e;n;n;n;s;s;s;e;n;s;e;w;s;n;se;s;u;enter;out;d;n;ne;e;ne;ne;sw;sw;w;sw;nw;nd;w;e;e;e;e;e;n;s;s;s;se"

	t[5]="岳王墓墓前广场"
	p[5]="s;s;w;n;n;n;nu;nw;nw;e;n;n;s;e;s;n;ne;n;n;nw;ne;sw;se;s;s;e;e;e"

	t[6]="江州天福镖局"
	p[6]="s;s;w;n;n;n;nu;nw;nw;s;nw;n;nw;n;n;n;n;n;n;n;nw;nd;n;n;n;n;n;n;e;s;n;ne;se;nw;nw;w;e;se;ne;ne;sw;sw;sw;w;w;enter;w;e;e;w;out;e;n;s;s;s;e;e;w;w;s;e;w;s;n;w;n;n;s;sw;ne;ne;n;s;s"

	t[7]="临安府江南钱庄"
	p[7]="s;s;w;n;n;n;nu;nw;nw;sw;w;sw;w;w;w;n;s;s;sw;w;se;nw;s;s;n;n;out;enter;w;e;sw;u;d;w;w;e;nw;e;n;s;e;n;s;e;e;n;w;e;n;w"

	t[8]="牙山小荒地"
	p[8]="s;s;w;n;n;n;nu;nw;nw;n;n;e;se;ne;e;ne;ne;e;e;e;e;e;e;n;s;s;n;e;s;s;s;n;w;e;e;w;n;w;e;e;w;n;e;n;s;e;n;s;e;w;w;w;n;w;e;e;w;n"

	t[9]="南昌飞虎镖局"
	p[9]="s;s;w;n;n;n;nu;nw;nw;s;nw;n;nw;n;n;n;n;n;e;w;w;e;n;n;nw;nd;n;s;e;sw;se;s;s;s;e;n;s;s;enter;w;e;e;w;out;n;e;e;eu;wd;w;w;w;w;n;s;s;n;w;w;wu;wu;wu;nd;nd;nd;su;su;su;ed;nu;enter;n;s;w;e;e;w;out;sd;ed;ed;e;e;e;s;w;e;e;w;s;s;s;se;s;se;s;n;n;sw;w;sw;w;w"

	t[10]="镇江飞龙镖局"
	p[10]="s;s;w;n;n;n;nu;nw;nw;n;n;n;n;n;n;n;n;n;n;n;n;n;nw;n;ne;ne;n;nw;nw;w;w;w;w;n;n;e;w;n;nu;sd;s;s;e;s;s;n;e;n;s;s;n;w;w;w;s;n;w;s;n;n;s;w;e;e;e;s;w;e;e;w;s;e;e;n;n;n;n;w;w;w;w;nw;u;d;se;s;s;s;s;e"

	t[11]="苏州聚宝斋"
	p[11]="s;s;w;n;n;n;nu;nw;nw;n;n;n;n;n;n;w;e;sw;ne;ne;sw;e;ne;sw;e;se;e;s;n;w;nw;w;w;s;e;w;w;w;w;sw;ne;e;e;e;n;n;n;sw;s;n;n;s;nw;se;w;n;s;s;n;w;e;e;ne;n;sw;n;e;e;w;n;w;e;e;w;n;s;s;s;se;s;n;n;w;e;n;s;ne;e;se;n;s;s;n;e"


	if HB_start == "0" then
		for k,v in pairs (t) do
			if v == str2 then
				SetVariable("HB_start", "1")
				SetVariable("HB_xuhao", str1)
				SetVariable("HB_mudidi", str2)
				SetVariable("HB_step", "1")
				SetVariable("HB_findhuoji", "0")
				SetVariable("HB_path", p[k])
			end
		end
	end
end

HuBiao.InitZuo = function(str1, str2)
	local HB_start=GetVariable("HB_start")
	local t={}
	local p={}

	t[1]="归云庄太湖街1"
	p[1]="s;s;sw;nw;w;w;w;w;w;w;nw;ne;se;n;w;n;e;e;e;e;e;s;s;s;n;n;n;nu;nu;sd;sd;e;n;s;s;e;w;n;e;s;n;n;u;d;s;e;e"

	t[2]="嘉兴陆家庄大厅"
	p[2]="s;s;sw;s;s;s;s;s;s;s;n;n;w;e;s;sw;w;nw;se;e;sw;e;w;s;enter;enter;s"

	t[3]="泉州当铺"
	p[3]="s;s;sw;s;s;s;s;s;s;s;s;nw;n;nw;n;s;se;s;se;s;s;e;n;s;s;n;ne;ne;ne;n;w;e;n;ne;ne;sw;sw;s;s;sw;sw;sw;ed;n;s;s;n;wu;w;s;s;e;w;n;n;w;s;n;n;s;nw;w"

	t[4]="嘉兴钱庄"
	p[4]="s;s;sw;s;s;s;s;s;s;s;n;sw;w;nw;se;e;sw;e;w;s;n;ne;ne;e;s;n;w;n;w;nu;sd;e;n;n;n;s;s;s;e;n;s;e;w;s;n;se;s;u;enter;out;d;n;ne;e;ne;ne;sw;sw;w;sw;nw;nd;w;e;e;e;e;e;n;s;s;s;se"

	t[5]="岳王墓墓前广场"
	p[5]="s;s;sw;s;s;s;s;s;s;s;e;n;n;s;e;s;n;ne;n;n;nw;ne;sw;se;s;s;e;e;e"

	t[6]="江州天福镖局"
	p[6]="s;s;sw;s;s;s;s;s;s;s;s;nw;n;nw;n;n;n;n;n;n;n;nw;nd;n;n;n;n;n;n;e;s;n;ne;se;nw;nw;w;e;se;ne;ne;sw;e;e;ne;sw;w;w;sw;sw;w;w;enter;w;e;e;w;out;e;n;s;s;s;e;e;w;w;s;e;w;s;n;w;n;n;s;sw;ne;ne;n;s;s"

	t[7]="临安府江南钱庄"
	p[7]="s;s;sw;s;s;s;s;s;s;s;sw;w;sw;w;w;w;n;s;s;sw;w;se;nw;s;s;n;n;out;enter;w;e;sw;u;d;w;w;e;nw;e;n;s;e;n;s;e;e;n;w;e;n;w"

	t[8]="牙山小荒地"
	p[8]="s;s;sw;s;s;s;s;s;s;s;n;n;e;se;ne;e;ne;ne;e;e;e;e;e;e;n;s;s;n;e;s;s;s;n;w;e;e;w;n;w;e;e;w;n;e;n;s;e;n;s;e;w;w;w;n;w;e;e;w;n"

	t[9]="南昌飞虎镖局"
	p[9]="s;s;sw;s;s;s;s;s;s;s;s;nw;n;nw;n;n;n;n;n;e;w;w;e;n;n;nw;nd;n;s;e;sw;se;s;s;s;e;n;s;s;enter;w;e;e;w;out;n;e;e;eu;wd;w;w;w;w;n;s;s;n;w;w;wu;wu;wu;nd;nd;nd;su;su;su;ed;nu;enter;n;s;w;e;e;w;out;sd;ed;ed;e;e;e;s;w;e;e;w;s;s;s;se;s;se;s;n;n;sw;w;sw;w;w"

	t[10]="镇江飞龙镖局"
	p[10]="s;s;sw;s;s;s;s;s;s;s;n;n;n;n;n;n;n;n;n;n;n;n;n;nw;n;ne;ne;n;nw;nw;w;w;w;w;n;n;e;w;n;nu;sd;s;s;e;s;s;n;e;n;s;s;n;w;w;w;s;n;w;s;n;n;s;w;e;e;e;s;w;e;e;w;s;e;e;n;n;n;n;w;w;w;w;nw;u;d;se;s;s;s;s;e"

	t[11]="苏州聚宝斋"
	p[11]="s;s;sw;s;w;e;sw;ne;ne;sw;e;ne;sw;e;se;e;s;n;w;nw;w;w;s;e;w;w;w;w;sw;ne;e;e;e;e;w;s;s;n;n;n;n;n;sw;s;n;n;s;nw;se;w;n;s;s;n;w;e;e;ne;n;sw;n;e;e;w;n;w;e;e;w;n;s;s;s;se;s;n;n;w;e;n;s;ne;e;se;n;s;s;n;e"

	t[12]="福州福威镖局"
	p[12]="s;s;sw;s;s;s;s;s;s;s;se;se;sd;s;s;e;w;w;e;s;e;n;n;s;s;e;w;s;n;w;s;s;n;w;n;n;enter;out;s;w;w;sw;sw;s;w;e;s;sw;sw;sw"

--	t[13]="岳阳车马行"
--	p[13]="s;s;sw;s;s;s;s;s;s;s;s;nw;n;nw;n;n;n;n;w;w;w;wu;wu;wu;nd;nd;nd;n;n;w;e;e;w;n;n;e;w;n;s;s;e;n;s;s;n;e;e;ed;se;ed;e;w;wu;nw;wu;w;w;w;w;n;s;s;n;w;w;u;d;s;w;wu;ed;e;su;sw;e;"
--	p[13]="s;s;sw;s;s;s;s;s;s;s;s;nw;n;nw;n;n;n;n;w;w;w;wu;wu;wu;nd;nd;nd;n;n;w;e;e;w;n;n;e;w;n;"(到长江边)

--	s;s;sw;s;s;s;s;s;s;s;	

	if HB_start == "0" then
		for k,v in pairs (t) do
			if v == str2 then
				SetVariable("HB_start", "1")
				SetVariable("HB_xuhao", str1)
				SetVariable("HB_mudidi", str2)
				SetVariable("HB_step", "1")
				SetVariable("HB_findhuoji", "0")
				SetVariable("HB_path", p[k])
			end
		end
	end
end

HuBiao.InitZuoSec = function(p1, p2, p3)
	Note("!!!" .. p1 .. " " .. p2 .. " " .. p3);
	HuBiao.AddTime();
	SetVariable("HB_huoji", p2);
	Info("区域：".. p1 .."　伙计：", p2 ,"　在：".. p3);
	SetVariable("timea", utils.timer());

	Common.SetID(Name.TrancelateName(p2));
	Common_StatusClear();
	HuBiao.Clear();
	Common.SetID(Name.TrancelateName(p2));
	Common.FindAgain();
	SetVariable("Q_status", p2);
	Common.CreateTimer("hubiao_find", 0, 15, "HuBiao.Find");
end

HuBiao.ListAccept = function(id, place)
	print("ID:" .. id .. " Place:" .. place)
	if HuBiao.place == "" then
		if string.find(place, "归云庄") or string.find(place, "扬州") or string.find(place, "峨嵋") or string.find(place, "岳阳") then
			return;
		end
		HuBiao.id = id;
		HuBiao.place = place;
		SendNoEcho("getesc " .. id);
		Note("请取任务" .. place .. " ID:" .. id)
	end
end