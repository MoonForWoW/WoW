local _, ADDONSELF = ...

local FrameHide = ADDONSELF.FrameHide
local GetClassCFF = ADDONSELF.GetClassCFF
local QianKuan = ADDONSELF.QianKuan

local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi
    
local pt = print

local function TongBaoUI()
    local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
    bt:SetSize(100, 25)
    bt:SetPoint("BOTTOM", BG.MainFrame, "BOTTOM", 30, 15)
    bt:SetText("通报欠款")
    bt:Show()
    BG.ButtonQianKuan = bt

    bt:SetScript("OnEnter", function(self)
        local QianKuan1,QianKuan3 = QianKuan(BiaoGe[BG.FB1],Maxb[BG.FB1],Maxi[BG.FB1])
        local text = "|cffffffff< 通 报 欠 款 >|r\n"
        for i=1,#QianKuan1 do
            text = text..i.."、"..GetClassCFF(QianKuan1[i][2]).." "..QianKuan1[i][1].."|cffFF0000欠款："..QianKuan1[i][3].."|r\n"
        end
        if #QianKuan3 >= 1 then
            text = text.."|cffffffff< 合 计 欠 款 >|r\n"
            for i=1,#QianKuan3 do
                local name
                if QianKuan3[i][1] == "" then
                    name = "没记买家"
                else
                    name = GetClassCFF(QianKuan3[i][1])
                end
                text = text..i.."、"..name.." |cffFF0000合计欠款："..QianKuan3[i][2].."|r\n"
            end
        end
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
        GameTooltip:ClearLines()
        GameTooltip:SetText(text)
    end)
    bt:SetScript("OnLeave",function (self)
        GameTooltip:Hide()
    end)
    -- 单击触发
    bt:SetScript("OnClick", function(self)
        FrameHide(0)
        if not IsInRaid() then
            print("不在团队，无法通报")
            PlaySound(BG.sound1)
        else
            self:SetEnabled(false)      -- 点击后按钮变灰2秒
            C_Timer.After(2,function ()
                bt:SetEnabled(true)
            end)
            local text = "————通报欠款————"
            SendChatMessage(text,"RAID")
            local QianKuan1,QianKuan3 = QianKuan(BiaoGe[BG.FB1],Maxb[BG.FB1],Maxi[BG.FB1])
            for i=1,#QianKuan1 do
                text = i.."、"..QianKuan1[i][2].." "..QianKuan1[i][1].."欠款："..QianKuan1[i][3]
                SendChatMessage(text,"RAID")
            end
            if #QianKuan3 >= 1 then
                text = "{rt7} 合计欠款 {rt7}"
                SendChatMessage(text,"RAID")
                for i=1,#QianKuan3 do
                    local name
                    if QianKuan3[i][1] == "" then
                        name = "没记买家"
                    else
                        name = GetClassCFF(QianKuan3[i][1])
                    end
                    text = i.."、"..name.." 合计欠款："..QianKuan3[i][2]
                    SendChatMessage(text,"RAID")
                end
            end
            text = "——感谢使用金团表格——"
            SendChatMessage(text,"RAID")
            PlaySoundFile(BG.sound2)
        end
    end)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "BiaoGe" then
        TongBaoUI()
    end
end)