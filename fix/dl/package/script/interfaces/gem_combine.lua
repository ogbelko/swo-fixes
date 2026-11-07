-- Gem Auto-Combine window (left of the Gem Combination page). All logic is in gameui.lua (ClientUI.GemCombine).
Win_GemCombine = DlgTemplate:new({this = "Win_GemCombine"})
local function G() return ClientUI and ClientUI.GemCombine end
function Win_GemCombine:Init()
    self.eventMap["IDCANCEL"] = nil
    self:RegisterEvent("cb_start", function() if G() then G():Start() end; return true end)
    self:RegisterEvent("cb_stop", function() if G() and G().run then G():Stop("Stopped.") end; return true end)
    self:RegisterEvent("cb_all", function() if G() then G():SelectAll(true) end; return true end)
    self:RegisterEvent("cb_none", function() if G() then G():SelectAll(false) end; return true end)
    self:RegisterEvent("cb_prev", function() if G() then G():PageBy(-1) end; return true end)
    self:RegisterEvent("cb_next", function() if G() then G():PageBy(1) end; return true end)
    self:RegisterEvent("IDCANCEL", function() if G() then G():Close() end; return true end)
end
