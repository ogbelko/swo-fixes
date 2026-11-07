-- Gem Cleanser window (left of the Gem Cleansing page). All logic is in gameui.lua (ClientUI.GemCleanser).
Win_GemCleanser = DlgTemplate:new({this = "Win_GemCleanser"})
local function G() return ClientUI and ClientUI.GemCleanser end
function Win_GemCleanser:Init()
    self.eventMap["IDCANCEL"] = nil
    self:RegisterEvent("gc_donext", function() if G() then G():DoNext() end; return true end)
    self:RegisterEvent("gc_auto", function() if G() then G():Auto() end; return true end)
    self:RegisterEvent("gc_prev", function() if G() then G():PageBy(-1) end; return true end)
    self:RegisterEvent("gc_nextpage", function() if G() then G():PageBy(1) end; return true end)
    for i = 1, 10 do
        self:RegisterEvent("gc_dn" .. i, function() if G() then G():KeepStep(i, -1) end; return true end)
        self:RegisterEvent("gc_up" .. i, function() if G() then G():KeepStep(i, 1) end; return true end)
        self:RegisterEvent("gc_au" .. i, function() if G() then G():KeepAuto(i) end; return true end)
    end
    self:RegisterEvent("IDCANCEL", function() if G() then G():Close() end; return true end)
end
