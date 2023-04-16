local _, ADDONSELF = ...

local Size = ADDONSELF.Size
local RGB = ADDONSELF.RGB
local GetClassRGB = ADDONSELF.GetClassRGB
local GetClassCFF = ADDONSELF.GetClassCFF
local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi
local FrameHide = ADDONSELF.FrameHide

local pt = print

function BG.HistoryUI()

    BG.History = {}

    local bt = CreateFrame("Button",nil,BG.MainFrame)
    bt:SetSize(90, 30)
    bt:SetPoint("TOPRIGHT",BG.MainFrame,"TOPRIGHT",-30,4)
    bt:SetNormalFontObject(BG.FontGold1)
    bt:SetHighlightFontObject(BG.FontHilight)
    bt:SetText("历史表格")
    bt:Show()
    BG.History.HistoryButton = bt

    -- 单击触发
    bt:SetScript("OnClick", function(self)
        pt(date("%y%m%d%H%M%S"))
    end)
    
    local bt = CreateFrame("Button",nil,BG.MainFrame)
    bt:SetSize(90, 30)
    bt:SetPoint("TOPRIGHT",BG.History.HistoryButton,"TOPLEFT",0,0)
    bt:SetNormalFontObject(BG.FontGold1)
    bt:SetDisabledFontObject(BG.FontDisabled)
    bt:SetHighlightFontObject(BG.FontHilight)
    bt:SetText("保存当前表格")
    bt:Show()
    BG.History.SaveButton = bt

    -- 单击触发
    bt:SetScript("OnClick", function(self)
        if not date("%y%m%d%H%M%S") then return end
        self:SetEnabled(false)      -- 点击后按钮变灰2秒
        C_Timer.After(2,function ()
            bt:SetEnabled(true)
        end)
        BiaoGe[date("%y%m%d%H%M%S")] = {["FB"] = BG.FB1}
        for b=1,Maxb[BG.FB1]+2 do
            BiaoGe[date("%y%m%d%H%M%S")]["boss"..b] = {}
            for i=1,Maxi[BG.FB1] do
                if BG.Frame[BG.FB1]["boss"..b]["zhuangbei"..i] then
                    BiaoGe[date("%y%m%d%H%M%S")]["boss"..b]["zhuangbei"..i] = BG.Frame[BG.FB1]["boss"..b]["zhuangbei"..i]:GetText()
                    BiaoGe[date("%y%m%d%H%M%S")]["boss"..b]["maijia"..i] = BG.Frame[BG.FB1]["boss"..b]["maijia"..i]:GetText()
                    BiaoGe[date("%y%m%d%H%M%S")]["boss"..b]["color"..i] = {BG.Frame[BG.FB1]["boss"..b]["maijia"..i]:GetTextColor()}
                    BiaoGe[date("%y%m%d%H%M%S")]["boss"..b]["jine"..i] = BG.Frame[BG.FB1]["boss"..b]["jine"..i]:GetText()
                end
            end
        end
    end)
end