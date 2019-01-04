Jianding = {};
Jianding.EquipCHS = {"护心", "护肩", "腿甲", "护腿", "面具", "戒指", "项链", "剑", "刀", "杖", "鞭", "斧", "枪", "锤", "戟", "匕", "甲", "靴", "袍", "护手", "盔", "盾", "披风", "腰带", "护腕", "针", "箫"};
Jianding.EquipENG = {"huxin", "hujian", "tuijia", "hutui", "mask", "ring", "necklace", "sword", "blade", "staff", "whip", "axe", "spear", "hammer", "halberd", "dagger", "armor", "boots", "cloth", "hushou", "armet", "shield", "cape", "belt", "huwan", "needle", "flute"};
Jianding.strEquipBuffer = "";
Jianding.strEquipNameBuffer = "";
Jianding.nKong = "";
Jianding.strImportant = "";
Jianding.strLogContent = "";

Common.CreateTrigger("item_kong", "^      可塑性:(.{1})\\(0\\)$", '--Jianding.Kong(%1)', 12, "jianding", 0);
Common.CreateTrigger("item_damage", "^      【基础】(\\S+) : (\\S+)点$", '--Jianding.Damage(%2, "%1")', 12, "jianding", 0);
Common.CreateTrigger("item_damage2", "^      【基础】\\S+ : 有$", '--Jianding.JiandingEnd()', 12, "jianding", 0);
Common.CreateTrigger("jiangding_start", "^你捧着(\\S+)上上下下仔仔细细的打量了一遍.*。$", 'Jianding.JiangdingStart("%1")', 12, "jianding", 1);
Common.CreateTrigger("jiangding_find", "^你发现了一\\S{2}(\\S+)。$", 'Common.Jianding("%1")', 12, "jianding", 1);
Common.CreateTrigger("jianding_log", "^(.*)$", 'Jianding.Log("%1")', 12, "jianding", 1);
EnableTrigger("jianding_log", false);	

Common.Jianding = function(strName)
	Jianding.strImportant = "";
	Jianding.strEquipBuffer = "";
	Jianding.strEquipNameBuffer = "";
	for i = 1, table.getn(Jianding.EquipCHS) do
		if string.find(strName, Jianding.EquipCHS[i]) then
			Note("开始鉴定:" .. strName .. ":" .. Jianding.strEquipBuffer);
			Jianding.strEquipBuffer = Jianding.EquipENG[i];
			Jianding.strEquipNameBuffer = strName;
			SendNoEcho("jianding " .. Jianding.EquipENG[i]);
			return;
		end
	end
	if strName ~= "玉蜂浆" and strName ~= "兵符" then
		Jianding.Log("\t" .. strName);
	end
end

Jianding.Kong = function(nNumber)
	if Jianding.strEquipNameBuffer == "" then return; end
	DeleteTrigger("item_kong");
	Jianding.nKong = nNumber;
	if Jianding.strEquipBuffer == "ring" or Jianding.strEquipBuffer == "necklace" then
		if nNumber >= 2 then
			SendNoEcho("put " .. Jianding.strEquipBuffer .. " in bao fu");
			Jianding.strImportant = "\t高级首饰";
		end
	else
		if nNumber >= 3 then
			SendNoEcho("put " .. Jianding.strEquipBuffer .. " in bao fu");
			Jianding.strImportant = "\t高级装备";
		end
	end
	DeleteTrigger("item_kong");
end

Jianding.Damage = function(nDamage, strType)
	if Jianding.strEquipNameBuffer == "" then return; end
	if Jianding.strEquipBuffer ~= "armor" and Jianding.strEquipBuffer ~= "shield" and nDamage > 210 then
		SendNoEcho("put " .. Jianding.strEquipBuffer .. " in bao fu 2");
		Jianding.strImportant = "\t高攻武器";
	end
	Jianding.Log("\t" .. Jianding.strEquipNameBuffer .. "\t孔:" .. Jianding.nKong .. "\t" .. strType .. ":" .. nDamage .. Jianding.strImportant);
	Jianding.strEquipNameBuffer = "";
end

Jianding.JiandingEnd = function()
	if Jianding.strEquipNameBuffer == "" then return; end
	Jianding.Log("\t" .. Jianding.strEquipNameBuffer .. "\t孔:" .. Jianding.nKong);
	Jianding.strEquipNameBuffer = "";
end

Jianding.JiangdingStart = function(strName)
	--Note("开始鉴定:" .. strName .. "-" .. Jianding.strEquipNameBuffer);
	if strName == Jianding.strEquipNameBuffer then
		Jianding.strLogContent = "";
		EnableTrigger("jianding_log", true);
	end
end

Jianding.Log = function(strContent)
	if string.find(strContent, "【") == 1 then
		return;
	elseif string.find(strContent, " ") == 1 or string.find(strContent, "☆") == 1 or string.find(strContent, "★") == 1 or string.find(strContent, "◇") == 1 or string.find(strContent, "◎") == 1 or string.find(strContent, "=") == 1 then
		strContent = Replace(strContent, "=", "", ture);
		strContent = Replace(strContent, " ", "", ture);
		strContent = Replace(strContent, "◎装备条件：", "", ture);
		strContent = Replace(strContent, "可装备级别:", "Lv", ture);
		strContent = Replace(strContent, "仅限", ":", ture);
		strContent = Replace(strContent, "职业装备", "", ture);
		strContent = Replace(strContent, "装备)：", "", ture);
		strContent = Replace(strContent, "铭文位置:", "", ture);
		strContent = Replace(strContent, "◇基本属性(", "", ture);
		strContent = Replace(strContent, "(0)", " ", ture);
		strContent = Replace(strContent, "【基础】", "", ture);
		strContent = Replace(strContent, "无", "", ture);
		strContent = Replace(strContent, "★固定属性：", "", ture);
		strContent = Replace(strContent, "☆动态属性：", "", ture);
		strContent = Replace(strContent, "☆动态属性(暗淡无光)：", "", ture);
		if strContent ~= "" then
			Jianding.strLogContent = Jianding.strLogContent .. strContent .. "\t";
		end
		if string.find(strContent, "靴") or string.find(strContent, "袍") or string.find(strContent, "盔") then
			Jianding.strLogContent = Jianding.strLogContent .. "\t";
		end
	elseif strContent ~= "" then
		--Note("关闭");
		Jianding.strEquipBuffer = "";
		Jianding.strEquipNameBuffer = "";
		EnableTrigger("jianding_log", false);
		if string.find(Jianding.strLogContent, "Lv") then
			Common.LogEquip("\t" .. Jianding.strLogContent);
			Jianding.strLogContent = "";
		end
	end
end