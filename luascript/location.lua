-------------------------------------
--              地名转换               --
-------------------------------------

Location = Location or {}

Location.describe = ""
Location.exit = ""
Location.DescribeStart = function()
	Location.describe = "";
	EnableTrigger("locateDescribe", true);
end

Location.DescribeGet = function(des)
	if des ~= "^\s{4}这里.+$" then
		Location.describe = Location.describe .. des;
	else
		EnableTrigger("locateDescribe", false);
	end
end

Location.DescribeOut = function(des)
	EnableTrigger("locateDescribe", false);
	des = Replace(des, "、", ";", ture);
	des = Replace(des, " 和 ", ";", ture);
	des = Replace(des, "。", ";", ture);
	Location.exit = des
end

Location.Revert = {};
Location.Revert["south"] = "north";
Location.Revert["east"] = "west";
Location.Revert["west"] = "east";
Location.Revert["north"] = "south";
Location.Revert["southup"] = "northdown";
Location.Revert["southdown"] = "northup";
Location.Revert["westup"] = "eastdown";
Location.Revert["westdown"] = "eastup";
Location.Revert["eastup"] = "westdown";
Location.Revert["eastdown"] = "westup";
Location.Revert["northup"] = "southdown";
Location.Revert["northdown"] = "southup";
Location.Revert["northwest"] = "southeast";
Location.Revert["northeast"] = "southwest";
Location.Revert["southwest"] = "northeast";
Location.Revert["southeast"] = "northwest";
Location.Revert["enter"] = "out";
Location.Revert["out"] = "enter";
Location.Revert["up"] = "down";
Location.Revert["down"] = "up";

Location.GetTowardChs = {}
Location.GetTowardChs["南上"] = "su"
Location.GetTowardChs["南下"] = "sd"
Location.GetTowardChs["西上"] = "wu"
Location.GetTowardChs["西下"] = "wd"
Location.GetTowardChs["东上"] = "eu"
Location.GetTowardChs["东下"] = "ed"
Location.GetTowardChs["北上"] = "nu"
Location.GetTowardChs["北下"] = "nd"
Location.GetTowardChs["西北"] = "nw"
Location.GetTowardChs["东北"] = "ne"
Location.GetTowardChs["西南"] = "sw"
Location.GetTowardChs["东南"] = "se"
Location.GetTowardChs["小道"] = "xiaodao"
Location.GetTowardChs["进"] = "enter"
Location.GetTowardChs["出"] = "out"
Location.GetTowardChs["求助"] = ""
Location.GetTowardChs["任务"] = ""
Location.GetTowardChs["聊天"] = ""
Location.GetTowardChs["杂项"] = ""
Location.GetTowardChs["江湖"] = ""
Location.GetTowardChs["谣言"] = ""
Location.GetTowardChs["系统"] = ""
Location.GetTowardChs["巫师"] = ""
Location.GetTowardChs["北侠QQ群"] = ""
Location.GetTowardChs["帮派"] = ""
Location.GetTowardChs["区域"] = ""
Location.GetTowardChs["交易"] = ""

Location.GetTowardChs2 = {}
Location.GetTowardChs2["上"] = "u"
Location.GetTowardChs2["下"] = "d"
Location.GetTowardChs2["南"] = "s"
Location.GetTowardChs2["东"] = "e"
Location.GetTowardChs2["西"] = "w"
Location.GetTowardChs2["北"] = "n"

--[[
Location.GetTowardChs["u"] = "up"
Location.GetTowardChs["d"] = "down"
Location.GetTowardChs["s"] = "south"
Location.GetTowardChs["e"] = "east"
Location.GetTowardChs["w"] = "west"
Location.GetTowardChs["n"] = "north"
Location.GetTowardChs["su"] = "southup"
Location.GetTowardChs["sd"] = "southdown"
Location.GetTowardChs["wu"] = "westup"
Location.GetTowardChs["wd"] = "westdown"
Location.GetTowardChs["eu"] = "eastup"
Location.GetTowardChs["ed"] = "eastdown"
Location.GetTowardChs["nu"] = "northup"
Location.GetTowardChs["nd"] = "northdown"
Location.GetTowardChs["nw"] = "northwest"
Location.GetTowardChs["ne"] = "northeast"
Location.GetTowardChs["sw"] = "southwest"
Location.GetTowardChs["se"] = "southeast"
]]--

Location.GetPlace = function(strLocation)
	if strLocation == nil then return; end
	local tPlace = {};
	tPlace.area = "";
	tPlace.room = "";
	tPlace.id = "";
	for i = 1, table.getn(Location.strAreaNames) do
		local nIndex = string.find(strLocation, Location.strAreaNames[i]);
		if nIndex == 1 then
			--Note("定位:" .. Location.strAreaNames[i]);
			tPlace.area = Location.strAreaNamesS[i];
			tPlace.room = string.sub(strLocation, nIndex+string.len(Location.strAreaNames[i]), string.len(strLocation));
			tPlace.room  = string.gsub(tPlace.room , "一带", "");
			nIndex = string.find(tPlace.room, "的");
			if nIndex == 1 then
				tPlace.room = string.sub(tPlace.room, 3, string.len(tPlace.room));
			end
			tPlace.id = Location.strAreaIDs[tPlace.area];
			if tPlace.id == nil then
				tPlace.id = "";
			end
			break;
		end
	end
	return tPlace
end

Location.GetPlace_Test = function(strLocation)
	local tPlace = Location.GetPlace(strLocation)
	--Note( "地点:" .. tPlace.area .. " 位置:" .. tPlace.room .. " ID:" .. tPlace.id )
	return tPlace
end
