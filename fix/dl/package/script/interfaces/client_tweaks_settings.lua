-- Client Tweaks window. All logic is in gameui.lua (ClientUI.Settings).
Win_ClientTweaksSettings = DlgTemplate:new({this = "Win_ClientTweaksSettings"})
local function S() return ClientUI and ClientUI.Settings end
function Win_ClientTweaksSettings:Init()
    self:RegisterEvent("Btn_OK", function() if S() then S():OK() end; return true end)
    self:RegisterEvent("Btn_Apply", function() if S() then S():Apply() end; return true end)
    self:RegisterEvent("IDCANCEL", function() if S() then S():Cancel() end; return true end)
end
