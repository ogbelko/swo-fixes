-- v9 search bar (bag). All logic is in gameui.lua (ClientUI.Search).
Win_QolBagFind = DlgTemplate:new({this = "Win_QolBagFind"})
local function F() return ClientUI and ClientUI.Search end
function Win_QolBagFind:Init()
    self:RegisterEvent("qol_next", function() if F() then F():Step("bag", 1) end; return true end)
    self:RegisterEvent("qol_enter", function() if F() then F():Step("bag", 1) end; return true end)
    self:RegisterEvent("qol_prev", function() if F() then F():Step("bag", -1) end; return true end)
    self:RegisterEvent("IDCANCEL", function() if F() then F():Close("bag") end; return true end)
end
