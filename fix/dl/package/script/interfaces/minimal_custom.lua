-- Minimal Mode Settings window. All logic is in gameui.lua (ClientUI.Minimal).
Win_MinimalCustom = DlgTemplate:new({this = "Win_MinimalCustom"})
local function M() return ClientUI and ClientUI.Minimal end
function Win_MinimalCustom:Init()
    self:RegisterEvent("Btn_OK", function() if M() then M():OK() end; return true end)
    self:RegisterEvent("Btn_Apply", function() if M() then M():Apply() end; return true end)
    self:RegisterEvent("IDCANCEL", function() if M() then M():Close() end; return true end)
    self:RegisterEvent("preset_ultra", function() if M() then M():Preset("ultra") end; return true end)
    self:RegisterEvent("preset_balanced", function() if M() then M():Preset("balanced") end; return true end)
    self:RegisterEvent("preset_original", function() if M() then M():Preset("original") end; return true end)
end
