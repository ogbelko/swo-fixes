-- Top bar (map name row): the cogwheel next to FPS / ping opens Quick Settings (gameui.lua, ClientUI.Quick).
-- Every other command of this window is handled natively first; unknown commands return false.
Win_MainInfoLeft = DlgTemplate:new({this = "Win_MainInfoLeft"})
local function Q() return ClientUI and ClientUI.Quick end
function Win_MainInfoLeft:Init()
    self.eventMap["IDCANCEL"] = nil
    self:RegisterEvent("swc_cog", function() if Q() then Q():Toggle() end; return true end)
end
