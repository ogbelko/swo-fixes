-- Quick Settings panel (cogwheel on the FPS / ping bar). All logic is in gameui.lua (ClientUI.Quick).
Win_SwcQuick = DlgTemplate:new({this = "Win_SwcQuick"})
local function Q() return ClientUI and ClientUI.Quick end
function Win_SwcQuick:Init()
    self.eventMap["IDCANCEL"] = nil
    self:RegisterEvent("IDCANCEL", function() if Q() then Q():Close() end; return true end)
end
