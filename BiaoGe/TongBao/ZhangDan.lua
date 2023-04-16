local _, ADDONSELF = ...

local TongBao = ADDONSELF.TongBao
local FrameHide = ADDONSELF.FrameHide

local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi
    
local pt = print

local function TongBaoUI()
    local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
    bt:SetSize(100, 25)
    bt:SetPoint("BOTTOM", BG.MainFrame, "BOTTOM", 170, 50)
    bt:SetText("通报账单")
    bt:Show()
    BG.ButtonTongBao = bt

        -- 鼠标悬停提示账单
    bt:SetScript("OnEnter", function(self)
        local TongBaozhuangbei,TongBaojine = TongBao(BiaoGe[BG.FB1],Maxb[BG.FB1],Maxi[BG.FB1])
        local text = "|cffffffff< 收  入 >|r\n"
        local num = 0
        for i=1,#TongBaojine do
            if TongBaozhuangbei[i] and TongBaojine[i] then
                text = text..i.."、"..TongBaozhuangbei[i].."："..TongBaojine[i].."\n"
                num = num + 1
            end
        end
        for i=1,Maxi[BG.FB1] do
            if BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["zhuangbei"..i] then
                if BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["zhuangbei"..i] ~= "" or BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["maijia"..i] ~= "" or BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["jine"..i] ~= "" then
                    if tonumber(BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["jine"..i]) then
                        num = num + 1
                        text = text..num.."、"..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["zhuangbei"..i].." "..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["maijia"..i].."："..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["jine"..i].."\n"
                    end
                end
            end
        end
        text = text.."|cffffffff< 支  出 >|r\n"
        for i = 1, 5, 1 do
            if BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+1]["zhuangbei"..i] ~= "" and tonumber(BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+1]["jine"..i]) then
                text = text.."|cff00FF00"..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+1]["zhuangbei"..i].."："..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+1]["jine"..i].."|r".."\n"
            end
        end
        text = text.."|cffffffff< 总  览 >|r\n"
        for i = 1, 3, 1 do
            if BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["zhuangbei"..i] ~= "" and tonumber(BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine"..i]) then
                text = text.."|cffEE82EE"..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["zhuangbei"..i].."："..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine"..i].."|r".."\n"
            end
        end
        text = text.."|cffffffff< 工  资 >|r\n"
        if BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["zhuangbei4"] ~= "" and tonumber(BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine4"]) then
            text = text.."|cff00BFFF"..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["zhuangbei4"].."："..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine4"].."人".."|r".."\n"
        end
        if BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["zhuangbei5"] ~= "" and tonumber(BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine5"]) then
            text = text.."|cff00BFFF"..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["zhuangbei5"].."："..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine5"].."|r".."\n"
            text = text.."|cff00BFFF"..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine5"].." * 5 = "..(tonumber(BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine5"])*5).."|r".."\n"
        end
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
        GameTooltip:ClearLines()
        for b = 1, Maxb[BG.FB1]+2, 1 do
            for i = 1, Maxi[BG.FB1], 1 do
                if BG.Frame[BG.FB1]["boss"..b]["jine"..i] then
                    if not tonumber(BG.Frame[BG.FB1]["boss"..b]["jine"..i]:GetText()) and BG.Frame[BG.FB1]["boss"..b]["jine"..i]:GetText() ~= "" then
                        GameTooltip:SetText("金额里有错误（红字），无法通报")
                        return
                    end
                end
            end                
        end
        GameTooltip:SetText(text)
    end)
    bt:SetScript("OnLeave",function (self)
        GameTooltip:Hide()
    end)
        -- 点击通报账单
    bt:SetScript("OnClick", function(self)
        FrameHide(0)
        if not IsInRaid() then
            print("不在团队，无法通报")
            PlaySound(BG.sound1)
        else
            for b = 1, Maxb[BG.FB1]+2, 1 do
                for i = 1, Maxi[BG.FB1], 1 do
                    if BG.Frame[BG.FB1]["boss"..b]["jine"..i] then
                        if not tonumber(BG.Frame[BG.FB1]["boss"..b]["jine"..i]:GetText()) and BG.Frame[BG.FB1]["boss"..b]["jine"..i]:GetText() ~= "" then
                            print("金额里有错误（红字），无法通报")
                            return
                        end
                    end
                end
            end
            self:SetEnabled(false)      -- 点击后按钮变灰2秒
            C_Timer.After(2,function ()
                bt:SetEnabled(true)
            end)
            local TongBaozhuangbei,TongBaojine = TongBao(BiaoGe[BG.FB1],Maxb[BG.FB1],Maxi[BG.FB1])
            local text = "———通报金团账单———"
            SendChatMessage(text,"RAID")
            local text = "< 收 {rt1} 入 >"
            SendChatMessage(text,"RAID")
            local num = 0
            for i=1,#TongBaojine do
                if TongBaozhuangbei[i] and TongBaojine[i] then
                    text = i.."、"..TongBaozhuangbei[i].."："..TongBaojine[i]
                    num = num + 1
                    SendChatMessage(text,"RAID")
                end
            end
            for i=1,Maxi[BG.FB1] do
                if BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["zhuangbei"..i] then
                    if BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["zhuangbei"..i] ~= "" or BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["maijia"..i] ~= "" or BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["jine"..i] ~= "" then
                        if tonumber(BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["jine"..i]) then
                            num = num + 1
                            text = num.."、"..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["zhuangbei"..i].." "..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["maijia"..i].."："..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]]["jine"..i]
                            SendChatMessage(text,"RAID")
                        end
                    end
                end
            end
            text = "< 支 {rt4} 出 >"
            SendChatMessage(text,"RAID")
            for i = 1, 5, 1 do
                if BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+1]["zhuangbei"..i] ~= "" and tonumber(BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+1]["jine"..i]) then
                    text = BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+1]["zhuangbei"..i].."："..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+1]["jine"..i]
                    SendChatMessage(text,"RAID")
                end
            end
            text = "< 总 {rt3} 览 >"
            SendChatMessage(text,"RAID")
            for i = 1, 3, 1 do
                if BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["zhuangbei"..i] ~= "" and tonumber(BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine"..i]) then
                    text = BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["zhuangbei"..i].."："..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine"..i]
                    SendChatMessage(text,"RAID")
                end
            end
            text = "< 工 {rt6} 资 >"
            SendChatMessage(text,"RAID")
            if BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["zhuangbei4"] ~= "" and tonumber(BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine4"]) then
                text = BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["zhuangbei4"].."："..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine4"].."人"
                SendChatMessage(text,"RAID")
            end
            if BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["zhuangbei5"] ~= "" and tonumber(BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine5"]) then
                text = BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["zhuangbei5"].."："..BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine5"]
                SendChatMessage(text,"RAID")
                text = BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine5"].." * 5 = "..(tonumber(BiaoGe[BG.FB1]["boss"..Maxb[BG.FB1]+2]["jine5"])*5)
                SendChatMessage(text,"RAID")
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