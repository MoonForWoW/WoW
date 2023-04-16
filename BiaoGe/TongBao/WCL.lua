local _, ADDONSELF = ...

local FrameHide = ADDONSELF.FrameHide
local WCLpm = ADDONSELF.WCLpm
local WCLcolor = ADDONSELF.WCLcolor

local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi
    
local pt = print

local function TongBaoUI()
    local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
    bt:SetSize(100, 25)
    bt:SetPoint("BOTTOM", BG.MainFrame, "BOTTOM", -110, 50)
    bt:SetText("通报WCL")
    bt:Show()
    BG.ButtonWCL = bt

    local groupchange = true
    local f=CreateFrame("Frame")
    f:RegisterEvent("GROUP_ROSTER_UPDATE")
    f:SetScript("OnEvent", function(self,even,...)
        groupchange = true
    end)

    -- 鼠标悬停提示
    local text
    local wclname4,wclname5,wclfenshu4,wclfenshu5,wclfenshu6,updatetime     -- 单纯的名字，带颜色字符串的名字，单纯的分数，短字符串分数，带颜色字符串分数，更新日期
    bt:SetScript("OnEnter", function(self)
        if groupchange then
            wclname4,wclname5,wclfenshu4,wclfenshu5,wclfenshu6,updatetime = WCLpm()
            if not wclname4 then
                text = "读取不到数据，你可能没安装或者没打开WCL插件"
            else
                updatetime = "|cffFFFFFF更新时间："..updatetime.."|r"
                text = "|cffffffff< WCL分数 >|r\n"
                local num = GetNumGroupMembers()
                if not IsInRaid() then
                    num = 1
                end
                for i=1,num do                        
                    if wclname5[i] and wclfenshu6[i] then
                        text = text..i.."、"..wclname5[i].."："..wclfenshu6[i].."\n"
                    end
                end
                text = text..updatetime
            end
            groupchange = false
        end
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0)
        GameTooltip:ClearLines()
        GameTooltip:SetText(text)
    end)
    bt:SetScript("OnLeave",function (self)
        GameTooltip:Hide()
    end)
        -- 点击通报WCL分数
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
            wclname4,wclname5,wclfenshu4,wclfenshu5,wclfenshu6,updatetime = WCLpm()
            updatetime = "更新时间："..updatetime
            local text = ""
            local num = GetNumGroupMembers()
            SendChatMessage("———通报WCL分数———","RAID")
            for i=1,num do
                if wclname4[i] and wclfenshu4[i] and wclfenshu5[i] then
                    text = WCLcolor(wclfenshu4[i])..i.."、"..wclname4[i].."："..wclfenshu5[i].."\n"
                    SendChatMessage(text,"RAID")
                end
            end  
            text = updatetime
            SendChatMessage(text,"RAID")
            SendChatMessage("——感谢使用金团表格——","RAID")
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