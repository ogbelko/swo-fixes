-- Multi Disassembly window (left of the Disassemble page). All logic is in gameui.lua (ClientUI.GearSplit).
Win_GearSplit = DlgTemplate:new({this = "Win_GearSplit"})
local function G() return ClientUI and ClientUI.GearSplit end
function Win_GearSplit:Init()
    self.eventMap["IDCANCEL"] = nil
    self:RegisterEvent("gs_start", function() if G() then G():StartClick() end; return true end)
    self:RegisterEvent("gs_stop", function() if G() and G().run then G():Stop("Stopped.") end; return true end)
    self:RegisterEvent("gs_all", function() if G() then G():SelectAll(true) end; return true end)
    self:RegisterEvent("gs_none", function() if G() then G():SelectAll(false) end; return true end)
    self:RegisterEvent("gs_prev", function() if G() then G():PageBy(-1) end; return true end)
    self:RegisterEvent("gs_next", function() if G() then G():PageBy(1) end; return true end)
    self:RegisterEvent("IDCANCEL", function() if G() then G():Close() end; return true end)
end
