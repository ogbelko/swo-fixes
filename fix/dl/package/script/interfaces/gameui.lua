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
        {key = "uf_kill_counter", quick = true},
        {key = "quest_closed"},
        {key = "uf_chat_focus", group = 5},
        {key = "uf_get_all"},
        -- Hall of Heroes
        {key = "hoh_skip_cutscene"},
        -- name labels (exe reads names_only / enemy_names_red from ClientTweaks.ini)
        -- quick = true: set in the cogwheel panel (ClientUI.Quick), not in the Client Tweaks window
        {key = "names_only", default = false, quick = true},
        {key = "enemy_names_red", default = false, quick = true},
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
        {key = "mirage_arrows", group = 16},   -- v37: Mirage arrows walk through doorways (GameApi.MirageStep)
        -- Rare Animal Island
        {key = "boss_notes"},
        {key = "jade_labels"},
        -- start-up and graphics
        {key = "uf_skip_logos", group = 10},
        {key = "uf_skip_serverlist", group = 11},
        {key = "uf_minimal_fog", group = 12},
        -- performance (v36)
        {key = "uf_fps_unlock", group = 14},
        {key = "uf_bg_fps", group = 15},
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
    for _, o in ipairs(O.list) do
        if not o.quick then pcall(DlgApi.CheckItem, self.name, "Chk_" .. o.key, O.values[o.key] == true) end
    end
    settext(self.name, "Txt_Status", "")
end

function S:Apply()
    O:Load()
    for _, o in ipairs(O.list) do
        local ok, checked = pcall(DlgApi.IsItemChecked, self.name, "Chk_" .. o.key)
        if ok and not o.quick then O.values[o.key] = checked == true end
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

---------------------------------------------------------------- World Energy auto-use
-- Row "World Energy below [n] auto-use item" in Self-Cultivation Settings > Healing
-- (Win_AutoPlayRecover). Own file userdata\AutoEnergy.ini: O:Save rewrites ClientTweaks.ini.
local AE = {DLG = "Win_AutoPlayRecover", CHK = "Chk_AutoEnergy", EDT = "Edt_AutoEnergyInput",
    on = false, at = 50, names = {}, KNOWN = {75033, 92583},   -- World Energy Remedy, Fresh Dragonspit Herb
    WANT = {"world energy", "dragonspit herb"},
    SKIP = {"pack", "box", "bag", "chest", "crate", "recipe", "scroll"},
    nextCheck = 0, nextRead = 0, wasShown = false}
U.AutoEnergy = AE

function AE:Path()
    local p = O:Path()
    local dir = p and p:match("^(.*[\\/])")
    if dir then return dir .. "AutoEnergy.ini" end
end

function AE:Load()
    if self.loaded then return end
    self.loaded = true
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "rb")
    if not ok or not f then return end
    local okR, text = pcall(f.read, f, "*a"); pcall(f.close, f)
    if not okR or type(text) ~= "string" then return end
    local on = text:match("enabled%s*=%s*(%d+)")
    local at = tonumber(text:match("below%s*=%s*(%d+)") or "")
    if on then self.on = on ~= "0" end
    if at then self.at = math.max(0, math.min(200, at)) end
end

function AE:Save()
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "wb")
    if not ok or not f then return end
    pcall(f.write, f, "[AutoEnergy]\r\nenabled=" .. (self.on and "1" or "0") .. "\r\nbelow=" .. self.at .. "\r\n")
    pcall(f.close, f)
end

-- row <-> saved values while the Healing tab is open
function AE:Sync(now)
    local vis = shown(self.DLG)
    if vis and not self.wasShown then
        pcall(DlgApi.CheckItem, self.DLG, self.CHK, self.on)
        settext(self.DLG, self.EDT, tostring(self.at))
        self.nextRead = now + 250
    elseif vis and now >= self.nextRead then
        self.nextRead = now + 250
        local on, at = self.on, self.at
        local okC, c = pcall(DlgApi.IsItemChecked, self.DLG, self.CHK)
        if okC then on = c == true end
        local okT, txt = pcall(DlgApi.GetItemText, self.DLG, self.EDT)
        local n = okT and type(txt) == "string" and tonumber(txt) or nil
        if n then
            n = math.floor(n)
            if n > 200 then n = 200; settext(self.DLG, self.EDT, "200") end
            if n < 0 then n = 0 end
            at = n
        end
        if on ~= self.on or at ~= self.at then
            self.on, self.at = on, at
            self:Save()
        end
    end
    self.wasShown = vis
end

local function ae_count(id)
    local ok, n = pcall(GameApi.GetItemNumByID, id)
    return ok and type(n) == "number" and n or 0
end

function AE:Usable(id)
    local name = self.names[id]
    if name == nil then
        local ok, nm = pcall(GameApi.GetItemInfo, id)
        if not ok or type(nm) ~= "string" or nm == "" then return false end   -- ask again next time
        name = (nm:gsub("%^%x%x%x%x%x%x", "")):lower()
        self.names[id] = name
    end
    for _, s in ipairs(self.SKIP) do if name:find(s, 1, true) then return false end end
    for _, w in ipairs(self.WANT) do if name:find(w, 1, true) then return true end end
    return false
end

function AE:FindItem()
    if self.itemId and ae_count(self.itemId) > 0 then return self.itemId end
    self.itemId = nil
    if type(GameApi.GetItemNumByID) == "function" then
        for _, id in ipairs(self.KNOWN) do
            if ae_count(id) > 0 then self.itemId = id; return id end
        end
    end
    if type(GameApi.GetInventoryQoLPack) == "function" and type(GameApi.GetItemInfo) == "function" then
        for _, pack in ipairs({2, 3, 4}) do
            local ok, _, raw = pcall(GameApi.GetInventoryQoLPack, pack)
            if ok and type(raw) == "string" then
                for id in raw:gmatch("%d+:(%d+):%d+;") do
                    id = tonumber(id)
                    if id and id > 0 and self:Usable(id) then self.itemId = id; return id end
                end
            end
        end
    end
end

function AE:Tick(now)
    self:Load()
    self:Sync(now)
    if not self.on or now < self.nextCheck then return end
    self.nextCheck = now + 1000
    if type(GameApi.GetWorldEnergySample) ~= "function" or type(GameApi.UseItemByID) ~= "function" then return end
    local host = host_key()
    if host ~= self.host then self.host = host; self.readyAt = now + 10000; self.usedAt = nil end
    if not host or now < (self.readyAt or 0) then return end     -- not in game / just logged in
    local ok, bal, cap = pcall(GameApi.GetWorldEnergySample)
    if not ok or not finite(bal) or not finite(cap) or cap <= 0 or bal < 0 then return end
    if bal >= cap or math.ceil(bal) > self.at then self.usedAt = nil; return end
    -- one item at a time: wait for the last one to show up in the energy (or 15 s)
    if self.usedAt and bal <= self.usedBal + 0.5 and now - self.usedAt < 15000 then return end
    local id = self:FindItem()
    if not id then self.nextCheck = now + 5000; return end
    local okU, r = pcall(GameApi.UseItemByID, id)
    if okU and r ~= false then
        self.usedAt, self.usedBal = now, bal
    else
        self.nextCheck = now + 10000
    end
end

---------------------------------------------------------------- Minimal Mode Settings
-- Win_MinimalCustom (ESC > Settings > System > Minimal Settings). Writes userdata\MinimalMode.ini,
-- which the exe reads every time a map loads (Custom=0 or no file: the original Minimal Mode).
local MM = {DLG = "Win_MinimalCustom",
    KEYS = {"Custom", "Grass", "FarTerrain", "GroundPaint", "Trees", "Objects", "Water", "Other", "BgFps", "MaxPlayers", "NoCostumes", "FxDistance"},
    CHECKS = {Custom = "Chk_Custom", Grass = "Chk_Grass", FarTerrain = "Chk_Far", GroundPaint = "Chk_Ground",
              NoCostumes = "Chk_NoCostume"},
    EDITS = {Trees = "Edt_Trees", Objects = "Edt_Objects", Water = "Edt_Water", Other = "Edt_Other",
             BgFps = "Edt_BgFps", MaxPlayers = "Edt_MaxPlayers", FxDistance = "Edt_FxDistance"},
    RANGE = {BgFps = {0, 60}, MaxPlayers = {0, 200}, FxDistance = {0, 300}},
    PRESETS = {
        ultra = {Custom = 1, Grass = 0, FarTerrain = 0, GroundPaint = 0, Trees = 15, Objects = 40, Water = 40, Other = 40, BgFps = 10, MaxPlayers = 20, NoCostumes = 1, FxDistance = 20},
        balanced = {Custom = 1, Grass = 1, FarTerrain = 1, GroundPaint = 1, Trees = 40, Objects = 120, Water = 300, Other = 100, BgFps = 20, MaxPlayers = 50, NoCostumes = 0, FxDistance = 50},
        original = {Custom = 0, Grass = 0, FarTerrain = 0, GroundPaint = 0, Trees = 20, Objects = 50, Water = 50, Other = 50, BgFps = 0, MaxPlayers = 0, NoCostumes = 0, FxDistance = 0},
    }}
MM.v = {}
for k, val in pairs(MM.PRESETS.original) do MM.v[k] = val end
U.Minimal = MM

function MM:Path()
    local p = O:Path()
    local dir = p and p:match("^(.*[\\/])")
    if dir then return dir .. "MinimalMode.ini" end
end

function MM:Load()
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "rb")
    if not ok or not f then return end
    local okR, text = pcall(f.read, f, "*a"); pcall(f.close, f)
    if not okR or type(text) ~= "string" or #text > 4096 then return end
    for key, value in text:gmatch("([%a]+)%s*=%s*(%d+)") do
        if self.v[key] ~= nil then self.v[key] = tonumber(value) end
    end
end

function MM:Save()
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return false end
    local lines = {"[Minimal]"}
    for _, k in ipairs(self.KEYS) do lines[#lines + 1] = k .. "=" .. tostring(self.v[k]) end
    local ok, f = pcall(io.open, path, "wb")
    if not ok or not f then return false end
    local okW = pcall(f.write, f, table.concat(lines, "\r\n") .. "\r\n")
    pcall(f.close, f)
    return okW
end

function MM:Enable()
    local on = self.v.Custom == 1
    for _, item in pairs(self.EDITS) do enable(self.DLG, item, on) end
    for k, item in pairs(self.CHECKS) do if k ~= "Custom" then enable(self.DLG, item, on) end end
end

function MM:Populate()
    for k, item in pairs(self.CHECKS) do pcall(DlgApi.CheckItem, self.DLG, item, self.v[k] == 1) end
    for k, item in pairs(self.EDITS) do settext(self.DLG, item, tostring(self.v[k])) end
    self:Enable()
end

function MM:Read()
    for k, item in pairs(self.CHECKS) do
        local ok, c = pcall(DlgApi.IsItemChecked, self.DLG, item)
        if ok then self.v[k] = (c == true) and 1 or 0 end
    end
    for k, item in pairs(self.EDITS) do
        local ok, txt = pcall(DlgApi.GetItemText, self.DLG, item)
        local n = ok and type(txt) == "string" and tonumber(txt) or nil
        if n then
            local r = self.RANGE[k] or {10, 600}
            n = math.max(r[1], math.min(r[2], math.floor(n)))
            if (k == "BgFps" or k == "FxDistance") and n > 0 and n < 5 then n = 5 end
            self.v[k] = n
        end
    end
end

function MM:Open()
    if shown(self.DLG) then self:Close(); return end
    self:Load()
    show(self.DLG, true)
    center(self.DLG)
    self:Populate()
    settext(self.DLG, "Txt_Status", "")
    self.open = true
end

function MM:Close() show(self.DLG, false); self.open = false end

function MM:Preset(name)
    local p = self.PRESETS[name]
    if not p then return end
    for k, val in pairs(p) do self.v[k] = val end
    self:Populate()
    settext(self.DLG, "Txt_Status", "Preset loaded. Press Apply or OK to keep it.")
end

function MM:Apply()
    self:Read()
    local saved = self:Save()
    self:Populate()
    settext(self.DLG, "Txt_Status", saved and "Saved. FPS and player limits apply within 2 s; the rest at the next map load or teleport."
        or "The settings file could not be written.")
    return saved
end

function MM:OK() if self:Apply() then self:Close() end end

-- keeps the rows greyed out while "Use my settings" is off
function MM:Tick(now)
    if not self.open then return end
    if not shown(self.DLG) then self.open = false; return end
    if now < (self.nextRead or 0) then return end
    self.nextRead = now + 200
    local ok, c = pcall(DlgApi.IsItemChecked, self.DLG, "Chk_Custom")
    local v = (ok and c == true) and 1 or 0
    if ok and v ~= self.v.Custom then self.v.Custom = v; self:Enable() end
end

-- Reforge reroll core: parsing, matching and exact odds. No game calls (testable in plain Lua 5.1).
-- The roll follows the game server's addon_manager::GenerateGroup:
--   1. skill group: index by the pool's skillprop odds (0 = none); count 1..3 by the group's count odds;
--      ids drawn uniformly without replacement from one list (or all lists merged when "mixed");
--      each level by the group's level odds.
--   2. stats (by-count pools): n by gen_random_bycount_odds, n -= skills drawn, then n slots drawn by
--      weight without replacement (independent pools: each slot by its own odds; select-one: one slot).
RerollCore = RerollCore or {}
local C = RerollCore

---------------------------------------------------------------- hex helpers
local function byte_at(hex, off) return tonumber(hex:sub(off * 2 + 1, off * 2 + 2), 16) or 0 end
local function u32(hex, off)
    return byte_at(hex, off) + byte_at(hex, off + 1) * 256 + byte_at(hex, off + 2) * 65536 + byte_at(hex, off + 3) * 16777216
end
local function i32(hex, off) local v = u32(hex, off); if v >= 2147483648 then v = v - 4294967296 end; return v end
local function f32(hex, off)
    local b = u32(hex, off)
    local sign = (b >= 2147483648) and -1 or 1
    local e = math.floor(b / 8388608) % 256
    local m = b % 8388608
    if e == 0 then
        if m == 0 then return 0 end
        return sign * m * 2 ^ -149
    elseif e == 255 then
        return 0
    end
    return sign * (1 + m / 8388608) * 2 ^ (e - 127)
end
C.u32, C.f32, C.byte_at = u32, f32, byte_at

local function normalize(t)
    local s = 0
    for _, v in ipairs(t) do s = s + v end
    if s <= 1e-6 then return nil end
    local out = {}
    for i, v in ipairs(t) do out[i] = v / s end
    return out
end

---------------------------------------------------------------- parsing
-- item essence (0x70 bytes from item+0x18d)
function C.ParseItem(hex)
    if type(hex) ~= "string" or #hex < 0xe0 then return nil end
    local it = {pool = u32(hex, 0), slots = {}, skills = {}}
    for i = 0, 31 do it.slots[i] = byte_at(hex, 0x0f + i) ~= 0 end
    local n = byte_at(hex, 0x4f)
    if n > 3 then return nil end
    for i = 0, n - 1 do
        it.skills[#it.skills + 1] = {id = u32(hex, 0x50 + 5 * i), level = byte_at(hex, 0x54 + 5 * i)}
    end
    return it
end

-- ADDON_GROUP_ESSENCE (552 bytes)
function C.ParsePool(hex)
    if type(hex) ~= "string" or #hex < 552 * 2 then return nil end
    local p = {gen = u32(hex, 0x90), slots = {}, groups = {}}
    for i = 0, 31 do
        local id, w = u32(hex, 0xbc + 8 * i), f32(hex, 0xc0 + 8 * i)
        p.slots[i] = {id = id, w = (id ~= 0 and w > 0) and w or 0}
    end
    local bc = {}
    for n = 0, 8 do bc[n + 1] = f32(hex, 0x1bc + 4 * n) end
    p.bycount = normalize(bc)                      -- [n + 1] = chance of n random lines
    local sp, ids = {}, {}
    for k = 0, 8 do
        local id, o = u32(hex, 0x1e0 + 8 * k), f32(hex, 0x1e4 + 8 * k)
        if k == 0 then id = 0 elseif id == 0 then o = 0 end
        ids[k + 1], sp[k + 1] = id, o
    end
    local spn = normalize(sp)
    if not spn then return nil end
    for k = 1, 9 do
        if spn[k] > 0 then p.groups[#p.groups + 1] = {p = spn[k], id = ids[k]} end
    end
    if p.gen == 2 and not p.bycount then return nil end
    return p
end

-- SKILLPROP_GROUP_CONFIG (660 bytes)
function C.ParseSkillGroup(hex)
    if type(hex) ~= "string" or #hex < 660 * 2 then return nil end
    local g = {mixed = u32(hex, 0x4c) ~= 0, levels = {}, lists = {}, maxlv = 0}
    local lv, lo = {}, {}
    for i = 0, 4 do
        local v, o = i32(hex, 0x50 + 8 * i), f32(hex, 0x54 + 8 * i)
        if v > 0 and o > 1e-6 then lv[#lv + 1] = v; lo[#lo + 1] = o end
    end
    local lon = normalize(lo)
    if lon then
        for i, v in ipairs(lv) do
            g.levels[i] = {v = v, p = lon[i]}
            if v > g.maxlv then g.maxlv = v end
        end
    end
    g.pmax = 0
    for _, l in ipairs(g.levels) do if l.v == g.maxlv then g.pmax = g.pmax + l.p end end
    g.counts = normalize({f32(hex, 0x78), f32(hex, 0x7c), f32(hex, 0x80)})
    if not g.counts then return nil end
    for l = 0, 10 do
        local list = {}
        for j = 0, 11 do
            local id = i32(hex, 0x84 + 48 * l + 4 * j)
            if id > 0 then list[#list + 1] = id end
        end
        if #list > 0 then g.lists[#g.lists + 1] = list end
    end
    return g
end

---------------------------------------------------------------- what the item can roll
-- stats: {id, slots = {i...}} for every slot with a weight (ordered by first slot)
function C.PoolStats(pool)
    local out, seen = {}, {}
    for i = 0, 31 do
        local s = pool.slots[i]
        if s.id ~= 0 and s.w > 0 then
            if not seen[s.id] then seen[s.id] = {id = s.id, slots = {}}; out[#out + 1] = seen[s.id] end
            table.insert(seen[s.id].slots, i)
        end
    end
    return out
end

-- skills: ordered unique ids over all skill groups (needs pool.groups[k].sk = parsed group)
function C.PoolSkills(pool)
    local out, seen = {}, {}
    for _, gr in ipairs(pool.groups) do
        if gr.sk then
            for _, list in ipairs(gr.sk.lists) do
                for _, id in ipairs(list) do
                    if not seen[id] then seen[id] = true; out[#out + 1] = id end
                end
            end
        end
    end
    return out
end

-- highest level any group gives a skill
function C.SkillMaxLevel(pool, id)
    local best = 0
    for _, gr in ipairs(pool.groups) do
        local g = gr.sk
        if g and #g.levels > 0 then
            for _, list in ipairs(g.lists) do
                for _, x in ipairs(list) do if x == id and g.maxlv > best then best = g.maxlv end end
            end
        end
    end
    return best
end

---------------------------------------------------------------- matching
-- want = {stats = {[id] = true}, atleast = N, skills = {[id] = true}, maxlevel = bool}
function C.Matches(item, pool, want)
    local hit = 0
    for i = 0, 31 do
        if item.slots[i] then
            local s = pool.slots[i]
            if s and want.stats[s.id] then hit = hit + 1 end
        end
    end
    if hit < (want.atleast or 0) then return false end
    for id in pairs(want.skills) do
        local ok = false
        for _, sk in ipairs(item.skills) do
            if sk.id == id and (not want.maxlevel or sk.level >= C.SkillMaxLevel(pool, id)) then ok = true end
        end
        if not ok then return false end
    end
    return true
end

---------------------------------------------------------------- exact odds
local function choose(n, k)
    if k < 0 or k > n then return 0 end
    local r = 1
    for i = 1, k do r = r * (n - k + i) / i end
    return r
end

-- chance that every wanted skill appears among c uniform draws (no replacement) from list
-- (and, with p < 1, at least one copy at max level, each copy at max level with chance p)
local function skill_prob(list, c, wanted, p)
    local ids = {}
    for id in pairs(wanted) do ids[#ids + 1] = id end
    if #ids == 0 then return 1 end
    local m = {}
    for i, id in ipairs(ids) do
        m[i] = 0
        for _, x in ipairs(list) do if x == id then m[i] = m[i] + 1 end end
        if m[i] == 0 then return 0 end
    end
    local L = #list
    local total = choose(L, c)
    if total == 0 then return 0 end
    local sum = 0
    for mask = 0, 2 ^ #ids - 1 do
        local ms, bits, x = 0, 0, mask
        for i = 1, #ids do
            if x % 2 == 1 then ms = ms + m[i]; bits = bits + 1 end
            x = math.floor(x / 2)
        end
        local none = 0          -- no max-level copy of the skills in this subset
        for j = 0, math.min(c, ms) do
            local hyp = choose(ms, j) * choose(L - ms, c - j) / total
            none = none + hyp * (1 - p) ^ j
        end
        sum = sum + ((bits % 2 == 1) and -none or none)
    end
    if sum < 0 then sum = 0 end
    return sum
end
C.skill_prob = skill_prob

-- stat chance by number of drawn lines: res[k + 1] = P(at least N wanted lines | k draws), by-count pools
local function stat_by_lines(pool, wanted, need)
    local groups, key = {}, {}
    for i = 0, 31 do
        local s = pool.slots[i]
        if s.w > 0 then
            local wk = (wanted[s.id] and "1" or "0") .. ":" .. string.format("%.9g", s.w)
            if not key[wk] then
                key[wk] = #groups + 1
                groups[#groups + 1] = {w = s.w, n = 0, want = wanted[s.id] and true or false}
            end
            local g = groups[key[wk]]
            g.n = g.n + 1
        end
    end
    local res = {}
    -- layer = {[statekey] = {d = {...}, p = prob}}
    local layer = {[""] = {d = {}, p = 1}}
    for _, g in ipairs(groups) do end
    local function hits(d)
        local h = 0
        for gi, g in ipairs(groups) do if g.want then h = h + (d[gi] or 0) end end
        return h
    end
    for k = 0, 8 do
        local s = 0
        for _, st in pairs(layer) do if hits(st.d) >= need then s = s + st.p end end
        res[k + 1] = s
        if k == 8 then break end
        local nxt = {}
        for _, st in pairs(layer) do
            local R = 0
            for gi, g in ipairs(groups) do R = R + (g.n - (st.d[gi] or 0)) * g.w end
            if R <= 1e-12 then
                local kk = table.concat(st.d, ",")
                if nxt[kk] then nxt[kk].p = nxt[kk].p + st.p else nxt[kk] = {d = st.d, p = st.p} end
            else
                for gi, g in ipairs(groups) do
                    local left = g.n - (st.d[gi] or 0)
                    if left > 0 then
                        local d = {}
                        for j = 1, #groups do d[j] = st.d[j] or 0 end
                        d[gi] = d[gi] + 1
                        local kk = table.concat(d, ",")
                        local pr = st.p * left * g.w / R
                        if nxt[kk] then nxt[kk].p = nxt[kk].p + pr else nxt[kk] = {d = d, p = pr} end
                    end
                end
            end
        end
        layer = nxt
    end
    return res
end
C.stat_by_lines = stat_by_lines

-- chance of the stat condition for independent / select-one pools
local function stat_other(pool, wanted, need)
    if pool.gen == 1 then
        local tot, good = 0, 0
        for i = 0, 31 do
            local s = pool.slots[i]
            tot = tot + s.w
            if wanted[s.id] then good = good + s.w end
        end
        if tot <= 1e-6 then return need <= 0 and 1 or 0 end
        if need <= 0 then return 1 end
        if need == 1 then return good / tot end
        return 0
    end
    -- independent: each slot rolls with its own chance
    local dist = {[0] = 1}
    for i = 0, 31 do
        local s = pool.slots[i]
        if s.w > 0 and wanted[s.id] then
            local q = math.min(1, s.w)
            local nd = {}
            for h, pr in pairs(dist) do
                nd[h] = (nd[h] or 0) + pr * (1 - q)
                nd[h + 1] = (nd[h + 1] or 0) + pr * q
            end
            dist = nd
        end
    end
    local s = 0
    for h, pr in pairs(dist) do if h >= need then s = s + pr end end
    return s
end

-- want as in Matches. Returns the chance per roll (0..1).
function C.Chance(pool, want)
    local need = want.atleast or 0
    local by_lines = (pool.gen == 2) and stat_by_lines(pool, want.stats, need) or nil
    local other = (pool.gen ~= 2) and stat_other(pool, want.stats, need) or nil
    local function stat(cact)
        if not by_lines then return other end
        local s = 0
        for n = 0, 8 do
            local lines = n - cact
            if lines < 0 then lines = 0 end
            s = s + pool.bycount[n + 1] * by_lines[lines + 1]
        end
        return s
    end
    local any_skill = next(want.skills) ~= nil
    local total = 0
    for _, gr in ipairs(pool.groups) do
        local g = gr.sk
        if gr.id == 0 or not g or #g.levels == 0 then
            -- no skills rolled (no group, missing group, or a group without levels)
            if not any_skill then total = total + gr.p * stat(0) end
        else
            local lists = g.lists
            if g.mixed then
                local all = {}
                for _, l in ipairs(lists) do for _, id in ipairs(l) do all[#all + 1] = id end end
                lists = (#all > 0) and {all} or {}
            end
            if #lists == 0 then
                if not any_skill then total = total + gr.p * stat(0) end
            else
                local pmax = want.maxlevel and g.pmax or 1
                for _, list in ipairs(lists) do
                    for c = 1, 3 do
                        local q = g.counts[c]
                        if q > 0 then
                            local cact = math.min(c, #list)
                            total = total + gr.p * (1 / #lists) * q * skill_prob(list, cact, want.skills, pmax) * stat(cact)
                        end
                    end
                end
            end
        end
    end
    return total
end


---------------------------------------------------------------- Reforge reroll tool
-- Win_RerollTool docks to the left of the Equipment Service window (Win_EquipServ_Main, the frame with the tabs; the
-- Celestial / Legendary Reforge pages are sub-dialogs inside it), tops aligned, and follows it when it is moved. It is
-- shown while the Celestial Reforge (Win_EquipServ_ArtifactRebuild) or Legendary Reforge (Win_EquipServ_LegendRebuild)
-- page is open. Tick the wanted stats / skills, Start: it presses Reforge (GameApi.RerollPress / RerollPressL), waits
-- for the item to change (GameApi.RerollItem / RerollItemL), checks it and repeats until it matches. Both pages use the
-- server's RefreshEquip reroll, so items and pools parse the same way. Never ticks Chk_UseTrace (Celestial).
local RR = {DLG = "Win_RerollTool", MAIN = "Win_EquipServ_Main",
    HOSTS = {
        {name = "Win_EquipServ_ArtifactRebuild", item = "RerollItem", press = "RerollPress", label = "Celestial", trace = true},
        {name = "Win_EquipServ_LegendRebuild", item = "RerollItemL", press = "RerollPressL", label = "Legendary"},
    },
    STATS = 32, SKILLS = 16, GAP = 150, TIMEOUT = 6000, DEFAULT_TYPES = {[189] = true, [190] = true},
    running = false, nextRead = 0, statTick = {}, skillTick = {}, page = 1}
U.Reroll = RR
local Core = RerollCore

local function rr_show_item(item, on) pcall(DlgApi.ShowItem, RR.DLG, item, on and true or false) end
local function rr_checked(item) local ok, c = pcall(DlgApi.IsItemChecked, RR.DLG, item); return ok and c == true end
local function rr_check(item, on) pcall(DlgApi.CheckItem, RR.DLG, item, on and true or false) end
local function rr_pos(name)
    local ok, p = pcall(DlgApi.GetDialogProp, name)
    if ok and type(p) == "table" and type(p.x) == "number" and type(p.y) == "number" then return p.x, p.y end
end

function RR:Status(text) settext(self.DLG, "Txt_Status", text or "") end

-- the Reforge page that is open now (or nil)
function RR:ActiveHost()
    for _, h in ipairs(self.HOSTS) do if shown(h.name) then return h end end
end

function RR:PutHint() return "Put a " .. (self.host and self.host.label or "Celestial") .. " item in the Reforge window." end

local function stat_label(id)
    local ok, okp, typ, p1, p2 = pcall(GameApi.GetItemDBProp, id, 1004, "type", "param1", "param2", "param3")
    if ok and okp and type(EQUIP_ESSENCE_TYPE) == "table" and EQUIP_ESSENCE_TYPE[typ] then
        local style = EQUIP_ESSENCE_TYPE[typ].style
        local okf, txt = pcall(string.format, style, p1 or 0)
        if okf and type(txt) == "string" then return txt, typ end
        return style, typ
    end
    return "Stat #" .. tostring(id), ok and okp and typ or 0
end

local function skill_label(id)
    local ok, name = pcall(GameApi.GetSkillName, id)
    if ok and type(name) == "string" and name ~= "" then return name end
    return "Skill #" .. tostring(id)
end

-- reads the item in the open page's Reforge slot; returns hex, tid, ptr or nil
function RR:ReadItem()
    local fn = self.host and GameApi[self.host.item]
    if type(fn) ~= "function" then return nil end
    local ok, hex, tid, ptr = pcall(fn)
    if ok and type(hex) == "string" then return hex, tid, ptr end
end

-- docks the tool to the left of the Equipment Service frame (or the page itself if the frame is not found)
function RR:Dock()
    local anchor = shown(self.MAIN) and self.MAIN or (self.host and self.host.name)
    if not anchor then return end
    pcall(DlgApi.SetDialogPosition, self.DLG, 0, 0, anchor, AUIDIALOG_ALIGN_OUTSIDE, AUIDIALOG_ALIGN_LEFT,
        AUIDIALOG_ALIGN_INSIDE, AUIDIALOG_ALIGN_TOP)
    self.anchorX, self.anchorY = rr_pos(anchor)
end

function RR:Clear(msg)
    self.item, self.pool, self.stats, self.skills, self.hex, self.ptr, self.tid = nil, nil, {}, {}, nil, nil, nil
    for i = 1, self.STATS do rr_show_item("Chk_S" .. i, false) end
    for i = 1, self.SKILLS do rr_show_item("Chk_K" .. i, false) end
    rr_show_item("Btn_KPrev", false); rr_show_item("Btn_KNext", false); settext(self.DLG, "Lab_KPage", "")
    settext(self.DLG, "Lab_Item", "")
    settext(self.DLG, "Txt_Odds", "")
    self:Status(self.lastStop or msg)
end

-- (re)builds the lists for the item now in the slot
function RR:Load()
    local hex, tid, ptr = self:ReadItem()
    if not hex then self:Clear(self:PutHint()); return end
    local item = Core.ParseItem(hex)
    local ph = item and GameApi.RerollTemplate and select(2, pcall(GameApi.RerollTemplate, item.pool, 6, 86, 552))
    local pool = type(ph) == "string" and Core.ParsePool(ph) or nil
    if not pool then self:Clear("Can't read this item's stats."); self.hex, self.ptr, self.tid = hex, ptr, tid; return end
    for _, gr in ipairs(pool.groups) do
        if gr.id ~= 0 then
            local ok, gh = pcall(GameApi.RerollTemplate, gr.id, 4, 135, 660)
            gr.sk = (ok and type(gh) == "string") and Core.ParseSkillGroup(gh) or nil
        end
    end
    local samePool = self.pool and self.poolId == item.pool
    self.item, self.pool, self.poolId, self.hex, self.ptr, self.tid = item, pool, item.pool, hex, ptr, tid
    if not samePool then
        self.stats, self.skills, self.statTick, self.skillTick, self.page = {}, {}, {}, {}, 1
        local ticked = 0
        for _, st in ipairs(Core.PoolStats(pool)) do
            local label, typ = stat_label(st.id)
            if #st.slots > 1 then label = label .. " (x" .. #st.slots .. ")" end
            self.stats[#self.stats + 1] = {id = st.id, label = label}
            if self.DEFAULT_TYPES[typ] then self.statTick[st.id] = true; ticked = ticked + 1 end
        end
        for _, id in ipairs(Core.PoolSkills(pool)) do
            self.skills[#self.skills + 1] = {id = id, label = skill_label(id)}
        end
        settext(self.DLG, "Edt_AtLeast", tostring(ticked))
        rr_check("Chk_MaxLevel", false)
    end
    local name = "Item"
    local okn, nm = pcall(GameApi.GetItemName, tid)
    if okn and type(nm) == "string" and nm ~= "" then name = nm end
    local lines = ""
    if pool.gen == 2 then
        local most = 0
        for n = 0, 8 do if pool.bycount[n + 1] > 0 then most = n end end
        lines = string.format("  (up to %d lines, skills take lines)", most)
    end
    settext(self.DLG, "Lab_Item", name .. lines)
    self:Populate()
end

function RR:Populate()
    for i = 1, self.STATS do
        local st = self.stats[i]
        rr_show_item("Chk_S" .. i, st ~= nil)
        if st then settext(self.DLG, "Chk_S" .. i, st.label); rr_check("Chk_S" .. i, self.statTick[st.id]) end
    end
    local pages = math.max(1, math.ceil(#self.skills / self.SKILLS))
    if self.page > pages then self.page = pages end
    for i = 1, self.SKILLS do
        local sk = self.skills[(self.page - 1) * self.SKILLS + i]
        rr_show_item("Chk_K" .. i, sk ~= nil)
        if sk then settext(self.DLG, "Chk_K" .. i, sk.label); rr_check("Chk_K" .. i, self.skillTick[sk.id]) end
    end
    rr_show_item("Btn_KPrev", pages > 1); rr_show_item("Btn_KNext", pages > 1)
    settext(self.DLG, "Lab_KPage", pages > 1 and string.format("%d / %d", self.page, pages) or "")
    if #self.skills == 0 then settext(self.DLG, "Lab_SkillsHdr", "Skills (none on this item)")
    else settext(self.DLG, "Lab_SkillsHdr", "Skills") end
    self.wantKey = nil
    self:ReadControls()
end

-- checkbox / option state -> self.want, odds text
function RR:ReadControls()
    if not self.pool then return end
    for i = 1, self.STATS do
        local st = self.stats[i]
        if st then self.statTick[st.id] = rr_checked("Chk_S" .. i) or nil end
    end
    for i = 1, self.SKILLS do
        local sk = self.skills[(self.page - 1) * self.SKILLS + i]
        if sk then self.skillTick[sk.id] = rr_checked("Chk_K" .. i) or nil end
    end
    local okT, txt = pcall(DlgApi.GetItemText, self.DLG, "Edt_AtLeast")
    local n = okT and tonumber(txt) or 0
    local want = {stats = {}, skills = {}, atleast = n or 0, maxlevel = rr_checked("Chk_MaxLevel")}
    local keys, nstats = {}, 0
    for id in pairs(self.statTick) do want.stats[id] = true; keys[#keys + 1] = "s" .. id; nstats = nstats + 1 end
    for id in pairs(self.skillTick) do want.skills[id] = true; keys[#keys + 1] = "k" .. id end
    if want.atleast > nstats then want.atleast = nstats end
    table.sort(keys)
    local key = table.concat(keys, ",") .. "|" .. want.atleast .. "|" .. tostring(want.maxlevel)
    self.want = want
    if key == self.wantKey then return end
    self.wantKey = key
    if nstats == 0 and next(want.skills) == nil then
        self.chance = nil
        settext(self.DLG, "Txt_Odds", "Tick the stats and skills you want.")
        return
    end
    local ok, p = pcall(Core.Chance, self.pool, want)
    self.chance = ok and p or nil
    if not ok then
        settext(self.DLG, "Txt_Odds", "Could not compute the odds.")
    elseif p <= 0 then
        settext(self.DLG, "Txt_Odds", "This combination can't roll on this item.")
    else
        local inv = 1 / p
        local s = inv < 10 and string.format("%.2f", inv) or string.format("%.0f", inv)
        settext(self.DLG, "Txt_Odds", string.format("Chance per roll: 1 in %s  (%.4g%%)", s, p * 100))
    end
end

function RR:Page(delta)
    if self.running then return end
    self:ReadControls()
    local pages = math.max(1, math.ceil(#self.skills / self.SKILLS))
    self.page = math.max(1, math.min(pages, self.page + delta))
    self:Populate()
end

local function rr_controls(on)
    for i = 1, RR.STATS do enable(RR.DLG, "Chk_S" .. i, on) end
    for i = 1, RR.SKILLS do enable(RR.DLG, "Chk_K" .. i, on) end
    for _, n in ipairs({"Chk_MaxLevel", "Edt_AtLeast", "Btn_KPrev", "Btn_KNext", "Btn_Start"}) do enable(RR.DLG, n, on) end
    enable(RR.DLG, "Btn_Stop", not on)
end

function RR:Start()
    if self.running then return end
    self:Load()
    if not self.item or not self.pool then self:Status(self.item and "Can't read this item's stats." or self:PutHint()); return end
    self:ReadControls()
    if not self.chance then self:Status("Tick the stats and skills you want first."); return end
    if self.chance <= 0 then self:Status("This combination can't roll on this item."); return end
    if Core.Matches(self.item, self.pool, self.want) then self:Status("The item already matches."); return end
    self.running, self.rolls, self.waiting, self.nextAt, self.lastStop = true, 0, false, 0, nil
    rr_controls(false)
    self.statusText = "Rolling..."
    self:Status(self.statusText)
end

function RR:Stop(msg)
    self.running, self.waiting = false, false
    rr_controls(true)
    self.lastStop = msg or "Stopped."
    self:Status(self.lastStop)
end

function RR:Press(now)
    local h = self.host
    if h.trace then pcall(DlgApi.CheckItem, h.name, "Chk_UseTrace", false) end      -- never use the Recall token
    if U.Money then U.Money:Apply(h.name) end                -- Notes first, or Coins only (the page's Only Use Coin)
    local fn = GameApi[h.press]
    local ok, r = false, nil
    if type(fn) == "function" then ok, r = pcall(fn) end
    if ok and r == 2 then
        self:Stop("Stopped: Notes would bind this item, so the game asks first. Reforge once by hand (it is then "
            .. "bound), or untick Notes first (Coins only), then Start again.")
        return
    end
    if not ok or r ~= 1 then
        self:Stop(string.format("Stopped: Reforge not possible (not enough items or coins?) after %d rolls.", self.rolls))
        return
    end
    self.waiting, self.pressAt, self.pressHex = true, now, self.hex
end

-- the Notes-first tick <-> the shared setting (U.Money); the page's own Only Use Coin box follows it
function RR:SyncMoney()
    local M = U.Money
    if not M then return end
    M:Load()
    local c = rr_checked("Chk_NotesFirst")
    if self.moneyShown ~= nil and c ~= self.moneyShown then
        M:Set(c)
        self.moneyShown = c
    elseif self.moneyShown ~= M.notesFirst then
        rr_check("Chk_NotesFirst", M.notesFirst)
        self.moneyShown = M.notesFirst
    end
    if self.host then M:Apply(self.host.name) end
end

function RR:Step(now)
    local hex, tid, ptr = self:ReadItem()
    if not hex then self:Stop(string.format("Stopped: the item was removed after %d rolls.", self.rolls)); return end
    -- a new item object while a roll is pending can be the server's update of the same item
    if tid ~= self.tid or (ptr ~= self.ptr and not (self.waiting and hex ~= self.pressHex)) then
        self:Stop(string.format("Stopped: the item was swapped after %d rolls.", self.rolls)); return
    end
    self.ptr = ptr
    local item = Core.ParseItem(hex)
    if not item or item.pool ~= self.poolId then self:Stop(string.format("Stopped: the item changed after %d rolls.", self.rolls)); return end
    if self.waiting then
        if hex ~= self.pressHex then
            self.waiting, self.hex, self.item = false, hex, item
            self.rolls = self.rolls + 1
            if Core.Matches(item, self.pool, self.want) then
                self:Stop(string.format("Got it after %d rolls!", self.rolls))
                return
            end
            self.nextAt = now + self.GAP
            self.statusText = string.format("Rolling... %d rolls", self.rolls)
            self:Status(self.statusText)
        elseif now - self.pressAt > self.TIMEOUT then
            self:Stop(string.format("Stopped: no reply from the server for 6 s (after %d rolls).", self.rolls))
        end
        return
    end
    if now >= self.nextAt then self:Press(now) end
end

function RR:Close()
    if self.running then self:Stop("Stopped.") end
    self.userClosed = true
    show(self.DLG, false)
end

function RR:Tick(now)
    local host = self:ActiveHost()
    if host ~= self.host then
        -- the page changed (Celestial <-> Legendary, or closed): start over for the new page
        if self.running then self:Stop(string.format("Stopped: the Reforge page was closed after %d rolls.", self.rolls)) end
        self.host, self.pool, self.poolId, self.hex, self.ptr, self.tid = host, nil, nil, nil, nil, nil
        if not host then
            if shown(self.DLG) then show(self.DLG, false) end
            self.userClosed = false
            return
        end
        if shown(self.DLG) then self:Dock(); self:Load() end
    end
    if not host then return end
    if not shown(self.DLG) then
        if self.userClosed then return end
        show(self.DLG, true)
        self:Dock()
        rr_controls(true)
        self:Load()
        self.moneyShown = nil
        self:SyncMoney()
        return
    end
    -- stay docked when the Equipment Service window is moved
    local ax, ay = rr_pos(shown(self.MAIN) and self.MAIN or host.name)
    if ax and (ax ~= self.anchorX or ay ~= self.anchorY) then self:Dock() end
    if self.running then self:Step(now); return end
    if now < self.nextRead then return end
    self.nextRead = now + 300
    self:SyncMoney()
    local hex, tid, ptr = self:ReadItem()
    if hex ~= self.hex or ptr ~= self.ptr or tid ~= self.tid then self:Load() else self:ReadControls() end
end

---------------------------------------------------------------- General Power target mode per key
-- Control Scheme tab (Win_SettingFightOperation): "Set per key" + padlocks under keys 1-8
-- (ticked = Locked Target, empty = Area Select). Own file userdata\SkillTarget.ini (O:Save rewrites ClientTweaks.ini);
-- the exe (per_key_target.py) reads per_key / key1..key8 at most once a second for General Power casts.
local ST = {DLG = "Win_SettingFightOperation", PER = "Chk_GpPerKey", BAR_LOCKED = "Rdo_EliteMode2",
    on = false, keys = {false, false, false, false, false, false, false, false}, found = false,
    wasShown = false, nextRead = 0}
U.SkillTarget = ST

function ST:Path()
    local p = O:Path()
    local dir = p and p:match("^(.*[\\/])")
    if dir then return dir .. "SkillTarget.ini" end
end

function ST:Load()
    if self.loaded then return end
    self.loaded = true
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "rb")
    if not ok or not f then return end
    local okR, text = pcall(f.read, f, "*a"); pcall(f.close, f)
    if not okR or type(text) ~= "string" then return end
    self.found = true
    local on = text:match("per_key%s*=%s*(%d+)")
    if on then self.on = on ~= "0" end
    for i = 1, 8 do
        local v = text:match("key" .. i .. "%s*=%s*(%d+)")
        if v then self.keys[i] = v ~= "0" end
    end
end

function ST:Save()
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local lines = {"[SkillTarget]", "per_key=" .. (self.on and "1" or "0")}
    for i = 1, 8 do lines[#lines + 1] = "key" .. i .. "=" .. (self.keys[i] and "1" or "0") end
    local ok, f = pcall(io.open, path, "wb")
    if not ok or not f then return end
    pcall(f.write, f, table.concat(lines, "\r\n") .. "\r\n")
    pcall(f.close, f)
    self.found = true
end

function ST:Checked(item)
    local ok, c = pcall(DlgApi.IsItemChecked, self.DLG, item)
    if ok then return c == true end
end

function ST:Paint()
    pcall(DlgApi.CheckItem, self.DLG, self.PER, self.on)
    for i = 1, 8 do pcall(DlgApi.CheckItem, self.DLG, "Chk_GpKey" .. i, self.keys[i]) end
    self:Enable()
end

-- per key on: the locks work and the bar's Area Select / Locked Target are greyed; off: the other way round
function ST:Enable()
    if type(DlgApi.EnableItem) ~= "function" then return end
    for i = 1, 8 do pcall(DlgApi.EnableItem, self.DLG, "Chk_GpKey" .. i, self.on) end
    pcall(DlgApi.EnableItem, self.DLG, "Rdo_EliteMode1", not self.on)
    pcall(DlgApi.EnableItem, self.DLG, self.BAR_LOCKED, not self.on)
end

-- boxes <-> saved values while the Control Scheme tab is open
function ST:Tick(now)
    self:Load()
    local vis = shown(self.DLG)
    if vis and not self.wasShown then
        self:Paint()
        self.nextRead = now + 250
    elseif vis and now >= self.nextRead then
        self.nextRead = now + 250
        local changed = false
        local on = self:Checked(self.PER)
        if on ~= nil and on ~= self.on then
            self.on, changed = on, true
            self:Enable()
            if on and not self.found then
                -- first use: every key starts from the General Power bar's current choice
                local locked = self:Checked(self.BAR_LOCKED) == true
                for i = 1, 8 do self.keys[i] = locked end
                self:Paint()
            end
        end
        for i = 1, 8 do
            local c = self:Checked("Chk_GpKey" .. i)
            if c ~= nil and c ~= self.keys[i] then self.keys[i], changed = c, true end
        end
        if changed then self:Save() end
    end
    self.wasShown = vis
end

---------------------------------------------------------------- FPS / ping + cogwheel in the top bar, quick settings
-- Win_MainInfoLeft (the top bar: map name, PK setting, area icons) holds Txt_PerfInfo (the exe's perf routine writes it
-- once a second) and Btn_SwcCog (command swc_cog, interfaces/maininfoleft.lua). Both follow the last area icon shown
-- (Img_1..Img_7, else the Send Position button), so they always sit right next to it, on the map name's line.
-- The game sizes the bar to 385 px at run time (the XML width is ignored) and clips what lies outside, so the bar is
-- widened to just past the cogwheel (DlgApi.SetDialogSize) whenever it is narrower.
-- Win_SwcQuick: Name labels (names_only, enemy_names_red) and Player kill counter (ClientTweaks.ini keys, quick = true:
-- not in the Client Tweaks window any more), the loot auto-roll and the System mail auto-claim (QuickPanel.ini).
-- Loot auto-roll: every 0.25 s GameApi.LootAutoRoll(0 Need / 1 Greed) answers the open rolls the way the roll
-- window's buttons do (the window then drops those rows by itself).
-- Mail auto-claim: when the System mailbox is at least mail_pct % full (the server's own figure, GameApi.MailInfo),
-- in a safe area and with the mail window closed: open it on the System tab, press Get All (GameApi.MailGetAll, the
-- visible page) again and again while mail keeps disappearing, then close it. The server only removes items that fit
-- in the bag and deletes a System mail once it is empty; mail that cannot be claimed stays (then a 5 minute pause).
local QP = {BAR = "Win_MainInfoLeft", PANEL = "Win_SwcQuick", MAIL = "Win_MailList",
    ICONS = {"Btn_SendPos", "Img_1", "Img_2", "Img_3", "Img_4", "Img_5", "Img_6", "Img_7"},
    GAP = 6, COG = 150, SENDPOS_X = 223,  -- UI pixels (x GetWindowScale): after the icon, text -> cogwheel
    KEYS = {"names_only", "enemy_names_red", "uf_kill_counter"},
    mailOn = false, mailPct = 80, lootOn = false, lootMode = "greed", nextLoot = 0,
    nextTick = 0, nextRead = 0, panelShown = false,
    mail = {state = "idle", nextCheck = 0}}
U.Quick = QP

function QP:Path()
    local p = O:Path()
    local dir = p and p:match("^(.*[\\/])")
    if dir then return dir .. "QuickPanel.ini" end
end

function QP:Load()
    if self.loaded then return end
    self.loaded = true
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "rb")
    if not ok or not f then return end
    local okR, text = pcall(f.read, f, "*a"); pcall(f.close, f)
    if not okR or type(text) ~= "string" then return end
    local on = text:match("mail_auto%s*=%s*(%d+)")
    local pct = tonumber(text:match("mail_pct%s*=%s*(%d+)") or "")
    if on then self.mailOn = on ~= "0" end
    if pct then self.mailPct = math.max(1, math.min(100, pct)) end
    local loot, mode = text:match("loot_auto%s*=%s*(%d+)"), text:match("loot_mode%s*=%s*(%a+)")
    if loot then self.lootOn = loot ~= "0" end
    if mode == "need" or mode == "greed" then self.lootMode = mode end
end

function QP:Save()
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local lines = {"[QuickPanel]", "mail_auto=" .. (self.mailOn and "1" or "0"), "mail_pct=" .. self.mailPct,
        "loot_auto=" .. (self.lootOn and "1" or "0"), "loot_mode=" .. self.lootMode}
    local ok, f = pcall(io.open, path, "wb")
    if not ok or not f then return end
    pcall(f.write, f, table.concat(lines, "\r\n") .. "\r\n")
    pcall(f.close, f)
end

local function qp_checked(dlg, item)
    local ok, c = pcall(DlgApi.IsItemChecked, dlg, item)
    if ok then return c == true end
end

---------------------------------------------------------------- in the top bar
function QP:Scale()
    local ok, s = pcall(DlgApi.GetWindowScale)
    return (ok and finite(s) and s > 0) and s or 1
end

-- item rectangle inside the top bar (same units as SetItemPos)
function QP:Rect(item)
    local ok, r = pcall(DlgApi.GetItemRect, self.BAR, item, true)
    if ok and type(r) == "table" and finite(r.x) and finite(r.y) and finite(r.width) and finite(r.height) then return r end
end

-- right edge of the last icon shown after the map name
function QP:IconRight()
    local right
    for _, item in ipairs(self.ICONS) do
        local okS, s = pcall(DlgApi.IsItemShow, self.BAR, item)
        local r = okS and s == true and self:Rect(item)
        if r and (not right or r.x + r.width > right) then right = r.x + r.width end
    end
    return right
end

function QP:TickBar()
    if not host_key() or not shown(self.BAR) then self.lastRight = nil; return end
    local want = O:On("uf_fps_ping")
    if self.textOn ~= want then
        pcall(DlgApi.ShowItem, self.BAR, "Txt_PerfInfo", want)
        self.textOn, self.lastRight = want, nil
    end
    local s = self:Scale()
    local send = self:Rect("Btn_SendPos")
    -- only trust the rectangles when they are relative to the bar (Send Position sits at x 223)
    if not send or math.abs(send.x - self.SENDPOS_X * s) > 40 * s then return end
    local right = self:IconRight()
    if right and right ~= self.lastRight then
        local t, c = self:Rect("Txt_PerfInfo"), self:Rect("Btn_SwcCog")
        if t and c then
            local x = math.floor(right + self.GAP * s + 0.5)
            pcall(DlgApi.SetItemPos, self.BAR, "Txt_PerfInfo", x, t.y)
            pcall(DlgApi.SetItemPos, self.BAR, "Btn_SwcCog", want and math.floor(x + self.COG * s + 0.5) or x, c.y)
            self.lastRight = right
        end
    end
    self:Fit(s)
end

-- wide enough to show (and click) everything up to the cogwheel
function QP:Fit(s)
    local c = self:Rect("Btn_SwcCog")
    if not c then return end
    local ok, w, h = pcall(DlgApi.GetDialogSize, self.BAR)
    if not ok or not finite(w) or not finite(h) then return end
    local need = math.ceil(c.x + c.width + 4 * s)
    if w < need then pcall(DlgApi.SetDialogSize, self.BAR, need, h) end
end

---------------------------------------------------------------- the panel
function QP:Toggle()
    self:Load()
    if shown(self.PANEL) then show(self.PANEL, false); self.panelShown = false; return true end
    show(self.PANEL, true)
    local bx, by = dialog_pos(self.BAR)
    local c = self:Rect("Btn_SwcCog")
    if bx and c then
        pcall(DlgApi.SetDialogPosition, self.PANEL, math.floor(bx + c.x + 0.5), math.floor(by + c.y + c.height + 6 + 0.5))
    else
        pcall(DlgApi.SetDialogPosition, self.PANEL, 0, 0, self.BAR, AUIDIALOG_ALIGN_INSIDE, AUIDIALOG_ALIGN_LEFT,
            AUIDIALOG_ALIGN_OUTSIDE, AUIDIALOG_ALIGN_BOTTOM)
    end
    self:Paint()
    self.panelShown = true
    return true
end

function QP:Close() show(self.PANEL, false); self.panelShown = false; return true end

function QP:Paint()
    O:Load()
    for _, k in ipairs(self.KEYS) do pcall(DlgApi.CheckItem, self.PANEL, "Chk_" .. k, O.values[k] == true) end
    pcall(DlgApi.CheckItem, self.PANEL, "Chk_mail_auto", self.mailOn)
    pcall(DlgApi.CheckItem, self.PANEL, "Chk_loot_auto", self.lootOn)
    pcall(DlgApi.CheckItem, self.PANEL, "Chk_loot_need", self.lootMode == "need")
    pcall(DlgApi.CheckItem, self.PANEL, "Chk_loot_greed", self.lootMode == "greed")
    settext(self.PANEL, "Edt_MailPct", tostring(self.mailPct))
    self.shownPct = tostring(self.mailPct)
    self:MailText()
end

function QP:TickPanel(now)
    local vis = shown(self.PANEL)
    if not vis then self.panelShown = false; return end
    if not self.panelShown then self.panelShown = true; self:Paint() end
    if now < self.nextRead then return end
    self.nextRead = now + 250
    local saveTweaks = false
    for _, k in ipairs(self.KEYS) do
        local c = qp_checked(self.PANEL, "Chk_" .. k)
        if c ~= nil and c ~= (O.values[k] == true) then O.values[k] = c; saveTweaks = true end
    end
    if saveTweaks then O:Save() end
    local changed = false
    local on = qp_checked(self.PANEL, "Chk_mail_auto")
    if on ~= nil and on ~= self.mailOn then self.mailOn, changed = on, true end
    local loot = qp_checked(self.PANEL, "Chk_loot_auto")
    if loot ~= nil and loot ~= self.lootOn then self.lootOn, changed = loot, true end
    -- Need / Greed behave like a pair of radio buttons: the one just ticked wins, one is always ticked
    local need, greed = qp_checked(self.PANEL, "Chk_loot_need"), qp_checked(self.PANEL, "Chk_loot_greed")
    if need ~= nil and greed ~= nil then
        local mode = self.lootMode
        if self.lootMode == "greed" and need then mode = "need" elseif self.lootMode == "need" and greed then mode = "greed" end
        if mode ~= self.lootMode then self.lootMode, changed = mode, true end
        if need ~= (mode == "need") then pcall(DlgApi.CheckItem, self.PANEL, "Chk_loot_need", mode == "need") end
        if greed ~= (mode == "greed") then pcall(DlgApi.CheckItem, self.PANEL, "Chk_loot_greed", mode == "greed") end
    end
    local okT, txt = pcall(DlgApi.GetItemText, self.PANEL, "Edt_MailPct")
    local n = okT and type(txt) == "string" and tonumber(txt) or nil
    if n and txt ~= self.shownPct then
        n = math.floor(n)
        if n > 100 then n = 100; settext(self.PANEL, "Edt_MailPct", "100") end
        if n >= 1 and n ~= self.mailPct then self.mailPct, changed = n, true end
        self.shownPct = txt
    end
    if changed then self:Save() end
    self:MailText()
end

---------------------------------------------------------------- System mail auto-claim
function QP:MailInfo()
    if type(GameApi.MailInfo) ~= "function" then return nil end
    local ok, pct, total, unread, ppct, ptotal, tab, rows, safe = pcall(GameApi.MailInfo)
    if not ok or not finite(pct) or not finite(total) then return nil end
    return {pct = pct, total = total, unread = unread, ppct = ppct, ptotal = ptotal, tab = tab, rows = rows or 0,
        safe = safe == 1}
end

function QP:MailText()
    if not shown(self.PANEL) then return end
    local i = self:MailInfo()
    local info = i and string.format("System mailbox: %d%% full (%d mails)", i.pct, i.total)
        or "System mailbox: not known yet"
    if info ~= self.infoText then settext(self.PANEL, "Txt_MailInfo", info); self.infoText = info end
    local m = self.mail
    local st = m.message or (self.mailOn and ("Claims at " .. self.mailPct .. "% in towns and safe zones.") or "Off.")
    if st ~= self.statusText then settext(self.PANEL, "Txt_MailStatus", st); self.statusText = st end
end

function QP:MailFinish(message, pause, now)
    local m = self.mail
    if m.opened and shown(self.MAIL) then show(self.MAIL, false) end
    m.state, m.opened, m.message = "idle", false, message
    m.nextCheck = now + pause
end

function QP:TickMail(now)
    local m = self.mail
    if m.state == "idle" then
        if now < m.nextCheck then return end
        m.nextCheck = now + 1000
        if not self.mailOn or not host_key() then return end
        local i = self:MailInfo()
        if not i or i.total <= 0 or i.pct < self.mailPct or not i.safe or shown(self.MAIL) then return end
        if type(GameApi.MailGetAll) ~= "function" or type(GameApi.MailSystemTab) ~= "function" then return end
        show(self.MAIL, true)                              -- opening asks the server for the list
        m.opened, m.state, m.t, m.rounds, m.stalls, m.message = true, "list", now, 0, 0, "Claiming System mail..."
        if i.tab ~= 1 then pcall(GameApi.MailSystemTab) end
        return
    end
    if not shown(self.MAIL) then self:MailFinish("Stopped: the mail window was closed.", 60000, now); return end
    local i = self:MailInfo()
    if not i then self:MailFinish(nil, 60000, now); return end
    if i.tab ~= 1 then pcall(GameApi.MailSystemTab); m.t = now; return end
    if m.state == "list" then
        if i.rows > 0 then
            m.state, m.t = "claim", now
        elseif now - m.t > 4000 then
            self:MailFinish(i.total > 0 and "Stopped: the mail list did not load." or nil, 60000, now)
        end
    elseif m.state == "claim" then
        if not i.safe then self:MailFinish("Stopped: not in a safe area.", 60000, now); return end
        m.before, m.rowsBefore = i.total, i.rows
        local ok, r = pcall(GameApi.MailGetAll)
        if not ok or r ~= 1 then self:MailFinish("Stopped: Get All was refused.", 60000, now); return end
        m.rounds, m.state, m.t = m.rounds + 1, "wait", now
    elseif m.state == "wait" then
        if now - m.t < 1500 then return end
        if i.total <= 0 then self:MailFinish("Done: the System mailbox is empty.", 30000, now); return end
        if i.total < m.before or i.rows < m.rowsBefore then
            m.stalls = 0
        else
            m.stalls = m.stalls + 1
        end
        if m.stalls >= 2 or m.rounds >= 40 then
            self:MailFinish(string.format("Paused: %d System mails could not be claimed (bag full?).", i.total),
                300000, now)
            return
        end
        m.state = "claim"
    end
end

function QP:TickLoot(now)
    if not self.lootOn or now < self.nextLoot then return end
    self.nextLoot = now + 250
    if type(GameApi.LootAutoRoll) == "function" and host_key() then
        pcall(GameApi.LootAutoRoll, self.lootMode == "need" and 0 or 1)
    end
end

function QP:Tick(now)
    self:Load()
    self:TickLoot(now)
    if now >= self.nextTick then
        self.nextTick = now + 500
        self:TickBar()
    end
    self:TickPanel(now)
    self:TickMail(now)
end

---------------------------------------------------------------- Alt + right-click: open the whole stack
-- The exe (altopen_exe.py) notes the bag slot when an item is used (UseItem) while Alt and a mouse button are held,
-- i.e. Alt + right-click / double-click in a window (selling, storing, compose windows never use the item).
-- Each time the stack has gone down, the same slot is used again (GameApi.AltOpenUse checks it still holds that
-- item), until it is empty or holds something else. Nothing for 1.5 s: try again; 3 tries in a row: stop (bag full,
-- cooldown, ...). Alt + right-click on the same stack again while it runs stops it.
local AO = {GAP = 60, WAIT = 1500, TRIES = 3}
U.AltOpen = AO

function AO:Say(text)
    if GP_CHAT_MISC ~= nil then pcall(GameApi.AddChatMessage, GP_CHAT_MISC, text) end
end

function AO:Name(tid)
    local ok, nm = pcall(GameApi.GetItemInfo, tid)
    if ok and type(nm) == "string" and nm ~= "" then return (nm:gsub("%^%x%x%x%x%x%x", "")) end
    return "item " .. tostring(tid)
end

function AO:Finish(left, why)
    local j = self.job
    self.job = nil
    local text = string.format("Opened %d x %s.", j.start - left, j.name)
    self:Say(why and (text .. " " .. why) or text)
end

function AO:Tick(now)
    if type(GameApi.AltOpenPoll) ~= "function" or type(GameApi.AltOpenUse) ~= "function" then return end
    local ok, seq, pack, slot, tid, count = pcall(GameApi.AltOpenPoll)
    if not ok or not finite(seq) then return end
    if self.seq == nil then self.seq = seq end                    -- requests from before a UI reload don't count
    local j = self.job
    if seq ~= self.seq then
        self.seq = seq
        if j and j.pack == pack and j.slot == slot and j.tid == tid then
            self:Finish(count - 1, string.format("Stopped with %d left.", count - 1))
            return
        end
        if j then self:Finish(j.last, "Stopped.") end
        if count <= 1 then
            self:Say(string.format("Alt + right-click: that was the last %s, nothing more to open.", self:Name(tid)))
            return
        end
        -- the click itself has just used one
        self.job = {pack = pack, slot = slot, tid = tid, start = count, last = count, sent = now, tries = 1,
            name = self:Name(tid)}
        self:Say(string.format("Opening %d x %s... (Alt + right-click it again to stop)", count, self.job.name))
        return
    end
    if not j then return end
    if not host_key() then self.job = nil; return end
    local okI, t, n = pcall(GameApi.AltOpenItem, j.pack, j.slot)
    if not okI or not finite(t) or not finite(n) then self.job = nil; return end
    if t ~= j.tid or n <= 0 then self:Finish(0); return end
    if n < j.last then j.last, j.tries = n, 0 end
    if j.tries > 0 then                                           -- the last use has not shown yet
        if now - j.sent < self.WAIT then return end
        if j.tries >= self.TRIES then
            self:Finish(n, string.format("Stopped with %d left (bag full?).", n))
            return
        end
    end
    if now - j.sent < self.GAP then return end
    local okU, r = pcall(GameApi.AltOpenUse, j.pack, j.slot, j.tid)
    if not okU or r ~= 1 then self:Finish(n, string.format("Stopped with %d left.", n)); return end
    j.sent, j.tries = now, j.tries + 1
end

---------------------------------------------------------------- Gem Cleanser helper
-- Win_GemCleanser docks to the left of the Equipment Service window while its Gem Cleansing page
-- (Win_EquipServ_StonePurify) is open. Server rules (gs synthetize_manager::StoneClean, produce_svr.lua
-- StoneCleanConfig, elements.data):
--   * a gem of level N and quality Q can be cleansed up to min(N, Q) (max 9; level-10 gems have no cost entry);
--     the client also stops at the stove level. One level at a time: level L costs COST[L] crystals + 5000 coins.
--   * clean level L multiplies the gem's stat by (100 + pct[L]) / 100 (gem template purify_add_property).
--   * every cleanse lasts 30 days; then the gem drops one level (and that level runs 30 days, ...).
--     Clean keeps the level and restarts the 30 days for COST[L] x (time used / 30 days), no coins.
--     So holding level L costs COST[L] crystals per 30 days.
--   * crystals: +1 every 2 hours (also offline), up to the stove's cap (no more are made while full).
-- Plan: the levels for the ticked gems with the most gain whose upkeep fits the budget (default = income, 360 per
-- 30 days); exact - a knapsack over gem x level. Gain is measured in "level-5 gems of
-- that stat" (GC.UNIT), so different stats compare. Unticked gems get nothing (they drop a level every 30 days).
-- "Keep at" (the - / + / A buttons of a row, per gem kind, GemCleanser.ini keep=<kind>|<level>): that kind is held at
-- exactly that level (0 = let it drop), whatever is ticked; its upkeep is counted first, the planner shares the rest.
-- Gems: pack 0 = equipped gear, pack 1 = the hidden weapon (GameApi.GemSockets records carry the pack).
-- Actions: Clean planned gems with less than 5 days left, then the upgrade steps, best first.
-- "Do next" does the first action with the game's own buttons (Clean shows the game's cost box);
-- "Auto" does them one after another (Clean without the box) until crystals run out or the plan is done.
local GC = {DLG = "Win_GemCleanser", HOST = "Win_EquipServ_StonePurify", MAIN = "Win_EquipServ_Main",
    ROWS = 10, COST = {2, 4, 7, 11, 15, 21, 27, 35, 43}, COINS = 5000, SPAN = 2592000, PERIOD = 7200,
    CAP = {[0] = 0, 10, 30, 60, 100, 150, 200, 250, 300, 400}, INCOME = 360, REFRESH = 5 * 86400,
    CATS = {
        {key = "exo", label = "Exo-Attack", types = {129}, on = true},
        {key = "endo", label = "Endo-Attack", types = {130}, on = true},
        {key = "crit", label = "Critical", types = {144}, on = true},
        {key = "eldmg", label = "Element damage", types = {50, 51, 52, 53}, on = true},
        {key = "elprof", label = "Element proficiency", types = {149, 150, 151, 152}, on = true},
        {key = "elpen", label = "Element penetration", types = {157, 158, 159, 160}, on = true},
        {key = "str", label = "Strength", types = {1}, on = true},
        {key = "wil", label = "Willpower", types = {5}, on = true},
        {key = "ref", label = "Reflex", types = {4}},
        {key = "ten", label = "Tenacity", types = {3}},
        {key = "con", label = "Constitution", types = {2}},
        {key = "hp", label = "HP / Chi", types = {9, 10}},
        {key = "def", label = "Exo / Endo-Defense", types = {30, 41}},
        {key = "res", label = "Element resist", types = {58, 59, 60, 61}},
        {key = "mit", label = "Mitigation / Evasion", types = {145, 146}},
        {key = "other", label = "Other", types = {179}},
    },
    SHORT = {[1] = "Str", [2] = "Con", [3] = "Ten", [4] = "Ref", [5] = "Wil", [9] = "HP", [10] = "Chi",
        [30] = "Exo-Def", [41] = "Endo-Def", [50] = "Ice Dmg", [51] = "Fire Dmg", [52] = "Poison Dmg",
        [53] = "Earth Dmg", [58] = "Ice Res%", [59] = "Fire Res%", [60] = "Poison Res%", [61] = "Earth Res%",
        [129] = "Exo-Atk", [130] = "Endo-Atk", [144] = "Crit", [145] = "Evasion", [146] = "Mitigation",
        [149] = "Ice Prof%", [150] = "Fire Prof%", [151] = "Poison Prof%", [152] = "Earth Prof%",
        [157] = "Ice Pen%", [158] = "Fire Pen%", [159] = "Poison Pen%", [160] = "Earth Pen%", [179] = "Other"},
    budget = 360, tick = {}, keep = {}, page = 1, nextRead = 0, socks = {}, names = {}}
U.GemCleanser = GC
GC.GEMS = {
    [56530] = {"Sunstone I", 1, 30, 116, {73}},
    [56531] = {"Sunstone II", 2, 30, 291, {73, 87}},
    [56532] = {"Sunstone III", 3, 30, 466, {73, 87, 102}},
    [56533] = {"Sunstone IV", 4, 30, 1003, {73, 87, 102, 118}},
    [56534] = {"Sunstone V", 5, 30, 1630, {73, 87, 102, 118, 136}},
    [56535] = {"Sunstone VI", 6, 30, 2094, {73, 87, 102, 118, 136, 156}},
    [56536] = {"Sunstone VII", 7, 30, 2828, {73, 87, 102, 118, 136, 156, 178}},
    [56537] = {"Sunstone VIII", 8, 30, 3461, {73, 87, 102, 118, 136, 156, 178, 201}},
    [56538] = {"Sunstone IX", 9, 30, 4052, {73, 87, 102, 118, 136, 156, 178, 201, 227}},
    [56539] = {"Sunstone X", 10, 30, 4963, {73, 87, 102, 118, 136, 156, 178, 201, 227}},
    [56540] = {"Moonstone I", 1, 41, 116, {73}},
    [56541] = {"Moonstone II", 2, 41, 291, {73, 87}},
    [56542] = {"Moonstone III", 3, 41, 466, {73, 87, 102}},
    [56543] = {"Moonstone IV", 4, 41, 1003, {73, 87, 102, 118}},
    [56544] = {"Moonstone V", 5, 41, 1630, {73, 87, 102, 118, 136}},
    [56545] = {"Moonstone VI", 6, 41, 2094, {73, 87, 102, 118, 136, 156}},
    [56546] = {"Moonstone VII", 7, 41, 2828, {73, 87, 102, 118, 136, 156, 178}},
    [56547] = {"Moonstone VIII", 8, 41, 3461, {73, 87, 102, 118, 136, 156, 178, 201}},
    [56548] = {"Moonstone IX", 9, 41, 4052, {73, 87, 102, 118, 136, 156, 178, 201, 227}},
    [56549] = {"Moonstone X", 10, 41, 4963, {73, 87, 102, 118, 136, 156, 178, 201, 227}},
    [56550] = {"Ruby I", 1, 129, 118, {8}},
    [56551] = {"Ruby II", 2, 129, 295, {8, 17}},
    [56552] = {"Ruby III", 3, 129, 470, {8, 17, 26}},
    [56553] = {"Ruby IV", 4, 129, 1009, {8, 17, 26, 36}},
    [56554] = {"Ruby V", 5, 129, 1639, {8, 17, 26, 36, 48}},
    [56555] = {"Ruby VI", 6, 129, 2108, {8, 17, 26, 36, 48, 60}},
    [56556] = {"Ruby VII", 7, 129, 2842, {8, 17, 26, 36, 48, 60, 74}},
    [56557] = {"Ruby VII", 8, 129, 3479, {8, 17, 26, 36, 48, 60, 74, 88}},
    [56558] = {"Ruby IX", 9, 129, 4073, {8, 17, 26, 36, 48, 60, 74, 88, 105}},
    [56559] = {"Ruby X", 10, 129, 4984, {8, 17, 26, 36, 48, 60, 74, 88, 105}},
    [56560] = {"Sapphire I", 1, 130, 118, {8}},
    [56561] = {"Sapphire II", 2, 130, 295, {8, 17}},
    [56562] = {"Sapphire III", 3, 130, 470, {8, 17, 26}},
    [56563] = {"Sapphire IV", 4, 130, 1009, {8, 17, 26, 36}},
    [56564] = {"Sapphire V", 5, 130, 1639, {8, 17, 26, 36, 48}},
    [56565] = {"Sapphire VI", 6, 130, 2108, {8, 17, 26, 36, 48, 60}},
    [56566] = {"Sapphire VII", 7, 130, 2842, {8, 17, 26, 36, 48, 60, 74}},
    [56567] = {"Sapphire VIII", 8, 130, 3479, {8, 17, 26, 36, 48, 60, 74, 88}},
    [56568] = {"Sapphire IX", 9, 130, 4073, {8, 17, 26, 36, 48, 60, 74, 88, 105}},
    [56569] = {"Sapphire X", 10, 130, 4984, {8, 17, 26, 36, 48, 60, 74, 88, 105}},
    [56570] = {"Rock Crystal I", 1, 50, 45, {62}},
    [56571] = {"Rock Crystal II", 2, 50, 111, {62, 75}},
    [56572] = {"Rock Crystal III", 3, 50, 177, {62, 75, 89}},
    [56573] = {"Rock Crystal IV", 4, 50, 378, {62, 75, 89, 105}},
    [56574] = {"Rock Crystal V", 5, 50, 615, {62, 75, 89, 105, 122}},
    [56575] = {"Rock Crystal VI", 6, 50, 791, {62, 75, 89, 105, 122, 140}},
    [56576] = {"Rock Crystal VII", 7, 50, 1067, {62, 75, 89, 105, 122, 140, 160}},
    [56577] = {"Rock Crystal VIII", 8, 50, 1305, {62, 75, 89, 105, 122, 140, 160, 183}},
    [56578] = {"Rock Crystal IX", 9, 50, 1527, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56579] = {"Rock Crystal X", 10, 50, 1869, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56580] = {"Garnet I", 1, 51, 45, {62}},
    [56581] = {"Garnet II", 2, 51, 111, {62, 75}},
    [56582] = {"Garnet III", 3, 51, 177, {62, 75, 89}},
    [56583] = {"Garnet IV", 4, 51, 378, {62, 75, 89, 105}},
    [56584] = {"Garnet V", 5, 51, 615, {62, 75, 89, 105, 122}},
    [56585] = {"Garnet VI", 6, 51, 791, {62, 75, 89, 105, 122, 140}},
    [56586] = {"Garnet VII", 7, 51, 1067, {62, 75, 89, 105, 122, 140, 160}},
    [56587] = {"Garnet VIII", 8, 51, 1305, {62, 75, 89, 105, 122, 140, 160, 183}},
    [56588] = {"Garnet IX", 9, 51, 1527, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56589] = {"Garnet X", 10, 51, 1869, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56590] = {"Citrine I", 1, 53, 45, {62}},
    [56591] = {"Citrine II", 2, 53, 111, {62, 75}},
    [56592] = {"Citrine III", 3, 53, 177, {62, 75, 89}},
    [56593] = {"Citrine IV", 4, 53, 378, {62, 75, 89, 105}},
    [56594] = {"Citrine V", 5, 53, 615, {62, 75, 89, 105, 122}},
    [56595] = {"Citrine VI", 6, 53, 791, {62, 75, 89, 105, 122, 140}},
    [56596] = {"Citrine VII", 7, 53, 1067, {62, 75, 89, 105, 122, 140, 160}},
    [56597] = {"Citrine VIII", 8, 53, 1305, {62, 75, 89, 105, 122, 140, 160, 183}},
    [56598] = {"Citrine IX", 9, 53, 1527, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56599] = {"Citrine X", 10, 53, 1869, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56600] = {"Amethyst I", 1, 52, 45, {62}},
    [56601] = {"Amethyst II", 2, 52, 111, {62, 75}},
    [56602] = {"Amethyst III", 3, 52, 177, {62, 75, 89}},
    [56603] = {"Amethyst IV", 4, 52, 378, {62, 75, 89, 105}},
    [56604] = {"Amethyst V", 5, 52, 615, {62, 75, 89, 105, 122}},
    [56605] = {"Amethyst VI", 6, 52, 791, {62, 75, 89, 105, 122, 140}},
    [56606] = {"Amethyst VII", 7, 52, 1067, {62, 75, 89, 105, 122, 140, 160}},
    [56607] = {"Amethyst VIII", 8, 52, 1305, {62, 75, 89, 105, 122, 140, 160, 183}},
    [56608] = {"Amethyst IX", 9, 52, 1527, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56609] = {"Amethyst X", 10, 52, 1869, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56610] = {"White Agate I", 1, 58, 500, {62}},
    [56611] = {"White Agate II", 2, 58, 1500, {62, 75}},
    [56612] = {"White Agate III", 3, 58, 2500, {62, 75, 89}},
    [56613] = {"White Agate IV", 4, 58, 3500, {62, 75, 89, 105}},
    [56614] = {"White Agate V", 5, 58, 5000, {62, 75, 89, 105, 122}},
    [56615] = {"White Agate VI", 6, 58, 6500, {62, 75, 89, 105, 122, 140}},
    [56616] = {"White Agate VII", 7, 58, 8500, {62, 75, 89, 105, 122, 140, 160}},
    [56617] = {"White Agate VIII", 8, 58, 10500, {62, 75, 89, 105, 122, 140, 160, 183}},
    [56618] = {"White Agate IX", 9, 58, 13000, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56619] = {"White Agate X", 10, 58, 16000, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56636] = {"Red Agate I", 1, 59, 500, {62}},
    [56637] = {"Red Agate II", 2, 59, 1500, {62, 75}},
    [56638] = {"Red Agate III", 3, 59, 2500, {62, 75, 89}},
    [56639] = {"Red Agate IV", 4, 59, 3500, {62, 75, 89, 105}},
    [56640] = {"Red Agate V", 5, 59, 5000, {62, 75, 89, 105, 122}},
    [56641] = {"Red Agate VI", 6, 59, 6500, {62, 75, 89, 105, 122, 140}},
    [56642] = {"Red Agate VII", 7, 59, 8500, {62, 75, 89, 105, 122, 140, 160}},
    [56643] = {"Red Agate VIII", 8, 59, 10500, {62, 75, 89, 105, 122, 140, 160, 183}},
    [56644] = {"Red Agate IX", 9, 59, 13000, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56645] = {"Red Agate X", 10, 59, 16000, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56646] = {"Yellow Agate I", 1, 61, 500, {62}},
    [56647] = {"Yellow Agate II", 2, 61, 1500, {62, 75}},
    [56648] = {"Yellow Agate III", 3, 61, 2500, {62, 75, 89}},
    [56649] = {"Yellow Agate IV", 4, 61, 3500, {62, 75, 89, 105}},
    [56650] = {"Yellow Agate V", 5, 61, 5000, {62, 75, 89, 105, 122}},
    [56651] = {"Yellow Agate VI", 6, 61, 6500, {62, 75, 89, 105, 122, 140}},
    [56652] = {"Yellow Agate VII", 7, 61, 8500, {62, 75, 89, 105, 122, 140, 160}},
    [56653] = {"Yellow Agate VIII", 8, 61, 10500, {62, 75, 89, 105, 122, 140, 160, 183}},
    [56654] = {"Yellow Agate IX", 9, 61, 13000, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56655] = {"Yellow Agate X", 10, 61, 16000, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56656] = {"Green Agate I", 1, 60, 500, {62}},
    [56657] = {"Green Agate II", 2, 60, 1500, {62, 75}},
    [56658] = {"Green Agate III", 3, 60, 2500, {62, 75, 89}},
    [56659] = {"Green Agate IV", 4, 60, 3500, {62, 75, 89, 105}},
    [56660] = {"Green Agate V", 5, 60, 5000, {62, 75, 89, 105, 122}},
    [56661] = {"Green Agate VI", 6, 60, 6500, {62, 75, 89, 105, 122, 140}},
    [56662] = {"Green Agate VII", 7, 60, 8500, {62, 75, 89, 105, 122, 140, 160}},
    [56663] = {"Green Agate VIII", 8, 60, 10500, {62, 75, 89, 105, 122, 140, 160, 183}},
    [56664] = {"Green Agate IX", 9, 60, 13000, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56665] = {"Green Agate X", 10, 60, 16000, {62, 75, 89, 105, 122, 140, 160, 183, 207}},
    [56666] = {"Aventurine I", 1, 145, 103, {30}},
    [56667] = {"Aventurine II", 2, 145, 259, {30, 40}},
    [56668] = {"Aventurine III", 3, 145, 413, {30, 40, 51}},
    [56669] = {"Aventurine IV", 4, 145, 892, {30, 40, 51, 64}},
    [56670] = {"Aventurine V", 5, 145, 1449, {30, 40, 51, 64, 77}},
    [56671] = {"Aventurine VI", 6, 145, 1863, {30, 40, 51, 64, 77, 92}},
    [56672] = {"Aventurine VII", 7, 145, 2523, {30, 40, 51, 64, 77, 92, 108}},
    [56673] = {"Aventurine VIII", 8, 145, 3087, {30, 40, 51, 64, 77, 92, 108, 126}},
    [56674] = {"Aventurine IX", 9, 145, 3615, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56675] = {"Aventurine X", 10, 145, 4434, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56676] = {"Blue Coral I", 1, 4, 9, {19}},
    [56677] = {"Blue Coral II", 2, 4, 23, {19, 28}},
    [56678] = {"Blue Coral III", 3, 4, 36, {19, 28, 39}},
    [56679] = {"Blue Coral IV", 4, 4, 78, {19, 28, 39, 50}},
    [56680] = {"Blue Coral V", 5, 4, 126, {19, 28, 39, 50, 63}},
    [56681] = {"Blue Coral VI", 6, 4, 162, {19, 28, 39, 50, 63, 76}},
    [56682] = {"Blue Coral VII", 7, 4, 218, {19, 28, 39, 50, 63, 76, 91}},
    [56683] = {"Blue Coral VIII", 8, 4, 266, {19, 28, 39, 50, 63, 76, 91, 107}},
    [56684] = {"Blue Coral IX", 9, 4, 311, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56685] = {"Blue Coral X", 10, 4, 382, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56686] = {"Thorn Coral I", 1, 1, 17, {19}},
    [56687] = {"Thorn Coral II", 2, 1, 42, {19, 28}},
    [56688] = {"Thorn Coral III", 3, 1, 66, {19, 28, 39}},
    [56689] = {"Thorn Coral IV", 4, 1, 143, {19, 28, 39, 50}},
    [56690] = {"Thorn Coral V", 5, 1, 230, {19, 28, 39, 50, 63}},
    [56691] = {"Thorn Coral VI", 6, 1, 297, {19, 28, 39, 50, 63, 76}},
    [56692] = {"Thorn Coral VII", 7, 1, 401, {19, 28, 39, 50, 63, 76, 91}},
    [56693] = {"Thorn Coral VIII", 8, 1, 491, {19, 28, 39, 50, 63, 76, 91, 107}},
    [56694] = {"Thorn Coral IX", 9, 1, 574, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56695] = {"Thorn Coral X", 10, 1, 704, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56696] = {"Red Coral I", 1, 2, 16, {19}},
    [56697] = {"Red Coral II", 2, 2, 40, {19, 28}},
    [56698] = {"Red Coral III", 3, 2, 65, {19, 28, 39}},
    [56699] = {"Red Coral IV", 4, 2, 141, {19, 28, 39, 50}},
    [56700] = {"Red Coral V", 5, 2, 229, {19, 28, 39, 50, 63}},
    [56701] = {"Red Coral VI", 6, 2, 293, {19, 28, 39, 50, 63, 76}},
    [56702] = {"Red Coral VII", 7, 2, 398, {19, 28, 39, 50, 63, 76, 91}},
    [56703] = {"Red Coral VIII", 8, 2, 486, {19, 28, 39, 50, 63, 76, 91, 107}},
    [56704] = {"Red Coral IX", 9, 2, 569, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56705] = {"Red Coral X", 10, 2, 698, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56706] = {"Horn Coral I", 1, 5, 17, {19}},
    [56707] = {"Horn Coral II", 2, 5, 42, {19, 28}},
    [56708] = {"Horn Coral III", 3, 5, 66, {19, 28, 39}},
    [56709] = {"Horn Coral IV", 4, 5, 143, {19, 28, 39, 50}},
    [56710] = {"Horn Coral V", 5, 5, 230, {19, 28, 39, 50, 63}},
    [56711] = {"Horn Coral VI", 6, 5, 297, {19, 28, 39, 50, 63, 76}},
    [56712] = {"Horn Coral VII", 7, 5, 401, {19, 28, 39, 50, 63, 76, 91}},
    [56713] = {"Horn Coral VIII", 8, 5, 491, {19, 28, 39, 50, 63, 76, 91, 107}},
    [56714] = {"Horn Coral IX", 9, 5, 574, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56715] = {"Horn Coral X", 10, 5, 704, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56716] = {"Cave Coral I", 1, 3, 16, {19}},
    [56717] = {"Cave Coral II", 2, 3, 40, {19, 28}},
    [56718] = {"Cave Coral III", 3, 3, 65, {19, 28, 39}},
    [56719] = {"Cave Coral IV", 4, 3, 141, {19, 28, 39, 50}},
    [56720] = {"Cave Coral V", 5, 3, 229, {19, 28, 39, 50, 63}},
    [56721] = {"Cave Coral VI", 6, 3, 293, {19, 28, 39, 50, 63, 76}},
    [56722] = {"Cave Coral VII", 7, 3, 398, {19, 28, 39, 50, 63, 76, 91}},
    [56723] = {"Cave Coral VIII", 8, 3, 486, {19, 28, 39, 50, 63, 76, 91, 107}},
    [56724] = {"Cave Coral IX", 9, 3, 569, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56725] = {"Cave Coral X", 10, 3, 698, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56726] = {"Alabaster I", 1, 157, 200, {19}},
    [56727] = {"Alabaster II", 2, 157, 300, {19, 28}},
    [56728] = {"Alabaster III", 3, 157, 500, {19, 28, 39}},
    [56729] = {"Alabaster IV", 4, 157, 1000, {19, 28, 39, 50}},
    [56730] = {"Alabaster V", 5, 157, 1500, {19, 28, 39, 50, 63}},
    [56731] = {"Alabaster VI", 6, 157, 2500, {19, 28, 39, 50, 63, 76}},
    [56732] = {"Alabaster VII", 7, 157, 3500, {19, 28, 39, 50, 63, 76, 91}},
    [56733] = {"Alabaster VIII", 8, 157, 5000, {19, 28, 39, 50, 63, 76, 91, 107}},
    [56734] = {"Alabaster IX", 9, 157, 7500, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56735] = {"Alabaster X", 10, 157, 10000, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56736] = {"Jasper I", 1, 159, 200, {19}},
    [56737] = {"Jasper II", 2, 159, 300, {19, 28}},
    [56738] = {"Jasper III", 3, 159, 500, {19, 28, 39}},
    [56739] = {"Jasper IV", 4, 159, 1000, {19, 28, 39, 50}},
    [56740] = {"Jasper V", 5, 159, 1500, {19, 28, 39, 50, 63}},
    [56741] = {"Jasper VI", 6, 159, 2500, {19, 28, 39, 50, 63, 76}},
    [56742] = {"Jasper VII", 7, 159, 3500, {19, 28, 39, 50, 63, 76, 91}},
    [56743] = {"Jasper VIII", 8, 159, 5000, {19, 28, 39, 50, 63, 76, 91, 107}},
    [56744] = {"Jasper IX", 9, 159, 7500, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56745] = {"Jasper X", 10, 159, 10000, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56746] = {"Red Jade I", 1, 158, 200, {19}},
    [56747] = {"Red Jade II", 2, 158, 300, {19, 28}},
    [56748] = {"Red Jade III", 3, 158, 500, {19, 28, 39}},
    [56749] = {"Red Jade IV", 4, 158, 1000, {19, 28, 39, 50}},
    [56750] = {"Red Jade V", 5, 158, 1500, {19, 28, 39, 50, 63}},
    [56751] = {"Red Jade VI", 6, 158, 2500, {19, 28, 39, 50, 63, 76}},
    [56752] = {"Red Jade VII", 7, 158, 3500, {19, 28, 39, 50, 63, 76, 91}},
    [56753] = {"Red Jade VIII", 8, 158, 5000, {19, 28, 39, 50, 63, 76, 91, 107}},
    [56754] = {"Red Jade IX", 9, 158, 7500, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56755] = {"Red Jade X", 10, 158, 10000, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56756] = {"Topaz I", 1, 160, 200, {19}},
    [56757] = {"Topaz II", 2, 160, 300, {19, 28}},
    [56758] = {"Topaz III", 3, 160, 500, {19, 28, 39}},
    [56759] = {"Topaz IV", 4, 160, 1000, {19, 28, 39, 50}},
    [56760] = {"Topaz V", 5, 160, 1500, {19, 28, 39, 50, 63}},
    [56761] = {"Topaz VI", 6, 160, 2500, {19, 28, 39, 50, 63, 76}},
    [56762] = {"Topaz VII", 7, 160, 3500, {19, 28, 39, 50, 63, 76, 91}},
    [56763] = {"Topaz VIII", 8, 160, 5000, {19, 28, 39, 50, 63, 76, 91, 107}},
    [56764] = {"Topaz IX", 9, 160, 7500, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56765] = {"Topaz X", 10, 160, 10000, {19, 28, 39, 50, 63, 76, 91, 107, 125}},
    [56766] = {"Azurestone I", 1, 146, 35, {30}},
    [56767] = {"Azurestone II", 2, 146, 86, {30, 40}},
    [56768] = {"Azurestone III", 3, 146, 138, {30, 40, 51}},
    [56769] = {"Azurestone IV", 4, 146, 297, {30, 40, 51, 64}},
    [56770] = {"Azurestone V", 5, 146, 483, {30, 40, 51, 64, 77}},
    [56771] = {"Azurestone VI", 6, 146, 622, {30, 40, 51, 64, 77, 92}},
    [56772] = {"Azurestone VII", 7, 146, 841, {30, 40, 51, 64, 77, 92, 108}},
    [56773] = {"Azurestone VIII", 8, 146, 1029, {30, 40, 51, 64, 77, 92, 108, 126}},
    [56774] = {"Azurestone IX", 9, 146, 1205, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56775] = {"Azurestone X", 10, 146, 1478, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56779] = {"Black Pearl I", 1, 144, 22, {30}},
    [56780] = {"Black Pearl II", 2, 144, 57, {30, 40}},
    [56781] = {"Black Pearl III", 3, 144, 91, {30, 40, 51}},
    [56782] = {"Black Pearl IV", 4, 144, 197, {30, 40, 51, 64}},
    [56783] = {"Black Pearl V", 5, 144, 319, {30, 40, 51, 64, 77}},
    [56784] = {"Black Pearl VI", 6, 144, 410, {30, 40, 51, 64, 77, 92}},
    [56785] = {"Black Pearl VII", 7, 144, 554, {30, 40, 51, 64, 77, 92, 108}},
    [56786] = {"Black Pearl VIII", 8, 144, 678, {30, 40, 51, 64, 77, 92, 108, 126}},
    [56787] = {"Black Pearl IX", 9, 144, 794, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56788] = {"Black Pearl X", 10, 144, 973, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56789] = {"Red Jadeite I", 1, 150, 500, {30}},
    [56790] = {"Red Jadeite II", 2, 150, 1500, {30, 40}},
    [56791] = {"Red Jadeite III", 3, 150, 2500, {30, 40, 51}},
    [56792] = {"Red Jadeite IV", 4, 150, 3500, {30, 40, 51, 64}},
    [56793] = {"Red Jadeite V", 5, 150, 5000, {30, 40, 51, 64, 77}},
    [56794] = {"Red Jadeite VI", 6, 150, 6500, {30, 40, 51, 64, 77, 92}},
    [56795] = {"Red Jadeite VII", 7, 150, 8500, {30, 40, 51, 64, 77, 92, 108}},
    [56796] = {"Red Jadeite VIII", 8, 150, 10500, {30, 40, 51, 64, 77, 92, 108, 126}},
    [56797] = {"Red Jadeite IX", 9, 150, 13000, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56798] = {"Red Jadeite X", 10, 150, 16000, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56799] = {"Yellow Jadeite I", 1, 152, 500, {30}},
    [56800] = {"Yellow Jadeite II", 2, 152, 1500, {30, 40}},
    [56801] = {"Yellow Jadeite III", 3, 152, 2500, {30, 40, 51}},
    [56802] = {"Yellow Jadeite IV", 4, 152, 3500, {30, 40, 51, 64}},
    [56803] = {"Yellow Jadeite V", 5, 152, 5000, {30, 40, 51, 64, 77}},
    [56804] = {"Yellow Jadeite VI", 6, 152, 6500, {30, 40, 51, 64, 77, 92}},
    [56805] = {"Yellow Jadeite VII", 7, 152, 8500, {30, 40, 51, 64, 77, 92, 108}},
    [56806] = {"Yellow Jadeite VIII", 8, 152, 10500, {30, 40, 51, 64, 77, 92, 108, 126}},
    [56807] = {"Yellow Jadeite IX", 9, 152, 13000, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56808] = {"Yellow Jadeite X", 10, 152, 16000, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56809] = {"Blue Crystal I", 1, 149, 500, {30}},
    [56810] = {"Blue Crystal II", 2, 149, 1500, {30, 40}},
    [56811] = {"Blue Crystal III", 3, 149, 2500, {30, 40, 51}},
    [56812] = {"Blue Crystal IV", 4, 149, 3500, {30, 40, 51, 64}},
    [56813] = {"Blue Crystal V", 5, 149, 5000, {30, 40, 51, 64, 77}},
    [56814] = {"Blue Crystal VI", 6, 149, 6500, {30, 40, 51, 64, 77, 92}},
    [56815] = {"Blue Crystal VII", 7, 149, 8500, {30, 40, 51, 64, 77, 92, 108}},
    [56816] = {"Blue Crystal VIII", 8, 149, 10500, {30, 40, 51, 64, 77, 92, 108, 126}},
    [56817] = {"Blue Crystal IX", 9, 149, 13000, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56818] = {"Blue Crystal X", 10, 149, 16000, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56819] = {"Ink Jadeite I", 1, 151, 500, {30}},
    [56820] = {"Ink Jadeite II", 2, 151, 1500, {30, 40}},
    [56821] = {"Ink Jadeite III", 3, 151, 2500, {30, 40, 51}},
    [56822] = {"Ink Jadeite IV", 4, 151, 3500, {30, 40, 51, 64}},
    [56823] = {"Ink Jadeite V", 5, 151, 5000, {30, 40, 51, 64, 77}},
    [56824] = {"Ink Jadeite VI", 6, 151, 6500, {30, 40, 51, 64, 77, 92}},
    [56825] = {"Ink Jadeite VII", 7, 151, 8500, {30, 40, 51, 64, 77, 92, 108}},
    [56826] = {"Ink Jadeite VIII", 8, 151, 10500, {30, 40, 51, 64, 77, 92, 108, 126}},
    [56827] = {"Ink Jadeite IX", 9, 151, 13000, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [56828] = {"Ink Jadeite X", 10, 151, 16000, {30, 40, 51, 64, 77, 92, 108, 126, 146}},
    [75278] = {"Rainbow Stone I", 1, 9, 506, {73}},
    [75279] = {"Rainbow Stone II", 2, 9, 1253, {73, 87}},
    [75280] = {"Rainbow Stone III", 3, 9, 1989, {73, 87, 102}},
    [75281] = {"Rainbow Stone IV", 4, 9, 4266, {73, 87, 102, 118}},
    [75282] = {"Rainbow Stone V", 5, 9, 6934, {73, 87, 102, 118, 136}},
    [75283] = {"Rainbow Stone VI", 6, 9, 8912, {73, 87, 102, 118, 136, 156}},
    [75284] = {"Rainbow Stone VII", 7, 9, 12017, {73, 87, 102, 118, 136, 156, 178}},
    [75285] = {"Rainbow Stone VIII", 8, 9, 14708, {73, 87, 102, 118, 136, 156, 178, 201}},
    [75286] = {"Rainbow Stone IX", 9, 9, 17227, {73, 87, 102, 118, 136, 156, 178, 201, 227}},
    [75287] = {"Rainbow Stone X", 10, 9, 21068, {73, 87, 102, 118, 136, 156, 178, 201, 227}},
    [75289] = {"Amazon Stone I", 1, 10, 210, {73}},
    [75290] = {"Amazon Stone II", 2, 10, 510, {73, 87}},
    [75291] = {"Amazon Stone III", 3, 10, 810, {73, 87, 102}},
    [75292] = {"Amazon Stone IV", 4, 10, 1730, {73, 87, 102, 118}},
    [75293] = {"Amazon Stone V", 5, 10, 2800, {73, 87, 102, 118, 136}},
    [75294] = {"Amazon Stone VI", 6, 10, 3600, {73, 87, 102, 118, 136, 156}},
    [75295] = {"Amazon Stone VII", 7, 10, 4860, {73, 87, 102, 118, 136, 156, 178}},
    [75296] = {"Amazon Stone VIII", 8, 10, 5940, {73, 87, 102, 118, 136, 156, 178, 201}},
    [75297] = {"Amazon Stone IX", 9, 10, 6960, {73, 87, 102, 118, 136, 156, 178, 201, 227}},
    [75298] = {"Amazon Stone X", 10, 10, 8510, {73, 87, 102, 118, 136, 156, 178, 201, 227}},
    [93445] = {"Premium Red Jadeite III", 3, 150, 2950, {34, 46, 58}},
    [93446] = {"Premium Red Jadeite IV", 4, 150, 4175, {34, 46, 58, 73}},
    [93447] = {"Premium Red Jadeite V", 5, 150, 5675, {34, 46, 58, 73, 88}},
    [93448] = {"Premium Red Jadeite VI", 6, 150, 8450, {34, 46, 58, 73, 88, 105}},
    [93449] = {"Premium Yellow Jadeite III", 3, 152, 2950, {34, 46, 58}},
    [93450] = {"Premium Yellow Jadeite IV", 4, 152, 4175, {34, 46, 58, 73}},
    [93451] = {"Premium Yellow Jadeite V", 5, 152, 5675, {34, 46, 58, 73, 88}},
    [93452] = {"Premium Yellow Jadeite VI", 6, 152, 8450, {34, 46, 58, 73, 88, 105}},
    [93453] = {"Premium Blue Crystal III", 3, 149, 2950, {34, 46, 58}},
    [93454] = {"Premium Blue Crystal IV", 4, 149, 4175, {34, 46, 58, 73}},
    [93455] = {"Premium Blue Crystal V", 5, 149, 5675, {34, 46, 58, 73, 88}},
    [93456] = {"Premium Blue Crystal VI", 6, 149, 8450, {34, 46, 58, 73, 88, 105}},
    [93457] = {"Premium Ink Jadeite III", 3, 151, 2950, {34, 46, 58}},
    [93458] = {"Premium Ink Jadeite IV", 4, 151, 4175, {34, 46, 58, 73}},
    [93459] = {"Premium Ink Jadeite V", 5, 151, 5675, {34, 46, 58, 73, 88}},
    [93460] = {"Premium Ink Jadeite VI", 6, 151, 8450, {34, 46, 58, 73, 88, 105}},
    [93461] = {"Premium Ruby III", 3, 129, 712, {12, 26, 39}},
    [93462] = {"Premium Ruby IV", 4, 129, 1292, {12, 26, 39, 54}},
    [93463] = {"Premium Ruby V", 5, 129, 1850, {12, 26, 39, 54, 72}},
    [93464] = {"Premium Ruby VI", 6, 129, 2740, {12, 26, 39, 54, 72, 90}},
    [93465] = {"Premium Sapphire III", 3, 130, 712, {12, 26, 39}},
    [93466] = {"Premium Sapphire IV", 4, 130, 1292, {12, 26, 39, 54}},
    [93467] = {"Premium Sapphire V", 5, 130, 1850, {12, 26, 39, 54, 72}},
    [93468] = {"Premium Sapphire VI", 6, 130, 2740, {12, 26, 39, 54, 72, 90}},
    [93469] = {"Premium Rock Crystal III", 3, 50, 267, {71, 86, 102}},
    [93470] = {"Premium Rock Crystal IV", 4, 50, 484, {71, 86, 102, 120}},
    [93471] = {"Premium Rock Crystal V", 5, 50, 694, {71, 86, 102, 120, 139}},
    [93472] = {"Premium Rock Crystal VI", 6, 50, 1028, {71, 86, 102, 120, 139, 160}},
    [93473] = {"Premium Garnet III", 3, 51, 267, {71, 86, 102}},
    [93474] = {"Premium Garnet IV", 4, 51, 484, {71, 86, 102, 120}},
    [93475] = {"Premium Garnet V", 5, 51, 694, {71, 86, 102, 120, 139}},
    [93476] = {"Premium Garnet VI", 6, 51, 1028, {71, 86, 102, 120, 139, 160}},
    [93477] = {"Premium Citrine III", 3, 53, 267, {71, 86, 102}},
    [93478] = {"Premium Citrine IV", 4, 53, 484, {71, 86, 102, 120}},
    [93479] = {"Premium Citrine V", 5, 53, 694, {71, 86, 102, 120, 139}},
    [93480] = {"Premium Citrine VI", 6, 53, 1028, {71, 86, 102, 120, 139, 160}},
    [93481] = {"Premium Amethyst III", 3, 52, 267, {71, 86, 102}},
    [93482] = {"Premium Amethyst IV", 4, 52, 484, {71, 86, 102, 120}},
    [93483] = {"Premium Amethyst V", 5, 52, 694, {71, 86, 102, 120, 139}},
    [93484] = {"Premium Amethyst VI", 6, 52, 1028, {71, 86, 102, 120, 139, 160}},
    [93485] = {"Premium White Agate III", 3, 58, 2950, {71, 86, 102}},
    [93486] = {"Premium White Agate IV", 4, 58, 4175, {71, 86, 102, 120}},
    [93487] = {"Premium White Agate V", 5, 58, 5675, {71, 86, 102, 120, 139}},
    [93488] = {"Premium White Agate VI", 6, 58, 8450, {71, 86, 102, 120, 139, 160}},
    [93489] = {"Premium Red Agate III", 3, 59, 2950, {71, 86, 102}},
    [93490] = {"Premium Red Agarte IV", 4, 59, 4175, {71, 86, 102, 120}},
    [93491] = {"Premium Red Agarte V", 5, 59, 5675, {71, 86, 102, 120, 139}},
    [93492] = {"Premium Red Agarte VI", 6, 59, 8450, {71, 86, 102, 120, 139, 160}},
    [93493] = {"Premium Yellow Agate III", 3, 61, 2950, {71, 86, 102}},
    [93494] = {"Premium Yellow Agate IV", 4, 61, 4175, {71, 86, 102, 120}},
    [93495] = {"Premium Yellow Agate V", 5, 61, 5675, {71, 86, 102, 120, 139}},
    [93496] = {"Premium Yellow Agate VI", 6, 61, 8450, {71, 86, 102, 120, 139, 160}},
    [93497] = {"Premium Green Agate III", 3, 60, 2950, {71, 86, 102}},
    [93498] = {"Premium Green Agate IV", 4, 60, 4175, {71, 86, 102, 120}},
    [93499] = {"Premium Green Agate V", 5, 60, 5675, {71, 86, 102, 120, 139}},
    [93500] = {"Premium Green Agate VI", 6, 60, 8450, {71, 86, 102, 120, 139, 160}},
    [93501] = {"Premium Aventurine III", 3, 145, 628, {45, 60, 77}},
    [93502] = {"Premium Aventurine IV", 4, 145, 1142, {45, 60, 77, 96}},
    [93503] = {"Premium Aventurine V", 5, 145, 1635, {45, 60, 77, 96, 116}},
    [93504] = {"Premium Aventurine VI", 6, 145, 2421, {45, 60, 77, 96, 116, 138}},
    [93505] = {"Premium Blue Coral III", 3, 4, 54, {29, 42, 59}},
    [93506] = {"Premium Blue Coral IV", 4, 4, 99, {29, 42, 59, 75}},
    [93507] = {"Premium Blue Coral V", 5, 4, 142, {29, 42, 59, 75, 95}},
    [93508] = {"Premium Blue Coral VI", 6, 4, 210, {29, 42, 59, 75, 95, 114}},
    [93509] = {"Premium Thorn Coral III", 3, 1, 100, {29, 42, 59}},
    [93510] = {"Premium Thorn Coral IV", 4, 1, 182, {29, 42, 59, 75}},
    [93511] = {"Premium Thorn Coral V", 5, 1, 260, {29, 42, 59, 75, 95}},
    [93512] = {"Premium Thorn Coral VI", 6, 1, 386, {29, 42, 59, 75, 95, 114}},
    [93513] = {"Premium Red Coral III", 3, 2, 99, {29, 42, 59}},
    [93514] = {"Premium Red Coral IV", 4, 2, 180, {29, 42, 59, 75}},
    [93515] = {"Premium Red Coral V", 5, 2, 257, {29, 42, 59, 75, 95}},
    [93516] = {"Premium Red Coral VI", 6, 2, 380, {29, 42, 59, 75, 95, 114}},
    [93517] = {"Premium Horn Coral III", 3, 5, 100, {29, 42, 59}},
    [93518] = {"Premium Horn Coral IV", 4, 5, 182, {29, 42, 59, 75}},
    [93519] = {"Premium Horn Coral V", 5, 5, 260, {29, 42, 59, 75, 95}},
    [93520] = {"Premium Horn Coral VI", 6, 5, 386, {29, 42, 59, 75, 95, 114}},
    [93521] = {"Premium Cave Coral III", 3, 3, 99, {29, 42, 59}},
    [93522] = {"Premium Cave Coral IV", 4, 3, 180, {29, 42, 59, 75}},
    [93523] = {"Premium Cave Coral V", 5, 3, 257, {29, 42, 59, 75, 95}},
    [93524] = {"Premium Cave Coral VI", 6, 3, 380, {29, 42, 59, 75, 95, 114}},
    [93525] = {"Premium White Jade III", 3, 157, 725, {19, 28, 39}},
    [93526] = {"Premium White Jade IV", 4, 157, 1225, {19, 28, 39, 50}},
    [93527] = {"Premium White Jade V", 5, 157, 1950, {19, 28, 39, 50, 63}},
    [93528] = {"Premium White Jade VI", 6, 157, 3250, {19, 28, 39, 50, 63, 76}},
    [93529] = {"Premium Green Jade III", 3, 159, 725, {19, 28, 39}},
    [93530] = {"Premium Green Jade IV", 4, 159, 1225, {19, 28, 39, 50}},
    [93531] = {"Premium Green Jade V", 5, 159, 1950, {19, 28, 39, 50, 63}},
    [93532] = {"Premium Green Jade VI", 6, 159, 3250, {19, 28, 39, 50, 63, 76}},
    [93533] = {"Premium Red Jade III", 3, 158, 725, {19, 28, 39}},
    [93534] = {"Premium Red Jade IV", 4, 158, 1225, {19, 28, 39, 50}},
    [93535] = {"Premium Red Jade V", 5, 158, 1950, {19, 28, 39, 50, 63}},
    [93536] = {"Premium Red Jade VI", 6, 158, 3250, {19, 28, 39, 50, 63, 76}},
    [93537] = {"Premium Yellow Jade III", 3, 160, 725, {19, 28, 39}},
    [93538] = {"Premium Yellow Jade IV", 4, 160, 1225, {19, 28, 39, 50}},
    [93539] = {"Premium Yellow Jade V", 5, 160, 1950, {19, 28, 39, 50, 63}},
    [93540] = {"Premium Yellow Jade VI", 6, 160, 3250, {19, 28, 39, 50, 63, 76}},
    [93541] = {"Premium Rainbow Stone III", 3, 9, 3013, {110, 131, 153}},
    [93542] = {"Premium Rainbow Stone IV", 4, 9, 5466, {110, 131, 153, 177}},
    [93543] = {"Premium Rainbow Stone V", 5, 9, 7824, {110, 131, 153, 177, 204}},
    [93544] = {"Premium Rainbow Stone VI", 6, 9, 11585, {110, 131, 153, 177, 204, 234}},
    [93545] = {"Premium Sunstone III", 3, 30, 707, {110, 131, 153}},
    [93546] = {"Premium Sunstone IV", 4, 30, 1285, {110, 131, 153, 177}},
    [93547] = {"Premium Sunstone V", 5, 30, 1838, {110, 131, 153, 177, 204}},
    [93548] = {"Premium Sunstone VI", 6, 30, 2722, {110, 131, 153, 177, 204, 234}},
    [93549] = {"Premium Amazon Stone III", 3, 10, 1224, {110, 131, 153}},
    [93550] = {"Premium Amazon Stone IV", 4, 10, 2211, {110, 131, 153, 177}},
    [93551] = {"Premium Amazon Stone V", 5, 10, 3160, {110, 131, 153, 177, 204}},
    [93552] = {"Premium Amazon Stone VI", 6, 10, 4680, {110, 131, 153, 177, 204, 234}},
    [93553] = {"Premium Moonstone III", 3, 41, 707, {110, 131, 153}},
    [93554] = {"Premium Moonstone IV", 4, 41, 1285, {110, 131, 153, 177}},
    [93555] = {"Premium Moonstone V", 5, 41, 1838, {110, 131, 153, 177, 204}},
    [93556] = {"Premium Moonstone VI", 6, 41, 2722, {110, 131, 153, 177, 204, 234}},
    [93557] = {"Premium Azurestone III", 3, 146, 209, {45, 60, 77}},
    [93558] = {"Premium Azurestone IV", 4, 146, 380, {45, 60, 77, 96}},
    [93559] = {"Premium Azurestone V", 5, 146, 545, {45, 60, 77, 96, 116}},
    [93560] = {"Premium Azurestone VI", 6, 146, 808, {45, 60, 77, 96, 116, 138}},
    [93561] = {"Premium Black Pearl III", 3, 144, 138, {45, 60, 77}},
    [93562] = {"Premium Black Pearl IV", 4, 144, 251, {45, 60, 77, 96}},
    [93563] = {"Premium Black Pearl V", 5, 144, 359, {45, 60, 77, 96, 116}},
    [93564] = {"Premium Black Pearl VI", 6, 144, 533, {45, 60, 77, 96, 116, 138}},
    [95899] = {"1\188\182\194\204\177\166\202\175", 1, 179, 223, {12}},
    [95900] = {"2\188\182\194\204\177\166\202\175", 2, 179, 558, {12, 26}},
    [95901] = {"3\188\182\194\204\177\166\202\175", 3, 179, 888, {12, 26, 39}},
    [95902] = {"\163\168\211\197\214\202\181\196\163\1693\188\182\194\204\177\166\202\175", 3, 179, 1345, {12, 26, 39}},
    [95903] = {"4\188\182\194\204\177\166\202\175", 4, 179, 1906, {12, 26, 39, 54}},
    [95904] = {"\163\168\211\197\214\202\181\196\163\1694\188\182\194\204\177\166\202\175", 4, 179, 2441, {12, 26, 39, 54}},
    [95905] = {"5\188\182\194\204\177\166\202\175", 5, 179, 3096, {12, 26, 39, 54, 72}},
    [95906] = {"\163\168\211\197\214\202\181\196\163\1695\188\182\194\204\177\166\202\175", 5, 179, 3494, {12, 26, 39, 54, 72}},
    [95907] = {"6\188\182\194\204\177\166\202\175", 6, 179, 3982, {12, 26, 39, 54, 72, 90}},
    [95908] = {"\163\168\211\197\214\202\181\196\163\1696\188\182\194\204\177\166\202\175", 6, 179, 5175, {12, 26, 39, 54, 72, 90}},
    [102555] = {"Thorn Coral I", 1, 1, 17, {19}},
    [102556] = {"Thorn Coral II", 2, 1, 42, {19, 28}},
    [102557] = {"Thorn Coral III", 3, 1, 66, {19, 28, 39}},
    [102558] = {"Thorn Coral IV", 4, 1, 143, {19, 28, 39, 50}},
    [102559] = {"Thorn Coral V", 5, 1, 230, {19, 28, 39, 50, 63}},
    [102560] = {"Thorn Coral VI", 6, 1, 297, {19, 28, 39, 50, 63, 76}},
    [102561] = {"Premium Thorn Coral III", 3, 1, 100, {19, 28, 39}},
    [102562] = {"Premium Thorn Coral IV", 4, 1, 182, {19, 28, 39, 50}},
    [102563] = {"Premium Thorn Coral V", 5, 1, 260, {19, 28, 39, 50, 63}},
    [102564] = {"Horn Coral I", 1, 5, 17, {19}},
    [102565] = {"Horn Coral II", 2, 5, 42, {19, 28}},
    [102566] = {"Horn Coral III", 3, 5, 66, {19, 28, 39}},
    [102567] = {"Horn Coral IV", 4, 5, 143, {19, 28, 39, 50}},
    [102568] = {"Horn Coral V", 5, 5, 230, {19, 28, 39, 50, 63}},
    [102569] = {"Horn Coral VI", 6, 5, 297, {19, 28, 39, 50, 63, 76}},
    [102570] = {"Premium Horn Coral III", 3, 5, 100, {19, 28, 39}},
    [102571] = {"Premium Horn Coral IV", 4, 5, 182, {19, 28, 39, 50}},
    [102572] = {"Premium Horn Coral V", 5, 5, 260, {19, 28, 39, 50, 63}},
}
GC.UNIT = {[1] = 245, [2] = 243, [3] = 243, [4] = 134, [5] = 245, [9] = 7379, [10] = 2980, [30] = 1734, [41] = 1734, [50] = 654.5, [51] = 654.5, [52] = 654.5, [53] = 654.5, [58] = 5337.5, [59] = 5337.5, [60] = 5337.5, [61] = 5337.5, [129] = 1744.5, [130] = 1744.5, [144] = 339, [145] = 1542, [146] = 514, [149] = 5337.5, [150] = 5337.5, [151] = 5337.5, [152] = 5337.5, [157] = 1725, [158] = 1725, [159] = 1725, [160] = 1725, [179] = 3295}

local function gc_check(item, on) pcall(DlgApi.CheckItem, GC.DLG, item, on and true or false) end
local function gc_checked(item) local ok, c = pcall(DlgApi.IsItemChecked, GC.DLG, item); if ok then return c == true end end
local function gc_pos(name)
    local ok, p = pcall(DlgApi.GetDialogProp, name)
    if ok and type(p) == "table" and finite(p.x) and finite(p.y) then return p.x, p.y end
end
local function gc_num(n)
    local s = tostring(math.floor(n + 0.5))
    while true do
        local t, k = s:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        s = t
        if k == 0 then return s end
    end
end
local function gc_range(a, b)
    if a == nil then return "" end
    return a == b and tostring(a) or (a .. "-" .. b)
end
local function gc_span(sec)
    if sec <= 0 then return "now" end
    local d, h, m = math.floor(sec / 86400), math.floor(sec % 86400 / 3600), math.floor(sec % 3600 / 60)
    if d > 0 then return d .. "d " .. h .. "h" end
    if h > 0 then return h .. "h " .. m .. "m" end
    return math.max(m, 1) .. "m"
end

function GC:Set(item, text)
    self.shownText = self.shownText or {}
    if self.shownText[item] ~= text then self.shownText[item] = text; settext(self.DLG, item, text) end
end

---------------------------------------------------------------- settings (GemCleanser.ini next to ClientTweaks.ini)
function GC:Path()
    local p = O:Path()
    local dir = p and p:match("^(.*[\\/])")
    if dir then return dir .. "GemCleanser.ini" end
end

function GC:Load()
    if self.loaded then return end
    self.loaded = true
    for _, c in ipairs(self.CATS) do self.tick[c.key] = c.on == true end
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "rb")
    if not ok or not f then return end
    local okR, text = pcall(f.read, f, "*a"); pcall(f.close, f)
    if not okR or type(text) ~= "string" then return end
    for _, c in ipairs(self.CATS) do
        local v = text:match("\n" .. c.key .. "%s*=%s*(%d)")
        if v then self.tick[c.key] = v ~= "0" end
    end
    local b = tonumber(text:match("budget%s*=%s*(%d+)") or "")
    if b then self.budget = math.max(0, math.min(9999, b)) end
    for kind, n in text:gmatch("keep=([^|\r\n]+)|(%d+)") do self.keep[kind] = math.min(9, tonumber(n)) end
end

function GC:Save()
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local lines = {"[GemCleanser]", "budget=" .. self.budget}
    for _, c in ipairs(self.CATS) do table.insert(lines, c.key .. "=" .. (self.tick[c.key] and "1" or "0")) end
    local kinds = {}
    for kind in pairs(self.keep) do table.insert(kinds, kind) end
    table.sort(kinds)
    for _, kind in ipairs(kinds) do table.insert(lines, "keep=" .. kind .. "|" .. self.keep[kind]) end
    local ok, f = pcall(io.open, path, "wb")
    if not ok or not f then return end
    pcall(f.write, f, table.concat(lines, "\r\n") .. "\r\n")
    pcall(f.close, f)
end

---------------------------------------------------------------- reading the game
local function gc_dword(hex, i)
    local b1, b2, b3, b4 = tonumber(hex:sub(i, i + 1), 16), tonumber(hex:sub(i + 2, i + 3), 16),
        tonumber(hex:sub(i + 4, i + 5), 16), tonumber(hex:sub(i + 6, i + 7), 16)
    if not (b1 and b2 and b3 and b4) then return nil end
    local v = b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
    if v >= 2147483648 then v = v - 4294967296 end
    return v
end

function GC:Category(t)
    for _, c in ipairs(self.CATS) do
        for _, x in ipairs(c.types) do if x == t then return c end end
    end
    return self.CATS[#self.CATS]
end

function GC:GearName(tid)
    local n = self.names[tid]
    if n == nil then
        local ok, nm = pcall(GameApi.GetItemInfo, tid)
        n = (ok and type(nm) == "string" and nm ~= "") and (nm:gsub("%^%x%x%x%x%x%x", "")) or ("Item " .. tid)
        self.names[tid] = n
    end
    return n
end

-- equipped gems with their state; false when the natives are missing
function GC:Read()
    if type(GameApi.GemSockets) ~= "function" or type(GameApi.GemOven) ~= "function" then return false end
    local ok, crystals, stove, nextT, srv, mode, sel, pending, t0, l0, t1, l1, t2, l2, inSlot, inPack, fx =
        pcall(GameApi.GemOven)
    if not ok or not finite(crystals) then return false end
    self.oven = {crystals = crystals, stove = stove, next = nextT, now = srv, mode = mode, sel = sel,
        pending = pending ~= 0, tid = {t0, t1, t2}, lv = {l0, l1, l2}, inSlot = inSlot, inPack = inPack, fx = fx}
    local okS, hex = pcall(GameApi.GemSockets)
    if not okS or type(hex) ~= "string" then return false end
    local socks = {}
    for i = 1, #hex - 55, 56 do
        local pack, slot, h, tid, lv, exp, gear = gc_dword(hex, i), gc_dword(hex, i + 8), gc_dword(hex, i + 16),
            gc_dword(hex, i + 24), gc_dword(hex, i + 32), gc_dword(hex, i + 40), gc_dword(hex, i + 48)
        if slot and tid and tid > 0 then
            local gem = self.GEMS[tid]
            table.insert(socks, {pack = pack, slot = slot, h = h, tid = tid, lv = lv, exp = exp, gear = gear, gem = gem,
                kind = gem and self:Kind(gem[1])})
        end
    end
    self.socks = socks
    return true
end

---------------------------------------------------------------- the plan
function GC:Pct(g, L) return L > 0 and (g[5][L] or 0) or 0 end
function GC:Stat(g, L) return math.floor(g[4] * (100 + self:Pct(g, L)) / 100) end
function GC:MaxLevel(g)
    if not g or g[2] > 9 then return 0 end
    return math.min(g[2], #g[5], 9, math.max(self.oven and self.oven.stove or 0, 0))
end
function GC:Value(g, L) return g[4] * self:Pct(g, L) / 100 / (self.UNIT[g[3]] or g[4]) end

-- the gem kind a "keep at" level belongs to: the name without its level ("Garnet VI" -> "Garnet")
function GC:Kind(name)
    local k = name:gsub("%s+[IVX]+$", ""):gsub("%s+LV%d+$", ""):gsub("%s+%d+$", "")
    return k
end

-- gems with a "keep at" level get exactly that (up to their max) and their upkeep first; the planner shares the rest
-- of the budget among the ticked gems that have no fixed level
function GC:Plan()
    local used = 0
    for _, s in ipairs(self.socks) do
        s.target = 0
        s.max = self:MaxLevel(s.gem)
        local keep = s.kind and self.keep[s.kind]
        s.fixed = keep ~= nil
        s.wanted = s.gem ~= nil and (s.fixed or self.tick[self:Category(s.gem[3]).key] == true)
        if s.fixed then
            s.target = math.min(keep, s.max)
            if s.target > 0 then used = used + self.COST[s.target] end
        end
    end
    self.fixedUpkeep = used
    -- the rest: an exact knapsack over (gem, level) - upkeep COST[level], value Value(level) - so the most gain that
    -- fits, not just the cheapest steps first
    local free, top = {}, 0
    for _, s in ipairs(self.socks) do
        if s.wanted and not s.fixed and s.max > 0 then
            local vals = {}
            for L = 1, s.max do vals[L] = self:Value(s.gem, L) end
            table.insert(free, {s = s, vals = vals})
            top = top + self.COST[s.max]
        end
    end
    local cap = math.min(math.max(0, self.budget - used), top)
    local best, picks = {}, {}
    for c = 0, cap do best[c] = 0 end
    for k, f in ipairs(free) do
        local nb, pick = {}, {}
        for c = 0, cap do
            local bv, bl = best[c], 0
            for L = 1, f.s.max do
                local cost = self.COST[L]
                if cost > c then break end
                local v = best[c - cost] + f.vals[L]
                if v > bv + 1e-9 then bv, bl = v, L end
            end
            nb[c], pick[c] = bv, bl
        end
        best, picks[k] = nb, pick
    end
    local c = cap
    for k = #free, 1, -1 do
        local L = picks[k][c]
        free[k].s.target = L
        if L > 0 then c, used = c - self.COST[L], used + self.COST[L] end
    end
    local crystals, coins, gain = 0, 0, {}
    for _, s in ipairs(self.socks) do
        if s.wanted and s.target > s.lv then
            for L = s.lv + 1, s.target do crystals, coins = crystals + self.COST[L], coins + self.COINS end
            local t = s.gem[3]
            gain[t] = (gain[t] or 0) + self:Stat(s.gem, s.target) - self:Stat(s.gem, s.lv)
        end
    end
    self.upkeep, self.needCrystals, self.needCoins, self.gain = used, crystals, coins, gain
end

-- cost of Clean now (server: COST[L] - int(time left x COST[L] / 30 days))
function GC:CleanCost(s)
    local left = s.exp - (self.oven.now or 0)
    if s.lv <= 0 or left <= 0 then return nil end
    local c = self.COST[s.lv]
    return math.max(0, c - math.floor(left * c / self.SPAN))
end

-- gems that expire within 5 days come first: an upgrade when it is planned and affordable (it restarts the 30 days
-- too), else a Clean; then the other upgrades, most gain per crystal first
function GC:Actions()
    local list = {}
    local have = self.oven and self.oven.crystals or 0
    for _, s in ipairs(self.socks) do
        local left = s.exp - (self.oven.now or 0)
        local urgent = s.wanted and s.lv > 0 and s.target >= s.lv and left < self.REFRESH
        if s.wanted and s.target > s.lv and s.lv < s.max then
            local L = s.lv + 1
            local score = (self:Value(s.gem, L) - self:Value(s.gem, s.lv)) / self.COST[L]
            local key = (urgent and self.COST[L] <= have) and (-1e9 + left) or -score
            table.insert(list, {sock = s, kind = "up", level = L, cost = self.COST[L], key = key})
            if key < -1e8 then urgent = false end
        end
        local cost = urgent and self:CleanCost(s)
        if cost then table.insert(list, {sock = s, kind = "clean", cost = cost, key = -1e9 + left}) end
    end
    table.sort(list, function(a, b) return a.key < b.key end)
    return list
end

-- what (one line) and the gain / cost (second line)
function GC:Describe(a)
    local s = a.sock
    if a.kind == "clean" then
        return string.format("Clean %s (%s, socket %d), level %d", s.gem[1], self:GearName(s.gear), s.h + 1, s.lv),
            string.format("keeps level %d for 30 more days (%s left now)  |  costs %d crystals", s.lv,
                gc_span(s.exp - (self.oven.now or 0)), a.cost)
    end
    return string.format("Cleanse %s (%s, socket %d) to level %d", s.gem[1], self:GearName(s.gear), s.h + 1, a.level),
        string.format("%s %+d  |  costs %d crystals + %s (Notes first, then Coins)", self.SHORT[s.gem[3]] or "",
            self:Stat(s.gem, a.level) - self:Stat(s.gem, s.lv), a.cost, gc_num(self.COINS))
end

---------------------------------------------------------------- window
function GC:Dock()
    local anchor = shown(self.MAIN) and self.MAIN or self.HOST
    pcall(DlgApi.SetDialogPosition, self.DLG, 0, 0, anchor, AUIDIALOG_ALIGN_OUTSIDE, AUIDIALOG_ALIGN_LEFT,
        AUIDIALOG_ALIGN_INSIDE, AUIDIALOG_ALIGN_TOP)
    self.anchorX, self.anchorY = gc_pos(anchor)
end

function GC:PaintTicks()
    for i, c in ipairs(self.CATS) do gc_check("Chk_Cat" .. i, self.tick[c.key]) end
    gc_check("Chk_NotesFirst", true)                        -- the game always takes Notes first for cleansing
    pcall(DlgApi.EnableItem, self.DLG, "Chk_NotesFirst", false)
    settext(self.DLG, "Edt_Budget", tostring(self.budget))
    self.shownBudget = tostring(self.budget)
end

function GC:ReadControls()
    local changed = false
    for i, c in ipairs(self.CATS) do
        local v = gc_checked("Chk_Cat" .. i)
        if v ~= nil and v ~= self.tick[c.key] then self.tick[c.key], changed = v, true end
    end
    local ok, txt = pcall(DlgApi.GetItemText, self.DLG, "Edt_Budget")
    if ok and type(txt) == "string" and txt ~= self.shownBudget then
        local n = tonumber(txt)
        if n then
            n = math.max(0, math.min(9999, math.floor(n)))
            if n ~= self.budget then self.budget, changed = n, true end
        end
        self.shownBudget = txt
    end
    if changed then self:Save() end
end

-- the gem kinds over all the gear: count, levels now / planned, the max any of them can reach, levels still to
-- cleanse, the earliest expiry of a kept level (dueLeft) and whether one is due for a Clean (urgent)
function GC:Kinds()
    local list, by = {}, {}
    local now = self.oven and self.oven.now or 0
    for _, s in ipairs(self.socks) do
        local k = s.kind or ("Gem " .. s.tid)
        local e = by[k]
        if not e then
            e = {kind = k, gem = s.gem, n = 0, top = 0, steps = 0, wanted = false, drop = false, urgent = false,
                fixed = self.keep[k] ~= nil}
            by[k] = e
            table.insert(list, e)
        end
        e.n = e.n + 1
        e.top = math.max(e.top, s.max or 0)
        e.lvMin, e.lvMax = math.min(e.lvMin or s.lv, s.lv), math.max(e.lvMax or s.lv, s.lv)
        if s.wanted then
            e.wanted = true
            e.tMin, e.tMax = math.min(e.tMin or s.target, s.target), math.max(e.tMax or s.target, s.target)
            if s.target > s.lv then e.steps = e.steps + s.target - s.lv end
            if s.target < s.lv then e.drop = true end
            if s.lv > 0 and s.target >= s.lv then
                local left = s.exp - now
                if not e.dueLeft or left < e.dueLeft then e.dueLeft = left end
                if left < self.REFRESH then e.urgent = true end
            end
        end
    end
    table.sort(list, function(a, b)
        if a.wanted ~= b.wanted then return a.wanted end
        return a.kind < b.kind
    end)
    return list
end

function GC:Paint()
    local o = self.oven
    local cap = self.CAP[o.stove] or 0
    local nextIn = (o.next or 0) - (o.now or 0)
    local line = string.format("Crystals %d / %d", o.crystals, cap)
    if o.stove <= 0 then
        line = line .. "  |  the stove makes none yet"
    elseif o.crystals >= cap then
        line = line .. "  |  FULL: none are made until you spend some"
    else
        line = line .. "  |  next in " .. gc_span(nextIn) .. " (+12 a day)"
    end
    line = line .. string.format("  |  Stove %d: cleanse up to level %d", o.stove, math.min(o.stove, 9))
    self:Set("Txt_Crystals", line)
    self:Set("Txt_Plan", string.format("Plan upkeep %d / %d crystals per 30 days%s  |  to finish: %d crystals + %s (Notes first)",
        self.upkeep, self.budget, self.upkeep > self.budget and " (kept levels: over budget)" or "", self.needCrystals,
        gc_num(self.needCoins)))
    local parts = {}
    for t, v in pairs(self.gain) do if v ~= 0 then table.insert(parts, {t, v}) end end
    table.sort(parts, function(a, b) return a[1] < b[1] end)
    local g = {}
    for _, p in ipairs(parts) do table.insert(g, (self.SHORT[p[1]] or "?") .. " " .. string.format("%+d", p[2])) end
    self:Set("Txt_Gain", #g > 0 and ("Plan gain: " .. table.concat(g, "   ")) or
        (#self.socks == 0 and "No gems on your equipped gear." or "Plan gain: nothing more for the ticked gems."))
    -- rows: one per gem kind over all the gear, ticked / kept kinds first
    local rows = self:Kinds()
    local pages = math.max(1, math.ceil(#rows / self.ROWS))
    if self.page > pages then self.page = pages end
    self:Set("Txt_Page", self.page .. " / " .. pages)
    self.rowKinds = {}
    for i = 1, self.ROWS do
        local e = rows[(self.page - 1) * self.ROWS + i]
        local name, stat, now, keep, plan, act = "", "", "", "", "", ""
        local adjustable = e ~= nil and e.top > 0
        self.rowKinds[i] = adjustable and e.kind or nil
        for _, b in ipairs({"Btn_Dn", "Btn_Up", "Btn_Au"}) do pcall(DlgApi.ShowItem, self.DLG, b .. i, adjustable) end
        if e then
            name = e.kind .. (e.n > 1 and ("  x" .. e.n) or "")
            stat = e.gem and (self.SHORT[e.gem[3]] or "") or ""
            now = gc_range(e.lvMin, e.lvMax)
            if not e.gem then
                act = "cannot cleanse"
            elseif e.top <= 0 then
                act = e.gem[2] > 9 and "lv 10: no cleanse" or "stove too low"
            else
                keep = e.fixed and (self.keep[e.kind] .. "*") or "auto"
                plan = e.wanted and (gc_range(e.tMin, e.tMax) .. " (" .. e.top .. ")") or ("- (" .. e.top .. ")")
                local due = e.dueLeft and gc_span(e.dueLeft)
                if e.steps > 0 then
                    act = "+" .. e.steps .. (e.steps == 1 and " level" or " levels") .. (e.urgent and (", " .. due) or "")
                elseif e.fixed and self.keep[e.kind] == 0 then
                    act = e.lvMax > 0 and "let drop" or "kept at 0"
                elseif not e.wanted then
                    act = "not ticked"
                elseif e.drop then
                    act = "let drop"
                elseif e.urgent then
                    act = "clean, " .. due
                elseif e.lvMax > 0 then
                    act = "ok, " .. (due or "")
                else
                    act = "over budget"
                end
            end
        end
        self:Set("Txt_N" .. i, name); self:Set("Txt_S" .. i, stat); self:Set("Txt_L" .. i, now)
        self:Set("Txt_K" .. i, keep); self:Set("Txt_P" .. i, plan); self:Set("Txt_A" .. i, act)
    end
    local acts = self:Actions()
    self.actions = acts
    local first = acts[1]
    local what, detail = "nothing to do - every ticked gem is at its planned level.", ""
    if first then what, detail = self:Describe(first) end
    self:Set("Txt_Next", "Next: " .. what)
    self:Set("Txt_Next2", detail)
    pcall(DlgApi.EnableItem, self.DLG, "Btn_DoNext", first ~= nil and not self.run)
    self:Set("Btn_Auto", self.run and self.run.auto and "Stop" or "Auto")
end

function GC:Status(text) self:Set("Txt_Status", text or "") end

function GC:Refresh()
    if not self:Read() then
        self:Status("The Gem Cleanser needs the updated xajh.exe (GameApi.GemSockets).")
        return false
    end
    self:Plan()
    self:Paint()
    return true
end

---------------------------------------------------------------- doing it
function GC:Sock(pack, slot, h)
    for _, s in ipairs(self.socks) do if s.pack == pack and s.slot == slot and s.h == h then return s end end
end

-- the "keep at" buttons of row i (a gem kind): -1 / +1 from the level shown (kept, else the highest planned), capped
-- at the highest level any gem of the kind can reach; "A" hands the kind back to the planner
function GC:KeepStep(i, d)
    local kind = self.rowKinds and self.rowKinds[i]
    if not kind then return end
    local top, planned = 0, 0
    for _, s in ipairs(self.socks) do
        if s.kind == kind then
            top = math.max(top, s.max or 0)
            planned = math.max(planned, s.wanted and s.target or s.lv)
        end
    end
    local now = self.keep[kind] or planned
    self.keep[kind] = math.max(0, math.min(top, now + d))
    self:Save()
    if shown(self.DLG) then self:Refresh() end
end

function GC:KeepAuto(i)
    local kind = self.rowKinds and self.rowKinds[i]
    if not kind or self.keep[kind] == nil then return end
    self.keep[kind] = nil
    self:Save()
    if shown(self.DLG) then self:Refresh() end
end

-- the dialog shows this gear: its pack / slot (two pieces can carry identical gems), and its sockets show the gear's
-- current gems
function GC:DialogHolds(pack, slot)
    local o = self.oven
    if o.mode ~= 2 then return false end
    if finite(o.inSlot) and (o.inSlot ~= slot or o.inPack ~= pack) then return false end
    for h = 0, 2 do
        local s = self:Sock(pack, slot, h)
        local want = s and s.tid or 0
        if (o.tid[h + 1] or 0) ~= want then return false end
        if s and (o.lv[h + 1] or 0) ~= s.lv then return false end
    end
    return true
end

function GC:Start(auto)
    if self.run then return end
    self:Refresh()
    local a = self:Pick()
    if not a then self:Status(auto and "Nothing to do that your crystals can pay for." or "Nothing to do."); return end
    self.run = {auto = auto, count = 0}
    self:Begin(a, 0)
end

-- the first action the crystals can pay for
function GC:Pick()
    for _, a in ipairs(self:Actions()) do
        if a.cost <= (self.oven and self.oven.crystals or 0) then return a end
    end
end

function GC:Begin(a, now)
    local r = self.run
    r.act, r.phase, r.t, r.tries, r.retries = a, "put", now, 0, 0
    r.pack, r.slot, r.h, r.lv0, r.exp0 = a.sock.pack, a.sock.slot, a.sock.h, a.sock.lv, a.sock.exp
    self:Status((r.auto and "Auto: " or "") .. (self:Describe(a)))
end

function GC:Stop(msg)
    self.run = nil
    if msg then self:Status(msg) end
    if shown(self.DLG) then self:Refresh() end
end

function GC:Step(now)
    local r = self.run
    if not shown(self.HOST) then self:Stop("Stopped: the Gem Cleansing page was closed."); return end
    if not self:Read() then self:Stop("Stopped: could not read the gems."); return end
    local a = r.act
    if r.phase == "put" then
        if self:DialogHolds(r.pack, r.slot) then r.phase, r.tries = "select", 0; return end
        if now - r.t < 400 and r.tries > 0 then return end
        if r.tries >= 3 then self:Stop("Stopped: the gear did not go into the Gem Cleansing window."); return end
        pcall(GameApi.GemPurifyPut, r.pack, r.slot)
        r.tries, r.t = r.tries + 1, now
    elseif r.phase == "select" then
        local ok, v = pcall(GameApi.GemPurifySelect, r.h)
        if not ok or v ~= 1 then self:Stop("Stopped: could not pick socket " .. (r.h + 1) .. "."); return end
        r.phase, r.t = "press", now
    elseif r.phase == "press" then
        if a.cost > self.oven.crystals then self:Stop("Stopped: not enough crystals."); return end
        -- the game sends a press only after the effect of the last cleanse has stopped, and drops it 1 s after the
        -- press if the effect still plays - so wait for it first
        if finite(self.oven.fx) and self.oven.fx > 0 then
            if now - r.t > 10000 then self:Stop("Stopped: the Gem Cleansing effect did not finish.") end
            return
        end
        local kind = a.kind == "up" and 0 or (r.auto and 2 or 1)
        local ok, v = pcall(GameApi.GemPurifyPress, kind)
        if ok and v == 1 then
            r.phase, r.t, r.kind, r.sent, r.idle = "wait", now, kind, false, nil
        elseif now - r.t > 3000 then
            self:Stop("Stopped: the Gem Cleansing window stayed busy.")
        end
    elseif r.phase == "wait" then
        local s = self:Sock(r.pack, r.slot, r.h)
        local done = s and ((a.kind == "up" and s.lv == a.level) or (a.kind == "clean" and s.exp > r.exp0))
        local o = self.oven
        -- sending starts the effect; no effect, no pending request and no change = the game dropped the press (or
        -- refused it with a message): press again, at most 3 times
        if finite(o.fx) and o.fx > 0 then r.sent = true end
        local dropped = not done and not r.sent and r.kind ~= 1 and finite(o.fx) and o.fx == 0 and not o.pending
        if dropped then r.idle = r.idle or now else r.idle = nil end
        if dropped and now - r.idle > 1500 then
            r.retries = (r.retries or 0) + 1
            if r.retries > 3 then
                self:Stop("Stopped: the game did not take the press 3 times (see its message?).")
                return
            end
            r.phase, r.t = "select", now
            return
        end
        if done then
            r.count = r.count + 1
            self:Plan()
            if not r.auto then self:Stop("Done: " .. (self:Describe(a))); return end
            r.phase, r.t = "gap", now
        elseif now - r.t > (r.kind == 1 and 30000 or 6000) then
            self:Stop(r.kind == 1 and "Clean was not confirmed." or
                "Stopped: nothing changed (not enough crystals or coins?).")
        end
    elseif r.phase == "gap" then
        if now - r.t < 400 then return end
        self:Plan()
        local nxt = self:Pick()
        if not nxt then
            self:Stop(string.format("Auto finished: %d done. %s", r.count,
                #self:Actions() > 0 and "Waiting for more crystals." or "Every ticked gem is at its planned level."))
            return
        end
        self:Begin(nxt, now)
    end
end

function GC:DoNext() if self.run then return end; self:Start(false) end
function GC:Auto() if self.run then self:Stop("Stopped.") else self:Start(true) end end
function GC:PageBy(d) self.page = math.max(1, self.page + d); if shown(self.DLG) then self:Refresh() end end
function GC:Close() if self.run then self:Stop("Stopped.") end; self.userClosed = true; show(self.DLG, false) end

function GC:Tick(now)
    local open = shown(self.HOST)
    if not open then
        if self.run then self:Stop("Stopped: the Gem Cleansing page was closed.") end
        if self.hostOpen then
            self.hostOpen, self.userClosed = false, false
            if shown(self.DLG) then show(self.DLG, false) end
        end
        return
    end
    self:Load()
    if not self.hostOpen then
        self.hostOpen = true
        if self.userClosed then return end
        show(self.DLG, true)
        self.shownText = {}
        self:Dock()
        self:PaintTicks()
        self:Refresh()
        return
    end
    if not shown(self.DLG) then return end
    local ax, ay = gc_pos(shown(self.MAIN) and self.MAIN or self.HOST)
    if ax and (ax ~= self.anchorX or ay ~= self.anchorY) then self:Dock() end
    if self.run then
        if now >= self.nextRead then self.nextRead = now + 150; self:Step(now) end
        return
    end
    if now < self.nextRead then return end
    self.nextRead = now + 500
    self:ReadControls()
    self:Refresh()
end

---------------------------------------------------------------- Multi Disassembly
-- Win_GearSplit docks to the left of the Equipment Service window while its Disassemble page (Win_EquipServ_Seperate)
-- is open. It lists every piece of gear in the bag (packs 2-4) that the game would accept for disassembly
-- (GameApi.GearScan: the page's own controller check + the gear's EQUIP_DECOMPOSE_CONFIG: charm, coins, reward).
-- Tick the gear, Disassemble (twice: the second click confirms), and it does them one by one with the page itself:
-- GearPut(gear) -> GearPut(a Disassembly Charm stack with enough charms: for bound gear bound charms first, for unbound
-- gear unbound charms first, only the kinds that are ticked) -> GearPress (the game's Disassemble, without its "will be
-- bound" box) -> waits until the gear has left the bag. Stops when charms run out, the game refuses (coins), the
-- server does not answer for 15 s, the page is closed or Stop is pressed.
local GS = {DLG = "Win_GearSplit", HOST = "Win_EquipServ_Seperate", MAIN = "Win_EquipServ_Main",
    PACKS = {2, 3, 4}, ROWS = 12, WAIT = 15000, GAP = 500, CONFIRM = 4000,
    useUnbound = true, useBound = true, pick = {}, page = 1, nextRead = 0, names = {}}
U.GearSplit = GS

local function gs_checked(item) local ok, c = pcall(DlgApi.IsItemChecked, GS.DLG, item); if ok then return c == true end end
local function gs_pos(name)
    local ok, p = pcall(DlgApi.GetDialogProp, name)
    if ok and type(p) == "table" and finite(p.x) and finite(p.y) then return p.x, p.y end
end
local function gs_num(n)
    local s = tostring(math.floor(n + 0.5))
    while true do
        local t, k = s:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        s = t
        if k == 0 then return s end
    end
end
local function gs_dword(hex, i)
    local b1, b2, b3, b4 = tonumber(hex:sub(i, i + 1), 16), tonumber(hex:sub(i + 2, i + 3), 16),
        tonumber(hex:sub(i + 4, i + 5), 16), tonumber(hex:sub(i + 6, i + 7), 16)
    if not (b1 and b2 and b3 and b4) then return nil end
    return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
end
-- IEEE single from its 32 bits
local function gs_float(u)
    if not u or u == 0 then return 0 end
    local sign = u >= 2147483648 and -1 or 1
    local e = math.floor(u / 8388608) % 256
    local m = u % 8388608
    if e == 0 then return sign * m * 2 ^ -149 end
    return sign * (1 + m / 8388608) * 2 ^ (e - 127)
end

function GS:Set(item, text)
    self.shownText = self.shownText or {}
    if self.shownText[item] ~= text then self.shownText[item] = text; settext(self.DLG, item, text) end
end
function GS:Status(text) self:Set("Txt_Status", text or "") end

function GS:Name(tid)
    local n = self.names[tid]
    if n == nil then
        local ok, nm = pcall(GameApi.GetItemInfo, tid)
        n = (ok and type(nm) == "string" and nm ~= "") and (nm:gsub("%^%x%x%x%x%x%x", "")) or ("Item " .. tid)
        self.names[tid] = n
    end
    return n
end

---------------------------------------------------------------- settings (GearSplit.ini next to ClientTweaks.ini)
function GS:Path()
    local p = O:Path()
    local dir = p and p:match("^(.*[\\/])")
    if dir then return dir .. "GearSplit.ini" end
end

function GS:Load()
    if self.loaded then return end
    self.loaded = true
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "rb")
    if not ok or not f then return end
    local okR, text = pcall(f.read, f, "*a"); pcall(f.close, f)
    if not okR or type(text) ~= "string" then return end
    local u, b = text:match("unbound%s*=%s*(%d)"), text:match("\nbound%s*=%s*(%d)")
    if u then self.useUnbound = u ~= "0" end
    if b then self.useBound = b ~= "0" end
end

function GS:Save()
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "wb")
    if not ok or not f then return end
    pcall(f.write, f, "[GearSplit]\r\nunbound=" .. (self.useUnbound and "1" or "0") .. "\r\nbound=" ..
        (self.useBound and "1" or "0") .. "\r\n")
    pcall(f.close, f)
end

---------------------------------------------------------------- reading the bag
function GS:Read()
    if type(GameApi.GearScan) ~= "function" then return false end
    local items = {}
    for _, pack in ipairs(self.PACKS) do
        local ok, hex = pcall(GameApi.GearScan, pack)
        if ok and type(hex) == "string" then
            for i = 1, #hex - 95, 96 do
                local d = {}
                for k = 0, 11 do d[k] = gs_dword(hex, i + k * 8) end
                if d[0] and d[1] and d[1] > 0 then
                    local bound = d[3] % 2 == 1
                    -- the server's currency (gs EquipDecompose): recipe type 1 Notes, 2 Coins, 0 by the gear's binding
                    local notes = d[6] == 1 or (d[6] == 0 and bound)
                    table.insert(items, {pack = pack, slot = d[0], tid = d[1], count = d[2], bound = bound,
                        can = math.floor(d[3] / 2) % 2 == 1, charm = d[4], need = d[5], coinType = d[6], coins = d[7],
                        notes = notes, reward = d[8], chance = gs_float(d[9]), rewardCoins = d[10],
                        key = pack .. ":" .. d[0] .. ":" .. d[1]})
                end
            end
        end
    end
    self.items = items
    local gear = {}
    for _, it in ipairs(items) do if it.can then table.insert(gear, it) end end
    self.gear = gear
    return true
end

-- charm stacks of tid in the bag: unbound and bound totals
function GS:CharmTotals(tid)
    local u, b = 0, 0
    for _, it in ipairs(self.items) do
        if it.tid == tid then if it.bound then b = b + it.count else u = u + it.count end end
    end
    return u, b
end

-- a stack with at least need charms of tid, in the order the gear wants (bound gear: bound first)
function GS:PickCharm(g)
    local order = g.bound and {true, false} or {false, true}
    for _, wantBound in ipairs(order) do
        if (wantBound and self.useBound) or (not wantBound and self.useUnbound) then
            local best
            for _, it in ipairs(self.items) do
                if it.tid == g.charm and it.bound == wantBound and it.count >= g.need and
                    (not best or it.count < best.count) then best = it end
            end
            if best then return best end
        end
    end
end

function GS:Selected()
    local list = {}
    for _, g in ipairs(self.gear) do if self.pick[g.key] then table.insert(list, g) end end
    return list
end

---------------------------------------------------------------- window
function GS:Dock()
    local anchor = shown(self.MAIN) and self.MAIN or self.HOST
    pcall(DlgApi.SetDialogPosition, self.DLG, 0, 0, anchor, AUIDIALOG_ALIGN_OUTSIDE, AUIDIALOG_ALIGN_LEFT,
        AUIDIALOG_ALIGN_INSIDE, AUIDIALOG_ALIGN_TOP)
    self.anchorX, self.anchorY = gs_pos(anchor)
end

function GS:PageRows()
    local first = (self.page - 1) * self.ROWS
    local rows = {}
    for i = 1, self.ROWS do rows[i] = self.gear[first + i] end
    return rows
end

-- row ticks -> pick (only for the rows that were painted with that gear)
function GS:ReadControls()
    if self.rowKeys then
        for i = 1, self.ROWS do
            local key = self.rowKeys[i]
            if key then
                local c = gs_checked("Chk_R" .. i)
                if c ~= nil then self.pick[key] = c or nil end
            end
        end
    end
    local changed = false
    local u, b = gs_checked("Chk_Unbound"), gs_checked("Chk_Bound")
    if u ~= nil and u ~= self.useUnbound then self.useUnbound, changed = u, true end
    if b ~= nil and b ~= self.useBound then self.useBound, changed = b, true end
    if changed then self:Save() end
end

function GS:Paint()
    local pages = math.max(1, math.ceil(#self.gear / self.ROWS))
    if self.page > pages then self.page = pages end
    self:Set("Txt_Page", self.page .. " / " .. pages)
    -- forget picks of gear that is gone
    local present = {}
    for _, g in ipairs(self.gear) do present[g.key] = true end
    for k in pairs(self.pick) do if not present[k] then self.pick[k] = nil end end
    local rows = self:PageRows()
    self.rowKeys = {}
    for i = 1, self.ROWS do
        local g = rows[i]
        local on = g ~= nil
        pcall(DlgApi.ShowItem, self.DLG, "Chk_R" .. i, on)
        if g then
            self.rowKeys[i] = g.key
            local name = self:Name(g.tid)
            if #name > 30 then name = name:sub(1, 29) .. "." end
            self:Set("Chk_R" .. i, name)
            pcall(DlgApi.CheckItem, self.DLG, "Chk_R" .. i, self.pick[g.key] == true)
            self:Set("Txt_B" .. i, g.bound and "bound" or "")
            self:Set("Txt_C" .. i, g.charm > 0 and (g.need .. " x charm") or "-")
            self:Set("Txt_W" .. i, gs_num(g.coins) .. (g.notes and " Notes" or " Coins"))
            local give = g.reward > 0 and string.format("%s %d%%", self:Name(g.reward), math.floor(g.chance * 100 + 0.5)) or ""
            if g.rewardCoins > 0 then give = give .. (give ~= "" and " + " or "") .. gs_num(g.rewardCoins) .. " coins" end
            if #give > 34 then give = give:sub(1, 33) .. "." end
            self:Set("Txt_G" .. i, give)
        else
            for _, k in ipairs({"Txt_B", "Txt_C", "Txt_W", "Txt_G"}) do self:Set(k .. i, "") end
        end
    end
    local sel = self:Selected()
    self:Set("Txt_Info", #self.gear == 0 and "No gear in your bag can be disassembled here." or
        string.format("%d gear in your bag can be disassembled here.  %d ticked.", #self.gear, #sel))
    -- charms and coins for the ticked gear
    local need, notes, coins = {}, 0, 0
    for _, g in ipairs(sel) do
        if g.charm > 0 then need[g.charm] = (need[g.charm] or 0) + g.need end
        if g.notes then notes = notes + g.coins else coins = coins + g.coins end
    end
    local parts = {}
    for tid, n in pairs(need) do
        local u, b = self:CharmTotals(tid)
        table.insert(parts, string.format("%s: need %d, in bag %d unbound + %d bound", self:Name(tid), n, u, b))
    end
    if #parts == 0 then
        local u, b, any = 0, 0, nil
        for _, g in ipairs(self.gear) do if g.charm > 0 then any = g.charm; break end end
        if any then u, b = self:CharmTotals(any) end
        parts[1] = any and string.format("%s in bag: %d unbound + %d bound", self:Name(any), u, b) or ""
    end
    self:Set("Txt_Charms", table.concat(parts, "   "))
    self:Set("Txt_Cost", #sel > 0 and string.format("Cost of the ticked gear: %s Notes + %s Coins  "
        .. "(the server takes Notes for bound gear, Coins for unbound)", gs_num(notes), gs_num(coins)) or "")
    if not self.run then
        local armed = self.armedAt and (self.now or 0) - self.armedAt < self.CONFIRM
        self:Set("Btn_Start", armed and "Click to confirm" or ("Disassemble " .. #sel))
        pcall(DlgApi.EnableItem, self.DLG, "Btn_Start", #sel > 0)
    else
        self:Set("Btn_Start", "Working...")
        pcall(DlgApi.EnableItem, self.DLG, "Btn_Start", false)
    end
end

function GS:PaintTicks()
    pcall(DlgApi.CheckItem, self.DLG, "Chk_Unbound", self.useUnbound)
    pcall(DlgApi.CheckItem, self.DLG, "Chk_Bound", self.useBound)
    -- disassembly cannot pay Notes first: the server takes Notes for bound gear and Coins for unbound gear
    pcall(DlgApi.CheckItem, self.DLG, "Chk_NotesFirst", false)
    pcall(DlgApi.EnableItem, self.DLG, "Chk_NotesFirst", false)
end

function GS:Refresh()
    if not self:Read() then
        self:Status("Multi Disassembly needs the updated xajh.exe (GameApi.GearScan).")
        return false
    end
    self:Paint()
    return true
end

function GS:SelectAll(on)
    for _, g in ipairs(self.gear or {}) do self.pick[g.key] = on or nil end
    self.armedAt = nil
    if shown(self.DLG) then self:Paint() end
end

function GS:PageBy(d)
    self:ReadControls()
    self.page = math.max(1, self.page + d)
    if shown(self.DLG) then self:Paint() end
end

---------------------------------------------------------------- doing it
function GS:StartClick()
    if self.run then return end
    self:ReadControls()
    self:Refresh()
    local sel = self:Selected()
    if #sel == 0 then self:Status("Tick the gear to disassemble first."); return end
    local now = self.now or 0
    if not self.armedAt or now - self.armedAt > self.CONFIRM then
        self.armedAt = now
        self:Status(string.format("Disassembling destroys the %d ticked gear. Click again to start.", #sel))
        self:Paint()
        return
    end
    self.armedAt = nil
    local queue = {}
    for _, g in ipairs(sel) do table.insert(queue, {pack = g.pack, slot = g.slot, tid = g.tid}) end
    self.run = {queue = queue, i = 0, done = 0, total = #queue}
    self:Next(now)
end

function GS:Find(q)
    for _, g in ipairs(self.gear) do
        if g.pack == q.pack and g.slot == q.slot and g.tid == q.tid then return g end
    end
end

function GS:Next(now)
    local r = self.run
    r.i = r.i + 1
    local q = r.queue[r.i]
    if not q then self:Stop(string.format("Done: %d of %d disassembled.", r.done, r.total)); return end
    self:Read()
    local g = self:Find(q)
    if not g then r.skipped = (r.skipped or 0) + 1; return self:Next(now) end
    r.g, r.phase, r.t, r.tries = g, "put", now, 0
    self:Status(string.format("%d / %d: %s", r.i, r.total, self:Name(g.tid)))
end

function GS:Stop(msg)
    self.run = nil
    if msg then self:Status(msg) end
    if shown(self.DLG) then self:Refresh() end
end

local function gs_state()
    if type(GameApi.GearState) ~= "function" then return nil end
    local ok, gp, gsl, mf, mp, ms, mc = pcall(GameApi.GearState)
    if ok and finite(gp) then return {gp = gp, gs = gsl, mf = mf, mp = mp, ms = ms, mc = mc} end
end

function GS:Step(now)
    local r = self.run
    if not shown(self.HOST) then self:Stop("Stopped: the Disassemble page was closed."); return end
    local g = r.g
    if r.phase == "put" then
        local s = gs_state()
        if s and s.gp == g.pack and s.gs == g.slot then r.phase, r.tries, r.t = "charm", 0, now; return end
        if r.tries > 0 and now - r.t < 300 then return end
        if r.tries >= 3 then self:Stop("Stopped: " .. self:Name(g.tid) .. " did not go into the Disassemble window."); return end
        pcall(GameApi.GearPut, g.pack, g.slot)
        r.tries, r.t = r.tries + 1, now
    elseif r.phase == "charm" then
        if g.charm <= 0 or g.need <= 0 then r.phase = "press"; return end
        local s = gs_state()
        if s and s.mf == 1 and r.charm and s.mp == r.charm.pack and s.ms == r.charm.slot then
            r.phase = "press"; return
        end
        if r.tries > 0 and now - r.t < 300 then return end
        if r.tries >= 3 then self:Stop("Stopped: the Disassembly Charm did not go into the window."); return end
        self:Read()
        local c = self:PickCharm(g)
        if not c then
            local u, b = self:CharmTotals(g.charm)
            local kinds = (self.useUnbound and self.useBound) and "" or (self.useUnbound and " unbound" or " bound")
            self:Stop(string.format("Stopped after %d: no stack of %d%s %s left (bag: %d unbound, %d bound).",
                r.done, g.need, kinds, self:Name(g.charm), u, b))
            return
        end
        r.charm = c
        pcall(GameApi.GearPut, c.pack, c.slot)
        r.tries, r.t = r.tries + 1, now
    elseif r.phase == "press" then
        local ok, v = pcall(GameApi.GearPress)
        if not ok or v ~= 1 then self:Stop("Stopped: the Disassemble window is gone."); return end
        local s = gs_state()
        if s and s.gp == g.pack and s.gs == g.slot then
            self:Stop(string.format("Stopped: the game did not disassemble %s (%s %s needed?).", self:Name(g.tid),
                gs_num(g.coins), g.notes and "Notes" or "Coins"))
            return
        end
        r.phase, r.t = "wait", now
    elseif r.phase == "wait" then
        local ok, tid = pcall(GameApi.AltOpenItem, g.pack, g.slot)
        if ok and finite(tid) and tid ~= g.tid then
            r.done = r.done + 1
            r.phase, r.t = "gap", now
        elseif now - r.t > self.WAIT then
            self:Stop(string.format("Stopped after %d: no answer from the server for %s.", r.done, self:Name(g.tid)))
        end
    elseif r.phase == "gap" then
        if now - r.t >= self.GAP then self:Next(now) end
    end
end

function GS:Close() if self.run then self:Stop("Stopped.") end; self.userClosed = true; show(self.DLG, false) end

function GS:Tick(now)
    self.now = now
    local open = shown(self.HOST)
    if not open then
        if self.run then self:Stop("Stopped: the Disassemble page was closed.") end
        if self.hostOpen then
            self.hostOpen, self.userClosed = false, false
            if shown(self.DLG) then show(self.DLG, false) end
        end
        return
    end
    self:Load()
    if not self.hostOpen then
        self.hostOpen = true
        if self.userClosed then return end
        show(self.DLG, true)
        self.shownText, self.rowKeys = {}, nil
        self:Dock()
        self:PaintTicks()
        self:Refresh()
        return
    end
    if not shown(self.DLG) then return end
    local ax, ay = gs_pos(shown(self.MAIN) and self.MAIN or self.HOST)
    if ax and (ax ~= self.anchorX or ay ~= self.anchorY) then self:Dock() end
    if self.run then
        if now >= self.nextRead then self.nextRead = now + 150; self:Step(now) end
        if self.run and now >= (self.nextPaint or 0) then self.nextPaint = now + 1000; self:Paint() end
        return
    end
    if now < self.nextRead then return end
    self.nextRead = now + 500
    self:ReadControls()
    self:Refresh()
end

---------------------------------------------------------------- Currency preference (shared by the gear tools)
-- One setting for every gear tool: pay with Notes (bound currency) first and with Coins (unbound) only for the rest,
-- or Coins only. What the server does (gs synthetize_manager, player GetMixMoney / DecMixMoney = Notes first):
--   * Celestial / Legendary Reforge: the page's own "Only Use Coin" box (Chk_UseUnbind) is sent with every Reforge;
--     unticked = Notes first, then Coins (Notes used on an unbound item bind it). The reroll tool keeps that box in
--     line with this setting (U.Money:Apply) while it is open and before every press.
--   * Gem cleansing: always Notes first, then Coins (the client never asks for Coins only).
--   * Disassembly: not selectable - the recipe / the gear decide (bound gear pays Notes, unbound gear pays Coins).
-- New gear tools: read U.Money.notesFirst, call U.Money:Apply(page) before pressing a page that has Chk_UseUnbind.
local MONEY = {notesFirst = true}
U.Money = MONEY

function MONEY:Path()
    local p = O:Path()
    local dir = p and p:match("^(.*[\\/])")
    if dir then return dir .. "CurrencyPref.ini" end
end

function MONEY:Load()
    if self.loaded then return end
    self.loaded = true
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "rb")
    if not ok or not f then return end
    local okR, text = pcall(f.read, f, "*a"); pcall(f.close, f)
    if not okR or type(text) ~= "string" then return end
    local v = text:match("notes_first%s*=%s*(%d)")
    if v then self.notesFirst = v ~= "0" end
end

function MONEY:Save()
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "wb")
    if not ok or not f then return end
    pcall(f.write, f, "[Currency]\r\nnotes_first=" .. (self.notesFirst and "1" or "0") .. "\r\n")
    pcall(f.close, f)
end

function MONEY:Set(on)
    self:Load()
    on = on and true or false
    if on ~= self.notesFirst then self.notesFirst = on; self:Save() end
end

-- a page's "Only Use Coin" box: unticked = Notes first, ticked = Coins only
function MONEY:Apply(page)
    self:Load()
    local want = not self.notesFirst
    local ok, c = pcall(DlgApi.IsItemChecked, page, "Chk_UseUnbind")
    if ok and c ~= want then pcall(DlgApi.CheckItem, page, "Chk_UseUnbind", want) end
end

---------------------------------------------------------------- Gem Auto-Combine
-- Win_GemCombine docks to the left of the Equipment Service window while its Gem Combination page
-- (Win_EquipServ_StoneCompose) is open. It lists every gem in the bag (packs 2-4, GameApi.GearScan) that has a
-- combine recipe (server produce_svr.lua StoneList: CB.REC[gem] = {product, gems needed, charm, coins}). Tick the gems,
-- Combine: each round empties the page (CombClear), puts the gems one by one (CombPutGem) and a Gem Combination Charm
-- stack (CombPutCharm), checks the page holds exactly that (CombState), sends with the game's own send (CombSend:
-- flag 0 = Notes first, 1 = Coins only, from the shared U.Money setting) and waits until the gems have left the bag.
-- Bound gems go first (with bound charms first), then unbound gems (unbound charms first), then a bound/unbound mix;
-- a bound gem or charm makes the result bound. "Keep combining" also combines what it makes, up to the top recipe.
-- Stops when no allowed charm is left, nothing changes for 8 s (coins?), the page is closed or Stop is pressed.
local CB = {DLG = "Win_GemCombine", HOST = "Win_EquipServ_StoneCompose", MAIN = "Win_EquipServ_Main",
    PACKS = {2, 3, 4}, ROWS = 12, WAIT = 8000, GAP = 300,
    useUnbound = true, useBound = true, chain = false, pick = {}, page = 1, nextRead = 0, names = {}}
U.GemCombine = CB
CB.CHARMS = {[56490] = true, [56491] = true}
CB.REC = {
    [13374] = {13375, 2, 56490, 40},
    [13375] = {13376, 2, 56490, 80},
    [56530] = {56531, 5, 56490, 500},
    [56531] = {56532, 5, 56490, 1000},
    [56532] = {56533, 5, 56490, 2000},
    [56533] = {56534, 5, 56490, 4000},
    [56534] = {56535, 5, 56491, 8000},
    [56540] = {56541, 5, 56490, 500},
    [56541] = {56542, 5, 56490, 1000},
    [56542] = {56543, 5, 56490, 2000},
    [56543] = {56544, 5, 56490, 4000},
    [56544] = {56545, 5, 56491, 8000},
    [56550] = {56551, 5, 56490, 500},
    [56551] = {56552, 5, 56490, 1000},
    [56552] = {56553, 5, 56490, 2000},
    [56553] = {56554, 5, 56490, 4000},
    [56554] = {56555, 5, 56491, 8000},
    [56560] = {56561, 5, 56490, 500},
    [56561] = {56562, 5, 56490, 1000},
    [56562] = {56563, 5, 56490, 2000},
    [56563] = {56564, 5, 56490, 4000},
    [56564] = {56565, 5, 56491, 8000},
    [56570] = {56571, 5, 56490, 500},
    [56571] = {56572, 5, 56490, 1000},
    [56572] = {56573, 5, 56490, 2000},
    [56573] = {56574, 5, 56490, 4000},
    [56574] = {56575, 5, 56491, 8000},
    [56580] = {56581, 5, 56490, 500},
    [56581] = {56582, 5, 56490, 1000},
    [56582] = {56583, 5, 56490, 2000},
    [56583] = {56584, 5, 56490, 4000},
    [56584] = {56585, 5, 56491, 8000},
    [56590] = {56591, 5, 56490, 500},
    [56591] = {56592, 5, 56490, 1000},
    [56592] = {56593, 5, 56490, 2000},
    [56593] = {56594, 5, 56490, 4000},
    [56594] = {56595, 5, 56491, 8000},
    [56600] = {56601, 5, 56490, 500},
    [56601] = {56602, 5, 56490, 1000},
    [56602] = {56603, 5, 56490, 2000},
    [56603] = {56604, 5, 56490, 4000},
    [56604] = {56605, 5, 56491, 8000},
    [56610] = {56611, 5, 56490, 500},
    [56611] = {56612, 5, 56490, 1000},
    [56612] = {56613, 5, 56490, 2000},
    [56613] = {56614, 5, 56490, 4000},
    [56614] = {56615, 5, 56491, 8000},
    [56636] = {56637, 5, 56490, 500},
    [56637] = {56638, 5, 56490, 1000},
    [56638] = {56639, 5, 56490, 2000},
    [56639] = {56640, 5, 56490, 4000},
    [56640] = {56641, 5, 56491, 8000},
    [56646] = {56647, 5, 56490, 500},
    [56647] = {56648, 5, 56490, 1000},
    [56648] = {56649, 5, 56490, 2000},
    [56649] = {56650, 5, 56490, 4000},
    [56650] = {56651, 5, 56491, 8000},
    [56656] = {56657, 5, 56490, 500},
    [56657] = {56658, 5, 56490, 1000},
    [56658] = {56659, 5, 56490, 2000},
    [56659] = {56660, 5, 56490, 4000},
    [56660] = {56661, 5, 56491, 8000},
    [56666] = {56667, 5, 56490, 500},
    [56667] = {56668, 5, 56490, 1000},
    [56668] = {56669, 5, 56490, 2000},
    [56669] = {56670, 5, 56490, 4000},
    [56670] = {56671, 5, 56491, 8000},
    [56676] = {56677, 5, 56490, 500},
    [56677] = {56678, 5, 56490, 1000},
    [56678] = {56679, 5, 56490, 2000},
    [56679] = {56680, 5, 56490, 4000},
    [56680] = {56681, 5, 56491, 8000},
    [56686] = {56687, 5, 56490, 500},
    [56687] = {56688, 5, 56490, 1000},
    [56688] = {56689, 5, 56490, 2000},
    [56689] = {56690, 5, 56490, 4000},
    [56690] = {56691, 5, 56491, 8000},
    [56696] = {56697, 5, 56490, 500},
    [56697] = {56698, 5, 56490, 1000},
    [56698] = {56699, 5, 56490, 2000},
    [56699] = {56700, 5, 56490, 4000},
    [56700] = {56701, 5, 56491, 8000},
    [56706] = {56707, 5, 56490, 500},
    [56707] = {56708, 5, 56490, 1000},
    [56708] = {56709, 5, 56490, 2000},
    [56709] = {56710, 5, 56490, 4000},
    [56710] = {56711, 5, 56491, 8000},
    [56716] = {56717, 5, 56490, 500},
    [56717] = {56718, 5, 56490, 1000},
    [56718] = {56719, 5, 56490, 2000},
    [56719] = {56720, 5, 56490, 4000},
    [56720] = {56721, 5, 56491, 8000},
    [56726] = {56727, 5, 56490, 500},
    [56727] = {56728, 5, 56490, 1000},
    [56728] = {56729, 5, 56490, 2000},
    [56729] = {56730, 5, 56490, 4000},
    [56730] = {56731, 5, 56491, 8000},
    [56736] = {56737, 5, 56490, 500},
    [56737] = {56738, 5, 56490, 1000},
    [56738] = {56739, 5, 56490, 2000},
    [56739] = {56740, 5, 56490, 4000},
    [56740] = {56741, 5, 56491, 8000},
    [56746] = {56747, 5, 56490, 500},
    [56747] = {56748, 5, 56490, 1000},
    [56748] = {56749, 5, 56490, 2000},
    [56749] = {56750, 5, 56490, 4000},
    [56750] = {56751, 5, 56491, 8000},
    [56756] = {56757, 5, 56490, 500},
    [56757] = {56758, 5, 56490, 1000},
    [56758] = {56759, 5, 56490, 2000},
    [56759] = {56760, 5, 56490, 4000},
    [56760] = {56761, 5, 56491, 8000},
    [56766] = {56767, 5, 56490, 500},
    [56767] = {56768, 5, 56490, 1000},
    [56768] = {56769, 5, 56490, 2000},
    [56769] = {56770, 5, 56490, 4000},
    [56770] = {56771, 5, 56491, 8000},
    [56779] = {56780, 5, 56490, 500},
    [56780] = {56781, 5, 56490, 1000},
    [56781] = {56782, 5, 56490, 2000},
    [56782] = {56783, 5, 56490, 4000},
    [56783] = {56784, 5, 56491, 8000},
    [56789] = {56790, 5, 56490, 500},
    [56790] = {56791, 5, 56490, 1000},
    [56791] = {56792, 5, 56490, 2000},
    [56792] = {56793, 5, 56490, 4000},
    [56793] = {56794, 5, 56491, 8000},
    [56799] = {56800, 5, 56490, 500},
    [56800] = {56801, 5, 56490, 1000},
    [56801] = {56802, 5, 56490, 2000},
    [56802] = {56803, 5, 56490, 4000},
    [56803] = {56804, 5, 56491, 8000},
    [56809] = {56810, 5, 56490, 500},
    [56810] = {56811, 5, 56490, 1000},
    [56811] = {56812, 5, 56490, 2000},
    [56812] = {56813, 5, 56490, 4000},
    [56813] = {56814, 5, 56491, 8000},
    [56819] = {56820, 5, 56490, 500},
    [56820] = {56821, 5, 56490, 1000},
    [56821] = {56822, 5, 56490, 2000},
    [56822] = {56823, 5, 56490, 4000},
    [56823] = {56824, 5, 56491, 8000},
    [75278] = {75279, 5, 56490, 500},
    [75279] = {75280, 5, 56490, 1000},
    [75280] = {75281, 5, 56490, 2000},
    [75281] = {75282, 5, 56490, 4000},
    [75282] = {75283, 5, 56491, 8000},
    [75289] = {75290, 5, 56490, 500},
    [75290] = {75291, 5, 56490, 1000},
    [75291] = {75292, 5, 56490, 2000},
    [75292] = {75293, 5, 56490, 4000},
    [75293] = {75294, 5, 56491, 8000},
}

local function cb_checked(item) local ok, c = pcall(DlgApi.IsItemChecked, CB.DLG, item); if ok then return c == true end end
local function cb_pos(name)
    local ok, p = pcall(DlgApi.GetDialogProp, name)
    if ok and type(p) == "table" and finite(p.x) and finite(p.y) then return p.x, p.y end
end
local function cb_num(n)
    local s = tostring(math.floor(n + 0.5))
    while true do
        local t, k = s:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        s = t
        if k == 0 then return s end
    end
end
local function cb_dword(hex, i)
    local b1, b2, b3, b4 = tonumber(hex:sub(i, i + 1), 16), tonumber(hex:sub(i + 2, i + 3), 16),
        tonumber(hex:sub(i + 4, i + 5), 16), tonumber(hex:sub(i + 6, i + 7), 16)
    if not (b1 and b2 and b3 and b4) then return nil end
    return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
end

function CB:Set(item, text)
    self.shownText = self.shownText or {}
    if self.shownText[item] ~= text then self.shownText[item] = text; settext(self.DLG, item, text) end
end
function CB:Status(text) self:Set("Txt_Status", text or "") end

function CB:Name(tid)
    local n = self.names[tid]
    if n == nil then
        local ok, nm = pcall(GameApi.GetItemInfo, tid)
        n = (ok and type(nm) == "string" and nm ~= "") and (nm:gsub("%^%x%x%x%x%x%x", "")) or ("Item " .. tid)
        self.names[tid] = n
    end
    return n
end

---------------------------------------------------------------- settings (GemCombine.ini next to ClientTweaks.ini)
function CB:Path()
    local p = O:Path()
    local dir = p and p:match("^(.*[\\/])")
    if dir then return dir .. "GemCombine.ini" end
end

function CB:Load()
    if self.loaded then return end
    self.loaded = true
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "rb")
    if not ok or not f then return end
    local okR, text = pcall(f.read, f, "*a"); pcall(f.close, f)
    if not okR or type(text) ~= "string" then return end
    local u, b, c = text:match("unbound%s*=%s*(%d)"), text:match("\nbound%s*=%s*(%d)"), text:match("chain%s*=%s*(%d)")
    if u then self.useUnbound = u ~= "0" end
    if b then self.useBound = b ~= "0" end
    if c then self.chain = c ~= "0" end
end

function CB:Save()
    local path = self:Path()
    if not path or not io or type(io.open) ~= "function" then return end
    local ok, f = pcall(io.open, path, "wb")
    if not ok or not f then return end
    pcall(f.write, f, "[GemCombine]\r\nunbound=" .. (self.useUnbound and "1" or "0") .. "\r\nbound=" ..
        (self.useBound and "1" or "0") .. "\r\nchain=" .. (self.chain and "1" or "0") .. "\r\n")
    pcall(f.close, f)
end

---------------------------------------------------------------- reading the bag
function CB:Read()
    if type(GameApi.GearScan) ~= "function" or type(GameApi.CombSend) ~= "function" then return false end
    local stacks, groups = {}, {}
    for _, pack in ipairs(self.PACKS) do
        local ok, hex = pcall(GameApi.GearScan, pack)
        if ok and type(hex) == "string" then
            for i = 1, #hex - 95, 96 do
                local slot, tid, count, flags = cb_dword(hex, i), cb_dword(hex, i + 8), cb_dword(hex, i + 16),
                    cb_dword(hex, i + 24)
                if slot and tid and tid > 0 and (self.REC[tid] or self.CHARMS[tid]) then
                    table.insert(stacks, {pack = pack, slot = slot, tid = tid, count = count, bound = flags % 2 == 1})
                end
            end
        end
    end
    for _, s in ipairs(stacks) do
        local r = self.REC[s.tid]
        if r then
            local g = groups[s.tid]
            if not g then
                g = {tid = s.tid, product = r[1], need = r[2], charm = r[3], coins = r[4], total = 0, bound = 0}
                groups[s.tid] = g
            end
            g.total = g.total + s.count
            if s.bound then g.bound = g.bound + s.count end
        end
    end
    local list = {}
    for _, g in pairs(groups) do table.insert(list, g) end
    table.sort(list, function(a, b)
        local na, nb = self:Name(a.tid), self:Name(b.tid)
        if na ~= nb then return na < nb end
        return a.tid < b.tid
    end)
    self.stacks, self.groups, self.list = stacks, groups, list
    return true
end

function CB:CharmTotals(tid)
    local u, b = 0, 0
    for _, s in ipairs(self.stacks) do
        if s.tid == tid then if s.bound then b = b + s.count else u = u + s.count end end
    end
    return u, b
end

-- ticked gems, plus (Keep combining) what they make, as long as there is a recipe for it
function CB:Wanted()
    local want = {}
    for tid in pairs(self.pick) do want[tid] = true end
    if self.chain then
        local grew = true
        while grew do
            grew = false
            for tid in pairs(want) do
                local r = self.REC[tid]
                if r and self.REC[r[1]] and not want[r[1]] then want[r[1]] = true; grew = true end
            end
        end
    end
    return want
end

-- the next round: {gem, units = {stack, ...} (need entries, a stack may repeat), charm = stack} or nil, reason
function CB:NextRound()
    local want = self:Wanted()
    local order = {}
    for _, g in ipairs(self.list) do if want[g.tid] and g.total >= g.need then table.insert(order, g) end end
    for _, g in ipairs(order) do
        for _, mode in ipairs({"bound", "unbound", "mixed"}) do
            local units = {}
            local function take(wantBound)
                for _, s in ipairs(self.stacks) do
                    if s.tid == g.tid and (wantBound == nil or s.bound == wantBound) then
                        for _ = 1, s.count do
                            if #units >= g.need then return end
                            table.insert(units, s)
                        end
                    end
                end
            end
            if mode == "bound" then take(true) elseif mode == "unbound" then take(false) else take(true); take(false) end
            if #units >= g.need then
                local charm = self:PickCharm(g.charm, mode ~= "unbound")
                if not charm then
                    local u, b = self:CharmTotals(g.charm)
                    return nil, string.format("no %s%s left for %s (bag: %d unbound, %d bound).",
                        (self.useUnbound and self.useBound) and "" or (self.useUnbound and "unbound " or "bound "),
                        self:Name(g.charm), self:Name(g.tid), u, b)
                end
                return {gem = g, units = units, charm = charm, bound = mode ~= "unbound" or charm.bound}
            end
        end
    end
end

function CB:PickCharm(tid, boundFirst)
    for _, wantBound in ipairs(boundFirst and {true, false} or {false, true}) do
        if (wantBound and self.useBound) or (not wantBound and self.useUnbound) then
            for _, s in ipairs(self.stacks) do
                if s.tid == tid and s.bound == wantBound and s.count > 0 then return s end
            end
        end
    end
end

---------------------------------------------------------------- window
function CB:Dock()
    local anchor = shown(self.MAIN) and self.MAIN or self.HOST
    pcall(DlgApi.SetDialogPosition, self.DLG, 0, 0, anchor, AUIDIALOG_ALIGN_OUTSIDE, AUIDIALOG_ALIGN_LEFT,
        AUIDIALOG_ALIGN_INSIDE, AUIDIALOG_ALIGN_TOP)
    self.anchorX, self.anchorY = cb_pos(anchor)
end

function CB:ReadControls()
    if self.rowTids then
        for i = 1, self.ROWS do
            local tid = self.rowTids[i]
            if tid then
                local c = cb_checked("Chk_R" .. i)
                if c ~= nil then self.pick[tid] = c or nil end
            end
        end
    end
    local changed = false
    local u, b, c = cb_checked("Chk_Unbound"), cb_checked("Chk_Bound"), cb_checked("Chk_Chain")
    if u ~= nil and u ~= self.useUnbound then self.useUnbound, changed = u, true end
    if b ~= nil and b ~= self.useBound then self.useBound, changed = b, true end
    if c ~= nil and c ~= self.chain then self.chain, changed = c, true end
    if changed then self:Save() end
    local M = U.Money
    if M then
        M:Load()
        local n = cb_checked("Chk_NotesFirst")
        if self.moneyShown ~= nil and n ~= nil and n ~= self.moneyShown then
            M:Set(n); self.moneyShown = n
        elseif self.moneyShown ~= M.notesFirst then
            pcall(DlgApi.CheckItem, self.DLG, "Chk_NotesFirst", M.notesFirst); self.moneyShown = M.notesFirst
        end
    end
end

function CB:PaintTicks()
    pcall(DlgApi.CheckItem, self.DLG, "Chk_Unbound", self.useUnbound)
    pcall(DlgApi.CheckItem, self.DLG, "Chk_Bound", self.useBound)
    pcall(DlgApi.CheckItem, self.DLG, "Chk_Chain", self.chain)
    self.moneyShown = nil
end

function CB:Paint()
    local pages = math.max(1, math.ceil(#self.list / self.ROWS))
    if self.page > pages then self.page = pages end
    self:Set("Txt_Page", self.page .. " / " .. pages)
    local want = self:Wanted()
    self.rowTids = {}
    for i = 1, self.ROWS do
        local g = self.list[(self.page - 1) * self.ROWS + i]
        pcall(DlgApi.ShowItem, self.DLG, "Chk_R" .. i, g ~= nil)
        if g then
            self.rowTids[i] = g.tid
            local name = self:Name(g.tid)
            if #name > 28 then name = name:sub(1, 27) .. "." end
            self:Set("Chk_R" .. i, name)
            pcall(DlgApi.CheckItem, self.DLG, "Chk_R" .. i, self.pick[g.tid] == true)
            self:Set("Txt_H" .. i, g.bound > 0 and string.format("%d (%d bound)", g.total, g.bound) or tostring(g.total))
            local n = math.floor(g.total / g.need)
            local make = string.format("%d x %s", n, self:Name(g.product))
            if #make > 30 then make = make:sub(1, 29) .. "." end
            self:Set("Txt_M" .. i, make)
            self:Set("Txt_K" .. i, (g.charm == 56491) and "Charm II" or "Charm I")
            self:Set("Txt_W" .. i, cb_num(g.coins) .. (want[g.tid] and not self.pick[g.tid] and "  (kept on)" or ""))
        else
            for _, k in ipairs({"Txt_H", "Txt_M", "Txt_K", "Txt_W"}) do self:Set(k .. i, "") end
        end
    end
    -- what the ticked gems need right now (one level; Keep combining adds more later)
    local charms, coins, rounds = {}, 0, 0
    for _, g in ipairs(self.list) do
        if want[g.tid] then
            local n = math.floor(g.total / g.need)
            rounds = rounds + n
            coins = coins + n * g.coins
            charms[g.charm] = (charms[g.charm] or 0) + n
        end
    end
    local parts = {}
    for tid, n in pairs(charms) do
        if n > 0 then
            local u, b = self:CharmTotals(tid)
            table.insert(parts, string.format("%s: need %d, bag %d unbound + %d bound", self:Name(tid), n, u, b))
        end
    end
    table.sort(parts)
    self:Set("Txt_Info", #self.list == 0 and "No gems in your bag can be combined." or
        string.format("%d kinds of gems in your bag can be combined.  Ticked: %d combines now (%s coins, %s).", #self.list,
            rounds, cb_num(coins), (U.Money and not U.Money.notesFirst) and "Coins only" or "Notes first"))
    self:Set("Txt_Charms", table.concat(parts, "   "))
    if not self.run then
        self:Set("Btn_Start", "Combine")
        pcall(DlgApi.EnableItem, self.DLG, "Btn_Start", rounds > 0)
    else
        self:Set("Btn_Start", "Working...")
        pcall(DlgApi.EnableItem, self.DLG, "Btn_Start", false)
    end
end

function CB:Refresh()
    if not self:Read() then
        self:Status("Gem Auto-Combine needs the updated xajh.exe (GameApi.CombSend).")
        return false
    end
    self:Paint()
    return true
end

function CB:SelectAll(on)
    self.pick = {}
    if on then for _, g in ipairs(self.list or {}) do if g.total >= g.need then self.pick[g.tid] = true end end end
    if shown(self.DLG) then self:Paint() end
end

function CB:PageBy(d)
    self:ReadControls()
    self.page = math.max(1, self.page + d)
    if shown(self.DLG) then self:Paint() end
end

---------------------------------------------------------------- doing it
local function cb_state()
    if type(GameApi.CombState) ~= "function" then return nil end
    local r = {pcall(GameApi.CombState)}
    if not r[1] or not finite(r[2]) then return nil end
    local ents = {}
    for i = 0, r[2] - 1 do
        ents[i] = {slot = r[3 + i * 3], pack = r[4 + i * 3], tid = r[5 + i * 3]}
    end
    return ents, r[2]
end

function CB:Start()
    if self.run then return end
    self:ReadControls()
    if not self:Refresh() then return end
    self.run = {done = 0, made = {}}
    self:Begin(0)
end

function CB:Begin(now)
    local r = self.run
    self:Read()
    local round, why = self:NextRound()
    if not round then
        self:Stop(why and string.format("Stopped after %d: %s", r.done, why) or
            string.format("Done: %d %s.", r.done, r.done == 1 and "combine" or "combines"))
        return
    end
    r.round, r.phase, r.t, r.tries = round, "put", now, 0
    r.before = round.gem.total
    self:Status(string.format("%d done - combining %d x %s...", r.done, round.gem.need, self:Name(round.gem.tid)))
end

function CB:Stop(msg)
    self.run = nil
    pcall(GameApi.CombClear)
    if msg then self:Status(msg) end
    if shown(self.DLG) then self:Refresh() end
end

-- the page holds exactly this round's gems and charm
function CB:Holds(round)
    local ents, n = cb_state()
    if not ents or n < 6 then return false end
    local gems = 0
    for i = 0, n - 2 do
        local e = ents[i]
        if e.tid and e.tid > 0 then
            if e.tid ~= round.gem.tid then return false end
            gems = gems + 1
        end
    end
    local c = ents[n - 1]
    return gems == round.gem.need and c.tid == round.charm.tid and c.pack == round.charm.pack and
        c.slot == round.charm.slot
end

function CB:Step(now)
    local r = self.run
    if not shown(self.HOST) then self:Stop("Stopped: the Gem Combination page was closed."); return end
    local round = r.round
    if r.phase == "put" then
        if r.tries >= 2 then self:Stop("Stopped: the gems did not go into the Gem Combination window."); return end
        pcall(GameApi.CombClear)
        for _, s in ipairs(round.units) do pcall(GameApi.CombPutGem, s.pack, s.slot) end
        pcall(GameApi.CombPutCharm, round.charm.pack, round.charm.slot)
        r.tries, r.phase, r.t = r.tries + 1, "check", now
    elseif r.phase == "check" then
        if self:Holds(round) then
            local flag = (U.Money and not U.Money.notesFirst) and 1 or 0
            local ok, n = pcall(GameApi.CombSend, flag)
            if not ok or not n or n < 1 then self:Stop("Stopped: the Gem Combination window is gone."); return end
            r.phase, r.t = "wait", now
        elseif now - r.t > 300 then
            r.phase = "put"
        end
    elseif r.phase == "wait" then
        if now - r.t < 150 then return end
        self:Read()
        local g = self.groups[round.gem.tid]
        local left = g and g.total or 0
        if left <= r.before - round.gem.need then
            r.done = r.done + 1
            r.phase, r.t = "gap", now
        elseif now - r.t > self.WAIT then
            self:Stop(string.format("Stopped after %d: nothing changed for %s (coins?).", r.done, self:Name(round.gem.tid)))
        end
    elseif r.phase == "gap" then
        if now - r.t >= self.GAP then self:Begin(now) end
    end
end

function CB:Close() if self.run then self:Stop("Stopped.") end; self.userClosed = true; show(self.DLG, false) end

function CB:Tick(now)
    local open = shown(self.HOST)
    if not open then
        if self.run then self:Stop("Stopped: the Gem Combination page was closed.") end
        if self.hostOpen then
            self.hostOpen, self.userClosed = false, false
            if shown(self.DLG) then show(self.DLG, false) end
        end
        return
    end
    self:Load()
    if not self.hostOpen then
        self.hostOpen = true
        if self.userClosed then return end
        show(self.DLG, true)
        self.shownText, self.rowTids = {}, nil
        self:Dock()
        self:PaintTicks()
        self:Refresh()
        return
    end
    if not shown(self.DLG) then return end
    local ax, ay = cb_pos(shown(self.MAIN) and self.MAIN or self.HOST)
    if ax and (ax ~= self.anchorX or ay ~= self.anchorY) then self:Dock() end
    if self.run then
        if now >= self.nextRead then self.nextRead = now + 100; self:Step(now) end
        if self.run and now >= (self.nextPaint or 0) then self.nextPaint = now + 1000; self:Paint() end
        return
    end
    if now < self.nextRead then return end
    self.nextRead = now + 500
    self:ReadControls()
    self:Refresh()
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
    pcall(AE.Tick, AE, now)
    pcall(QP.Tick, QP, now)
    pcall(AO.Tick, AO, now)
    pcall(GC.Tick, GC, now)
    pcall(GS.Tick, GS, now)
    pcall(CB.Tick, CB, now)
    pcall(ST.Tick, ST, now)
    pcall(MM.Tick, MM, now)
    pcall(RR.Tick, RR, now)
    if type(GameApi.MirageStep) == "function" and O:On("mirage_arrows") then pcall(GameApi.MirageStep) end
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
