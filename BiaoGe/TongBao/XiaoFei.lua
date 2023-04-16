local _, ADDONSELF = ...

local FrameHide = ADDONSELF.FrameHide
local XiaoFei = ADDONSELF.XiaoFei
local GetClassCFF = ADDONSELF.GetClassCFF

local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi
    
local pt = print

local function TongBaoUI()
    local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
    bt:SetSize(100, 25)
    bt:SetPoint("BOTTOM", BG.MainFrame, "BOTTOM", 30, 50)
    bt:SetText("通报消费")
    bt:Show()
    BG.ButtonXiaoFei = bt
        -- 鼠标悬停提示
    bt:SetScript("OnEnter", function(self)
        local text = "|cffffffff< 消 费 排 名 >|r\n"
        local XiaoFei4 = XiaoFei(BiaoGe[BG.FB1],Maxb[BG.FB1],Maxi[BG.FB1])
        for i=1,#XiaoFei4 do
            if XiaoFei4[i] then
                text = text..i.."、"..GetClassCFF(XiaoFei4[i][1]).."："..XiaoFei4[i][2].."\n"
            end
        end
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
        GameTooltip:ClearLines();
        GameTooltip:SetText(text)
    end)
    bt:SetScript("OnLeave",function (self)
        GameTooltip:Hide()
    end)
        -- 点击通报消费排名
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
            local text = "———通报消费排名———"
            SendChatMessage(text,"RAID")
            local XiaoFei4 = XiaoFei(BiaoGe[BG.FB1],Maxb[BG.FB1],Maxi[BG.FB1])
            for i=1,#XiaoFei4 do
                if XiaoFei4[i] then
                    text = i.."、"..XiaoFei4[i][1].."："..XiaoFei4[i][2]
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