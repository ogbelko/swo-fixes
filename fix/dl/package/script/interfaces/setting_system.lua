-- v7: adds a "Client Tweaks" button to the game's System Settings window.
-- Every other command of this window is handled natively first; unknown commands return false.
Win_SettingSystem = DlgTemplate:new({this = "Win_SettingSystem"})
function Win_SettingSystem:Init()
    self.eventMap["IDCANCEL"] = nil
    self:RegisterEvent("client_tweaks", function() if ClientUI then ClientUI.OpenSettings() end; return true end)
    self:RegisterEvent("minimal_custom", function() if ClientUI and ClientUI.Minimal then ClientUI.Minimal:Open() end; return true end)
end
