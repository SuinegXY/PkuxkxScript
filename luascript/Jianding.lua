Jianding = {};
Jianding.EquipCHS = {"����", "����", "�ȼ�", "����", "���", "��ָ", "����", "��", "��", "��", "��", "��", "ǹ", "��", "�", "ذ", "��", "ѥ", "��", "����", "��", "��", "����", "����", "����", "��", "��"};
Jianding.EquipENG = {"huxin", "hujian", "tuijia", "hutui", "mask", "ring", "necklace", "sword", "blade", "staff", "whip", "axe", "spear", "hammer", "halberd", "dagger", "armor", "boots", "cloth", "hushou", "armet", "shield", "cape", "belt", "huwan", "needle", "flute"};
Jianding.strEquipBuffer = "";
Jianding.strEquipNameBuffer = "";
Jianding.nKong = "";
Jianding.strImportant = "";
Jianding.strLogContent = "";

Common.CreateTrigger("item_kong", "^      ������:(.{1})\\(0\\)$", '--Jianding.Kong(%1)', 12, "jianding", 0);
Common.CreateTrigger("item_damage", "^      ��������(\\S+) : (\\S+)��$", '--Jianding.Damage(%2, "%1")', 12, "jianding", 0);
Common.CreateTrigger("item_damage2", "^      ��������\\S+ : ��$", '--Jianding.JiandingEnd()', 12, "jianding", 0);
Common.CreateTrigger("jiangding_start", "^������(\\S+)������������ϸϸ�Ĵ�����һ��.*��$", 'Jianding.JiangdingStart("%1")', 12, "jianding", 1);
Common.CreateTrigger("jiangding_find", "^�㷢����һ\\S{2}(\\S+)��$", 'Common.Jianding("%1")', 12, "jianding", 1);
Common.CreateTrigger("jianding_log", "^(.*)$", 'Jianding.Log("%1")', 12, "jianding", 1);
EnableTrigger("jianding_log", false);	

Common.Jianding = function(strName)
	Jianding.strImportant = "";
	Jianding.strEquipBuffer = "";
	Jianding.strEquipNameBuffer = "";
	for i = 1, table.getn(Jianding.EquipCHS) do
		if string.find(strName, Jianding.EquipCHS[i]) then
			Note("��ʼ����:" .. strName .. ":" .. Jianding.strEquipBuffer);
			Jianding.strEquipBuffer = Jianding.EquipENG[i];
			Jianding.strEquipNameBuffer = strName;
			SendNoEcho("jianding " .. Jianding.EquipENG[i]);
			return;
		end
	end
	if strName ~= "��佬" and strName ~= "����" then
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
			Jianding.strImportant = "\t�߼�����";
		end
	else
		if nNumber >= 3 then
			SendNoEcho("put " .. Jianding.strEquipBuffer .. " in bao fu");
			Jianding.strImportant = "\t�߼�װ��";
		end
	end
	DeleteTrigger("item_kong");
end

Jianding.Damage = function(nDamage, strType)
	if Jianding.strEquipNameBuffer == "" then return; end
	if Jianding.strEquipBuffer ~= "armor" and Jianding.strEquipBuffer ~= "shield" and nDamage > 210 then
		SendNoEcho("put " .. Jianding.strEquipBuffer .. " in bao fu 2");
		Jianding.strImportant = "\t�߹�����";
	end
	Jianding.Log("\t" .. Jianding.strEquipNameBuffer .. "\t��:" .. Jianding.nKong .. "\t" .. strType .. ":" .. nDamage .. Jianding.strImportant);
	Jianding.strEquipNameBuffer = "";
end

Jianding.JiandingEnd = function()
	if Jianding.strEquipNameBuffer == "" then return; end
	Jianding.Log("\t" .. Jianding.strEquipNameBuffer .. "\t��:" .. Jianding.nKong);
	Jianding.strEquipNameBuffer = "";
end

Jianding.JiangdingStart = function(strName)
	--Note("��ʼ����:" .. strName .. "-" .. Jianding.strEquipNameBuffer);
	if strName == Jianding.strEquipNameBuffer then
		Jianding.strLogContent = "";
		EnableTrigger("jianding_log", true);
	end
end

Jianding.Log = function(strContent)
	if string.find(strContent, "��") == 1 then
		return;
	elseif string.find(strContent, " ") == 1 or string.find(strContent, "��") == 1 or string.find(strContent, "��") == 1 or string.find(strContent, "��") == 1 or string.find(strContent, "��") == 1 or string.find(strContent, "=") == 1 then
		strContent = Replace(strContent, "=", "", ture);
		strContent = Replace(strContent, " ", "", ture);
		strContent = Replace(strContent, "��װ��������", "", ture);
		strContent = Replace(strContent, "��װ������:", "Lv", ture);
		strContent = Replace(strContent, "����", ":", ture);
		strContent = Replace(strContent, "ְҵװ��", "", ture);
		strContent = Replace(strContent, "װ��)��", "", ture);
		strContent = Replace(strContent, "����λ��:", "", ture);
		strContent = Replace(strContent, "���������(", "", ture);
		strContent = Replace(strContent, "(0)", " ", ture);
		strContent = Replace(strContent, "��������", "", ture);
		strContent = Replace(strContent, "��", "", ture);
		strContent = Replace(strContent, "��̶����ԣ�", "", ture);
		strContent = Replace(strContent, "�̬���ԣ�", "", ture);
		strContent = Replace(strContent, "�̬����(�����޹�)��", "", ture);
		if strContent ~= "" then
			Jianding.strLogContent = Jianding.strLogContent .. strContent .. "\t";
		end
		if string.find(strContent, "ѥ") or string.find(strContent, "��") or string.find(strContent, "��") then
			Jianding.strLogContent = Jianding.strLogContent .. "\t";
		end
	elseif strContent ~= "" then
		--Note("�ر�");
		Jianding.strEquipBuffer = "";
		Jianding.strEquipNameBuffer = "";
		EnableTrigger("jianding_log", false);
		if string.find(Jianding.strLogContent, "Lv") then
			Common.LogEquip("\t" .. Jianding.strLogContent);
			Jianding.strLogContent = "";
		end
	end
end