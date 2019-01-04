-------------------------------------
--              ����ת��               --
-------------------------------------

Location = Location or {}

Location.describe = ""
Location.exit = ""
Location.DescribeStart = function()
	Location.describe = "";
	EnableTrigger("locateDescribe", true);
end

Location.DescribeGet = function(des)
	if des ~= "^\s{4}����.+$" then
		Location.describe = Location.describe .. des;
	else
		EnableTrigger("locateDescribe", false);
	end
end

Location.DescribeOut = function(des)
	EnableTrigger("locateDescribe", false);
	des = Replace(des, "��", ";", ture);
	des = Replace(des, " �� ", ";", ture);
	des = Replace(des, "��", ";", ture);
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
Location.GetTowardChs["����"] = "su"
Location.GetTowardChs["����"] = "sd"
Location.GetTowardChs["����"] = "wu"
Location.GetTowardChs["����"] = "wd"
Location.GetTowardChs["����"] = "eu"
Location.GetTowardChs["����"] = "ed"
Location.GetTowardChs["����"] = "nu"
Location.GetTowardChs["����"] = "nd"
Location.GetTowardChs["����"] = "nw"
Location.GetTowardChs["����"] = "ne"
Location.GetTowardChs["����"] = "sw"
Location.GetTowardChs["����"] = "se"
Location.GetTowardChs["С��"] = "xiaodao"
Location.GetTowardChs["��"] = "enter"
Location.GetTowardChs["��"] = "out"
Location.GetTowardChs["����"] = ""
Location.GetTowardChs["����"] = ""
Location.GetTowardChs["����"] = ""
Location.GetTowardChs["����"] = ""
Location.GetTowardChs["����"] = ""
Location.GetTowardChs["ҥ��"] = ""
Location.GetTowardChs["ϵͳ"] = ""
Location.GetTowardChs["��ʦ"] = ""
Location.GetTowardChs["����QQȺ"] = ""
Location.GetTowardChs["����"] = ""
Location.GetTowardChs["����"] = ""
Location.GetTowardChs["����"] = ""

Location.GetTowardChs2 = {}
Location.GetTowardChs2["��"] = "u"
Location.GetTowardChs2["��"] = "d"
Location.GetTowardChs2["��"] = "s"
Location.GetTowardChs2["��"] = "e"
Location.GetTowardChs2["��"] = "w"
Location.GetTowardChs2["��"] = "n"

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
			--Note("��λ:" .. Location.strAreaNames[i]);
			tPlace.area = Location.strAreaNamesS[i];
			tPlace.room = string.sub(strLocation, nIndex+string.len(Location.strAreaNames[i]), string.len(strLocation));
			tPlace.room  = string.gsub(tPlace.room , "һ��", "");
			nIndex = string.find(tPlace.room, "��");
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
	--Note( "�ص�:" .. tPlace.area .. " λ��:" .. tPlace.room .. " ID:" .. tPlace.id )
	return tPlace
end
