--[[#tag push auto]]

--[[
	本文件引用的很多全局字符串已缺失，参考 text.lua (特别是 vss 49 ~ 50)
]]

local UIManTemplate = UIManTemplate
local DlgApi  = DlgApi
local GameApi = GameApi
local Format = string.format

local invite_leader_id
local request_leader_id
local click_player_id
local invite_player_id
local request_player_id
local join_member_id
local leave_member_id

local teaminfo, selfid

GameUI = UIManTemplate:new({this = --[[!AUTO_1]]"GameUI"});

function GameUI:Init()
	self:RegisterEvent(LUA_EVENT_LOADING_SETWORLD, self.OnEventLoadingSetWorld);
	self:RegisterEvent(LUA_EVENT_LOADING_SETPROGRESS, self.OnEventLoadingSetProgress);

	self:RegisterEvent(LUA_EVENT_TEAM_INVITE, self.OnEventTeamInvite);
	self:RegisterEvent(LUA_EVENT_TEAM_REJECTINVITE, self.OnEventTeamRejectInvite);
	self:RegisterEvent(LUA_EVENT_TEAM_SELFJOIN, self.OnEventSelfJoin);
	self:RegisterEvent(LUA_EVENT_TEAM_SELFLEAVE, self.OnEventSelfLeave);
	self:RegisterEvent(LUA_EVENT_TEAM_REQUEST, self.OnEventTeamRequest);
	self:RegisterEvent(LUA_EVENT_TEAM_REJECTREQUEST, self.OnEventTeamRejectRequest);
	self:RegisterEvent(LUA_EVENT_TEAM_MEMBERJOIN, self.OnEventTeamMemberJoin);
	self:RegisterEvent(LUA_EVENT_TEAM_MEMBERLEAVE, self.OnEventTeamMemberLeave);
	self:RegisterEvent(LUA_EVENT_TEAM_MEMBERLOGIN, self.OnEventTeamMemberLogin);
	self:RegisterEvent(LUA_EVENT_TEAM_MEMBERLOGOUT, self.OnEventTeamMemberLogout);
	self:RegisterEvent(LUA_EVENT_TEAM_CHANGELEADER, self.OnEventTeamChangeLeader);
	self:RegisterEvent(LUA_EVENT_TEAM_CHANGELOOTRULE, self.OnEventTeamChangeLootRule);
	self:RegisterEvent(LUA_EVENT_TEAM_CHANGEINVITERULE, self.OnEventTeamChangeInvite);
	self:RegisterEvent(LUA_EVENT_TEAM_CHANGERECRUITERULE, self.OnEventTeamChangeRecruit);

	self:RegisterEvent(LUA_EVENT_RBTNCLICK_PLAYER, self.OnEventRBtnClickPlayer);
	self:RegisterEvent(LUA_EVENT_LOOT_OPEN, self.OnEventLootOpen);
	self:RegisterEvent(LUA_EVENT_OPERATION_CANCEL, self.OnEventOperationCancel);

  	self:AddMessageboxCB(--[[!AUTO_2]]"MsgBox_TeamInvite", self.OnMsgBoxTeamInvite);
  	self:AddMessageboxCB(--[[!AUTO_3]]"MsgBox_TeamRequest", self.OnMsgBoxTeamRequest);
end

function GameUI:Release()

end

--[[
snsinfo的关键字：
"gender"
"spouse"
"masterid
"family"
"faction"
"level"
"profession"
"birth_month"
"birth_day"
"age"
"zodiac"
"horoscope"
"onlinetime"
"province"
"city"
"occupation"
"intro"
"almamater"
--]]

function GameUI:FateMatching(roleid,snsInfo)
	local hostSnsInfo = GameApi.GetPlayerSnsInfo(0)

	local marks=20
	local tempmark
	local level1 = hostSnsInfo["level"]
	local level2 = snsInfo["level"]
	local age1 = hostSnsInfo["age"]
	local age2 = snsInfo["age"]
	local time1 = hostSnsInfo["onlinetime"]
	local time2 = snsInfo["onlinetime"]
	local yearanimal1 = hostSnsInfo["horoscope"]
	local yearanimal2 = snsInfo["horoscope"]
	local zodiac1 = hostSnsInfo["zodiac"]
	local zodiac2 = snsInfo["zodiac"]
	local province1 = hostSnsInfo["province"]
	local province2 = snsInfo["province"]
	local city1 = hostSnsInfo["city"]
	local city2 = snsInfo["city"]
	local birth_month1 = hostSnsInfo["birth_month"]
	local birth_month2 = snsInfo["birth_month"]
	local birth_day1 = hostSnsInfo["birth_day"]
	local birth_day2 = snsInfo["birth_day"]

	--LogPrint("ID1:" .. 0 .. "，ID2:" .. roleid)
	--LogPrint("Level1:" .. level1 .. "，Level2:" .. level2)
	--LogPrint("初始分数：" .. marks)

    --等级加分
    if math.abs(level1 - level2) < 45 then
    	tempmark = 15 - math.ceil(math.abs(level1 - level2)/3)
    else
        tempmark = 0
    end
	--LogPrint("等级加分：" .. math.max(tempmark,0))

	marks = marks + math.max(tempmark,0)

	--年龄加分
	if age1 > 0 and age2 > 0 then
    	if math.abs(age1 - age2) <= 6 then
    	    tempmark = 10
    	else
    		tempmark = 10 - math.ceil((math.abs(age1 - age2) - 6)/3)
    	end
	else
	    tempmark = 0
	end

	--LogPrint("年龄加分：" .. math.max(tempmark,0))

	marks = marks + math.max(tempmark,0)

	--省份加分
	if province1 == province2 and province1 ~= --[[!AUTO_4]]"None" and province2 ~= --[[!AUTO_5]]"None" then
	    tempmark = 10
	elseif province1 ~= --[[!AUTO_6]]"None" and province2 ~= --[[!AUTO_7]]"None"  then
	    tempmark = 5
	elseif province1 ~= --[[!AUTO_8]]"None" or province2 ~= --[[!AUTO_9]]"None"  then
	    tempmark = 3
	else
	    tempmark = 0
	end
	--LogPrint("省份1：" .. province1 .."省份2：" .. province2 .. "。")
	--LogPrint("省份加分：" .. tempmark)

	marks = marks + tempmark

	--城市加分
	if city1 == city2 and city1 ~= --[[!AUTO_10]]"None" and city2 ~= --[[!AUTO_11]]"None" then
	    tempmark = 10
	elseif city1 ~= --[[!AUTO_12]]"None" and city2 ~= --[[!AUTO_13]]"None"  then
	    tempmark = 5
	elseif city1 ~= --[[!AUTO_14]]"None" or city2 ~= --[[!AUTO_15]]"None"  then
	    tempmark = 3
	else
	    tempmark = 0
	end
	--LogPrint("城市1：" .. city1 .."城市2：" .. city2 .. "。")
	--LogPrint("城市加分：" .. tempmark)

	marks = marks + tempmark

	--在线时间重叠加分
	if time1 == time2 and time1 ~= 0 then
	    tempmark = 10
	elseif time1 ~= 0 and time2 ~= 0 then
	    tempmark = 3
	elseif time1 ~= 0 or time2 ~= 0 then
	    tempmark = 1
	else
	    tempmark = 0
	end

	--LogPrint("在线时间加分：" .. tempmark)

	marks = marks + tempmark
	--生日加分
	if birth_month1 == birth_month2  and birth_day1 == birth_day2 and birth_month1 ~= 0 and birth_day1 ~= 0 then
		tempmark = 10
	else
		tempmark = 0
	end

	--LogPrint("生日加分：" .. tempmark)
	marks = marks + tempmark

	--判断生肖加分
	local y1 = yearanimal1
	local y2 = yearanimal2
	if (y1 == 1 and y2 == 2) or (y1 == 2 and y2 == 1) then
	    tempmark = 5
	elseif (y1 ==3 and y2 == 12) or (y1 == 12 and y2 == 3) then
		tempmark = 5
	elseif (y1 == 4 and y2 == 8) or (y1 == 8 and y2 == 4) then
		tempmark = 5
	elseif (y1 == 7 and y2 == 11) or (y1 == 11 and y2 == 7) then
		tempmark = 5
	elseif (y1 == 1 and y2 == 7) or (y1 == 7 and y2 == 1) then
		tempmark = -5
	elseif (y1 == 2 and y2 == 8) or (y1 == 8 and y2 == 2) then
		tempmark = -5
	elseif (y1 == 3 and y2 == 9) or (y1 == 9 and y2 == 3) then
		tempmark = -5
	elseif (y1 == 4 and y2 == 10) or (y1 == 10 and y2 == 4) then
		tempmark = -5
	elseif (y1 == 6 and y2 == 12) or (y1 == 12 and y2 == 6) then
		tempmark = -5
	elseif (y1 == 5 and y2 == 11) or (y1 == 11 and y2 == 5) then
		tempmark = -5
	else
	    tempmark = 0
	end

	--LogPrint("生肖加分：" .. tempmark)

	marks = marks + tempmark

	--星座加分
	if ZODIAC[zodiac1] and ZODIAC[zodiac1][2]==zodiac2 then
		tempmark = 5
	elseif ZODIAC[zodiac1] and ZODIAC[zodiac1][3]==zodiac2 then
		tempmark = 3
	elseif ZODIAC[zodiac1] and ZODIAC[zodiac1][4]==zodiac2 then
		tempmark = 1
	else
	    tempmark = 0
	end

	--LogPrint("星座加分：" .. tempmark)

	marks = marks + tempmark

	--帮派加分
	if hostSnsInfo["faction"] and snsInfo["faction"] and hostSnsInfo["faction"] == snsInfo["faction"] and hostSnsInfo["faction"] ~= 0 then
	    tempmark = 5
	else
	    tempmark = 0
	end
	--LogPrint("帮派1：" .. hostSnsInfo["faction"] .."帮派2：" .. snsInfo["faction"] .. "。")
	--LogPrint("帮派加分：" .. tempmark)

	marks = marks + tempmark

	--师门加分
	if hostSnsInfo["masterid"] and snsInfo["masterid"] and hostSnsInfo["masterid"] == snsInfo["masterid"] and hostSnsInfo["masterid"] ~= 0 then
	    tempmark = 10
	else
	    tempmark = 0
	end
	--LogPrint("师门1：" .. hostSnsInfo["masterid"] .."师门2：" .. snsInfo["masterid"] .. "。")
	--LogPrint("师门加分：" .. tempmark)

	marks = marks + tempmark

	--职业加分
	if hostSnsInfo["occupation"] and hostSnsInfo["occupation"] ~= --[[!AUTO_16]]"" and  snsInfo["occupation"]  and snsInfo["occupation"] ~= --[[!AUTO_17]]"" then
		tempmark = 3
	elseif (hostSnsInfo["occupation"] and hostSnsInfo["occupation"] ~= --[[!AUTO_18]]"") or  (snsInfo["occupation"] and snsInfo["occupation"] ~= --[[!AUTO_19]]"") then
		tempmark = 1
	else
	    tempmark = 0
	end

	--LogPrint("自身职业：“" .. hostSnsInfo["occupation"] .. "”，对方职业：“" .. snsInfo["occupation"] .. "”")
	--LogPrint("职业加分：" .. tempmark)

	marks = marks + tempmark

	--毕业院校加分
	if hostSnsInfo["almamater"] and hostSnsInfo["almamater"] ~= --[[!AUTO_20]]"" and  snsInfo["almamater"] and snsInfo["almamater"] ~= --[[!AUTO_21]]"" then
		tempmark = 3
	elseif (hostSnsInfo["almamater"] and hostSnsInfo["almamater"] ~= --[[!AUTO_22]]"") or  (snsInfo["almamater"] and snsInfo["almamater"] ~= --[[!AUTO_23]]"") then
		tempmark = 1
	else
	    tempmark = 0
	end

	--LogPrint("自身院校：“" .. hostSnsInfo["almamater"] .. "”，对方院校：“" .. snsInfo["almamater"] .. "”")
	--LogPrint("毕业院校加分：" .. tempmark)

	marks = marks + tempmark

	--个人说明加分
	if hostSnsInfo["intro"] and hostSnsInfo["intro"] ~= --[[!AUTO_24]]"" and  snsInfo["intro"] and snsInfo["intro"] ~= --[[!AUTO_25]]"" then
		tempmark = 5
	elseif (hostSnsInfo["intro"] and hostSnsInfo["intro"] ~= --[[!AUTO_26]]"") or  (snsInfo["intro"] and snsInfo["intro"] ~= --[[!AUTO_27]]"") then
		tempmark = 3
	else
	    tempmark = 0
	end

	--LogPrint("自身说明：“" .. hostSnsInfo["intro"] .. "”，对方说明：“" .. snsInfo["intro"] .. "”")
	--LogPrint("个人说明加分：" .. tempmark)

	marks = marks + tempmark

	--LogPrint("最后总分数：" .. marks)

	marks=math.min(marks,100)
	return marks
end

--[[
function GameUI:Tick()

	--获取玩家当前队伍状态，是否为队长及是否在队伍中
	teaminfo = GameApi.GetTeamInfo();
	selfid = GameApi.GetSelfID();
	if teaminfo.leader_id ~= selfid then
		--自己不是队长（或没有队伍） 		local isleader = false
	else
		--自己是队长 		local isleader = true
	end
	if teaminfo.leader_id == 0 then
		--没有队伍（队伍被解散） 		local isdiscard = true
	else
		--队伍没被解散
		local isdiscard = false
	end

	--等级Max时/开世界地图时不显示经验条的闪烁特效
	local ret = GameApi.GetPlayerBasicProp(0)
	if ret.level >= Max_Level or DlgApi.IsDialogShow("Win_WorldMap") or DlgApi.IsDialogShow("Win_WorldMap2") then
	    DlgApi.ShowItem("Win_ExpBar", "gfx", false)
	end

end
]]--

function GameUI:ProcessEvent()

end

function GameUI:OnEventLoadingSetWorld(event, id, mapfile)
	local ran1 = math.random(LDG_TIP.num)
	local ran2 = math.random(LDG_TIP.picnum)
	local tip = Format(LDG_TITLE, LDG_TIP[ran1])
	DlgApi.SetItemText(--[[!AUTO_28]]"Win_Loading", --[[!AUTO_29]]"Txt_Tip", tip);
	if id == 0 then
		DlgApi.SetImageFile(--[[!AUTO_30]]"Win_Loading", --[[!AUTO_31]]"Img_Loading", Format(--[[!AUTO_32]]"MapLoading\\a%d.dds", ran2), 1);
	else
		DlgApi.SetImageFile(--[[!AUTO_33]]"Win_Loading", --[[!AUTO_34]]"Img_Loading", Format(--[[!AUTO_35]]"MapLoading\\%s.dds", mapfile), 1);
	end
end

function GameUI:OnEventLoadingSetProgress(event, progress)
	DlgApi.SetProgress(--[[!AUTO_36]]"Win_Loading", --[[!AUTO_37]]"Prgs_Loading", progress);
end

--收到组队邀请时
--1.弹出消息框
function GameUI:OnEventTeamInvite(event, leader_id, leader_name)
    invite_leader_id = leader_id;
	DlgApi.PopupMessageBox(MB_YESNO, --[[!AUTO_38]]"MsgBox_TeamInvite", Format(TEXT_TEAM_INVITE, leader_name));
end

--组队邀请被拒绝时 --1.聊天框中显示消息
function GameUI:OnEventTeamRejectInvite(event, player_id, player_name)
	invite_player_id = player_id;
	GameApi.AddChatMessage(GP_CHAT_MISC, Format(TEXT_TEAM_INVITE_REJECT, player_name));
end

--加入队伍时 --1.显示TeamMain及TeamMate窗口
--2.指定TeamMain及TeamMate窗口位置
--3.聊天框中显示消息
function GameUI:OnEventSelfJoin(event)
    GameApi.AddChatMessage(GP_CHAT_MISC, TEXT_TEAM_SELF_JOIN);
	DlgApi.ShowDialog(--[[!AUTO_39]]"Win_TeamMain", true);
  	--DlgApi.SetDialogPosition("Win_TeamMain", 0, 0, "", AUIDIALOG_ALIGN_INSIDE, AUIDIALOG_ALIGN_LEFT, AUIDIALOG_ALIGN_INSIDE, AUIDIALOG_ALIGN_CENTER);
    --[[DlgApi.ShowDialog("Win_TeamMate1", true);
    DlgApi.SetDialogPosition("Win_TeamMate1", 0, 0, "Win_TeamMain", AUIDIALOG_ALIGN_OUTSIDE, AUIDIALOG_ALIGN_RIGHT, AUIDIALOG_ALIGN_INSIDE, AUIDIALOG_ALIGN_TOP);
    local tn = teaminfo.members;
    for k=2, tn do
		DlgApi.ShowDialog(Format("Win_TeamMate%d", k), true);
		DlgApi.SetDialogPosition(Format("Win_TeamMate%d", k), 0, 0, Format("Win_TeamMate%d", k-1), AUIDIALOG_ALIGN_INSIDE, AUIDIALOG_ALIGN_LEFT, AUIDIALOG_ALIGN_OUTSIDE, AUIDIALOG_ALIGN_BOTTOM);
	end]]
end

--离开队伍时 --1.关闭TeamMain及TeamMate窗口
--2.聊天框中显示消息
function GameUI:OnEventSelfLeave(event)
    GameApi.AddChatMessage(GP_CHAT_MISC, TEXT_TEAM_SELF_LEAVE);
    DlgApi.ShowDialog(--[[!AUTO_40]]"Win_TeamMain", false);
    for i=1,9 do
		DlgApi.ShowDialog(Format(--[[!AUTO_41]]"Win_TeamMate%d", i), false);
	end
end

--收到入队申请时 --1.弹出消息框
function GameUI:OnEventTeamRequest(event, player_id, player_name)
	request_player_id = player_id;
	DlgApi.PopupMessageBox(MB_YESNO, --[[!AUTO_42]]"MsgBox_TeamRequest", Format(TEXT_TEAM_REQUEST, player_name));
end

--入队申请被拒绝时
--1.聊天框中显示消息
function GameUI:OnEventTeamRejectRequest(event, leader_id, leader_name)
	request_leader_id = leader_id;
	GameApi.AddChatMessage(GP_CHAT_MISC, Format(TEXT_TEAM_REQUEST_REJECT, leader_name));
end

--有玩家加入队伍 --1.聊天框中显示消息
--2.增加一个TeamMate窗口
function GameUI:OnEventTeamMemberJoin(event, member_id, member_name)
	join_member_id = member_id;
	GameApi.AddChatMessage(GP_CHAT_MISC, Format(TEXT_TEAM_MEMBER_JOIN, member_name));
	DlgApi.ShowDialog(Format(--[[!AUTO_43]]"Win_TeamMate%d", teaminfo.members), true);
end

--有玩家离开队伍
--1.如果队伍解散，聊天框中显示消息，关闭TeamMain及所有TeamMate窗口
--2.否则，聊天框中显示消息，减少一个TeamMate窗口
function GameUI:OnEventTeamMemberLeave(event, member_id, member_name)
	leave_member_id = member_id;
	if isdiscard then
    	DlgApi.ShowDialog(--[[!AUTO_44]]"Win_TeamMain", false);
    	GameApi.AddChatMessage(GP_CHAT_MISC, Format(TEXT_TEAM_DISCARD, member_name));
    	for j=1,9 do
			DlgApi.ShowDialog(Format(--[[!AUTO_45]]"Win_TeamMate%d", j), false);
		end
	else
    	GameApi.AddChatMessage(GP_CHAT_MISC, Format(TEXT_TEAM_MEMBER_LEAVE, member_name));
		DlgApi.ShowDialog(Format(--[[!AUTO_46]]"Win_TeamMate%d", teaminfo.members + 1), false);
	end
end

--队友登入游戏
--1.聊天框中显示消息
function GameUI:OnEventTeamMemberLogin(event, member_id, member_name)
    GameApi.AddChatMessage(GP_CHAT_MISC, Format(TEXT_TEAM_MEMBER_LOGIN, member_name));
end

--队友登出游戏
--1.聊天框中显示消息
function GameUI:OnEventTeamMemberLogout(event, member_id, member_name)
    GameApi.AddChatMessage(GP_CHAT_MISC, Format(TEXT_TEAM_MEMBER_LOGOUT, member_name));
end

--队长改变
--1.聊天框中显示消息
function GameUI:OnEventTeamChangeLeader(event, leader_id, leader_name)
	GameApi.AddChatMessage(GP_CHAT_MISC, Format(TEXT_TEAM_CHANGE_LEADER, leader_name));
end

--分配规则改变
--1.聊天框中显示消息
function GameUI:OnEventTeamChangeLootRule(event, mainrule, subrule)
	if mainrule == 1 then
        GameApi.AddChatMessage(GP_CHAT_TEAM, Format(TEXT_TEAM_CHANGELOOT_FREE, GNR_LOOTRULE_FREE));
    else
        local rolllevel = GNR_ROLLLEVEL_2;
        if subrule == 1 then
            rolllevel = GNR_ROLLLEVEL_2;
        elseif subrule == 4 then
            rolllevel = GNR_ROLLLEVEL_3;
		elseif subrule == 7 then
            rolllevel = GNR_ROLLLEVEL_4;
        end
        GameApi.AddChatMessage(GP_CHAT_TEAM, Format(TEXT_TEAM_CHANGELOOT_TEAM, GNR_LOOTRULE_TEAM, rolllevel));
    end
end

--邀请入队规则改变
--1.聊天框中显示消息
function GameUI:OnEventTeamChangeInvite(event, bOpen)
	local msg = GNR_INVITE_FORBID
	 if bOpen > 0 then
		msg = GNR_INVITE_ALLOW
	 end
	 GameApi.AddChatMessage(GP_CHAT_TEAM, Format(TEXT_TEAM_CHANGEINVITE_TEAM, msg));

end

--招募入队规则改变
--1.聊天框中显示消息
function GameUI:OnEventTeamChangeRecruit(event, bAuto)

	 local msg = GNR_RECRUIT_NOAUTO
	 if bAuto > 0 then
		msg = GNR_RECRUIT_AUTO
	 end
    GameApi.AddChatMessage(GP_CHAT_TEAM, Format(TEXT_TEAM_CHANGERECRUIT_TEAM,  msg));

end

--目标头像上点右键
--1.弹出QuickAction窗口
function GameUI:OnEventRBtnClickPlayer(event, player_id)
  	click_player_id = player_id;
	local x, y = GameApi.GetCursorPos();
--	DlgApi.PopupPlayerMenu(player_id, x, y);
--	DlgApi.ShowDialog("Win_QuickAction", true);
--	DlgApi.SetDialogPosition("Win_QuickAction", x, y);
end

--拾取LOOT
--1.弹出Loot窗口
function GameUI:OnEventLootOpen(event)
	DlgApi.ShowDialog(--[[!AUTO_47]]"Win_Loot", true);
	local x, y = GameApi.GetCursorPos();
	DlgApi.SetDialogPosition(--[[!AUTO_48]]"Win_Loot", x, y);
end

--关闭当前操作窗口
function GameUI:OnEventOperationCancel(event)
	DlgApi.ShowDialog(--[[!AUTO_49]]"Win_Loot", false);
	DlgApi.ShowDialog(--[[!AUTO_50]]"Win_Shop", false);
	DlgApi.ShowDialog(--[[!AUTO_51]]"Win_Teach", false);
	DlgApi.ShowDialog(--[[!AUTO_52]]"Win_NPC", false);
end

--组队邀请消息框
function GameUI:OnMsgBoxTeamInvite(name, bret)
	if bret then
		GameApi.TeamAcceptInvite(invite_leader_id);
	else
		GameApi.TeamRejectInvite(invite_leader_id);
	end
end

--入队申请消息框
function GameUI:OnMsgBoxTeamRequest(name, bret)
	if bret then
		GameApi.TeamAcceptRequest(request_player_id);
	else
		GameApi.TeamRejectRequest(request_player_id);
	end
end

--物品拿起放下音效
function GameUI:GetItemSound(bDown, idClass, idMainType, idSubType)
--    if idClass == 1 then
--    	tsound = ICON_EQUIP_SOUND_PATH[idSubType].takeupsound
--    	dsound = ICON_EQUIP_SOUND_PATH[idSubType].dropsound
--    else
--    	tsound = ICON_SOUND_PATH[idClass].takeupsound
--    	dsound = ICON_SOUND_PATH[idClass].dropsound
--    end
--    if bDown then
----		return dsound
--		return ""
--	else
----		return tsound
--		return ""
--	end
	return --[[!AUTO_53]]""
end



--以下为老的脚本文件
--生产技能升级提示
function GameUI:GetProduceSkillDesc(idSkill, iLevel)
    local Produce = {}
	Produce[1077] = {Name = TEXT_PRODUCESKILL_SKILLTYPE1, OpenLv = 1, LearnNeedLv = {20}, LearnNPCid = {1915}} --驯养
	Produce[1078] = {Name = TEXT_PRODUCESKILL_SKILLTYPE2, OpenLv = 6, LearnNeedLv = {5,15,24,36,48,63}, LearnNPCid = {1923,1924,1924,1924,1924,1924}} --烹饪
	Produce[1079] = {Name = TEXT_PRODUCESKILL_SKILLTYPE3, OpenLv = 6, LearnNeedLv = {8,20,34,48,58,68}, LearnNPCid = {1917,1918,1918,1918,1918,1918}} --铁匠
	Produce[1080] = {Name = TEXT_PRODUCESKILL_SKILLTYPE4, OpenLv = 5, LearnNeedLv = {8,20,34,48,58}, LearnNPCid = {1919,1920,1920,1920,1920}} --裁缝
	Produce[1081] = {Name = TEXT_PRODUCESKILL_SKILLTYPE5, OpenLv = 4, LearnNeedLv = {22,34,48,58}, LearnNPCid = {1927,1928,1928,1928}} --巧匠
	Produce[1082] = {Name = TEXT_PRODUCESKILL_SKILLTYPE6, OpenLv = 6, LearnNeedLv = {19,24,34,44,53,71}, LearnNPCid = {1925,1926,1926,1926,1926,1926}} --药师
	Produce[1083] = {Name = TEXT_PRODUCESKILL_SKILLTYPE7, OpenLv = 6, LearnNeedLv = {9,15,28,40,48,65}, LearnNPCid = {1929,1930,1930,1930,1930,1930}} --急救
	Produce[1084] = {Name = TEXT_PRODUCESKILL_SKILLTYPE8, OpenLv = 1, LearnNeedLv = {22}, LearnNPCid = {1932}} --工匠
	local ProduceLvName = {TEXT_PRODUCESKILL_SKILLLEVELTYPE1, TEXT_PRODUCESKILL_SKILLLEVELTYPE2, TEXT_PRODUCESKILL_SKILLLEVELTYPE3, TEXT_PRODUCESKILL_SKILLLEVELTYPE4, TEXT_PRODUCESKILL_SKILLLEVELTYPE5, TEXT_PRODUCESKILL_SKILLLEVELTYPE6}
	local LearnNpcName = {}
	LearnNpcName[1077] = TEXT_PRODUCESKILL_NPCNAME1
	LearnNpcName[1078] = TEXT_PRODUCESKILL_NPCNAME2
	LearnNpcName[1079] = TEXT_PRODUCESKILL_NPCNAME3
	LearnNpcName[1080] = TEXT_PRODUCESKILL_NPCNAME4
	LearnNpcName[1081] = TEXT_PRODUCESKILL_NPCNAME5
	LearnNpcName[1082] = TEXT_PRODUCESKILL_NPCNAME6
	LearnNpcName[1083] = TEXT_PRODUCESKILL_NPCNAME7
	LearnNpcName[1084] = TEXT_PRODUCESKILL_NPCNAME8
	local LearnNpcMap = {}
	LearnNpcMap[1077] = GNR_MAP_NAME7
	LearnNpcMap[1078] = GNR_MAP_NAME7
	LearnNpcMap[1079] = GNR_MAP_NAME7
	LearnNpcMap[1080] = GNR_MAP_NAME7
	LearnNpcMap[1081] = GNR_MAP_NAME7
	LearnNpcMap[1082] = GNR_MAP_NAME7
	LearnNpcMap[1083] = GNR_MAP_NAME7
	LearnNpcMap[1084] = GNR_MAP_NAME7

	local LearnLv = Produce[idSkill].LearnNeedLv
	local LearnNpc = Produce[idSkill].LearnNPCid
    if iLevel >= Produce[idSkill].OpenLv then
        helpstring = --[[!AUTO_54]]""
    else
        helpname = Produce[idSkill].Name
        helplevel = LearnLv[iLevel + 1]
        helplevelname = ProduceLvName[iLevel + 1]
        produceskillnpcid = LearnNpc[iLevel + 1]
		produceskillnpcname = LearnNpcName[idSkill]
		produceskillnpchome = LearnNpcMap[idSkill]
		helpstring = Format(AUI_PRODUCESKILL_TIP, helplevel, produceskillnpchome, helplevelname, helpname)
	end
	return helpstring, produceskillnpcid
end

--职业升阶提示
function GameUI:GetProfLevelUpDesc(idProf, iLevel)
	local PROFLEVEL_HELP_NPCID = {}
	PROFLEVEL_HELP_NPCID[1] = {3996,1910,1910,1910,1910,1910,1910,1910,1910,1910}
	PROFLEVEL_HELP_NPCID[2] = {3996,3365,3365,3365,3365,3365,3365,3365,3365,3365}
	PROFLEVEL_HELP_NPCID[3] = {3996,3366,3366,3366,3366,3366,3366,3366,3366,3366}
	PROFLEVEL_HELP_NPCID[4] = {3996,3367,3367,3367,3367,3367,3367,3367,3367,3367}
	PROFLEVEL_HELP_NPCID[5] = {3996,3368,3368,3368,3368,3368,3368,3368,3368,3368}
	PROFLEVEL_HELP_NPCID[6] = {3996,3369,3369,3369,3369,3369,3369,3369,3369,3369}
	PROFLEVEL_HELP_NPCID[7] = {3996,3370,3370,3370,3370,3370,3370,3370,3370,3370}
	PROFLEVEL_HELP_NPCID[8] = {3996,3371,3371,3371,3371,3371,3371,3371,3371,3371}
	PROFLEVEL_HELP_NPCID[9] = {3996,3372,3372,3372,3372,3372,3372,3372,3372,3372}
	PROFLEVEL_HELP_NPCID[10] = {3996,3373,3373,3373,3373,3373,3373,3373,3373,3373}
	PROFLEVEL_HELP_NPCID[11] = {3996,3374,3374,3374,3374,3374,3374,3374,3374,3374}
	PROFLEVEL_HELP_NPCID[12] = {3996,3375,3375,3375,3375,3375,3375,3375,3375,3375}
	PROFLEVEL_HELP_NPCID[13] = {3996,3376,3376,3376,3376,3376,3376,3376,3376,3376}
	PROFLEVEL_HELP_NPCID[14] = {3996,3377,3377,3377,3377,3377,3377,3377,3377,3377}
	PROFLEVEL_HELP_NPCID[15] = {3996,3378,3378,3378,3378,3378,3378,3378,3378,3378}
	PROFLEVEL_HELP_NPCID[16] = {3996,3379,3379,3379,3379,3379,3379,3379,3379,3379}
	PROFLEVEL_HELP_NPCID[17] = {3996,3380,3380,3380,3380,3380,3380,3380,3380,3380}
	PROFLEVEL_HELP_NPCID[18] = {3996,3381,3381,3381,3381,3381,3381,3381,3381,3381}
	local TEXT_PROFHELP_NPC1 = Format(--[[!AUTO_55]]"%s %s", GNR_MAP_NAME1, --[[!AUTO_56]]"%s")
	local TEXT_PROFHELP_NPC2 = Format(--[[!AUTO_57]]"%s %s", GNR_MAP_NAME7, --[[!AUTO_58]]"%s")
	local PROFLEVEL_HELP_NPCNAME = {}
	PROFLEVEL_HELP_NPCNAME[1] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[2] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[3] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[4] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[5] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[6] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[7] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[8] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[9] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[10] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[11] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[12] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[13] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[14] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[15] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[16] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[17] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}
	PROFLEVEL_HELP_NPCNAME[18] = {TEXT_PROFHELP_NPC1,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2,TEXT_PROFHELP_NPC2}

	proflevelnpcname = PROFLEVEL_HELP_NPCNAME[idProf][iLevel+1]
	proflevelnpcid = PROFLEVEL_HELP_NPCID[idProf][iLevel+1]
	if idProf == 0 then
		Profhelpstring = AUI_CHARACTER_PROFNILHELP
	else
		if iLevel + 1 == Max_iLevel then
			Profhelpstring = AUI_CHARACTER_PROFMAXHELP
		else
			Profhelpstring = Format(AUI_CHARACTER_PROFHELP, proflevelnpcname)
		end
	end
	return Profhelpstring, proflevelnpcid
end

--战场信息
function GameUI:GetBattleInfo(idTemplate)
	local War = {}
--测试
    War[160] = {Pic = --[[!AUTO_59]]"CB\\BattleField\\颖川之战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION161 , Aname = AUI_BATTLEFIELD_ANAME161 , Bname = AUI_BATTLEFIELD_BNAME161 , AWin = AUI_BATTLEFIELD_AWIN161 , BWin = AUI_BATTLEFIELD_BWIN161 , ALost = AUI_BATTLEFIELD_ALOST161 , BLost = AUI_BATTLEFIELD_BLOST161 }
    War[161] = {Pic = --[[!AUTO_60]]"CB\\BattleField\\颖川之战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION161 , Aname = AUI_BATTLEFIELD_ANAME161 , Bname = AUI_BATTLEFIELD_BNAME161 , AWin = AUI_BATTLEFIELD_AWIN161 , BWin = AUI_BATTLEFIELD_BWIN161 , ALost = AUI_BATTLEFIELD_ALOST161 , BLost = AUI_BATTLEFIELD_BLOST161 }
    War[210] = {Pic = --[[!AUTO_61]]"CB\\BattleField\\颖川之战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION210 , Aname = AUI_BATTLEFIELD_ANAME210 , Bname = AUI_BATTLEFIELD_BNAME210 , AWin = AUI_BATTLEFIELD_AWIN210 , BWin = AUI_BATTLEFIELD_BWIN210 , ALost = AUI_BATTLEFIELD_ALOST210 , BLost = AUI_BATTLEFIELD_BLOST210 }
    War[211] = {Pic = --[[!AUTO_62]]"CB\\BattleField\\颖川之战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION211 , Aname = AUI_BATTLEFIELD_ANAME211 , Bname = AUI_BATTLEFIELD_BNAME211 , AWin = AUI_BATTLEFIELD_AWIN211 , BWin = AUI_BATTLEFIELD_BWIN211 , ALost = AUI_BATTLEFIELD_ALOST211 , BLost = AUI_BATTLEFIELD_BLOST211 }
    War[221] = {Pic = --[[!AUTO_63]]"CB\\BattleField\\颖川之战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION221 , Aname = AUI_BATTLEFIELD_ANAME221 , Bname = AUI_BATTLEFIELD_BNAME221 , AWin = AUI_BATTLEFIELD_AWIN221 , BWin = AUI_BATTLEFIELD_BWIN221 , ALost = AUI_BATTLEFIELD_ALOST221 , BLost = AUI_BATTLEFIELD_BLOST221 }
    War[222] = {Pic = --[[!AUTO_64]]"CB\\BattleField\\落凤坡之战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION222 , Aname = AUI_BATTLEFIELD_ANAME222 , Bname = AUI_BATTLEFIELD_BNAME222 , AWin = AUI_BATTLEFIELD_AWIN222 , BWin = AUI_BATTLEFIELD_BWIN222 , ALost = AUI_BATTLEFIELD_ALOST222 , BLost = AUI_BATTLEFIELD_BLOST222 }
    War[223] = {Pic = --[[!AUTO_65]]"CB\\BattleField\\尚香解救战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION223 , Aname = AUI_BATTLEFIELD_ANAME223 , Bname = AUI_BATTLEFIELD_BNAME223 , AWin = AUI_BATTLEFIELD_AWIN223 , BWin = AUI_BATTLEFIELD_BWIN223 , ALost = AUI_BATTLEFIELD_ALOST223 , BLost = AUI_BATTLEFIELD_BLOST223 }
    War[227] = {Pic = --[[!AUTO_66]]"CB\\BattleField\\黄巾之乱.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION227 , Aname = AUI_BATTLEFIELD_ANAME227 , Bname = AUI_BATTLEFIELD_BNAME227 , AWin = AUI_BATTLEFIELD_AWIN227 , BWin = AUI_BATTLEFIELD_BWIN227 , ALost = AUI_BATTLEFIELD_ALOST227 , BLost = AUI_BATTLEFIELD_BLOST227 }
    War[237] = {Pic = --[[!AUTO_67]]"CB\\BattleField\\黄巾之乱.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION237 , Aname = AUI_BATTLEFIELD_ANAME237 , Bname = AUI_BATTLEFIELD_BNAME237 , AWin = AUI_BATTLEFIELD_AWIN237 , BWin = AUI_BATTLEFIELD_BWIN237 , ALost = AUI_BATTLEFIELD_ALOST237 , BLost = AUI_BATTLEFIELD_BLOST237 }
--国战
	War[241] = {Pic = --[[!AUTO_68]]"CB\\BattleField\\国战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION241 , Aname = AUI_BATTLEFIELD_ANAME241 , Bname = AUI_BATTLEFIELD_BNAME241 , AWin = AUI_BATTLEFIELD_AWIN241 , BWin = AUI_BATTLEFIELD_BWIN241 , ALost = AUI_BATTLEFIELD_ALOST241 , BLost = AUI_BATTLEFIELD_BLOST241 }
    War[252] = {Pic = --[[!AUTO_69]]"CB\\BattleField\\西凉缭乱.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION252 , Aname = AUI_BATTLEFIELD_ANAME252 , Bname = AUI_BATTLEFIELD_BNAME252 , AWin = AUI_BATTLEFIELD_AWIN252 , BWin = AUI_BATTLEFIELD_BWIN252 , ALost = AUI_BATTLEFIELD_ALOST252 , BLost = AUI_BATTLEFIELD_BLOST252 }
    War[253] = {Pic = --[[!AUTO_70]]"CB\\BattleField\\曹操传.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION253 , Aname = AUI_BATTLEFIELD_ANAME253 , Bname = AUI_BATTLEFIELD_BNAME253 , AWin = AUI_BATTLEFIELD_AWIN253 , BWin = AUI_BATTLEFIELD_BWIN253 , ALost = AUI_BATTLEFIELD_ALOST253 , BLost = AUI_BATTLEFIELD_BLOST253 }
    War[254] = {Pic = --[[!AUTO_71]]"CB\\BattleField\\虎牢关群英会.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION254 , Aname = AUI_BATTLEFIELD_ANAME254 , Bname = AUI_BATTLEFIELD_BNAME254 , AWin = AUI_BATTLEFIELD_AWIN254 , BWin = AUI_BATTLEFIELD_BWIN254 , ALost = AUI_BATTLEFIELD_ALOST254 , BLost = AUI_BATTLEFIELD_BLOST254 }
    War[255] = {Pic = --[[!AUTO_72]]"CB\\BattleField\\刘备传.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION255 , Aname = AUI_BATTLEFIELD_ANAME255 , Bname = AUI_BATTLEFIELD_BNAME255 , AWin = AUI_BATTLEFIELD_AWIN255 , BWin = AUI_BATTLEFIELD_BWIN255 , ALost = AUI_BATTLEFIELD_ALOST255 , BLost = AUI_BATTLEFIELD_BLOST255 }
	War[256] = {Pic = --[[!AUTO_73]]"CB\\BattleField\\濮阳之战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION256 , Aname = AUI_BATTLEFIELD_ANAME256 , Bname = AUI_BATTLEFIELD_BNAME256 , AWin = AUI_BATTLEFIELD_AWIN256 , BWin = AUI_BATTLEFIELD_BWIN256 , ALost = AUI_BATTLEFIELD_ALOST256 , BLost = AUI_BATTLEFIELD_BLOST256 }
    War[265] = {Pic = --[[!AUTO_74]]"CB\\BattleField\\孙权传.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION265 , Aname = AUI_BATTLEFIELD_ANAME265 , Bname = AUI_BATTLEFIELD_BNAME265 , AWin = AUI_BATTLEFIELD_AWIN265 , BWin = AUI_BATTLEFIELD_BWIN265 , ALost = AUI_BATTLEFIELD_ALOST265 , BLost = AUI_BATTLEFIELD_BLOST265 }
	War[266] = {Pic = --[[!AUTO_75]]"CB\\BattleField\\典韦传.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION266 , Aname = AUI_BATTLEFIELD_ANAME266 , Bname = AUI_BATTLEFIELD_BNAME266 , AWin = AUI_BATTLEFIELD_AWIN266 , BWin = AUI_BATTLEFIELD_BWIN266 , ALost = AUI_BATTLEFIELD_ALOST266 , BLost = AUI_BATTLEFIELD_BLOST266 }
    War[267] = {Pic = --[[!AUTO_76]]"CB\\BattleField\\暗袭定军山.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION267 , Aname = AUI_BATTLEFIELD_ANAME267 , Bname = AUI_BATTLEFIELD_BNAME267 , AWin = AUI_BATTLEFIELD_AWIN267 , BWin = AUI_BATTLEFIELD_BWIN267 , ALost = AUI_BATTLEFIELD_ALOST267 , BLost = AUI_BATTLEFIELD_BLOST267 }
	War[268] = {Pic = --[[!AUTO_77]]"CB\\BattleField\\荆襄撤退战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION268 , Aname = AUI_BATTLEFIELD_ANAME268 , Bname = AUI_BATTLEFIELD_BNAME268 , AWin = AUI_BATTLEFIELD_AWIN268 , BWin = AUI_BATTLEFIELD_BWIN268 , ALost = AUI_BATTLEFIELD_ALOST268 , BLost = AUI_BATTLEFIELD_BLOST268 }
--华容道     War[274] = {Pic = "CB\\BattleField\\赵云传.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION275 , Aname = AUI_BATTLEFIELD_ANAME275 , Bname = AUI_BATTLEFIELD_BNAME275 , AWin = AUI_BATTLEFIELD_AWIN275 , BWin = AUI_BATTLEFIELD_BWIN275 , ALost = AUI_BATTLEFIELD_ALOST275 , BLost = AUI_BATTLEFIELD_BLOST275 }
    War[275] = {Pic = --[[!AUTO_78]]"CB\\BattleField\\赵云传.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION275 , Aname = AUI_BATTLEFIELD_ANAME275 , Bname = AUI_BATTLEFIELD_BNAME275 , AWin = AUI_BATTLEFIELD_AWIN275 , BWin = AUI_BATTLEFIELD_BWIN275 , ALost = AUI_BATTLEFIELD_ALOST275 , BLost = AUI_BATTLEFIELD_BLOST275 }
	War[279] = {Pic = --[[!AUTO_79]]"CB\\BattleField\\竞技场.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION279 , Aname = AUI_BATTLEFIELD_ANAME279 , Bname = AUI_BATTLEFIELD_BNAME279 , AWin = AUI_BATTLEFIELD_AWIN279 , BWin = AUI_BATTLEFIELD_BWIN279 , ALost = AUI_BATTLEFIELD_ALOST279 , BLost = AUI_BATTLEFIELD_BLOST279 }
	War[280] = {Pic = --[[!AUTO_80]]"CB\\BattleField\\竞技场.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION280 , Aname = AUI_BATTLEFIELD_ANAME280 , Bname = AUI_BATTLEFIELD_BNAME280 , AWin = AUI_BATTLEFIELD_AWIN280 , BWin = AUI_BATTLEFIELD_BWIN280 , ALost = AUI_BATTLEFIELD_ALOST280 , BLost = AUI_BATTLEFIELD_BLOST280 }
	War[281] = {Pic = --[[!AUTO_81]]"CB\\BattleField\\蒋干盗书.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION281 , Aname = AUI_BATTLEFIELD_ANAME281 , Bname = AUI_BATTLEFIELD_BNAME281 , AWin = AUI_BATTLEFIELD_AWIN281 , BWin = AUI_BATTLEFIELD_BWIN281 , ALost = AUI_BATTLEFIELD_ALOST281 , BLost = AUI_BATTLEFIELD_BLOST281 }
	War[277] = {Pic = --[[!AUTO_82]]"CB\\BattleField\\合肥之战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION277 , Aname = AUI_BATTLEFIELD_ANAME277 , Bname = AUI_BATTLEFIELD_BNAME277 , AWin = AUI_BATTLEFIELD_AWIN277 , BWin = AUI_BATTLEFIELD_BWIN277 , ALost = AUI_BATTLEFIELD_ALOST277 , BLost = AUI_BATTLEFIELD_BLOST277 }
    War[278] = {Pic = --[[!AUTO_83]]"CB\\BattleField\\益州攻克战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION278 , Aname = AUI_BATTLEFIELD_ANAME278 , Bname = AUI_BATTLEFIELD_BNAME278 , AWin = AUI_BATTLEFIELD_AWIN278 , BWin = AUI_BATTLEFIELD_BWIN278 , ALost = AUI_BATTLEFIELD_ALOST278 , BLost = AUI_BATTLEFIELD_BLOST278 }
    War[291] = {Pic = --[[!AUTO_84]]"CB\\BattleField\\轩辕遗迹.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION291 , Aname = AUI_BATTLEFIELD_ANAME291 , Bname = AUI_BATTLEFIELD_BNAME291 , AWin = AUI_BATTLEFIELD_AWIN291 , BWin = AUI_BATTLEFIELD_BWIN291 , ALost = AUI_BATTLEFIELD_ALOST291 , BLost = AUI_BATTLEFIELD_BLOST291 }
    War[292] = {Pic = --[[!AUTO_85]]"CB\\BattleField\\竞技场.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION292 , Aname = AUI_BATTLEFIELD_ANAME292 , Bname = AUI_BATTLEFIELD_BNAME292 , AWin = AUI_BATTLEFIELD_AWIN292 , BWin = AUI_BATTLEFIELD_BWIN292 , ALost = AUI_BATTLEFIELD_ALOST292 , BLost = AUI_BATTLEFIELD_BLOST292 }
    War[293] = {Pic = --[[!AUTO_86]]"CB\\BattleField\\楼兰古殿.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION293 , Aname = AUI_BATTLEFIELD_ANAME293 , Bname = AUI_BATTLEFIELD_BNAME293 , AWin = AUI_BATTLEFIELD_AWIN293 , BWin = AUI_BATTLEFIELD_BWIN293 , ALost = AUI_BATTLEFIELD_ALOST293 , BLost = AUI_BATTLEFIELD_BLOST293 }
    War[294] = {Pic = --[[!AUTO_87]]"CB\\BattleField\\项王魔域.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION294 , Aname = AUI_BATTLEFIELD_ANAME294 , Bname = AUI_BATTLEFIELD_BNAME294 , AWin = AUI_BATTLEFIELD_AWIN294 , BWin = AUI_BATTLEFIELD_BWIN294 , ALost = AUI_BATTLEFIELD_ALOST294 , BLost = AUI_BATTLEFIELD_BLOST294 }
    War[297] = {Pic = --[[!AUTO_88]]"CB\\BattleField\\蒋干盗书.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION297 , Aname = AUI_BATTLEFIELD_ANAME297 , Bname = AUI_BATTLEFIELD_BNAME297 , AWin = AUI_BATTLEFIELD_AWIN297 , BWin = AUI_BATTLEFIELD_BWIN297 , ALost = AUI_BATTLEFIELD_ALOST297 , BLost = AUI_BATTLEFIELD_BLOST297 }
	War[298] = {Pic = --[[!AUTO_89]]"CB\\BattleField\\桃园.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION298 , Aname = AUI_BATTLEFIELD_ANAME298 , Bname = AUI_BATTLEFIELD_BNAME298 , AWin = AUI_BATTLEFIELD_AWIN298 , BWin = AUI_BATTLEFIELD_BWIN298 , ALost = AUI_BATTLEFIELD_ALOST298 , BLost = AUI_BATTLEFIELD_BLOST298 }
	War[299] = {Pic = --[[!AUTO_90]]"CB\\BattleField\\濮阳之战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION299 , Aname = AUI_BATTLEFIELD_ANAME299 , Bname = AUI_BATTLEFIELD_BNAME299 , AWin = AUI_BATTLEFIELD_AWIN299 , BWin = AUI_BATTLEFIELD_BWIN299 , ALost = AUI_BATTLEFIELD_ALOST299 , BLost = AUI_BATTLEFIELD_BLOST299 }
	War[304] = {Pic = --[[!AUTO_91]]"CB\\BattleField\\牧羊传.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION304 , Aname = AUI_BATTLEFIELD_ANAME304 , Bname = AUI_BATTLEFIELD_BNAME304 , AWin = AUI_BATTLEFIELD_AWIN304 , BWin = AUI_BATTLEFIELD_BWIN304 , ALost = AUI_BATTLEFIELD_ALOST304 , BLost = AUI_BATTLEFIELD_BLOST304 }
	War[306] = {Pic = --[[!AUTO_92]]"CB\\BattleField\\西域蜃楼城.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION306 , Aname = AUI_BATTLEFIELD_ANAME306 , Bname = AUI_BATTLEFIELD_BNAME306 , AWin = AUI_BATTLEFIELD_AWIN306 , BWin = AUI_BATTLEFIELD_BWIN306 , ALost = AUI_BATTLEFIELD_ALOST306 , BLost = AUI_BATTLEFIELD_BLOST306 }
	War[308] = {Pic = --[[!AUTO_93]]"CB\\BattleField\\曹植传.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION308 , Aname = AUI_BATTLEFIELD_ANAME308 , Bname = AUI_BATTLEFIELD_BNAME308 , AWin = AUI_BATTLEFIELD_AWIN308 , BWin = AUI_BATTLEFIELD_BWIN308 , ALost = AUI_BATTLEFIELD_ALOST308 , BLost = AUI_BATTLEFIELD_BLOST308 }
	War[311] = {Pic = --[[!AUTO_94]]"CB\\BattleField\\赛马场.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION311 , Aname = AUI_BATTLEFIELD_ANAME311 , Bname = AUI_BATTLEFIELD_BNAME311 , AWin = AUI_BATTLEFIELD_AWIN311 , BWin = AUI_BATTLEFIELD_BWIN311 , ALost = AUI_BATTLEFIELD_ALOST311 , BLost = AUI_BATTLEFIELD_BLOST311 }
	War[312] = {Pic = --[[!AUTO_95]]"CB\\BattleField\\赛马场.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION312 , Aname = AUI_BATTLEFIELD_ANAME312 , Bname = AUI_BATTLEFIELD_BNAME312 , AWin = AUI_BATTLEFIELD_AWIN312 , BWin = AUI_BATTLEFIELD_BWIN312 , ALost = AUI_BATTLEFIELD_ALOST312 , BLost = AUI_BATTLEFIELD_BLOST312 }
	War[313] = {Pic = --[[!AUTO_96]]"CB\\BattleField\\赛马场.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION313 , Aname = AUI_BATTLEFIELD_ANAME313 , Bname = AUI_BATTLEFIELD_BNAME313 , AWin = AUI_BATTLEFIELD_AWIN313 , BWin = AUI_BATTLEFIELD_BWIN313 , ALost = AUI_BATTLEFIELD_ALOST313 , BLost = AUI_BATTLEFIELD_BLOST313 }
	War[317] = {Pic = --[[!AUTO_97]]"CB\\BattleField\\濮阳之战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION317 , Aname = AUI_BATTLEFIELD_ANAME317 , Bname = AUI_BATTLEFIELD_BNAME317 , AWin = AUI_BATTLEFIELD_AWIN317 , BWin = AUI_BATTLEFIELD_BWIN317 , ALost = AUI_BATTLEFIELD_ALOST317 , BLost = AUI_BATTLEFIELD_BLOST317 }
--魇魂洞 	War[318] = {Pic = "CB\\BattleField\\濮阳之战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION317 , Aname = AUI_BATTLEFIELD_ANAME317 , Bname = AUI_BATTLEFIELD_BNAME317 , AWin = AUI_BATTLEFIELD_AWIN317 , BWin = AUI_BATTLEFIELD_BWIN317 , ALost = AUI_BATTLEFIELD_ALOST317 , BLost = AUI_BATTLEFIELD_BLOST317 }
--无双07
	War[325] = {Pic = --[[!AUTO_98]]"CB\\BattleField\\濮阳之战.dds", introduction = AUI_BATTLEFIELD_INTRODUCTION317 , Aname = AUI_BATTLEFIELD_ANAME317 , Bname = AUI_BATTLEFIELD_BNAME317 , AWin = AUI_BATTLEFIELD_AWIN317 , BWin = AUI_BATTLEFIELD_BWIN317 , ALost = AUI_BATTLEFIELD_ALOST317 , BLost = AUI_BATTLEFIELD_BLOST317 }

	War_pic = War[idTemplate].Pic
	War_introduction = War[idTemplate].introduction
	War_Aname = War[idTemplate].Aname
	War_Bname = War[idTemplate].Bname
	War_Awin = War[idTemplate].AWin
	War_Bwin = War[idTemplate].BWin
	War_Alost = War[idTemplate].ALost
	War_Blost = War[idTemplate].BLost
	return War_pic,War_introduction,War_Aname,War_Bname,War_Awin,War_Bwin,War_Alost,War_Blost
end

--战场结束信息
function GameUI:GetBattleEndInfo(idTemplate,iCamp,bWin)--idtemplate(战场ID）icamp(1,2,攻方守方）bwin（1，0，-1，胜，平，负） 	local WarEnd = {}
	WarEnd[161] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 10,WinItemNameA = 9599,WinItemNumA = 4,WinItemNameB = 9598,WinItemNumB = 4,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 9599,LostItemNumA = 1,LostItemNameB = 9598,LostItemNumB = 1,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 9599,DrawItemNumA = 2,DrawItemNameB = 9598,DrawItemNumB = 2,WinEXP = 35000,LostEXP = 5000,DrawEXP = 10000}
	WarEnd[210] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 5,WinItemNameA = 9383,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 6000,LostEXP = 1000,DrawEXP = 0}
	WarEnd[211] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 5,WinItemNameA = 9384,WinItemNumA = 2,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 9384,DrawItemNumA = 1,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 10000,LostEXP = 2000,DrawEXP = 4000}
	WarEnd[221] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 10,WinItemNameA = 9469,WinItemNumA = 2,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 9469,DrawItemNumA = 1,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 12000,LostEXP = 3000,DrawEXP = 5000}
	WarEnd[222] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 5,WinItemNameA = 11906,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 12000,LostEXP = 2500,DrawEXP = 5000}
	WarEnd[223] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 5,WinItemNameA = 12462,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 8000,LostEXP = 1500,DrawEXP = 2000}
	WarEnd[227] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 10,WinItemNameA = 13002,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 30000,LostEXP = 5000,DrawEXP = 8000}
	WarEnd[237] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 10,WinItemNameA = 13017,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 100000,LostEXP = 6000,DrawEXP = 30000}
	WarEnd[252] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 10,WinItemNameA = 13928,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 7000,LostEXP = 1000,DrawEXP = 1500}
	WarEnd[254] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 15,WinItemNameA = 14353,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 150000,LostEXP = 10000,DrawEXP = 50000}
	WarEnd[253] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 15,WinItemNameA = 13959,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 50000,LostEXP = 5000,DrawEXP = 10000}
	WarEnd[255] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 15,WinItemNameA = 15562,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 50000,LostEXP = 5000,DrawEXP = 10000}
	WarEnd[256] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 15564,WinItemNumA = 1,WinItemNameB = 15564,WinItemNumB = 1,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 17066,LostItemNumA = 1,LostItemNameB = 17066,LostItemNumB = 1,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 17066,DrawItemNumA = 2,DrawItemNameB = 17066,DrawItemNumB = 1,WinEXP = 50000,LostEXP = 40000,DrawEXP = 30000}
	WarEnd[266] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 15,WinItemNameA = 0,WinItemNumA = 0,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 80000,LostEXP = 10000,DrawEXP = 20000}
	WarEnd[268] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 15,WinItemNameA = 19392,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 50000,LostEXP = 5000,DrawEXP = 10000}
	WarEnd[267] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 0,WinItemNumA = 0,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 100000,LostEXP = 60000,DrawEXP = 0}
	WarEnd[275] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 15,WinItemNameA = 20794,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 80000,LostEXP = 10000,DrawEXP = 20000}
	WarEnd[265] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 15,WinItemNameA = 21192,WinItemNumA = 2,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 60000,LostEXP = 5000,DrawEXP = 10000}
	WarEnd[281] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 15,WinItemNameA = 22034,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 20000,LostEXP = 10000,DrawEXP = 20000}
	WarEnd[277] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 24846,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 60000,LostEXP = 20000,DrawEXP = 0}
	WarEnd[278] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 24847,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 100000,LostEXP = 30000,DrawEXP = 0}
	WarEnd[291] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 27149,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 400000,LostEXP = 120000,DrawEXP = 0}
	WarEnd[292] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 27149,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 0,LostEXP = 0,DrawEXP = 0}
	WarEnd[293] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 27150,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 1900000,LostEXP = 500000,DrawEXP = 0}
	WarEnd[294] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 27151,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 900000,LostEXP = 250000,DrawEXP = 0}
	WarEnd[298] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 0,WinItemNumA = 0,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 0,LostEXP = 0,DrawEXP = 0}
	WarEnd[299] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 27447,WinItemNumA = 3,WinItemNameB = 27447,WinItemNumB = 3,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 27447,LostItemNumA = 2,LostItemNameB = 27447,LostItemNumB = 2,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 15564,DrawItemNumA = 1,DrawItemNameB = 15564,DrawItemNumB = 1,WinEXP = 0,LostEXP = 0,DrawEXP = 0}
	WarEnd[308] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 28276,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 200000,LostEXP = 0,DrawEXP = 50000}
	WarEnd[306] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 27360,WinItemNumA = 1,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 700000,LostEXP = 0,DrawEXP = 300000}
	WarEnd[304] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 0,WinItemNumA = 0,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = --[[!AUTO_99]]"Please claim the Prize",LostEXP = 0,DrawEXP = 0}
	WarEnd[317] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 27447,WinItemNumA = 3,WinItemNameB = 27447,WinItemNumB = 3,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 27447,LostItemNumA = 2,LostItemNameB = 27447,LostItemNumB = 2,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 15564,DrawItemNumA = 1,DrawItemNameB = 15564,DrawItemNumB = 1,WinEXP = 0,LostEXP = 0,DrawEXP = 0}

	--ID:279竞技场12人（积分） 	WarEnd[279] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 0,WinItemNumA = 0,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 3,LostEXP = 1,DrawEXP = 2}
	--ID:280竞技场1人（积分） 	WarEnd[280] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 0,WinItemNameA = 0,WinItemNumA = 0,WinItemNameB = 0,WinItemNumB = 0,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 0,LostItemNameA = 0,LostItemNumA = 0,LostItemNameB = 0,LostItemNumB = 0,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 0,DrawItemNameA = 0,DrawItemNumA = 0,DrawItemNameB = 0,DrawItemNumB = 0,WinEXP = 3,LostEXP = 1,DrawEXP = 2}
	--国战
	WarEnd[241] = {WinExploit1 = 0,WinExploit2 = 0,WinExploit = 0,WinReputation = 150,WinItemNameA = 15593,WinItemNumA = 2,WinItemNameB = 15593,WinItemNumB = 2,LostExploit1 = 0,LostExploit2 = 0,LostExploit = 0,LostReputation = 50,LostItemNameA = 15593,LostItemNumA = 1,LostItemNameB = 15593,LostItemNumB = 1,DrawExploit1 = 0,DrawExploit2 = 0,DrawExploit = 0,DrawReputation = 100,DrawItemNameA = 15593,DrawItemNumA = 1,DrawItemNameB = 15593,DrawItemNumB = 1,WinEXP = 200000,LostEXP = 50000,DrawEXP = 100000}

		if bWin == 1 then
		Exploit1 = WarEnd[idTemplate].WinExploit1
		Exploit2 = WarEnd[idTemplate].WinExploit2
		Exploit = WarEnd[idTemplate].WinExploit
		Reputation = WarEnd[idTemplate].WinReputation
		EXP = WarEnd[idTemplate].WinEXP
			if iCamp == 1 then
			ItemName = WarEnd[idTemplate].WinItemNameA
			ItemNum = WarEnd[idTemplate].WinItemNumA
			else
			ItemName = WarEnd[idTemplate].WinItemNameB
			ItemNum = WarEnd[idTemplate].WinItemNumB
			end
		else
			if bWin == 0 then
			Exploit1 = WarEnd[idTemplate].DrawExploit1
			Exploit2 = WarEnd[idTemplate].DrawExploit2
			Exploit = WarEnd[idTemplate].DrawExploit
			Reputation = WarEnd[idTemplate].DrawReputation
			EXP = WarEnd[idTemplate].DrawEXP
				if iCamp == 1 then
			ItemName = WarEnd[idTemplate].DrawItemNameA
			ItemNum = WarEnd[idTemplate].DrawItemNumA
				else
			ItemName = WarEnd[idTemplate].DrawItemNameB
			ItemNum = WarEnd[idTemplate].DrawItemNumB
				end
			else
			Exploit1 = WarEnd[idTemplate].LostExploit1
			Exploit2 = WarEnd[idTemplate].LostExploit2
			Exploit = WarEnd[idTemplate].LostExploit
			Reputation = WarEnd[idTemplate].LostReputation
			EXP = WarEnd[idTemplate].LostEXP
				if iCamp == 1 then
			ItemName = WarEnd[idTemplate].LostItemNameA
			ItemNum = WarEnd[idTemplate].LostItemNumA
				else
			ItemName = WarEnd[idTemplate].LostItemNameB
			ItemNum = WarEnd[idTemplate].LostItemNumB
				end
			end
		end
	return Exploit1,Exploit2,Exploit,Reputation,ItemName,ItemNum,EXP
end

--积分类战场结束信息（表现奖励部分）
function GameUI:GetBattleEndScoreInfo(idTemplate, score)
	local ScoreWarEnd = {}
	--ID:256濮阳之战（积分）
	ScoreWarEnd[256] = {
    	LvScore = {0, 1, 2, 3, 6, 12},
    	EndReputation = {0, 0, 0, 0, 0, 0},
    	EndItemName = {0, 0, 17066, 15564, 15564, 15564},
    	EndItemNum = {0, 0, 1, 1, 1, 1},
    	EndEXP = {0, 50000, 80000, 100000, 120000, 200000},
    	}
	--ID:279竞技场12人（积分）
	ScoreWarEnd[279] = {
    	LvScore = {0, 1, 5, 10, 15, 20},
    	EndReputation = {0, 0, 0, 0, 0, 0},
    	EndItemName = {0, 0, 0, 0, 0, 0},
    	EndItemNum = {0, 0, 0, 0, 0, 0},
    	EndEXP = {0, 0, 0, 0, 0, 0},
    	}
	--ID:281蒋干传（积分）
	ScoreWarEnd[281] = {
    	LvScore = {0, 1, 5, 10, 15, 20},
    	EndReputation = {0, 0, 0, 0, 0, 0},
    	EndItemName = {0, 0, 0, 0, 0, 0},
    	EndItemNum = {0, 0, 0, 0, 0, 0},
    	EndEXP = {0, 0, 0, 0, 0, 0},
    	}
	--ID:280竞技场1人（积分）
	ScoreWarEnd[280] = {
    	LvScore = {0, 1, 5, 10, 15, 20},
    	EndReputation = {0, 0, 0, 0, 0, 0},
    	EndItemName = {0, 0, 0, 0, 0, 0},
    	EndItemNum = {0, 0, 0, 0, 0, 0},
    	EndEXP = {0, 0, 0, 0, 0, 0},
    	}
	--ID:241国战战场
	ScoreWarEnd[241] = {
    	LvScore = {0, 1, 5, 30, 80, 150},
    	EndReputation = {0, 0, 0, 0, 0, 0},
    	EndItemName = {0, 22672, 22671, 22670, 22669, 22668},
    	EndItemNum = {0, 1, 1, 1, 1, 1},
    	EndEXP = {0, 0, 0, 0, 0, 0},
    	}

	local NowLvScore = ScoreWarEnd[idTemplate].LvScore
	local NowReputation = ScoreWarEnd[idTemplate].EndReputation
	local NowItemName = ScoreWarEnd[idTemplate].EndItemName
	local NowItemNum = ScoreWarEnd[idTemplate].EndItemNum
	local NowEXP = ScoreWarEnd[idTemplate].EndEXP
	local lv

	for k = 1, 6 do
		if score >= NowLvScore[k] then
			lv = k;
		else
		    lv = k - 1;
		    break;
		end
	end

	Reputation = NowReputation[lv]
	ItemName = NowItemName[lv]
	ItemNum = NowItemNum[lv]
	EXP = NowEXP[lv]
	return Reputation,ItemName,ItemNum,EXP
end

--资质假技能级别和激活变亮的显示
function GameUI:GetAttributeInfo(nLevel1,nLevel2,nLevel3,nLevel4,nLevel5,nLevel6, nParam)
	SkillOpenPoint = {3, 8, 11, 20, 25, 49, 60, 81, 100}
	SkillMaxLevel = {30, 12, 9, 2, 4, 2, 1, 1, 1}
	SkillLevel = {nLevel1, nLevel2, nLevel5, nLevel4, nLevel3, nLevel6}	--界面1～6排序并非按照6个技能的id次序
	if nParam <= 100 or nParam > 700 then
	    SkillType = 0
		ShowLv = nil
	elseif nParam <= 200 then SkillType = 1
	elseif nParam >200 and nParam <= 300 then SkillType = 2
	elseif nParam >300 and nParam <= 400 then SkillType = 3
	elseif nParam >400 and nParam <= 500 then SkillType = 4
	elseif nParam >500 and nParam <= 600 then SkillType = 5
	elseif nParam >600 then SkillType = 6
	end
	if SkillType ~= 0 then
		SkillNo = nParam - SkillType * 100
		if SkillLevel[SkillType] < SkillOpenPoint[SkillNo] then ShowLv = nil
		else
			for i = 1, SkillMaxLevel[SkillNo] do
				if SkillLevel[SkillType] >= SkillOpenPoint[SkillNo] * i then
			    	ShowLv = i
				else break end
			end
		end
	end
    if ShowLv ~= nil then
		DlgApi.ShowItem(--[[!AUTO_100]]"Win_SkillAttribute", Format(--[[!AUTO_101]]"AttTxt_%d", nParam), true)
    	DlgApi.ShowItem(--[[!AUTO_102]]"Win_SkillAttribute", Format(--[[!AUTO_103]]"Mask_%d", nParam), false)
    else
		DlgApi.ShowItem(--[[!AUTO_104]]"Win_SkillAttribute", Format(--[[!AUTO_105]]"AttTxt_%d", nParam), false)
    	DlgApi.ShowItem(--[[!AUTO_106]]"Win_SkillAttribute", Format(--[[!AUTO_107]]"Mask_%d", nParam), true)
    end
	return ShowLv
end

--天赋及资质界面上的职业剩余点数显示 --uType = 0时，计算天赋界面主职业剩余点数 --nCharLevel:角色等级
--nLevel    :主职业等级 --nRestPoint:主职业剩余天赋点数 --uType = 1时，计算天赋界面副职业剩余点数 --nCharLevel:角色等级
--nLevel    :副职业等级 --nRestPoint:副职业剩余天赋点数 --uType = 3时，计算资质界面剩余点数
--nCharLevel:角色等级
--nLevel    :主职业等级 --nRestPoint:主职业剩余天赋点数
function GameUI:GetRestPoint(uType, nCharLevel, nLevel, nRestPoint)
	if uType == 0 then
		if nCharLevel >= 61 and nLevel >= 62 then
			if nRestPoint > (nCharLevel - 60) * 5 then
			    ShowPoint = nRestPoint - (nCharLevel - 60) * 5
			else
				ShowPoint = 0
			end
		else
		    ShowPoint = nRestPoint
		end
	elseif uType == 1 then
		ShowPoint = nRestPoint
	elseif uType == 3 then
    	if nCharLevel >= 61 and nLevel >= 62 then
    		if nRestPoint > (nCharLevel - 60) * 5 then
    		    ShowPoint = (nCharLevel - 60) * 5
    		else
    			ShowPoint = nRestPoint
    		end
    	else
    	    ShowPoint = 0
    	end
	end
	return ShowPoint
end

--LevelHelpString1~7
--最近更新内容
function GameUI:GetLevelHelp1(level, prof1, prof1level, prof2, prof2level)
	LevelHelpString = TEXT_NEWHELP_CONTENT
	return LevelHelpString
end

--兵种LevelHelp
function GameUI:GetLevelHelp2(level, prof1, prof1level, prof2, prof2level)
	--各兵种的升阶NPC（对应ProfLevel为1,2,12,22,32,42,52,62,72,82） 	local ProfUpNPC = {}
	ProfUpNPC[1] = {3996,1910,1910,1910,1910,1910,1910,1910,1910,1910}
	ProfUpNPC[2] = {3996,3365,3365,3365,3365,3365,3365,3365,3365,3365}
	ProfUpNPC[3] = {3996,3366,3366,3366,3366,3366,3366,3366,3366,3366}
	ProfUpNPC[4] = {3996,3367,3367,3367,3367,3367,3367,3367,3367,3367}
	ProfUpNPC[5] = {3996,3368,3368,3368,3368,3368,3368,3368,3368,3368}
	ProfUpNPC[6] = {3996,3369,3369,3369,3369,3369,3369,3369,3369,3369}
	ProfUpNPC[7] = {3996,3370,3370,3370,3370,3370,3370,3370,3370,3370}
	ProfUpNPC[8] = {3996,3371,3371,3371,3371,3371,3371,3371,3371,3371}
	ProfUpNPC[9] = {3996,3372,3372,3372,3372,3372,3372,3372,3372,3372}
	ProfUpNPC[10] = {3996,3373,3373,3373,3373,3373,3373,3373,3373,3373}
	ProfUpNPC[11] = {3996,3374,3374,3374,3374,3374,3374,3374,3374,3374}
	ProfUpNPC[12] = {3996,3375,3375,3375,3375,3375,3375,3375,3375,3375}
	ProfUpNPC[13] = {3996,3376,3376,3376,3376,3376,3376,3376,3376,3376}
	ProfUpNPC[14] = {3996,3377,3377,3377,3377,3377,3377,3377,3377,3377}
	ProfUpNPC[15] = {3996,3378,3378,3378,3378,3378,3378,3378,3378,3378}
	ProfUpNPC[16] = {3996,3379,3379,3379,3379,3379,3379,3379,3379,3379}
	ProfUpNPC[17] = {3996,3380,3380,3380,3380,3380,3380,3380,3380,3380}
	ProfUpNPC[18] = {3996,3381,3381,3381,3381,3381,3381,3381,3381,3381}
	--职业前缀
	local ProfFirstName = {}
	ProfFirstName[1] = {GNR_PROFLEVEL_NAME1_0, GNR_PROFLEVEL_NAME1_1, GNR_PROFLEVEL_NAME1_2, GNR_PROFLEVEL_NAME1_3, GNR_PROFLEVEL_NAME1_4, GNR_PROFLEVEL_NAME1_5, GNR_PROFLEVEL_NAME1_6, GNR_PROFLEVEL_NAME1_7, GNR_PROFLEVEL_NAME1_8, GNR_PROFLEVEL_NAME1_9}
    ProfFirstName[2] = {GNR_PROFLEVEL_NAME2_0, GNR_PROFLEVEL_NAME2_1, GNR_PROFLEVEL_NAME2_2, GNR_PROFLEVEL_NAME2_3, GNR_PROFLEVEL_NAME2_4, GNR_PROFLEVEL_NAME2_5, GNR_PROFLEVEL_NAME2_6, GNR_PROFLEVEL_NAME2_7, GNR_PROFLEVEL_NAME2_8, GNR_PROFLEVEL_NAME2_9}
    ProfFirstName[3] = {GNR_PROFLEVEL_NAME3_0, GNR_PROFLEVEL_NAME3_1, GNR_PROFLEVEL_NAME3_2, GNR_PROFLEVEL_NAME3_3, GNR_PROFLEVEL_NAME3_4, GNR_PROFLEVEL_NAME3_5, GNR_PROFLEVEL_NAME3_6, GNR_PROFLEVEL_NAME3_7, GNR_PROFLEVEL_NAME3_8, GNR_PROFLEVEL_NAME3_9}
    ProfFirstName[4] = {GNR_PROFLEVEL_NAME4_0, GNR_PROFLEVEL_NAME4_1, GNR_PROFLEVEL_NAME4_2, GNR_PROFLEVEL_NAME4_3, GNR_PROFLEVEL_NAME4_4, GNR_PROFLEVEL_NAME4_5, GNR_PROFLEVEL_NAME4_6, GNR_PROFLEVEL_NAME4_7, GNR_PROFLEVEL_NAME4_8, GNR_PROFLEVEL_NAME4_9}
    ProfFirstName[5] = {GNR_PROFLEVEL_NAME5_0, GNR_PROFLEVEL_NAME5_1, GNR_PROFLEVEL_NAME5_2, GNR_PROFLEVEL_NAME5_3, GNR_PROFLEVEL_NAME5_4, GNR_PROFLEVEL_NAME5_5, GNR_PROFLEVEL_NAME5_6, GNR_PROFLEVEL_NAME5_7, GNR_PROFLEVEL_NAME5_8, GNR_PROFLEVEL_NAME5_9}
    ProfFirstName[6] = {GNR_PROFLEVEL_NAME6_0, GNR_PROFLEVEL_NAME6_1, GNR_PROFLEVEL_NAME6_2, GNR_PROFLEVEL_NAME6_3, GNR_PROFLEVEL_NAME6_4, GNR_PROFLEVEL_NAME6_5, GNR_PROFLEVEL_NAME6_6, GNR_PROFLEVEL_NAME6_7, GNR_PROFLEVEL_NAME6_8, GNR_PROFLEVEL_NAME6_9}
    ProfFirstName[7] = {GNR_PROFLEVEL_NAME7_0, GNR_PROFLEVEL_NAME7_1, GNR_PROFLEVEL_NAME7_2, GNR_PROFLEVEL_NAME7_3, GNR_PROFLEVEL_NAME7_4, GNR_PROFLEVEL_NAME7_5, GNR_PROFLEVEL_NAME7_6, GNR_PROFLEVEL_NAME7_7, GNR_PROFLEVEL_NAME7_8, GNR_PROFLEVEL_NAME7_9}
    ProfFirstName[8] = {GNR_PROFLEVEL_NAME8_0, GNR_PROFLEVEL_NAME8_1, GNR_PROFLEVEL_NAME8_2, GNR_PROFLEVEL_NAME8_3, GNR_PROFLEVEL_NAME8_4, GNR_PROFLEVEL_NAME8_5, GNR_PROFLEVEL_NAME8_6, GNR_PROFLEVEL_NAME8_7, GNR_PROFLEVEL_NAME8_8, GNR_PROFLEVEL_NAME8_9}
    ProfFirstName[9] = {GNR_PROFLEVEL_NAME9_0, GNR_PROFLEVEL_NAME9_1, GNR_PROFLEVEL_NAME9_2, GNR_PROFLEVEL_NAME9_3, GNR_PROFLEVEL_NAME9_4, GNR_PROFLEVEL_NAME9_5, GNR_PROFLEVEL_NAME9_6, GNR_PROFLEVEL_NAME9_7, GNR_PROFLEVEL_NAME9_8, GNR_PROFLEVEL_NAME9_9}
    ProfFirstName[10] = {GNR_PROFLEVEL_NAME10_0, GNR_PROFLEVEL_NAME10_1, GNR_PROFLEVEL_NAME10_2, GNR_PROFLEVEL_NAME10_3, GNR_PROFLEVEL_NAME10_4, GNR_PROFLEVEL_NAME10_5, GNR_PROFLEVEL_NAME10_6, GNR_PROFLEVEL_NAME10_7, GNR_PROFLEVEL_NAME10_8, GNR_PROFLEVEL_NAME10_9}
    ProfFirstName[11] = {GNR_PROFLEVEL_NAME11_0, GNR_PROFLEVEL_NAME11_1, GNR_PROFLEVEL_NAME11_2, GNR_PROFLEVEL_NAME11_3, GNR_PROFLEVEL_NAME11_4, GNR_PROFLEVEL_NAME11_5, GNR_PROFLEVEL_NAME11_6, GNR_PROFLEVEL_NAME11_7, GNR_PROFLEVEL_NAME11_8, GNR_PROFLEVEL_NAME11_9}
    ProfFirstName[12] = {GNR_PROFLEVEL_NAME12_0, GNR_PROFLEVEL_NAME12_1, GNR_PROFLEVEL_NAME12_2, GNR_PROFLEVEL_NAME12_3, GNR_PROFLEVEL_NAME12_4, GNR_PROFLEVEL_NAME12_5, GNR_PROFLEVEL_NAME12_6, GNR_PROFLEVEL_NAME12_7, GNR_PROFLEVEL_NAME12_8, GNR_PROFLEVEL_NAME12_9}
    ProfFirstName[13] = {GNR_PROFLEVEL_NAME13_0, GNR_PROFLEVEL_NAME13_1, GNR_PROFLEVEL_NAME13_2, GNR_PROFLEVEL_NAME13_3, GNR_PROFLEVEL_NAME13_4, GNR_PROFLEVEL_NAME13_5, GNR_PROFLEVEL_NAME13_6, GNR_PROFLEVEL_NAME13_7, GNR_PROFLEVEL_NAME13_8, GNR_PROFLEVEL_NAME13_9}
    ProfFirstName[14] = {GNR_PROFLEVEL_NAME14_0, GNR_PROFLEVEL_NAME14_1, GNR_PROFLEVEL_NAME14_2, GNR_PROFLEVEL_NAME14_3, GNR_PROFLEVEL_NAME14_4, GNR_PROFLEVEL_NAME14_5, GNR_PROFLEVEL_NAME14_6, GNR_PROFLEVEL_NAME14_7, GNR_PROFLEVEL_NAME14_8, GNR_PROFLEVEL_NAME14_9}
    ProfFirstName[15] = {GNR_PROFLEVEL_NAME15_0, GNR_PROFLEVEL_NAME15_1, GNR_PROFLEVEL_NAME15_2, GNR_PROFLEVEL_NAME15_3, GNR_PROFLEVEL_NAME15_4, GNR_PROFLEVEL_NAME15_5, GNR_PROFLEVEL_NAME15_6, GNR_PROFLEVEL_NAME15_7, GNR_PROFLEVEL_NAME15_8, GNR_PROFLEVEL_NAME15_9}
    ProfFirstName[16] = {GNR_PROFLEVEL_NAME16_0, GNR_PROFLEVEL_NAME16_1, GNR_PROFLEVEL_NAME16_2, GNR_PROFLEVEL_NAME16_3, GNR_PROFLEVEL_NAME16_4, GNR_PROFLEVEL_NAME16_5, GNR_PROFLEVEL_NAME16_6, GNR_PROFLEVEL_NAME16_7, GNR_PROFLEVEL_NAME16_8, GNR_PROFLEVEL_NAME16_9}
    ProfFirstName[17] = {GNR_PROFLEVEL_NAME17_0, GNR_PROFLEVEL_NAME17_1, GNR_PROFLEVEL_NAME17_2, GNR_PROFLEVEL_NAME17_3, GNR_PROFLEVEL_NAME17_4, GNR_PROFLEVEL_NAME17_5, GNR_PROFLEVEL_NAME17_6, GNR_PROFLEVEL_NAME17_7, GNR_PROFLEVEL_NAME17_8, GNR_PROFLEVEL_NAME17_9}
    ProfFirstName[18] = {GNR_PROFLEVEL_NAME18_0, GNR_PROFLEVEL_NAME18_1, GNR_PROFLEVEL_NAME18_2, GNR_PROFLEVEL_NAME18_3, GNR_PROFLEVEL_NAME18_4, GNR_PROFLEVEL_NAME18_5, GNR_PROFLEVEL_NAME18_6, GNR_PROFLEVEL_NAME18_7, GNR_PROFLEVEL_NAME18_8, GNR_PROFLEVEL_NAME18_9}
	--职业后缀
	local ProfNextName = {GNR_PROFRANK_NAME0, GNR_PROFRANK_NAME1, GNR_PROFRANK_NAME2, GNR_PROFRANK_NAME3, GNR_PROFRANK_NAME4, GNR_PROFRANK_NAME5, GNR_PROFRANK_NAME6, GNR_PROFRANK_NAME7, GNR_PROFRANK_NAME8, GNR_PROFRANK_NAME9}
	--每阶0段时的职业等级 	local Prof0ClassLevel = {1,2,12,22,32,42,52,62,72,82}
	--升阶时人物等级 	local ProfUpLv = {10,20,30,40,50,60,61}
	--选职业NPC ID
	SelectNPC = 4968
	--学骑乘NPC ID
	RideNPC = 3352

	local MainFirstName = ProfFirstName[prof1]
	local SubFirstName = ProfFirstName[prof2]
	local MainProfNPC = ProfUpNPC[prof1]
	local SubProfNPC = ProfUpNPC[prof2]
	local Main_Rank, Sub_Rank, Main_Class, Sub_Class, MainCanRankUp, SubCanRankUp = 0, 0, 0, 0, 0, 0
	local Max_Rank = Max_iLevel
	--计算主兵种rank和class
	if prof1 ~= 0 then
    	for i = 1, Max_Rank do
    	    if prof1level >= Prof0ClassLevel[i] then
    	        Main_Rank = i
    	    else Main_Rank = i - 1 break end
    	end
    	Main_Class = prof1level - Prof0ClassLevel[Main_Rank] + 1
    	if prof1level == 1 or Main_Class == 10 then
    	    if level >= ProfUpLv[Main_Rank] and prof1level < Max_ProfLevel then
    	        MainCanRankUp = 1
    	    end
    	end
	end
	--计算副兵种rank和class
	if prof2 ~= 0 then
    	for k = 1, Max_Rank do
    	    if prof2level >= Prof0ClassLevel[k] then
    	        Sub_Rank = k
    	    else Sub_Rank = k - 1 break end
    	end
    	Sub_Class = prof2level - Prof0ClassLevel[Sub_Rank] + 1
    	if prof2level == 1 or Sub_Class == 10 then
    	    if level >= ProfUpLv[Sub_Rank] and prof2level < Max_ProfLevel then
    	        SubCanRankUp = 1
    	    end
    	end
    end
	--计算可选副兵种时兵种等级的rank和class
	for j = 1, Max_Rank do
	    if SelSubLv >= Prof0ClassLevel[j] then
	        Sel_Rank = j
	    else Sel_Rank = j - 1 break end
	end
	Sel_Class = SelSubLv - Prof0ClassLevel[Sel_Rank] + 1
	--计算副兵种开始获得专精点时兵种等级的rank和class
	for l = 1, Max_Rank do
	    if DowerSubLv >= Prof0ClassLevel[l] then
	        SD_Rank = l
	    else SD_Rank = l - 1 break end
	end
	SD_Class = DowerSubLv - Prof0ClassLevel[SD_Rank] + 1
	--计算建议提升到的兵种等级的rank和class，人物等级到61级后直接建议提升ProfLevel到62
	if level >= 61 then
		if prof1level <= 61 then
    		Sug_Rank = 8
    		Sug_Class = 0
		end
	else
		if level >= 10 and level - 8 > prof1level then
    	for m = 1, Max_Rank do
    	    if level - 8 >= Prof0ClassLevel[m] then
    	        Sug_Rank = m
    	    else Sug_Rank = m - 1 break end
    	end
    	Sug_Class = level - 8 - Prof0ClassLevel[Sug_Rank] + 1
    	end
	end

	--兵种提示
	local ProfString, MainProfString, SubProfString = --[[!AUTO_108]]"", --[[!AUTO_109]]"", --[[!AUTO_110]]""
	if prof1 == 0 then
	    MainProfString = Format(TEXT_PROFHELP_MAINPROFNIL, SelectNPC)
	else
	    local NowMainString, MainSugString = --[[!AUTO_111]]"", --[[!AUTO_112]]""
		NowMainString = Format(TEXT_PROFHELP_NOWMAINPROF, MainFirstName[Main_Rank], ProfNextName[Main_Class])
		if prof1level >= Max_ProfLevel then
		    MainSugString = TEXT_PROFHELP_MAINPROFMAX
		else
		    if MainCanRankUp == 1 then
		    	MainSugString = Format(TEXT_PROFHELP_MAINSUGGEST2, MainProfNPC[Main_Rank], MainFirstName[Main_Rank + 1], ProfNextName[1])
			else
				if Sug_Rank~= nil then
					MainSugString = Format(TEXT_PROFHELP_MAINSUGGEST1, MainFirstName[Sug_Rank], ProfNextName[Sug_Class])
				else MainSugString = --[[!AUTO_113]]"" end
			end
		end
		MainProfString = Format(--[[!AUTO_114]]"%s %s", NowMainString, MainSugString)
	end
	if prof2 == 0 then
	    if prof1 == 0 then
	        SubProfString = TEXT_PROFHELP_SUBPROFNIL3
	    else
	        if prof1level < SelSubLv then
	        	SubProfString = Format(TEXT_PROFHELP_SUBPROFNIL2, MainFirstName[Sel_Rank], ProfNextName[Sel_Class])
	        else SubProfString = Format(TEXT_PROFHELP_SUBPROFNIL1, SelectNPC) end
	    end
	else
	    local NowSubString, SubSugString = --[[!AUTO_115]]"", --[[!AUTO_116]]""
		NowSubString = Format(TEXT_PROFHELP_NOWSUBPROF, SubFirstName[Sub_Rank], ProfNextName[Sub_Class])
		if prof2level >= Max_ProfLevel then
		    SubSugString = TEXT_PROFHELP_SUBPROFMAX
		else
		    if SubCanRankUp == 1 then
		    	SubSugString = Format(TEXT_PROFHELP_SUBSUGGEST, SubProfNPC[Sub_Rank], SubFirstName[Sub_Rank + 1], ProfNextName[1])
			else SubSugString = --[[!AUTO_117]]"" end
		end
		SubProfString = Format(--[[!AUTO_118]]"%s %s", NowSubString, SubSugString)
	end
	if prof1 ~= 0 and prof2 ~= 0 then
	    if prof1level <= prof2level and prof2level < Max_ProfLevel then
	        ProfString = Format(--[[!AUTO_119]]"        %s\r        %s\r        %s", MainProfString, SubProfString, TEXT_PROFHELP_SUGGEST)
	    else ProfString = Format(--[[!AUTO_120]]"        %s\r        %s", MainProfString, SubProfString) end
	else ProfString = Format(--[[!AUTO_121]]"        %s\r        %s", MainProfString, SubProfString)
	end

	--技能学习提示 	local SkillString, SkillSugString, RideSugString, LearnNPC= "", "", "", ""
	local LearnNPC = 0
	--河北地图技能学习NPC(lv：2/4 6/8 10 12/14，大于15时去长安学技能)
	if prof1 ~= 0 then
    	if level <= 4 then
    	    LearnNPC = 3346
    		else if level <= 8 then
    	    	LearnNPC = 3348
    			else if level <= 10 then
    	    		LearnNPC = 1882
    				else if level <= 14 then
    					LearnNPC = 1882
    					else
    					LearnNPC = MainProfNPC[2]
    				end
				end
    		end
		end

    	--人物等级上限开到100级，实际有技能学的等级只到80级
    	for i = 1, 80/2 do
    	    if level/2 == i then
    	        SkillSugString = Format(TEXT_PROFHELP_LEARNSKILL, LearnNPC)
    	        break
    	    else if level/2 < i then
    	        SkillSugString = TEXT_PROFHELP_LEARNNIL
    	        break
    	    	end
    	    end
    	end

    	if level > 80 then
    	    SkillSugString = TEXT_PROFHELP_LEARNNIL
    	end

	else
	    SkillSugString = TEXT_PROFHELP_LEARNNIL
	end
	if level < 20 then
	    RideSugString = Format(TEXT_PROFHELP_LEARNRIDE, RideNPC)
	end
	SkillString = Format(--[[!AUTO_122]]"        %s %s", SkillSugString, RideSugString)

	--专精提示
	local MainDowerString, SubDowerString = --[[!AUTO_123]]"", --[[!AUTO_124]]""
	if prof1 == 0 then
		MainDowerString = TEXT_PROFHELP_MAINDOWERNIL
	else
		if prof1level >= 61 then
	    	MainDowerString = Format(TEXT_PROFHELP_MAINDOWER1, 60)
		else MainDowerString = Format(--[[!AUTO_125]]"%s %s", Format(TEXT_PROFHELP_MAINDOWER1, prof1level - 1), TEXT_PROFHELP_MAINDOWER2) end
	end
	if prof2 == 0 then
		SubDowerString = TEXT_PROFHELP_SUBDOWERNIL
	else
	    if prof2level >= 61 then
			SubDowerString = Format(TEXT_PROFHELP_SUBDOWER1, 25)
	    else
	        if prof2level >= DowerSubLv then
	            SubDowerString = Format(--[[!AUTO_126]]"%s %s", Format(TEXT_PROFHELP_SUBDOWER1, prof2level - DowerSubLv + 1), TEXT_PROFHELP_SUBDOWER2)
	        else
	            SubDowerString = Format(--[[!AUTO_127]]"%s %s", Format(TEXT_PROFHELP_SUBDOWER1, 0), Format(TEXT_PROFHELP_SUBDOWER3, SubFirstName[SD_Rank], ProfNextName[SD_Class]))
	        end
	    end
	end

	--资质提示
	local IntDowerString = --[[!AUTO_128]]""
	if prof1 ~= 0 then
	    if level >= 61 and prof1level >= 62 then
	        if level >= Max_Level then
	            IntDowerString = Format(--[[!AUTO_129]]"\r%s\r        %s", TEXT_PROFHELP_TITLE4, Format(TEXT_PROFHELP_INTDOWER1, (level - 60) * 5))
	        else IntDowerString = Format(--[[!AUTO_130]]"\r%s\r        %s %s", TEXT_PROFHELP_TITLE4, Format(TEXT_PROFHELP_INTDOWER1, (level - 60) * 5), TEXT_PROFHELP_INTDOWER2) end
	    end
	end

	LevelHelpString = Format(--[[!AUTO_131]]"%s\r%s\r%s\r%s\r%s\r        %s\r        %s%s", TEXT_PROFHELP_TITLE1, ProfString, TEXT_PROFHELP_TITLE2, SkillString, TEXT_PROFHELP_TITLE3, MainDowerString, SubDowerString, IntDowerString)
	return LevelHelpString
end

--任务LevelHelp
function GameUI:GetLevelHelp3(level, prof1, prof1level, prof2, prof2level)
	LevelHelpString = --[[!AUTO_132]]""
	return LevelHelpString
end

--日常活动LevelHelp
function GameUI:GetLevelHelp4(level, prof1, prof1level, prof2, prof2level)
	--各个日常活动的资料表
	local Meet = {}
	Meet[1] = {NeedLv = 1, MeetNPCid = 0, Name = TEXT_MEET_NAME1, Note = TEXT_MEET_NOTE1}
	Meet[2] = {NeedLv = 1, MeetNPCid = 0, Name = TEXT_MEET_NAME2, Note = TEXT_MEET_NOTE2}
	Meet[3] = {NeedLv = 8, MeetNPCid = 14873, Name = TEXT_MEET_NAME3, Note = TEXT_MEET_NOTE3}
	Meet[4] = {NeedLv = 16, MeetNPCid = 9013, Name = TEXT_MEET_NAME4, Note = TEXT_MEET_NOTE4}
	Meet[5] = {NeedLv = 16, MeetNPCid = 9163, Name = TEXT_MEET_NAME5, Note = TEXT_MEET_NOTE5}
	Meet[6] = {NeedLv = 16, MeetNPCid = 9163, Name = TEXT_MEET_NAME6, Note = TEXT_MEET_NOTE6}
	Meet[7] = {NeedLv = 40, MeetNPCid = 3167, Name = TEXT_MEET_NAME7, Note = TEXT_MEET_NOTE7}
	Meet[8] = {NeedLv = 58, MeetNPCid = 0, Name = TEXT_MEET_NAME8, Note = TEXT_MEET_NOTE8}

	local MeetString = {}
	local String1, String2 = --[[!AUTO_133]]"", --[[!AUTO_134]]""
	local AllMeetString = --[[!AUTO_135]]""

	local n = 0
	while true do
	    n = n + 1
	    if Meet[n] == nil then n = n - 1 break end
	end
	for i = 1, n do
		if level >= Meet[i].NeedLv then
		    String1 = Format(TEXT_MEETHELP_CONTENT1, Meet[i].Name, Meet[i].Note)
		    if Meet[i].MeetNPCid ~= 0 then
		        String2 = Format(TEXT_MEETHELP_CONTENT2, Meet[i].MeetNPCid)
		    else
		        String2 = --[[!AUTO_136]]""
		    end
		    MeetString[i] = Format(--[[!AUTO_137]]"%s %s\r", String1, String2)
		else
		    MeetString[i] = --[[!AUTO_138]]""
		end
		AllMeetString = Format(--[[!AUTO_139]]"%s %s", AllMeetString, MeetString[i])
	end
	if AllMeetString ~= --[[!AUTO_140]]"" then
	    LevelHelpString = AllMeetString
	else
	    LevelHelpString = TEXT_MEETHELP_NIL
	end
	return LevelHelpString
end

--装备LevelHelp
function GameUI:GetLevelHelp5(level, prof1, prof1level, prof2, prof2level)
	--各阶装备的等级需求表(1武器2衣服3护肩4护腿5鞋6腰带7护腕)
	local EquipNeedLevel = {}
	EquipNeedLevel[1] = {1, 8, 22, 36, 50, 60, 60, 70, 80, 90, 100, 256} --武器
	EquipNeedLevel[2] = {2, 8, 22, 36, 50, 60, 60, 70, 80, 90, 100, 256} --衣服
	EquipNeedLevel[3] = {4, 13, 27, 41, 54, 60, 60, 70, 80, 90, 100, 256} --护肩
	EquipNeedLevel[4] = {5, 15, 29, 43, 56, 60, 60, 70, 80, 90, 100, 256} --护腿
	EquipNeedLevel[5] = {3, 10, 24, 38, 52, 60, 60, 70, 80, 90, 100, 256} --鞋 	EquipNeedLevel[6] = {6, 18, 32, 46, 57, 60, 60, 70, 80, 90, 100, 256} --腰带
	EquipNeedLevel[7] = {7, 20, 34, 48, 58, 60, 60, 70, 80, 90, 100, 256} --护腕
	--装备品级名称
	local EquipLevelName = {GNR_EQUIPLEVEL_NAME0, GNR_EQUIPLEVEL_NAME1, GNR_EQUIPLEVEL_NAME2, GNR_EQUIPLEVEL_NAME3, GNR_EQUIPLEVEL_NAME4, GNR_EQUIPLEVEL_NAME5, GNR_EQUIPLEVEL_NAME6, GNR_EQUIPLEVEL_NAME7, GNR_EQUIPLEVEL_NAME8, GNR_EQUIPLEVEL_NAME9, GNR_EQUIPLEVEL_NAME10}
	--装备位置名称
	local EquipGridName = {GNR_EQUIPGRID_NAME1, GNR_EQUIPGRID_NAME2, GNR_EQUIPGRID_NAME3, GNR_EQUIPGRID_NAME4, GNR_EQUIPGRID_NAME5, GNR_EQUIPGRID_NAME6, GNR_EQUIPGRID_NAME7}

	local EquipString = {}
	local CanChangeGrid, CanChangeString, AllEquipString = --[[!AUTO_141]]"", --[[!AUTO_142]]"", --[[!AUTO_143]]""

	local Now_eLv, n = 0, 0
	while true do
	    n = n + 1
	    if EquipNeedLevel[n] == nil then n = n - 1 break end
	end
	for eId = 1, n do
		for eLv = 1, Max_EquipLevel + 1 do
			if level >= EquipNeedLevel[eId][eLv] then
				Now_eLv = eLv;
			else
		    	Now_eLv = eLv - 1;
		    	break;
			end
		end
		NowString = Format(TEXT_EQUIPHELP_NOWEQUIP, EquipGridName[eId], EquipLevelName[Now_eLv])
		if EquipNeedLevel[eId][Now_eLv + 1] > Max_Level or Now_eLv >= Max_EquipLevel + 1 then
		    NextString = --[[!AUTO_144]]""
		else
			NextString = Format(TEXT_EQUIPHELP_NEXTEQUIP, EquipGridName[eId], EquipNeedLevel[eId][Now_eLv + 1])
		end
		EquipString[eId] = Format(--[[!AUTO_145]]"%s %s\r", NowString, NextString)
		AllEquipString = Format(--[[!AUTO_146]]"%s %s", AllEquipString, EquipString[eId])
		for eLvAG = 1, Max_EquipLevel + 1 do
			if level == EquipNeedLevel[eId][eLvAG] then
			   	CanChangeGrid = Format(--[[!AUTO_147]]"%s %s", CanChangeGrid, Format(--[[!AUTO_148]]"%s %s", EquipGridName[eId], --[[!AUTO_149]]" "));
				break;
			end
		end
	end

	if CanChangeGrid == --[[!AUTO_150]]"" then
	    CanChangeString = --[[!AUTO_151]]""
	else
	    CanChangeString = Format(--[[!AUTO_152]]"%s\r\r", Format(TEXT_EQUIPHELP_CANCHANGE, CanChangeGrid));
	end

	LevelHelpString = Format(--[[!AUTO_153]]"%s %s", CanChangeString, AllEquipString)
	return LevelHelpString
end

--生产技能LevelHelp
function GameUI:GetLevelHelp6(level, prof1, prof1level, prof2, prof2level)
	--各个生产技能的资料表，OpenLv开放生产等级，LearnNeedLv学习的等级要求，LearnNeedSkill学习的生产熟练度要求，LearnNPCid学习的NPC的ID
	local Produce = {}
	Produce[1] = {Name = TEXT_PRODUCESKILL_SKILLTYPE1, Note = TEXT_PRODUCESKILL_NOTE1, OpenLv = 1, LearnNeedLv = {20}, LearnNeedSkill = {0}, LearnNPCid = {1915}} --驯养
	Produce[2] = {Name = TEXT_PRODUCESKILL_SKILLTYPE2, Note = TEXT_PRODUCESKILL_NOTE2, OpenLv = 6, LearnNeedLv = {5,15,24,36,48,63}, LearnNeedSkill = {0,15,35,60,90,120}, LearnNPCid = {1923,1924,1924,1924,1924,1924}} --烹饪
	Produce[3] = {Name = TEXT_PRODUCESKILL_SKILLTYPE3, Note = TEXT_PRODUCESKILL_NOTE3, OpenLv = 6, LearnNeedLv = {8,20,34,48,58,68}, LearnNeedSkill = {0,15,35,60,90,120}, LearnNPCid = {1917,1918,1918,1918,1918,1918}} --铁匠
	Produce[4] = {Name = TEXT_PRODUCESKILL_SKILLTYPE4, Note = TEXT_PRODUCESKILL_NOTE4, OpenLv = 5, LearnNeedLv = {8,20,34,48,58}, LearnNeedSkill = {0,15,35,60,90}, LearnNPCid = {1919,1920,1920,1920,1920}} --裁缝
	Produce[5] = {Name = TEXT_PRODUCESKILL_SKILLTYPE5, Note = TEXT_PRODUCESKILL_NOTE5, OpenLv = 4, LearnNeedLv = {22,34,48,58}, LearnNeedSkill = {0,15,35,60}, LearnNPCid = {1927,1928,1928,1928}} --巧匠
	Produce[6] = {Name = TEXT_PRODUCESKILL_SKILLTYPE6, Note = TEXT_PRODUCESKILL_NOTE6, OpenLv = 6, LearnNeedLv = {19,24,34,44,53,71}, LearnNeedSkill = {0,15,35,60,90,120}, LearnNPCid = {1925,1926,1926,1926,1926,1926}} --药师
	Produce[7] = {Name = TEXT_PRODUCESKILL_SKILLTYPE7, Note = TEXT_PRODUCESKILL_NOTE7, OpenLv = 6, LearnNeedLv = {9,15,28,40,48,65}, LearnNeedSkill = {0,15,35,60,90,120}, LearnNPCid = {1929,1930,1930,1930,1930,1930}} --急救
	Produce[8] = {Name = TEXT_PRODUCESKILL_SKILLTYPE8, Note = TEXT_PRODUCESKILL_NOTE8, OpenLv = 1, LearnNeedLv = {22}, LearnNeedSkill = {0}, LearnNPCid = {1932}} --工匠
	local ProduceLvName = {TEXT_PRODUCESKILL_SKILLLEVELTYPE1, TEXT_PRODUCESKILL_SKILLLEVELTYPE2, TEXT_PRODUCESKILL_SKILLLEVELTYPE3, TEXT_PRODUCESKILL_SKILLLEVELTYPE4, TEXT_PRODUCESKILL_SKILLLEVELTYPE5, TEXT_PRODUCESKILL_SKILLLEVELTYPE6}

	local ProduceString = {}
	local AllProduceString = --[[!AUTO_154]]""
	local n, Now_pLv = 0, 0
	while true do
	    n = n + 1
	    if Produce[n] == nil then n = n - 1 break end
	end
	for i = 1, n do
		local LearnLv = Produce[i].LearnNeedLv
		local LearnNpc = Produce[i].LearnNPCid
		for pLv = 1, Produce[i].OpenLv do
			if level >= LearnLv[pLv] then
				Now_pLv = pLv;
			else
		    	Now_pLv = pLv - 1;
		    	break;
			end
		end
		if Now_pLv==0 then
			ProduceString[i] = Format(TEXT_PRODUCEHELP_SKILLINFO, Produce[i].Name, Produce[i].Note, Format(TEXT_PRODUCEHELP_FIRSTINFO, LearnLv[1]))
		else
		    ProduceString[i] = Format(TEXT_PRODUCEHELP_SKILLINFO, Produce[i].Name, Produce[i].Note, Format(TEXT_PRODUCEHELP_LEARNINFO, ProduceLvName[Now_pLv], LearnNpc[Now_pLv]))
		end
		AllProduceString = Format(--[[!AUTO_155]]"%s %s\r", AllProduceString, ProduceString[i])
	end
	LevelHelpString = AllProduceString
	return LevelHelpString
end

--战场LevelHelp
function GameUI:GetLevelHelp7(level, prof1, prof1level, prof2, prof2level)
	--各个战场的资料表
	local Battle = {}
	Battle[1] = {Name = TEXT_BATTLE_NAME1, NeedLv = 58, Type = 1}
	Battle[2] = {Name = TEXT_BATTLE_NAME2, NeedLv = 60, Type = 1}
	Battle[3] = {Name = TEXT_BATTLE_NAME3, NeedLv = 20, Type = 2}
	Battle[4] = {Name = TEXT_BATTLE_NAME4, NeedLv = 40, Type = 2}
	Battle[5] = {Name = TEXT_BATTLE_NAME5, NeedLv = 50, Type = 2}
	Battle[6] = {Name = TEXT_BATTLE_NAME6, NeedLv = 50, Type = 2}
	Battle[7] = {Name = TEXT_BATTLE_NAME7, NeedLv = 58, Type = 2}
	Battle[8] = {Name = TEXT_BATTLE_NAME8, NeedLv = 25, Type = 3}
	Battle[9] = {Name = TEXT_BATTLE_NAME9, NeedLv = 60, Type = 3}
	Battle[10] = {Name = TEXT_BATTLE_NAME10, NeedLv = 60, Type = 3}
	Battle[11] = {Name = TEXT_BATTLE_NAME11, NeedLv = 30, Type = 4}
	Battle[12] = {Name = TEXT_BATTLE_NAME12, NeedLv = 55, Type = 4}
	Battle[13] = {Name = TEXT_BATTLE_NAME13, NeedLv = 58, Type = 4}
	Battle[14] = {Name = TEXT_BATTLE_NAME14, NeedLv = 58, Type = 4}
	Battle[15] = {Name = TEXT_BATTLE_NAME15, NeedLv = 58, Type = 4}
	Battle[16] = {Name = TEXT_BATTLE_NAME16, NeedLv = 58, Type = 4}
	Battle[17] = {Name = TEXT_BATTLE_NAME17, NeedLv = 58, Type = 4}
	Battle[18] = {Name = TEXT_BATTLE_NAME18, NeedLv = 48, Type = 4}
	Battle[19] = {Name = TEXT_BATTLE_NAME19, NeedLv = 60, Type = 2}
	Battle[20] = {Name = TEXT_BATTLE_NAME20, NeedLv = 65, Type = 2}
	Battle[21] = {Name = TEXT_BATTLE_NAME21, NeedLv = 70, Type = 2}
	Battle[22] = {Name = TEXT_BATTLE_NAME22, NeedLv = 61, Type = 3}
	Battle[23] = {Name = TEXT_BATTLE_NAME23, NeedLv = 68, Type = 3}
	Battle[24] = {Name = TEXT_BATTLE_NAME24, NeedLv = 75, Type = 3}
	local BattleType = {TEXT_BATTLEHELP_BATTLETYPE1, TEXT_BATTLEHELP_BATTLETYPE2, TEXT_BATTLEHELP_BATTLETYPE3, TEXT_BATTLEHELP_BATTLETYPE4}

	local BattleString = {}
	local AllBattleString = --[[!AUTO_156]]""
	local n = 0
	while true do
	    n = n + 1
	    if Battle[n] == nil then n = n - 1 break end
	end
	for i = 1, n do
	    --等级大于入场等级在10级以内的战场均为推荐战场
		if level >= Battle[i].NeedLv and level <= Battle[i].NeedLv + 10 then
			TypeID = Battle[i].Type
			BattleString[i] = Format(--[[!AUTO_157]]"%s\r", Format(TEXT_BATTLEHELP_BATTLEINFO, Battle[i].NeedLv, BattleType[TypeID], Battle[i].Name))
		else
			BattleString[i] = --[[!AUTO_158]]""
		end
		AllBattleString = Format(--[[!AUTO_159]]"%s %s", AllBattleString, BattleString[i])
	end
	if AllBattleString ~= --[[!AUTO_160]]"" then
	    LevelHelpString = Format(--[[!AUTO_161]]"%s\r%s", TEXT_BATTLEHELP_TITLE, AllBattleString)
	else
	    LevelHelpString = TEXT_BATTLEHELP_NIL
	end
	return LevelHelpString
end

--官职LevelHelp（暂时不用）
--function GameUI:GetLevelHelp7(level, prof1, prof1level, prof2, prof2level)
--	--各品官职的资料表(等级需求/NPCid/官职名/官品Level/官职类型：军职文官武官/需要文勋武勋/消耗功勋值)
--	local Position = {}
--    Position[1] = {NeedLv = 10, QuestNPCid = 2484, Name = TEXT_POSITION_NAME1, Lv = 0, Type = 0, NeedExploit = 0, UseExploit = 0}
--    Position[2] = {NeedLv = 20, QuestNPCid = 2485, Name = TEXT_POSITION_NAME2, Lv = 0, Type = 0, NeedExploit = 0, UseExploit = 50}
--    Position[3] = {NeedLv = 30, QuestNPCid = 2219, Name = TEXT_POSITION_NAME3, Lv = 0, Type = 0, NeedExploit = 0, UseExploit = 100}
--    Position[4] = {NeedLv = 40, QuestNPCid = 2489, Name = TEXT_POSITION_NAME4, Lv = 1, Type = 2, NeedExploit = 200, UseExploit = 200}
--    Position[5] = {NeedLv = 50, QuestNPCid = 2489, Name = TEXT_POSITION_NAME5, Lv = 2, Type = 2, NeedExploit = 600, UseExploit = 600}
--    Position[6] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME6, Lv = 3, Type = 2, NeedExploit = 2000, UseExploit = 2000}
--    Position[7] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME7, Lv = 4, Type = 2, NeedExploit = 10000, UseExploit = 6000}
--    Position[8] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME8, Lv = 4, Type = 2, NeedExploit = 10000, UseExploit = 6000}
--    Position[9] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME9, Lv = 5, Type = 2, NeedExploit = 20000, UseExploit = 8000}
--    Position[10] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME10, Lv = 5, Type = 2, NeedExploit = 20000, UseExploit = 8000}
--    Position[11] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME11, Lv = 5, Type = 2, NeedExploit = 20000, UseExploit = 8000}
--    Position[12] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME12, Lv = 5, Type = 2, NeedExploit = 20000, UseExploit = 8000}
--    Position[13] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME13, Lv = 6, Type = 2, NeedExploit = 35000, UseExploit = 15000}
--    Position[14] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME14, Lv = 6, Type = 2, NeedExploit = 35000, UseExploit = 15000}
--    Position[15] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME15, Lv = 6, Type = 2, NeedExploit = 35000, UseExploit = 15000}
--    Position[16] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME16, Lv = 6, Type = 2, NeedExploit = 35000, UseExploit = 15000}
--    Position[17] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME17, Lv = 7, Type = 2, NeedExploit = 65000, UseExploit = 30000}
--    Position[18] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME18, Lv = 7, Type = 2, NeedExploit = 65000, UseExploit = 30000}
--    Position[19] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME19, Lv = 7, Type = 2, NeedExploit = 65000, UseExploit = 30000}
--    Position[20] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME20, Lv = 7, Type = 2, NeedExploit = 65000, UseExploit = 30000}
--    Position[21] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME21, Lv = 8, Type = 2, NeedExploit = 120000, UseExploit = 60000}
--    Position[22] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME22, Lv = 8, Type = 2, NeedExploit = 120000, UseExploit = 60000}
--    Position[23] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME23, Lv = 8, Type = 2, NeedExploit = 120000, UseExploit = 60000}
--    Position[24] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME24, Lv = 8, Type = 2, NeedExploit = 120000, UseExploit = 60000}
--    Position[25] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME25, Lv = 9, Type = 2, NeedExploit = 200000, UseExploit = 100000}
--    Position[26] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME26, Lv = 9, Type = 2, NeedExploit = 200000, UseExploit = 100000}
--    Position[27] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME27, Lv = 9, Type = 2, NeedExploit = 200000, UseExploit = 100000}
--    Position[28] = {NeedLv = 60, QuestNPCid = 2489, Name = TEXT_POSITION_NAME28, Lv = 9, Type = 2, NeedExploit = 200000, UseExploit = 100000}
--    Position[29] = {NeedLv = 40, QuestNPCid = 2490, Name = TEXT_POSITION_NAME29, Lv = 1, Type = 1, NeedExploit = 200, UseExploit = 200}
--    Position[30] = {NeedLv = 50, QuestNPCid = 2490, Name = TEXT_POSITION_NAME30, Lv = 2, Type = 1, NeedExploit = 600, UseExploit = 600}
--    Position[31] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME31, Lv = 3, Type = 1, NeedExploit = 2000, UseExploit = 2000}
--    Position[32] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME32, Lv = 4, Type = 1, NeedExploit = 10000, UseExploit = 6000}
--    Position[33] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME33, Lv = 4, Type = 1, NeedExploit = 10000, UseExploit = 6000}
--    Position[34] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME34, Lv = 5, Type = 1, NeedExploit = 20000, UseExploit = 8000}
--    Position[35] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME35, Lv = 5, Type = 1, NeedExploit = 20000, UseExploit = 8000}
--    Position[36] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME36, Lv = 5, Type = 1, NeedExploit = 20000, UseExploit = 8000}
--    Position[37] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME37, Lv = 5, Type = 1, NeedExploit = 20000, UseExploit = 8000}
--    Position[38] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME38, Lv = 6, Type = 1, NeedExploit = 35000, UseExploit = 15000}
--    Position[39] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME39, Lv = 6, Type = 1, NeedExploit = 35000, UseExploit = 15000}
--    Position[40] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME40, Lv = 6, Type = 1, NeedExploit = 35000, UseExploit = 15000}
--    Position[41] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME41, Lv = 6, Type = 1, NeedExploit = 35000, UseExploit = 15000}
--    Position[42] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME42, Lv = 7, Type = 1, NeedExploit = 65000, UseExploit = 30000}
--    Position[43] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME43, Lv = 7, Type = 1, NeedExploit = 65000, UseExploit = 30000}
--    Position[44] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME44, Lv = 7, Type = 1, NeedExploit = 65000, UseExploit = 30000}
--    Position[45] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME45, Lv = 7, Type = 1, NeedExploit = 65000, UseExploit = 30000}
--    Position[46] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME46, Lv = 8, Type = 1, NeedExploit = 120000, UseExploit = 60000}
--    Position[47] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME47, Lv = 8, Type = 1, NeedExploit = 120000, UseExploit = 60000}
--    Position[48] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME48, Lv = 8, Type = 1, NeedExploit = 120000, UseExploit = 60000}
--    Position[49] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME49, Lv = 8, Type = 1, NeedExploit = 120000, UseExploit = 60000}
--    Position[50] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME50, Lv = 9, Type = 1, NeedExploit = 200000, UseExploit = 100000}
--    Position[51] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME51, Lv = 9, Type = 1, NeedExploit = 200000, UseExploit = 100000}
--    Position[52] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME52, Lv = 9, Type = 1, NeedExploit = 200000, UseExploit = 100000}
--    Position[53] = {NeedLv = 60, QuestNPCid = 2490, Name = TEXT_POSITION_NAME53, Lv = 9, Type = 1, NeedExploit = 200000, UseExploit = 100000}
--	local PositionLvName = {GNR_POSITION_LEVEL0, GNR_POSITION_LEVEL1, GNR_POSITION_LEVEL2, GNR_POSITION_LEVEL3, GNR_POSITION_LEVEL4, GNR_POSITION_LEVEL5, GNR_POSITION_LEVEL6, GNR_POSITION_LEVEL7, GNR_POSITION_LEVEL8, GNR_POSITION_LEVEL9}
--	local PositionTypeName = {GNR_POSITION_TYPE0, GNR_POSITION_TYPE1, GNR_POSITION_TYPE2}
--	local PositionExploit = {GNR_POSITION_EXPLOIT1, GNR_POSITION_EXPLOIT2}
--
--	local PositionString = {}
--	local AllPositionString, NeedExploitString = "", ""
--	local n = 0
--	while true do
--	    n = n + 1
--	    if Position[n] == nil then n = n - 1 break end
--	end
--	for i = 1, n do
--		if level >= Position[i].NeedLv and Position[i].Lv <= Max_PositionLevel then
--			LvID = Position[i].Lv
--			TypeID = Position[i].Type
--			if LvID ~= 0 then
--				NeedExploitString = Format(TEXT_POSITIONHELP_NEEDEXPLOIT, PositionExploit[TypeID], Position[i].NeedExploit)
--			else
--				NeedExploitString = ""
--			end
--		    PositionString[i] = Format(TEXT_POSITIONHELP_INFO, PositionLvName[LvID + 1], PositionTypeName[TypeID + 1], Position[i].Name, NeedExploitString, Format(TEXT_POSITIONHELP_USEEXPLOIT, Position[i].UseExploit), Format(TEXT_POSITIONHELP_NPCINFO, Position[i].QuestNPCid))
--		else
--		    PositionString[i] = ""
--		end
--		AllPositionString = Format("%s%s", AllPositionString, PositionString[i])
--	end
--	if AllPositionString ~= "" then
--	    LevelHelpString = AllPositionString
--	else
--	    LevelHelpString = TEXT_POSITIONHELP_NIL
--	end
--	return LevelHelpString
--end
--GameUI:FateMatching(1, 1, 20, 20, 0, 0,0, 0, 24, 24, "子鼠", "丑牛", "处女座", "摩羯座", "北京", "北京", "北京", "北京")


-- BEGIN SWORDSMAN CLASSIC CLIENT TWEAKS (merged 2026-10-10)
-- One settings window (System Settings > Client Tweaks) for the selected features from the
-- Client Tweaks v14 kit and for this client's own fixes. Choices are kept in
-- userdata\ClientTweaks.ini, section [ClientTweaks], one key=0/1 per option. The exe reads the
-- same file at start-up (GetPrivateProfileInt) for the options that switch code on or off.
ClientUI = ClientUI or {}
local U = ClientUI
U.version = 100

local function show(name, on) return (pcall(DlgApi.ShowDialog, name, on and true or false)) end
local function shown(name) local ok, s = pcall(DlgApi.IsDialogShow, name); return ok and s == true end
local function settext(dlg, item, value) pcall(DlgApi.SetItemText, dlg, item, value) end
local function enable(dlg, item, on) pcall(DlgApi.EnableItem, dlg, item, on and true or false) end
local function center(name)
    pcall(DlgApi.SetDialogPosition, name, 0, 0, "", AUIDIALOG_ALIGN_INSIDE, AUIDIALOG_ALIGN_CENTER,
        AUIDIALOG_ALIGN_INSIDE, AUIDIALOG_ALIGN_CENTER)
end
local function finite(n) return type(n) == "number" and n == n and n > -math.huge and n < math.huge end
local function now_ms() local ok, t = pcall(GameApi.GetMSTime); if ok and finite(t) then return t end end
local function dialog_pos(name)
    local ok, p = pcall(DlgApi.GetDialogProp, name)
    if ok and type(p) == "table" and finite(p.x) and finite(p.y) then return p.x, p.y end
end
local function host_key()
    local okR, ruid = pcall(GameApi.GetHostRuid)
    if not okR or ruid == nil then return nil end
    local okK, key = pcall(GameApi.RuidToString, ruid)
    if okK and type(key) == "string" and key ~= "" and key ~= "0" then return key end
end
U.Show, U.Shown = show, shown

---------------------------------------------------------------- options
-- group = index of the exe's patch group (GameApi.SetClientTweakGroup), applied at start-up too
local O = {
    loaded = false, values = {},
    list = {
        -- combat
        {key = "uf_locked_target", group = 0},
        {key = "uf_action_camera", group = 1},
        {key = "uf_aim_indicator", group = 2},
        {key = "uf_tab_fix", group = 3},
        -- EXP
        {key = "exp_warning"},
        {key = "combat_exp_window", group = 13},
        {key = "energy_tracker"},
        -- interface
        {key = "uf_fps_ping"},
        {key = "uf_keepalive", group = 4},
        {key = "uf_bar_numbers"},
        {key = "uf_kill_counter"},
        {key = "quest_closed"},
        {key = "uf_chat_focus", group = 5},
        {key = "uf_get_all"},
        -- Hall of Heroes
        {key = "hoh_skip_cutscene"},
        -- bag and Marketplace
        {key = "uf_bag_maximized", group = 9, default = false},
        {key = "bag_search"},
        {key = "stash_search"},
        {key = "free_slots"},
        {key = "market_search"},
        -- map
        {key = "uf_map_bigger", group = 6},
        {key = "uf_map_back", group = 7},
        {key = "uf_map_zoomout", group = 8},
        -- Rare Animal Island
        {key = "boss_notes"},
        {key = "jade_labels"},
        -- start-up and graphics
        {key = "uf_skip_logos", group = 10},
        {key = "uf_skip_serverlist", group = 11},
        {key = "uf_minimal_fog", group = 12},
    },
}
U.Options = O
for _, o in ipairs(O.list) do O.values[o.key] = o.default ~= false end

function O:Path()
    if type(GameApi.GetClientTweaksPath) ~= "function" then return nil end
    local ok, p = pcall(GameApi.GetClientTweaksPath)
    if ok and type(p) == "string" and p ~= "" then return p end
end

function O:Load()
    if self.loaded then return end
    self.loaded = true
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "rb")
    if not ok or not f then return end
    local okR, text = pcall(f.read, f, "*a"); pcall(f.close, f)
    if not okR or type(text) ~= "string" or #text > 65536 then return end
    for key, value in text:gmatch("([%w_]+)%s*=%s*(%d+)") do
        if self.values[key] ~= nil then self.values[key] = value ~= "0" end
    end
end

function O:Save()
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return false end
    local lines = {"[ClientTweaks]"}
    for _, o in ipairs(self.list) do lines[#lines + 1] = o.key .. "=" .. (self.values[o.key] and "1" or "0") end
    local ok, f = pcall(io.open, path, "wb")
    if not ok or not f then return false end
    local okW = pcall(f.write, f, table.concat(lines, "\r\n") .. "\r\n")
    pcall(f.close, f)
    return okW
end

function O:On(key) self:Load(); return self.values[key] == true end

-- push the choices that live in native code
function O:ApplyNative()
    if type(GameApi.SetClientTweakGroup) == "function" then
        for _, o in ipairs(self.list) do
            if o.group then pcall(GameApi.SetClientTweakGroup, o.group, self.values[o.key] == true) end
        end
    end
    if type(GameApi.SetClientTweakOptions) == "function" then
        -- the v14 kit's native switches: only the EXP time warning (4) is installed here
        pcall(GameApi.SetClientTweakOptions, self.values.exp_warning and 4 or 0)
    end
    self.nativeDone = true
end

-- the Rare Animal Island boss tooltips (monstervisual.lua) ask this table
LuaClientTweaks = LuaClientTweaks or {}
function LuaClientTweaks:IsEnabled(key) return O:On(key) end
ClientTweaks = LuaClientTweaks

---------------------------------------------------------------- settings window
local S = {name = "Win_ClientTweaksSettings", open = false}
U.Settings = S

function U.OpenSettings()
    if shown(S.name) then show(S.name, false); S.open = false; return true end
    O:Load()
    show(S.name, true)          -- creates the window (and loads its script) on first use
    center(S.name)
    S.open = true
    S:Populate()
    return true
end

function S:Populate()
    O:Load()
    for _, o in ipairs(O.list) do pcall(DlgApi.CheckItem, self.name, "Chk_" .. o.key, O.values[o.key] == true) end
    settext(self.name, "Txt_Status", "")
end

function S:Apply()
    O:Load()
    for _, o in ipairs(O.list) do
        local ok, checked = pcall(DlgApi.IsItemChecked, self.name, "Chk_" .. o.key)
        if ok then O.values[o.key] = checked == true end
    end
    O:ApplyNative()
    local saved = O:Save()
    settext(self.name, "Txt_Status", saved and "Applied and saved. Start-up options take effect at the next start."
        or "Applied for this session; the settings file could not be written.")
    return saved
end

function S:OK() self:Apply(); show(self.name, false); self.open = false end
function S:Cancel() show(self.name, false); self.open = false end
function S:Tick() if self.open and not shown(self.name) then self.open = false end end

---------------------------------------------------------------- this client's own HUD fixes (show / hide only)
local V = {}
U.Panels = V
local BAR_LABELS = {"Lab_PhysicalNum", "Lab_MP3Num", "Lab_WH3Num"}

local function item_shown(dlg, item)
    local ok, s = pcall(DlgApi.IsItemShow, dlg, item)
    if ok then return s == true end
end
local function want_item(dlg, item, on)
    local s = item_shown(dlg, item)
    if s ~= nil and s ~= on then pcall(DlgApi.ShowItem, dlg, item, on) end
end
-- a whole window: hide while off; show once when switched back on
local function want_dialog(self, name, key)
    local on = O:On(key)
    if not on and shown(name) then show(name, false) end
    if on and self.last[key] == false and not shown(name) then show(name, true) end
    self.last[key] = on
end
V.last = {}

function V:Tick(now)
    if self.lastCheck and now >= self.lastCheck and now - self.lastCheck < 300 then return end
    self.lastCheck = now
    if shown("Win_MiniMap") then
        want_item("Win_MiniMap", "Txt_PerfInfo", O:On("uf_fps_ping"))
        want_dialog(self, "Win_KillCount", "uf_kill_counter")
    end
    if shown("Win_FightingCircle") then
        local on = O:On("uf_bar_numbers")
        for _, item in ipairs(BAR_LABELS) do want_item("Win_FightingCircle", item, on) end
    end
    if shown("Win_MailList") then want_item("Win_MailList", "Btn_GetAll", O:On("uf_get_all")) end
end

---------------------------------------------------------------- quest list closed at login
local Q = {}
U.Quest = Q
function Q:Tick(now)
    local key = host_key()
    if key ~= self.host then
        self.host = key
        self.due = key and (now + 1500) or nil     -- same delay as the v14 kit's native version
    end
    if self.due and now >= self.due and shown("Win_MiniMap") then
        self.due = nil
        if O:On("quest_closed") and type(GameApi.CloseQuestList) == "function" then pcall(GameApi.CloseQuestList) end
    end
end

---------------------------------------------------------------- Rare Animal Island: Jade Sung's teleport names
local R = {
    bosses = {
        {direction = "Central", name = "Northern Black Wolf"},
        {direction = "Northeast", name = "Sword Barrow Guardian Spirit"},
        {direction = "Southeast", name = "Sacred Flame Ox"},
        {direction = "Southwest", name = "Undead Scorpion"},
        {direction = "Northwest", name = "Jade Realm Beast"},
    },
}
U.Rai = R
-- Jade Sung (NPC template 79731, Luo Yang): add the boss names to her five direction options.
function R:DecorateJadeText(npcTemplate, text)
    if npcTemplate ~= 79731 or type(text) ~= "string" then return text end
    local on = O:On("jade_labels")
    for _, boss in ipairs(self.bosses) do
        local original = "To " .. boss.direction
        local decorated = original .. " (" .. boss.name .. ")"
        if on and text == original then return decorated end
        if not on and text == decorated then return original end
    end
    return text
end

function R:TickJade()
    if type(GameApi.GetTalkingNpcTemplate) ~= "function" then return end
    if not shown("Win_NPC") or not shown("Win_NPCTemplate") then return end
    local ok, npcTemplate, count = pcall(GameApi.GetTalkingNpcTemplate)
    if not ok or npcTemplate ~= 79731 or not finite(count) or count < 1 or count > 32 or count ~= math.floor(count) then return end
    for index = 0, count - 1 do
        local control = "Txt_Template" .. index
        local okT, current = pcall(DlgApi.GetItemText, "Win_NPCTemplate", control)
        if okT then
            local decorated = self:DecorateJadeText(npcTemplate, current)
            if decorated ~= current then settext("Win_NPCTemplate", control, decorated) end
        end
    end
end

---------------------------------------------------------------- Hall of Heroes: skip the entry scene
local HH = {}
U.Hall = HH
function HH:Tick()
    if type(GameApi.SetHallOfHeroesOptions) ~= "function" then return end
    local skip = O:On("hoh_skip_cutscene")
    if skip ~= self.skip then
        -- second value: Spawn All (not installed here) stays off
        if pcall(GameApi.SetHallOfHeroesOptions, skip, false) then self.skip = skip end
    end
end

-- Swordsman Multi-EXP energy tracker v1
-- Multi-EXP World Energy observation; does not change energy or EXP state.
-- This tracker uses native raw balances without multiplier assumptions.
MultiExpEnergyTracker = {}
local Tracker = MultiExpEnergyTracker
Tracker.__index = Tracker

local function finite(value)
    return type(value) == "number" and value == value
        and value > -math.huge and value < math.huge
end

function Tracker.new(options)
    options = options or {}
    return setmetatable({
        window = options.window or 180,
        warmup = options.warmup or 10,
        maxGap = options.maxGap or 5,
        intervals = {},
    }, Tracker)
end

function Tracker:Clear()
    self.firstTime, self.lastTime, self.lastBalance = nil, nil, nil
    self.session, self.role, self.map, self.capacity = nil, nil, nil, nil
    self.intervals = {}
    self.lastView = {status = "unavailable"}
    return self.lastView
end

function Tracker:Begin(sample, reason)
    self.firstTime, self.lastTime = sample.time, sample.time
    self.lastBalance = sample.balance
    self.session, self.role, self.map = sample.session, sample.role, sample.map
    self.capacity = sample.capacity
    self.intervals = {}
    self.lastView = {status = "measuring", balance = sample.balance, reason = reason}
    return self.lastView
end

-- Sample identity distinguishes role changes and a rebuilt host object on relogin.
-- Missing/invalid samples discard history so reconnects cannot create phantom use.
function Tracker:Sample(sample)
    if type(sample) ~= "table" or not finite(sample.time)
        or not finite(sample.balance) or sample.balance < 0
        or sample.session == nil or sample.role == nil or sample.map == nil
        or (sample.capacity ~= nil and
            (not finite(sample.capacity) or sample.capacity <= 0 or sample.balance > sample.capacity)) then
        return self:Clear()
    end
    if not self.lastTime then return self:Begin(sample, "initial") end
    if sample.session ~= self.session or sample.role ~= self.role or sample.map ~= self.map
        or sample.capacity ~= self.capacity then
        return self:Begin(sample, "identity")
    end
    local elapsed = sample.time - self.lastTime
    if elapsed < 0 or elapsed > self.maxGap then
        return self:Begin(sample, "clock_or_gap")
    end
    if sample.balance > self.lastBalance then return self:Begin(sample, "refill") end
    if elapsed == 0 then
        -- Millisecond clocks may repeat between frames. Leave the baseline intact;
        -- the next later sample captures any decrease over a real elapsed interval.
        local view = self.lastView or {status = "measuring"}
        view.balance = sample.balance
        return view
    end

    self.intervals[#self.intervals + 1] = {
        first = self.lastTime, last = sample.time,
        used = self.lastBalance - sample.balance,
    }
    self.lastTime, self.lastBalance = sample.time, sample.balance
    local cutoff = sample.time - self.window
    local kept, total = {}, 0
    for _, interval in ipairs(self.intervals) do
        if interval.last > cutoff then
            kept[#kept + 1] = interval
            local overlap = interval.last - math.max(interval.first, cutoff)
            total = total + interval.used * overlap / (interval.last - interval.first)
        end
    end
    self.intervals = kept
    local observed = math.min(self.window, sample.time - self.firstTime)
    if observed < self.warmup then
        self.lastView = {status = "measuring", balance = sample.balance, observed = observed}
    else
        local rate = total * 60 / observed
        self.lastView = {
            status = "ready", balance = sample.balance, rate = rate, observed = observed,
            eta = (rate > 0 and sample.balance * 60 / rate) or nil,
        }
    end
    return self.lastView
end

function Tracker.Format(view)
    if not view or view.status == "unavailable" then
        return "Unavailable", "Unavailable", "Unavailable"
    end
    -- Character's World Energy row rounds upward; only the displayed remaining
    -- balance follows that rule. Consumption and ETA retain the native raw float.
    local balance = string.format("%.0f", math.ceil(view.balance))
    if view.status ~= "ready" then return balance, "Measuring", "Measuring" end
    local rate = string.format("%.1f", view.rate)
    if view.rate > 0 and view.rate < 0.05 then rate = "<0.1" end
    if view.balance == 0 then return balance, rate, "0m 00s" end
    if not view.eta then return balance, rate, "No use" end
    local seconds = math.ceil(view.eta)
    if seconds >= 36000000 then return balance, rate, ">9999h" end
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor(seconds / 60) % 60
    if hours > 0 then return balance, rate, string.format("%dh %02dm", hours, minutes) end
    return balance, rate, string.format("%dm %02ds", minutes, seconds % 60)
end

-- Appended to the existing interfaces/gameui.lua source during staging. GameUI
-- ticks even while the native Win_DoubleExp dialog is hidden; that native dialog
-- overrides its own Lua tick, so attaching a new doubleexp.lua would not work.
MultiExpWorldEnergy = {tracker = Tracker.new(), session = 0, lastPaint = {}}
local Observer = MultiExpWorldEnergy
local required = {"GetWorldEnergySample", "GetMSTime", "GetHostRuid", "RuidToString", "GetSceneID"}
local controls = {"Txt_EnergyRemaining", "Txt_EnergyRate", "Txt_EnergyETA"}

function Observer:Unavailable()
    if self.available then self.session = self.session + 1 end
    self.available = false
    self.view = self.tracker:Clear()
end

function Observer:Read(now)
    local ok, balance, capacity = pcall(GameApi.GetWorldEnergySample)
    if not ok or not finite(balance) or not finite(capacity)
        or capacity <= 0 or balance < 0 or balance > capacity then
        self:Unavailable()
        return
    end
    local roleOK, role = pcall(GameApi.GetHostRuid)
    local mapOK, map = pcall(GameApi.GetSceneID)
    if not roleOK or not mapOK or role == nil or map == nil then
        self:Unavailable()
        return
    end
    -- RUID is carried by a native bitcast ScriptValue. Decimal tostring can lose
    -- identity bits; use the game's exact RUID formatter before comparing hosts.
    local roleStringOK, roleString = pcall(GameApi.RuidToString, role)
    if not roleStringOK or type(roleString) ~= "string"
        or roleString == "" or roleString == "0" then
        self:Unavailable()
        return
    end
    if (type(map) ~= "number" and type(map) ~= "string")
        or (type(map) == "number" and not finite(map)) then
        self:Unavailable()
        return
    end
    self.available = true
    self.view = self.tracker:Sample({
        time = now, balance = balance, capacity = capacity,
        session = self.session, role = roleString, map = tostring(map),
    })
end

function Observer:Paint()
    if not DlgApi or type(DlgApi.IsDialogShow) ~= "function"
        or type(DlgApi.SetItemText) ~= "function" then return end
    local ok, visible = pcall(DlgApi.IsDialogShow, "Win_DoubleExp")
    if not ok or not visible then
        self.wasVisible = false
        self.lastPaint = {}
        return
    end
    if not self.wasVisible then self.lastPaint = {} end
    self.wasVisible = true
    local values = {Tracker.Format(self.view)}
    for i, control in ipairs(controls) do
        if self.lastPaint[control] ~= values[i] then
            local success = pcall(DlgApi.SetItemText, "Win_DoubleExp", control, values[i])
            if success then self.lastPaint[control] = values[i] end
        end
    end
end

function Observer:Tick()
    if type(GameApi) ~= "table" then
        self:Unavailable()
        self.lastReadTime = nil
        self:Paint()
        return
    end
    for _, name in ipairs(required) do
        if type(GameApi[name]) ~= "function" then
            self:Unavailable()
            self.lastReadTime = nil
            self:Paint()
            return
        end
    end
    local ok, milliseconds = pcall(GameApi.GetMSTime)
    if not ok or not finite(milliseconds) then
        self:Unavailable()
        self.lastReadTime = nil
        self:Paint()
        return
    end
    local now = milliseconds / 1000
    if not self.lastReadTime or now < self.lastReadTime or now - self.lastReadTime >= 1 then
        self.lastReadTime = now
        self:Read(now)
    end
    self:Paint()
end


---------------------------------------------------------------- EXP replacement warning
local E = {name = "Win_EXPReplacementWarning", token = nil}
U.Exp = E

function E:Close(approve)
    local old = self.token
    self.token = nil
    show(self.name, false)
    if old and type(GameApi.ResolveEXPReplacementPrompt) == "function" then
        pcall(GameApi.ResolveEXPReplacementPrompt, old, approve == true)
    end
end
function E:Cancel() self:Close(false) end
function E:Use()
    if self.token and type(GameApi.CanConfirmEXPReplacementPrompt) == "function" then
        local ok, can = pcall(GameApi.CanConfirmEXPReplacementPrompt)
        if ok and can == 1 then self:Close(true) end
    end
end

-- Called every frame by LuaClientTweaks:Tick (shared settings block).
function EXPReplacementWarningTick()
    if type(GameApi.GetEXPReplacementPrompt) ~= "function" then return end
    local ok, pending, current, incoming, seconds, item, frozen = pcall(GameApi.GetEXPReplacementPrompt)
    if not ok then return end
    if not pending then
        if E.token then E:Close(false) end
        return
    end
    if E.token and E.token == pending and not shown(E.name) then E:Close(false); return end
    if pending ~= E.token then
        E.token = pending
        show(E.name, true)      -- creates the window on first use
        center(E.name)
        settext(E.name, "Txt_Current", string.format("Current boost:  x%d EXP", current or 0))
        settext(E.name, "Txt_Incoming", string.format("This item:  x%d EXP", incoming or 0))
        settext(E.name, "Btn_Use", string.format("Use x%d", incoming or 0))
        enable(E.name, "Btn_Use", false)
    end
    local okc, can = pcall(GameApi.CanConfirmEXPReplacementPrompt)
    enable(E.name, "Btn_Use", okc and can == 1)
    seconds = math.max(0, math.floor(seconds or 0))
    settext(E.name, "Txt_Remaining", string.format("Time left:  %dh %02dm %02ds%s", math.floor(seconds / 3600),
        math.floor(seconds / 60) % 60, seconds % 60, frozen == 1 and "  (frozen)" or ""))
end


---------------------------------------------------------------- bag / stash search (v9)
-- A magnifier button (Chk_QolSearch: a check box with the game's own "Find" icon) sits in the title
-- bar of the bag (Win_Inventory), the big bag (Win_InventoryMax) and the stash (Win_Storage).
-- Clicking it opens a small search bar on top of that window; clicking it again, the bar's cross,
-- Esc or closing the window closes it again. Nothing opens by itself.
-- Typing filters as you type: every word must appear in the item name, or type an item ID.
-- Matching slots stay bright, everything else dims; Prev / Next scroll to each match and make it
-- blink. Items never move: this only reads the bags, through Codex's native bridge
-- (GetInventoryQoLPack / GetInventoryQoLView / FocusInventoryQoLSlot, inventory-qol-kit) plus
-- GetBagScroll / SetBagScroll for the normal bag (hoh_native_v7).
local F = {names = {}, alpha = {}, buttons = {}, BUTTON = "Chk_QolSearch", DIM = 70, RESCAN = 400}
U.Search = F
F.HOSTS = {   -- dx / dy: where the window's visible frame starts (its dialog box has a margin)
    {dialog = "Win_InventoryMax", kind = "bag", dx = 34, dy = 30},
    {dialog = "Win_Inventory", kind = "bag", dx = 36, dy = 30},
    {dialog = "Win_Storage", kind = "stash", dx = 0, dy = 0},
}
F.BARS = {bag = {name = "Win_QolBagFind", option = "bag_search", want = {2, 3, 4}},
          stash = {name = "Win_QolStashFind", option = "stash_search", want = {11}}}
local PACK_NAME = {[2] = "Main", [3] = "Bag 1", [4] = "Bag 2", [11] = "Stash"}
local INV_COLS, INV_SHOWN, STASH_COLS, STASH_SHOWN, MAX_SHOWN = 5, 35, 8, 56, 200

local function whole(v) return finite(v) and v >= 0 and v == math.floor(v) end
local function api(name) return type(GameApi[name]) == "function" end
local function checked(dlg, item) local ok, c = pcall(DlgApi.IsItemChecked, dlg, item); return ok and c == true end
local function check_item(dlg, item, on) pcall(DlgApi.CheckItem, dlg, item, on and true or false) end

function F:Name(id)
    local cached = self.names[id]
    if cached then return cached end
    local ok, name = pcall(GameApi.GetItemInfo, id)
    if ok and type(name) == "string" and name ~= "" then
        name = name:gsub("%^%x%x%x%x%x%x", ""); self.names[id] = name; return name
    end
    return "#" .. tostring(id)                -- not cached: asked again on the next scan
end

-- one pack: {pack, capacity, items[slot] = {pack, slot, id, count}, free}; nil when unavailable
function F:Pack(pack)
    if not api("GetInventoryQoLPack") then return nil end
    local ok, cap, raw = pcall(GameApi.GetInventoryQoLPack, pack)
    if not ok or not whole(cap) or cap > 4096 or type(raw) ~= "string" then return nil end
    local t = {pack = pack, capacity = cap, items = {}, used = 0}
    for slot, id, count in raw:gmatch("(%d+):(%d+):(%d+);") do
        slot, id, count = tonumber(slot), tonumber(id), tonumber(count)
        if slot < cap and id > 0 and not t.items[slot] then
            t.items[slot] = {pack = pack, slot = slot, id = id, count = count}; t.used = t.used + 1
        end
    end
    t.free = cap - t.used
    return t
end

function F:Packs(list)
    local out = {}
    for i, p in ipairs(list) do out[i] = self:Pack(p) or {pack = p, capacity = 0, items = {}, used = 0, free = 0, missing = true} end
    return out
end

-- long: "Free slots: 4 / 99 / 100" (big bag footer: Main / Bag 1 / Bag 2)
-- short: "Free slots: Main 4, Bag 1 99, Bag 2 100" (search bar)
function F:FreeText(packs, long)
    local parts, free, total = {}, 0, 0
    for _, p in ipairs(packs) do
        local n = p.missing and "--" or (long and (p.free .. "/" .. p.capacity) or tostring(p.free))
        parts[#parts + 1] = PACK_NAME[p.pack] .. " " .. n
        free, total = free + p.free, total + p.capacity
    end
    if not long then
        if #packs == 1 then parts[1] = parts[1] .. " of " .. packs[1].capacity end
        return "Free slots: " .. table.concat(parts, ", ")
    end
    -- big bag footer (short space): "Free slots: 4 / 99 / 100" = Main / Bag 1 / Bag 2
    local nums = {}
    for _, p in ipairs(packs) do nums[#nums + 1] = p.missing and "--" or tostring(p.free) end
    return "Free slots: " .. table.concat(nums, " / ")
end

-- "red pot" matches "Large Red Potion"; a number matches that item ID
function F:Matches(b, item)
    if b.query:match("^%d+$") and tostring(item.id) == b.query then return true end
    local name = self:Name(item.id):lower()
    for _, w in ipairs(b.words) do
        if not name:find(w, 1, true) then return false end
    end
    return #b.words > 0
end

function F:Scan(b, now)
    b.packs = self:Packs(b.want)
    b.matches, b.bySlot, b.lastScan = {}, {}, now
    if b.query ~= "" then
        for _, p in ipairs(b.packs) do
            b.bySlot[p.pack] = {}
            for slot = 0, p.capacity - 1 do
                local it = p.items[slot]
                if it and self:Matches(b, it) then b.matches[#b.matches + 1] = it; b.bySlot[p.pack][slot] = true end
            end
        end
    end
    if b.focus then        -- keep pointing at the same match if it is still there
        b.cursor = 0
        for i, it in ipairs(b.matches) do
            if it.pack == b.focus.pack and it.slot == b.focus.slot and it.id == b.focus.id then b.cursor = i end
        end
        if b.cursor == 0 then b.focus = nil end
    end
end

function F:Alpha(dlg, index, value)
    local item = string.format("Item_%02d", index)
    local key = dlg .. "/" .. item
    if (self.alpha[key] or 255) ~= value then
        if pcall(DlgApi.SetItemAlpha, dlg, item, value) then self.alpha[key] = value end
    end
end

function F:Restore(dlg)
    local prefix = dlg .. "/"
    for key, value in pairs(self.alpha) do
        if key:sub(1, #prefix) == prefix then
            if value ~= 255 then pcall(DlgApi.SetItemAlpha, dlg, key:sub(#prefix + 1), 255) end
            self.alpha[key] = nil
        end
    end
end

-- slots shown in the host window right now: list of {index, pack, slot}, or nil when unknown
function F:Visible(host, b)
    local out = {}
    if host == "Win_Inventory" then
        if not checked(host, "Rdo_Normal") or not api("GetBagScroll") then return nil end
        local ok, row = pcall(GameApi.GetBagScroll)
        local main = b.packs[1]
        if not ok or not whole(row) or not main then return nil end
        for n = 0, INV_SHOWN - 1 do
            local slot = row * INV_COLS + n
            if slot < main.capacity then out[#out + 1] = {n, 2, slot} end
        end
    elseif host == "Win_InventoryMax" then
        if not api("GetInventoryQoLView") then return nil end
        local ok, start, count = pcall(GameApi.GetInventoryQoLView)
        if not ok or not whole(start) or not whole(count) or count > MAX_SHOWN then return nil end
        local offset = 0           -- the big bag pages through Main, Bag 1, Bag 2 laid end to end
        for _, p in ipairs(b.packs) do
            for slot = 0, p.capacity - 1 do
                local n = offset + slot - start
                if n >= 0 and n < count then out[#out + 1] = {n, p.pack, slot} end
            end
            offset = offset + p.capacity
        end
    else
        if not api("GetInventoryQoLView") then return nil end
        local ok, _, _, _, start = pcall(GameApi.GetInventoryQoLView)
        local stash = b.packs[1]
        if not ok or not whole(start) or not stash then return nil end
        for n = 0, STASH_SHOWN - 1 do
            if start + n < stash.capacity then out[#out + 1] = {n, 11, start + n} end
        end
    end
    return out
end

function F:Decorate(b, now)
    local host = b.host
    local vis = b.query ~= "" and self:Visible(host, b)
    if not vis then self:Restore(host); return end
    local seen = {}
    local blink = b.focus and b.blinkUntil and now < b.blinkUntil
    for _, v in ipairs(vis) do
        local n, pack, slot = v[1], v[2], v[3]
        local hit = b.bySlot[pack] and b.bySlot[pack][slot]
        local a = hit and 255 or self.DIM
        if hit and blink and b.focus.pack == pack and b.focus.slot == slot then
            a = (math.floor(now / 200) % 2 == 0) and 255 or 110
        end
        self:Alpha(host, n, a); seen[n] = true
    end
    local last = host == "Win_InventoryMax" and MAX_SHOWN or (host == "Win_Inventory" and INV_SHOWN or STASH_SHOWN)
    for n = 0, last - 1 do if not seen[n] then self:Alpha(host, n, 255) end end
end

function F:Status(b)
    local text
    if b.message and b.messageUntil and (now_ms() or 0) < b.messageUntil then
        text = b.message
    elseif b.query == "" then
        text = O:On("free_slots") and self:FreeText(b.packs or {}) or "Type part of an item name, or an item ID."
    elseif #b.matches == 0 then
        text = 'Nothing matches "' .. b.query .. '".'
    elseif b.focus then
        local name = self:Name(b.focus.id)
        if #name > 20 then name = name:sub(1, 19) .. "." end
        text = b.cursor .. "/" .. #b.matches .. "  " .. name .. " (" .. PACK_NAME[b.focus.pack] .. ", slot " .. (b.focus.slot + 1) .. ")"
    else
        local per, order = {}, {}
        for _, it in ipairs(b.matches) do
            if not per[it.pack] then per[it.pack] = 0; order[#order + 1] = it.pack end
            per[it.pack] = per[it.pack] + 1
        end
        local parts = {}
        for _, p in ipairs(order) do parts[#parts + 1] = PACK_NAME[p] .. " " .. per[p] end
        text = #b.matches .. " found - " .. table.concat(parts, ", ")
        if b.host == "Win_Inventory" and not checked("Win_Inventory", "Rdo_Normal") then
            text = text .. " (open the first bag tab)"
        end
    end
    if text ~= b.shownText then settext(b.name, "Txt_Result", text); b.shownText = text end
    enable(b.name, "Btn_Prev", #(b.matches or {}) > 0)
    enable(b.name, "Btn_Next", #(b.matches or {}) > 0)
end

-- place the bar on top of the host's visible frame, again whenever the host is moved
function F:Place(b)
    local hx, hy = dialog_pos(b.host)
    if not hx then return end
    if b.placedFor and b.placedFor[1] == b.host and b.placedFor[2] == hx and b.placedFor[3] == hy then return end
    local okS, scale = pcall(DlgApi.GetWindowScale)
    scale = (okS and finite(scale) and scale > 0) and scale or 1
    local h
    for _, x in ipairs(self.HOSTS) do if x.dialog == b.host then h = x end end
    pcall(DlgApi.SetDialogPosition, b.name, 0, 0, b.host,
        AUIDIALOG_ALIGN_INSIDE, AUIDIALOG_ALIGN_LEFT, AUIDIALOG_ALIGN_OUTSIDE, AUIDIALOG_ALIGN_TOP)
    local bx, by = dialog_pos(b.name)
    if bx and h then
        pcall(DlgApi.SetDialogPosition, b.name, math.floor(bx + h.dx * scale + 0.5),
              math.max(0, math.floor(by + h.dy * scale + 0.5)))
    end
    b.placedFor = {b.host, hx, hy}
end

function F:Open(kind, host)
    local b = self.BARS[kind]
    b.open, b.host, b.query, b.words, b.matches, b.bySlot = true, host, "", {}, {}, {}
    b.cursor, b.focus, b.message, b.shownText, b.placedFor = 0, nil, nil, nil, nil
    show(b.name, true)
    settext(b.name, "Edt_Find", "")
    self:Place(b)
    pcall(DlgApi.ChangeFocus, b.name, "Edt_Find", true)
    b.lastScan = nil
end

function F:Close(kind)
    local b = self.BARS[kind]
    if not b.open then return true end
    b.open = false
    if shown(b.name) then show(b.name, false) end
    for _, h in ipairs(self.HOSTS) do
        if h.kind == kind then check_item(h.dialog, self.BUTTON, false); self:Restore(h.dialog) end
    end
    b.query, b.matches, b.focus = "", {}, nil
    return true
end

function F:Step(kind, step)
    local b = self.BARS[kind]
    if not b.open then return true end
    local now = now_ms() or 0
    self:Scan(b, now)
    local n = #b.matches
    if n == 0 then return true end
    local cursor = (b.cursor + step - 1) % n + 1
    local it = b.matches[cursor]
    local ok, accepted
    if b.host == "Win_Inventory" and it.pack == 2 and checked("Win_Inventory", "Rdo_Normal") and api("SetBagScroll") then
        ok, accepted = pcall(GameApi.SetBagScroll, math.max(0, math.floor(it.slot / INV_COLS) - 3))
    elseif api("FocusInventoryQoLSlot") then
        -- Main in the big bag, Bag 1 / Bag 2 (opens the big bag if needed) and the stash
        ok, accepted = pcall(GameApi.FocusInventoryQoLSlot, it.pack, it.slot, it.id)
    end
    if ok and accepted == 1 then
        b.cursor, b.focus, b.blinkUntil, b.message = cursor, it, now + 1600, nil
    else
        b.message, b.messageUntil = "Can't jump there right now - drop the item you are dragging first.", now + 2500
    end
    self:Status(b)
    return true
end

function F:TickBar(kind, now)
    local b = self.BARS[kind]
    local host
    for _, h in ipairs(self.HOSTS) do
        if h.kind == kind and not host and shown(h.dialog) then host = h.dialog end
    end
    local on = O:On(b.option)
    for _, h in ipairs(self.HOSTS) do
        if h.kind == kind and shown(h.dialog) and self.buttons[h.dialog] ~= on then
            pcall(DlgApi.ShowItem, h.dialog, self.BUTTON, on); self.buttons[h.dialog] = on
        end
    end
    if not host or not on then
        if b.open then self:Close(kind) end
        if not host then
            for _, h in ipairs(self.HOSTS) do        -- a closed window keeps its check: clear it
                if h.kind == kind and checked(h.dialog, self.BUTTON) then check_item(h.dialog, self.BUTTON, false) end
            end
        end
        return
    end
    if b.open then
        if b.host ~= host then                        -- normal bag <-> big bag: the search moves along
            self:Restore(b.host); check_item(b.host, self.BUTTON, false)
            check_item(host, self.BUTTON, true)
            b.host, b.placedFor = host, nil
        elseif not checked(host, self.BUTTON) or not shown(b.name) then
            self:Close(kind); return
        end
    elseif checked(host, self.BUTTON) then
        self:Open(kind, host)
    else
        return
    end
    self:Place(b)
    local okT, text = pcall(DlgApi.GetItemText, b.name, "Edt_Find")
    text = (okT and type(text) == "string") and text:sub(1, 40):lower():match("^%s*(.-)%s*$") or ""
    if text ~= b.query then
        b.query, b.words, b.cursor, b.focus = text, {}, 0, nil
        for w in text:gmatch("%S+") do b.words[#b.words + 1] = w end
        b.lastScan = nil
    end
    if not b.lastScan or now < b.lastScan or now - b.lastScan >= self.RESCAN then self:Scan(b, now) end
    self:Decorate(b, now)
    self:Status(b)
end

-- free slots in the big bag's footer
function F:TickFooter(now)
    local on = O:On("free_slots") and shown("Win_InventoryMax")
    if self.footerOn ~= on then pcall(DlgApi.ShowItem, "Win_InventoryMax", "Lab_QolFree", on); self.footerOn = on end
    if not on or (self.footerAt and now >= self.footerAt and now - self.footerAt < 1000) then return end
    self.footerAt = now
    local text = self:FreeText(self:Packs({2, 3, 4}), true)
    if text ~= self.footerText then settext("Win_InventoryMax", "Lab_QolFree", text); self.footerText = text end
end

function F:Tick()
    local now = now_ms()
    if not now then return end
    pcall(self.TickBar, self, "bag", now)
    pcall(self.TickBar, self, "stash", now)
    pcall(self.TickFooter, self, now)
end

---------------------------------------------------------------- search bars stay hidden until opened (v14 kit, v10)
do
    local F = U.Search
    local previousTickBar = F.TickBar
    function F:TickBar(kind, now)
        local b = self.BARS[kind]
        if not b.open then pcall(DlgApi.ShowDialog, b.name, false) end
        return previousTickBar(self, kind, now)
    end
    for _, b in pairs(F.BARS) do pcall(DlgApi.ShowDialog, b.name, false) end
end

---------------------------------------------------------------- Marketplace search (from the v14 kit, v11)
do
    local U = ClientUI
    local F = U and U.Search
    if F then
        local O = U.Options
        local function shown(d) local ok,v=pcall(DlgApi.IsDialogShow,d);return ok and v==true end
        local function checked(d,c) local ok,v=pcall(DlgApi.IsItemChecked,d,c);return ok and v==true end
        local function text(d,c,s) pcall(DlgApi.SetItemText,d,c,s) end
        local function clamptext(s,n)
            if #s<=n then return s end
            -- Avoid splitting UTF-8 continuation bytes at an ellipsis boundary.
            local i=n-3
            while i>0 and s:byte(i+1)>=128 and s:byte(i+1)<192 do i=i-1 end
            return s:sub(1,i).."..."
        end
        local previousPlace, previousStatus = F.Place, F.Status
        function F:Place(b)
            local ok,s=pcall(DlgApi.GetWindowScale)
            s=(ok and type(s)=="number" and s==s and s>0 and s<=4) and s or 1
            if b.panelScale~=s then
                -- AUI multiplies global scale by dialog-local scale (E8E18C /
                -- E8E192). Local 1 keeps this panel aligned with the stock UI.
                pcall(DlgApi.SetDialogScale,b.name,1)
                b.panelScale,b.placedFor=s,nil
            end
            return previousPlace(self,b)
        end
        function F:Status(b)
            -- Keep Claude's result/count/navigation logic. Give long focused names
            -- and no-match text separate rows rather than squeezing everything in.
            previousStatus(self,b)
            local detail=""
            local okNow,now=pcall(GameApi.GetMSTime)
            local message=b.message and b.messageUntil and okNow and now<b.messageUntil
            if b.focus and not message then
                local pack=({[2]="Main",[3]="Bag 1",[4]="Bag 2",[11]="Stash"})[b.focus.pack]
                local s=b.cursor.."/"..#b.matches.."   "..clamptext(self:Name(b.focus.id),36)
                text(b.name,"Txt_Result",s);b.shownText=s
                detail=pack..", slot "..(b.focus.slot+1)
            elseif b.query=="" then
                detail="Type part of an item name, or an item ID."
            elseif #b.matches==0 then
                text(b.name,"Txt_Result","No matching items");b.shownText="No matching items"
                detail=clamptext(b.query,48)
            else detail="Enter / Next jumps to a match" end
            if message then
                text(b.name,"Txt_Result","Cannot jump to this item right now")
                detail="Drop the item you are dragging, then try again."
            end
            text(b.name,"Txt_Detail",detail)
        end
        local M={name="Win_QolMarketFind",host="Win_QShop",button="Chk_MarketSearch"}
        U.MarketSearch=M
        function M:Close()
            self.open=false;self.rows=nil;self.matches={};self.cursor=0
            pcall(DlgApi.ShowDialog,self.name,false)
            pcall(DlgApi.CheckItem,self.host,self.button,false)
            return true
        end
        function M:Open()
            self.open=true;self.rows={};self.seen={};self.matches={};self.cursor=0
            self.category=0;self.total=nil;self.query="";self.ready=false;self.failed=false
            pcall(DlgApi.ShowDialog,self.name,true);text(self.name,"Edt_Find","")
            F:Place(self);pcall(DlgApi.ChangeFocus,self.name,"Edt_Find",true)
        end
        function M:LoadCategory()
            if type(GameApi.GetMarketplaceSearchCategory)~="function" then self.failed=true;return end
            local ok,total,raw=pcall(GameApi.GetMarketplaceSearchCategory,self.category)
            if not ok or type(total)~="number" or total<1 or total>64 or total~=math.floor(total) or
               type(raw)~="string" or (self.total and self.total~=total) then self.failed=true;return end
            self.total=total
            for mall,id in raw:gmatch("(%d+):(%d+);") do
                mall,id=tonumber(mall),tonumber(id)
                if mall>0 and id>0 and not self.seen[mall] then
                    self.seen[mall]=true
                    self.rows[#self.rows+1]={mall=mall,id=id,category=self.category}
                end
            end
            self.category=self.category+1
            if self.category>=total then self.ready=true;self.query=nil end
        end
        function M:Find(query)
            self.matches={};self.cursor=0;self.message=nil
            if query=="" then return end
            local words={};for w in query:gmatch("%S+") do words[#words+1]=w end
            for _,it in ipairs(self.rows or {}) do
                local name=F:Name(it.id):lower()
                local hit=tostring(it.id)==query
                if not query:match("^%d+$") then
                    hit=true;for _,w in ipairs(words) do if not name:find(w,1,true) then hit=false;break end end
                end
                if hit then self.matches[#self.matches+1]=it end
            end
        end
        function M:ReadQuery()
            local ok,s=pcall(DlgApi.GetItemText,self.name,"Edt_Find")
            s=(ok and type(s)=="string") and s:sub(1,40):lower():match("^%s*(.-)%s*$") or ""
            if s~=self.query then self.query=s;self:Find(s) end
        end
        function M:Status()
            local s,detail
            if self.failed then s="Marketplace catalog unavailable";detail="Close and reopen search to retry."
            elseif not self.ready then s="Reading Marketplace categories...";detail=tostring(self.category).." categories read"
            elseif self.query=="" then s=#self.rows.." offers across all categories";detail="Type an item name or item ID."
            elseif self.message then s="This offer is unavailable right now";detail="Close and reopen search to refresh the catalog."
            elseif #self.matches==0 then s="No matching offers";detail=clamptext(self.query,48)
            elseif self.cursor>0 then
                local it=self.matches[self.cursor]
                s=self.cursor.."/"..#self.matches.."   "..clamptext(F:Name(it.id),36)
                detail="Shown in Marketplace; use its normal Buy button."
            else s=#self.matches.." matching offers";detail="Enter / Next opens the item's category and page." end
            text(self.name,"Txt_Result",s);text(self.name,"Txt_Detail",detail)
            local on=self.ready and not self.failed and #self.matches>0
            pcall(DlgApi.EnableItem,self.name,"Btn_Prev",on);pcall(DlgApi.EnableItem,self.name,"Btn_Next",on)
        end
        function M:Step(delta)
            if not self.open or not self.ready or self.failed or not shown(self.host) then return true end
            self:ReadQuery()
            if #self.matches==0 or type(GameApi.FocusMarketplaceSearchItem)~="function" then return true end
            local i=(self.cursor+delta-1)%#self.matches+1;local it=self.matches[i]
            local ok,v=pcall(GameApi.FocusMarketplaceSearchItem,it.mall,it.id)
            if ok and v==1 then self.cursor=i;self.message=nil else self.message=true end
            self:Status();return true
        end
        function M:Tick()
            if not self.open and shown(self.name) then pcall(DlgApi.ShowDialog,self.name,false) end
            local on=O:On("market_search")
            if shown(self.host) then pcall(DlgApi.ShowItem,self.host,self.button,on) end
            if not shown(self.host) or not on then
                if self.open then self:Close() else pcall(DlgApi.CheckItem,self.host,self.button,false) end
                return
            end
            if self.open then
                if not checked(self.host,self.button) or not shown(self.name) then self:Close();return end
            elseif checked(self.host,self.button) then self:Open()
            else return end
            F:Place(self)
            if not self.ready and not self.failed then self:LoadCategory() end
            if self.ready then self:ReadQuery() end
            self:Status()
        end
    end
end

---------------------------------------------------------------- World Energy rate (Multi-EXP window)
local ENERGY_ITEMS = {"Control_Edt_EnergyRemaining", "Lab_EnergyRemaining", "Txt_EnergyRemaining",
    "Control_Edt_EnergyRate", "Lab_EnergyRate", "Txt_EnergyRate",
    "Control_Edt_EnergyETA", "Lab_EnergyETA", "Txt_EnergyETA"}
local EnergyUI = {}
function EnergyUI:Tick()
    local on = O:On("energy_tracker")
    if shown("Win_DoubleExp") and on ~= self.rows then
        for _, item in ipairs(ENERGY_ITEMS) do pcall(DlgApi.ShowItem, "Win_DoubleExp", item, on) end
        self.rows = on
    elseif not shown("Win_DoubleExp") then
        self.rows = nil
    end
    if not on then return end
    local ok = pcall(MultiExpWorldEnergy.Tick, MultiExpWorldEnergy)
    if not ok then
        MultiExpWorldEnergy:Unavailable()
        pcall(MultiExpWorldEnergy.Paint, MultiExpWorldEnergy)
    end
end

---------------------------------------------------------------- one shared per-frame hook
function U.Tick()
    local now = now_ms()
    if not now then return end
    if not O.nativeDone then O:Load(); O:ApplyNative() end
    pcall(S.Tick, S)
    pcall(V.Tick, V, now)
    pcall(Q.Tick, Q, now)
    pcall(R.TickJade, R)
    pcall(HH.Tick, HH)
    pcall(U.Search.Tick, U.Search)
    if U.MarketSearch then pcall(U.MarketSearch.Tick, U.MarketSearch) end
    pcall(EnergyUI.Tick, EnergyUI)
    if type(GameApi.TickClientTweaks) == "function" then pcall(GameApi.TickClientTweaks) end
    if type(EXPReplacementWarningTick) == "function" then pcall(EXPReplacementWarningTick) end
end

if type(GameUI) == "table" then
    local previousTick = GameUI.Tick
    function GameUI:Tick(...)
        if previousTick then previousTick(self, ...) end
        pcall(U.Tick)
    end
end
-- END SWORDSMAN CLASSIC CLIENT TWEAKS
