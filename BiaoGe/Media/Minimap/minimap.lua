local addonName, addon = ...

local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
if not ldb then return end

local plugin = ldb:NewDataObject(addonName, {type = "data source", icon = "Interface\\AddOns\\BiaoGe\\Media\\icon\\icon"})
function plugin:OnClick(button)     --function plugin.OnClick(self, button)
    if BG.MainFrame and not BG.MainFrame:IsVisible() then
        BG.MainFrame:Show()
    else
        BG.MainFrame:Hide()
    end
end

function plugin:OnEnter(button)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM",-30,0)
    GameTooltip:ClearLines()
    GameTooltip:SetText("|cff00BFFF<BiaoGe>金团表格")
end
function plugin:OnLeave(button)
    GameTooltip:Hide()
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function()
    local icon = LibStub("LibDBIcon-1.0", true)
    if not icon then return end
    icon:Register(addonName, plugin, BiaoGe)
end)
frame:RegisterEvent("PLAYER_LOGIN")