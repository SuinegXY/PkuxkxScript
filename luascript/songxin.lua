-------------------------------------
--            ��ɽ����             --
-------------------------------------	
local Songxin_State1 = "��ʼ����"
local Songxin_State5 = "Ѱ�ҵ���"
local Songxin_State2 = "ɱ����"
local Songxin_State3 = "�������"
Songxin_nStatus 		= "Q_status"
Songxin_nLocation 	= "Q_location"
Songxin_nName 		= "Q_name"
Songxin_nNameKiller1 	= "Q_misc"
Songxin_nNameKiller2 	= "Q_misc2"

function Songxin_SetName(name, id)
	local nName1 = GetVariable(Songxin_nNameKiller1)
	local nName2 = GetVariable(Songxin_nNameKiller2)
	local nStatus = GetVariable(Songxin_nStatus)
	id = string.lower(id)
	--print("Songxin_SetName:name:" .. name .. " id:" .. id)
	if nStatus == Songxin_State5 then
		if string.find(name, "��Ī��") then
			print("��ɱ����")
		elseif nName1 == "" then
			print("��һ��:" .. name .. " ID:" .. id)
			SetVariable(Songxin_nNameKiller1, name)
			DoAfter(1, "l")
		elseif nName2 == "" and name ~= nName1 then
			print("�ڶ���:" .. name .. " ID:" .. id)
			SetVariable(Songxin_nNameKiller2, name)
		end
		DoAfter(1, "kill " .. id )
	end
end

function Songxin_FinishCheck()
	local nStatus = GetVariable(Songxin_nStatus)
	if nStatus == Songxin_State3 then
		SendNoEcho("ask yue about finish")
	end
end

function Songxin_Yue()
	SendNoEcho("dazuo 400")
	DoAfter(62, "ask yue about ����")
end

function Songxin_SearchEnemy()
	local nStatus = GetVariable(Songxin_nStatus)
	if nStatus == Songxin_State1 then
		SetVariable(Songxin_nStatus, Songxin_State5)
		EnableTrigger("songxin_search", true)
		EnableTrigger("songxin_check", true)
		Send("l")
	end
end

function Songxin_Start(location, name)
	SetVariable(Songxin_nStatus, Songxin_State1)
	SetVariable(Songxin_nLocation, location)
	SetVariable(Songxin_nName, name)
end

function Songxin_CorpseCheck(name)
	local nName1 = GetVariable(Songxin_nNameKiller1)
	local nName2 = GetVariable(Songxin_nNameKiller2)
	local nStatus = GetVariable(Songxin_nStatus)
	--print("CorpseCheck:name:"..name)
	if name == nName1 then
		SetVariable(Songxin_nNameKiller1, "")
		SetVariable(Songxin_nStatus, Songxin_State2)
	end
	if name == nName2 then
		SetVariable(Songxin_nNameKiller2, "")
		SetVariable(Songxin_nStatus, Songxin_State2)
	end
	if name == "½����" then
		Execute("s;w;w")
	end
	if string.find(name, "����") then
		SetVariable(Songxin_nStatus, "�������")
	end
end

function Songxin_NameCheck(name, id)
	local nName1 = GetVariable(Songxin_nNameKiller1)
	local nName2 = GetVariable(Songxin_nNameKiller2)
	local nStatus = GetVariable(Songxin_nStatus)
	local nXin = GetVariable(Songxin_nName)
	id = string.lower(id)
	--print("NameCheck:name:"..name.." id:"..id)
	--print("NameCheck:nStatus:"..nStatus)
	if nStatus == Songxin_State2 and string.find(name,nXin) then
		Send( "songxin " .. id )
		SetVariable(Songxin_nStatus, Songxin_State3)
		EnableTrigger("songxin_check", false)
		EnableTrigger("songxin_search", false)
	end
	if name == nName1 or name == nName2 then
		Send( "killall " .. id )
	end
end