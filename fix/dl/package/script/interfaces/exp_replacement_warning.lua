-- v7: EXP replacement warning. All logic is in gameui.lua (ClientUI.Exp); only Use approves.
Win_EXPReplacementWarning = DlgTemplate:new({this = "Win_EXPReplacementWarning"})
local function E() return ClientUI and ClientUI.Exp end
function Win_EXPReplacementWarning:Init()
    self:RegisterEvent("confirm", function() if E() then E():Cancel() end; return true end)
    self:RegisterEvent("IDCANCEL", function() if E() then E():Cancel() end; return true end)
    self:RegisterEvent("exp_use", function() if E() then E():Use() end; return true end)
end
function Win_EXPReplacementWarning:HideDialog() if E() and E().token then E():Cancel() end end
