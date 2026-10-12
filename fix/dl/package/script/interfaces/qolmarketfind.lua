-- v11 search: actual data/navigation in ClientUI.MarketSearch.
Win_QolMarketFind=DlgTemplate:new({this="Win_QolMarketFind"})
local function M() return ClientUI and ClientUI.MarketSearch end
function Win_QolMarketFind:Init()
    self:RegisterEvent("qol_next",function() if M() then M():Step(1) end;return true end)
    self:RegisterEvent("qol_enter",function() if M() then M():Step(1) end;return true end)
    self:RegisterEvent("qol_prev",function() if M() then M():Step(-1) end;return true end)
    self:RegisterEvent("IDCANCEL",function() if M() then M():Close() end;return true end)
end
