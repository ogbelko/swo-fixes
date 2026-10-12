-- v9 search bar (stash). All logic is in gameui.lua (ClientUI.Search).
Win_QolStashFind = DlgTemplate:new({this = "Win_QolStashFind"})
local function F() return ClientUI and ClientUI.Search end
function Win_QolStashFind:Init()
    self:RegisterEvent("qol_next", function() if F() then F():Step("stash", 1) end; return true end)
    self:RegisterEvent("qol_enter", function() if F() then F():Step("stash", 1) end; return true end)
    self:RegisterEvent("qol_prev", function() if F() then F():Step("stash", -1) end; return true end)
    self:RegisterEvent("IDCANCEL", function() if F() then F():Close("stash") end; return true end)
end
