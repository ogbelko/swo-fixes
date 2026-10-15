-- Reforge reroll window. All logic is in gameui.lua (ClientUI.Reroll, RerollCore).
Win_RerollTool = DlgTemplate:new({this = "Win_RerollTool"})
local function R() return ClientUI and ClientUI.Reroll end
function Win_RerollTool:Init()
    self:RegisterEvent("rr_start", function() if R() then R():Start() end; return true end)
    self:RegisterEvent("rr_stop", function() if R() then R():Stop("Stopped.") end; return true end)
    self:RegisterEvent("rr_kprev", function() if R() then R():Page(-1) end; return true end)
    self:RegisterEvent("rr_knext", function() if R() then R():Page(1) end; return true end)
    self:RegisterEvent("IDCANCEL", function() if R() then R():Close() end; return true end)
end
