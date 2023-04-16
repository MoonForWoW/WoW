local _, ADDONSELF = ...

local Size = ADDONSELF.Size
local RGB = ADDONSELF.RGB
local GetClassRGB = ADDONSELF.GetClassRGB
local GetClassCFF = ADDONSELF.GetClassCFF
local Trade = ADDONSELF.Trade
local FrameDongHua = ADDONSELF.FrameDongHua
local FrameHide = ADDONSELF.FrameHide

local Width = ADDONSELF.Width
local Height = ADDONSELF.Height
local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local HopeMaxn = ADDONSELF.HopeMaxn
local HopeMaxb = ADDONSELF.HopeMaxb
local HopeMaxi = ADDONSELF.HopeMaxi

local pt = print

local function BiaoGeUI()

    BG.Ver = "v1.2.0"
    ------------------主界面（背景）------------------
    do
        BG.MainFrame = CreateFrame("Frame", "BG.MainFrame", UIParent, "BasicFrameTemplate");
        BG.MainFrame:SetWidth(Width["BG.MainFrame"]);
        BG.MainFrame:SetHeight(Height["BG.MainFrame"]);
        BG.MainFrame:SetFrameStrata("HIGH");
        BG.MainFrame:SetPoint("CENTER");
        -- BG.MainFrame:SetAlpha(0.8)
        BG.MainFrame:SetFrameLevel(100)
        BG.MainFrame:SetMovable(true)
        BG.MainFrame:SetScript("OnMouseUp", function(self)
            self:StopMovingOrSizing();
        end);
        BG.MainFrame:SetScript("OnMouseDown", function(self)
            FrameHide(0)
            self:StartMoving();
        end);
        tinsert(UISpecialFrames, "BG.MainFrame")     -- 按ESC可关闭插件        

        local TitleText = BG.MainFrame:CreateFontString()
        TitleText:SetPoint("TOP", BG.MainFrame, "TOP", 0, -4);
        TitleText:SetFontObject(GameFontNormal)
        TitleText:SetText("|cff00BFFF< BiaoGe > 金 团 表 格")
        TitleText:Show()
        BG.Title = TitleText

        -- 说明书
        local frame = CreateFrame("Frame",nil,BG.MainFrame)
        frame:SetSize(350, 30)
        frame:SetPoint("TOPLEFT", BG.MainFrame, "TOPLEFT", 5, 4)
        local fontString = frame:CreateFontString()
        fontString:SetAllPoints()
        fontString:SetFontObject(GameFontNormal)
        fontString:SetJustifyH("LEFT")
        fontString:SetText("<说明书与更新记录> "..BG.STC_g1(BG.Ver))
        fontString:Show()
        BG.ShuoMingShu = frame
        BG.ShuoMingShuText = fontString
        local text = "|cffFFFFFF< 我是说明书 >|r\n\n1、插件命令：|cff00BFFF/biaoge 或 /bge|r，可以做成宏，方便打开\n2、按Tab可横跳光标，按Enter可下跳光标，点空白处可取消光标，右键输入框可清除内容\n3、SHIFT+点击装备可把装备发到聊天框。相反点聊天里的装备也可添加到表格\n4、ALT+点击装备可关注装备，团长拍卖此装备时会提醒\n5、当团长贴出装备开始拍卖时，会自动高亮表格里相应的装备\n\n刚学做插件，做得不好请见谅。\nBUG可反馈到：buick_hbj@163.com\n\n\n|cff00BFFF< 主要更新记录 >|r\n\n"
        text = text.."|cff00FF004月15日1.2.0版本|r\n1、功能增加：心愿清单（数据按角色保存）\n    你可以设置一些装备，这些装备只要掉落就会有提醒，并且掉落后自动关注团长拍卖\n    你还可以查询团队里有多少人跟你设置了相同的心愿装备，让你们提前了解竞争状况\n2、增加设置：UI透明度\n3、奥杜尔的杂项格子增加至7个，罚款格子减少至14个\n4、由于插件命令/bg跟战场频道冲突，所以把插件命令/bg改为/bge\n"
        text = text.."|cff00FF004月9日1.1.9版本|r\n1、按键调整：现在ALT+点击是关注装备，SHIFT+点击是发送装备。这样更符合WOW的使用习惯\n2、现在对聊天里装备也支持ALT+点击关注装备，前提是该装备已在表格里\n3、一个老BUG被修复：队伍分配下不会重复记录两次装备了\n"
        text = text.."|cff00FF004月8日1.1.8版本|r\n1、功能增加：关注装备。\n    ALT+点击装备（装备框或拾取通报的装备链接）可关注装备，团长拍卖此装备时会提醒\n2、现在进副本会提示清空表格\n3、橙片现在会记录数量\n4、金额自动加0现在可设置开关\n5、拍卖聊天框增加上下滚动按钮\n6、如果团长不是物品分配者，则也会记录物品分配者的拍卖聊天记录/拍卖关注通知\n"
        text = text.."|cff00FF004月4日1.1.7版本|r\n1、现在金额是0的话，不会再加两个0\n2、通报账单的收入改为从高到低排序（罚款除外）\n"
        text = text.."|cff00FF004月3日1.1.6版本|r\n1、功能增加：通报BOSS击杀用时\n2、功能增加：通报欠款（交易时可输入欠款，金额下拉菜单也可输入欠款）\n3、现在（拍卖聊天框，装备自动拾取消息，交易成功消息）里的装备链接可交互\n4、鼠标右键输入框可清除内容\n"
        frame:SetScript("OnEnter",function (self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT",-350,0);
            GameTooltip:ClearLines();
            GameTooltip:SetText(text)
        end)
        frame:SetScript("OnLeave",function (self)
            GameTooltip:Hide()
        end)

        ------------------设置------------------
        do
            local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
            bt:SetSize(100, 25)
            bt:SetPoint("BOTTOMRIGHT", BG.MainFrame, "BOTTOMRIGHT", -40, 30)
            bt:SetText("设置")
            bt:Show()
            BG.ButtonSheZhi = bt

            local f = CreateFrame("Frame",nil,BG.ButtonSheZhi,"BackdropTemplate")
            f:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                edgeSize = 16
            })
            f:SetBackdropColor(0,0,0.1,1)
            f:SetSize(155, 260)
            f:SetPoint("CENTER",nil,"CENTER",0,0)
            -- f:SetFrameStrata("HIGH")
            f:SetFrameLevel(121)
            f:Hide()
            BG.FrameSheZhi = f
            f:SetScript("OnMouseUp", function(self)
            end)

            bt:SetScript("OnClick", function(self)
                BG.FrameSheZhi:ClearAllPoints()
                BG.FrameSheZhi:SetPoint("BOTTOMLEFT",BG.ButtonSheZhi,"TOPLEFT")
                if BG.FrameSheZhi and not BG.FrameSheZhi:IsVisible() then
                    BG.FrameSheZhi:Show()
                else
                    BG.FrameSheZhi:Hide()
                end
                PlaySound(BG.sound1)
            end)
        end

        ------------------难度选择菜单------------------
        do
            local nandu 
            local nanduID
            C_Timer.After(1,function ()
                nanduID = GetRaidDifficultyID()
                if nanduID == 3 or nanduID == 175 then
                    nandu = "10人|cff00BFFF普通|r"
                elseif nanduID == 4 or nanduID == 176 then
                    nandu = "25人|cff00BFFF普通|r"
                elseif nanduID == 5 or nanduID == 193 then
                    nandu = "10人|cffFF0000英雄|r"
                elseif nanduID == 6 or nanduID == 194 then
                    nandu = "25人|cffFF0000英雄|r"
                end
                -- pt(GetRaidDifficultyID())
            end)
            BG.NanDuDropDown = {}
            local dropDown = CreateFrame("FRAME", nil, BG.MainFrame, "UIDropDownMenuTemplate")
            dropDown:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT",295,25)
            UIDropDownMenu_SetWidth(dropDown, 95)
            C_Timer.After(2,function ()
                UIDropDownMenu_SetText(dropDown, nandu)
            end)
            BG.NanDuDropDown.DropDown = dropDown
            local text = dropDown:CreateFontString()
            text:SetPoint("RIGHT", dropDown, "LEFT",7,3)
            text:SetFontObject(GameFontNormal)
            text:SetText("当前团队副本难度:")
            text:Show()
            BG.NanDuDropDown.BiaoTi = text
            UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
                FrameHide(0)
                PlaySound(BG.sound1)
                local info = UIDropDownMenu_CreateInfo()
                    info.text, info.func = "10人|cff00BFFF普通|r", function ()
                        SetRaidDifficultyID(3)
                        FrameHide(0)
                        PlaySound(12880)        -- 冰霜灵气的声音
                    end 
                UIDropDownMenu_AddButton(info)
                local info = UIDropDownMenu_CreateInfo()
                    info.text, info.func = "25人|cff00BFFF普通|r", function ()
                        SetRaidDifficultyID(4)
                        FrameHide(0)
                        PlaySound(12880)        -- 冰霜灵气的声音
                    end 
                    UIDropDownMenu_AddButton(info)
                local info = UIDropDownMenu_CreateInfo()
                    info.text, info.func = "10人|cffFF0000英雄|r", function ()
                        SetRaidDifficultyID(5)
                        FrameHide(0)
                        PlaySound(12873)        -- 鲜血灵气的声音
                    end 
                    UIDropDownMenu_AddButton(info)
                local info = UIDropDownMenu_CreateInfo()
                    info.text, info.func = "25人|cffFF0000英雄|r", function ()
                        SetRaidDifficultyID(6)
                        FrameHide(0)
                        PlaySound(12873)        -- 鲜血灵气的声音
                    end 
                    UIDropDownMenu_AddButton(info)
            end)
            local f=CreateFrame("Frame")
            f:RegisterEvent("CHAT_MSG_SYSTEM")
            f:SetScript("OnEvent", function(self,even,text,...)
                if string.find(text,"团队副本难度设置为") then
                    local nandu 
                    local nanduID = GetRaidDifficultyID()
                    if nanduID == 3 or nanduID == 175 then
                        nandu = "10人|cff00BFFF普通|r"
                    elseif nanduID == 4 or nanduID == 176 then
                        nandu = "25人|cff00BFFF普通|r"
                    elseif nanduID == 5 or nanduID == 193 then
                        nandu = "10人|cffFF0000英雄|r"
                    elseif nanduID == 6 or nanduID == 194 then
                        nandu = "25人|cffFF0000英雄|r"
                    end
                    UIDropDownMenu_SetText(dropDown, nandu)
                end
            end)
        end
    end
    ------------------副本切换按钮------------------
    do
        -- 窗口
        BG.FrameNAXX = CreateFrame("Frame", "BG.FrameNAXX", BG.MainFrame)
        BG.FrameULD = CreateFrame("Frame", "BG.FrameULD", BG.MainFrame)
        BG.FrameTOC = CreateFrame("Frame", "BG.FrameTOC", BG.MainFrame)
        BG.FrameICC = CreateFrame("Frame", "BG.FrameICC", BG.MainFrame)

        BG.FrameNAXX:Hide()
        BG.FrameULD:Hide()
        BG.FrameTOC:Hide()
        BG.FrameICC:Hide()

        BG.HopeFrameNAXX = CreateFrame("Frame", "BG.HopeFrameNAXX", BG.MainFrame)   -- 心愿清单
        BG.HopeFrameULD = CreateFrame("Frame", "BG.HopeFrameULD", BG.MainFrame)
        BG.HopeFrameTOC = CreateFrame("Frame", "BG.HopeFrameTOC", BG.MainFrame)
        BG.HopeFrameICC = CreateFrame("Frame", "BG.HopeFrameICC", BG.MainFrame)

        BG.HopeFrameNAXX:Hide()
        BG.HopeFrameULD:Hide()
        BG.HopeFrameTOC:Hide()
        BG.HopeFrameICC:Hide()

        -- 按钮
        local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
        bt:SetSize(60, 25)
        bt:SetPoint("TOPLEFT", BG.MainFrame, "TOPRIGHT", -10, -50)
        bt:SetFrameStrata("MEDIUM")
        bt:SetFrameLevel(90)
        bt:SetText("ICC")
        bt:Show()
        local fb = bt   -- 创建后续按钮对齐用
        BG.ButtonICC = bt

        local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
        bt:SetSize(60, 25)
        bt:SetPoint("TOP", fb, "BOTTOM", 0, -1)
        bt:SetFrameStrata("MEDIUM")
        bt:SetFrameLevel(90)
        bt:SetText("TOC")
        bt:Show()
        local fb = bt
        BG.ButtonTOC = bt

        local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
        bt:SetSize(60, 25)
        bt:SetPoint("TOP", fb, "BOTTOM", 0, -1)
        bt:SetFrameStrata("MEDIUM")
        bt:SetFrameLevel(90)
        bt:SetText("ULD")
        bt:Show()
        local fb = bt
        BG.ButtonULD = bt

        local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
        bt:SetSize(60, 25)
        bt:SetPoint("TOP", fb, "BOTTOM", 0, -1)
        bt:SetFrameStrata("MEDIUM")
        bt:SetFrameLevel(90)
        bt:SetText("NAXX")
        bt:Show()
        local fb = bt
        BG.ButtonNAXX = bt

        -- 副本切换单击触发
        do
            BG.ButtonICC:SetScript("OnClick", function(self)       -- ICC
                FrameHide(0)
                if BG["Frame"..BG.FB1] and BG["Frame"..BG.FB1]:IsVisible() then
                    BG.FrameICC:Show()
                    BG.FrameTOC:Hide()
                    BG.FrameULD:Hide()
                    BG.FrameNAXX:Hide()
                else
                    BG.HopeFrameICC:Show()
                    BG.HopeFrameTOC:Hide()
                    BG.HopeFrameULD:Hide()
                    BG.HopeFrameNAXX:Hide()
                end

                BG.ButtonICC:SetEnabled(false)
                BG.ButtonTOC:SetEnabled(false)
                BG.ButtonULD:SetEnabled(false)
                BG.ButtonNAXX:SetEnabled(false)
                C_Timer.After(0.5,function ()
                    BG.ButtonTOC:SetEnabled(true)
                    BG.ButtonULD:SetEnabled(true)
                    BG.ButtonNAXX:SetEnabled(true)
                end)
                BG.FB1 = "ICC"
                BiaoGe.FB = BG.FB1
                Maxb[BG.FB1],Maxi[BG.FB1] = Maxb[BG.FB1],Maxi[BG.FB1]
                FrameDongHua(BG.MainFrame,Height[BG.FB1],Width[BG.FB1])
                PlaySound(BG.sound1)
            end)

            BG.ButtonTOC:SetScript("OnClick", function(self)       -- TOC
                FrameHide(0)
                if BG["Frame"..BG.FB1] and BG["Frame"..BG.FB1]:IsVisible() then
                    BG.FrameICC:Hide()
                    BG.FrameTOC:Show()
                    BG.FrameULD:Hide()
                    BG.FrameNAXX:Hide()
                else
                    BG.HopeFrameICC:Hide()
                    BG.HopeFrameTOC:Show()
                    BG.HopeFrameULD:Hide()
                    BG.HopeFrameNAXX:Hide()
                end
                BG.ButtonICC:SetEnabled(false)
                BG.ButtonTOC:SetEnabled(false)
                BG.ButtonULD:SetEnabled(false)
                BG.ButtonNAXX:SetEnabled(false)
                C_Timer.After(0.5,function ()
                    BG.ButtonICC:SetEnabled(true)
                    BG.ButtonULD:SetEnabled(true)
                    BG.ButtonNAXX:SetEnabled(true)
                end)
                BG.FB1 = "TOC"
                BiaoGe.FB = BG.FB1
                Maxb[BG.FB1],Maxi[BG.FB1] = Maxb[BG.FB1],Maxi[BG.FB1]
                FrameDongHua(BG.MainFrame,Height[BG.FB1],Width[BG.FB1],BG.Frame[BG.FB1],Maxb[BG.FB1],Maxi[BG.FB1])
                PlaySound(BG.sound1)
            end)

            BG.ButtonULD:SetScript("OnClick", function(self)       -- ULD
                FrameHide(0)
                if BG["Frame"..BG.FB1] and BG["Frame"..BG.FB1]:IsVisible() then
                    BG.FrameICC:Hide()
                    BG.FrameTOC:Hide()
                    BG.FrameULD:Show()
                    BG.FrameNAXX:Hide()
                else
                    BG.HopeFrameICC:Hide()
                    BG.HopeFrameTOC:Hide()
                    BG.HopeFrameULD:Show()
                    BG.HopeFrameNAXX:Hide()
                end
                BG.ButtonICC:SetEnabled(false)
                BG.ButtonTOC:SetEnabled(false)
                BG.ButtonULD:SetEnabled(false)
                BG.ButtonNAXX:SetEnabled(false)
                C_Timer.After(0.5,function ()
                    BG.ButtonICC:SetEnabled(true)
                    BG.ButtonTOC:SetEnabled(true)
                    BG.ButtonNAXX:SetEnabled(true)
                end)
                BG.FB1 = "ULD"
                BiaoGe.FB = BG.FB1
                Maxb[BG.FB1],Maxi[BG.FB1] = Maxb[BG.FB1],Maxi[BG.FB1]
                FrameDongHua(BG.MainFrame,Height[BG.FB1],Width[BG.FB1],BG.Frame[BG.FB1],Maxb[BG.FB1],Maxi[BG.FB1])
                PlaySound(BG.sound1)
            end)

            BG.ButtonNAXX:SetScript("OnClick", function(self)       -- NAXX
                FrameHide(0)
                if BG["Frame"..BG.FB1] and BG["Frame"..BG.FB1]:IsVisible() then
                    BG.FrameICC:Hide()
                    BG.FrameTOC:Hide()
                    BG.FrameULD:Hide()
                    BG.FrameNAXX:Show()
                else
                    BG.HopeFrameICC:Hide()
                    BG.HopeFrameTOC:Hide()
                    BG.HopeFrameULD:Hide()
                    BG.HopeFrameNAXX:Show()
                end
                BG.ButtonICC:SetEnabled(false)
                BG.ButtonTOC:SetEnabled(false)
                BG.ButtonULD:SetEnabled(false)
                BG.ButtonNAXX:SetEnabled(false)
                C_Timer.After(0.5,function ()
                    BG.ButtonICC:SetEnabled(true)
                    BG.ButtonTOC:SetEnabled(true)
                    BG.ButtonULD:SetEnabled(true)
                end)
                BG.FB1 = "NAXX"
                BiaoGe.FB = BG.FB1
                Maxb[BG.FB1],Maxi[BG.FB1] = Maxb[BG.FB1],Maxi[BG.FB1]
                FrameDongHua(BG.MainFrame,Height[BG.FB1],Width[BG.FB1],BG.Frame[BG.FB1],Maxb[BG.FB1],Maxi[BG.FB1])
                PlaySound(BG.sound1)
            end)
        end

        -- 副本选择初始化

        if BiaoGe.FB then
            BG.FB1 = BiaoGe.FB
        else
            BG.FB1 = "ULD"
            BiaoGe.FB = BG.FB1
        end

        BG.MainFrame:SetHeight(Height[BG.FB1])
        BG.MainFrame:SetWidth(Width[BG.FB1])

        if BiaoGe.HopeShow then
            BG["HopeFrame"..BG.FB1]:Show()
            BG["Button"..BG.FB1]:SetEnabled(false)
        else
            BG["Frame"..BG.FB1]:Show()
            BG["Button"..BG.FB1]:SetEnabled(false)
        end
    end
    ------------------心愿清单按钮------------------
    do
        local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
        bt:SetSize(100, 25)
        bt:SetPoint("BOTTOMRIGHT", BG.MainFrame, "BOTTOMRIGHT", -200, 30)
        bt:SetText("心愿清单")
        bt:Show()
        bt:SetFrameLevel(105)
        BG.ButtonHope = bt

        local bt0 = CreateFrame("Button", nil, bt)
        bt0:SetSize(130, 35)
        bt0:SetPoint("CENTER")
        bt0:SetFrameLevel(102)

        local texture = bt0:CreateTexture(nil, "BACKGROUND") -- 高亮材质
        texture:SetAllPoints()
        texture:SetTexture("Interface/ChatFrame/UI-ChatIcon-BlinkHilight")

        bt:SetScript("OnClick", function(self)
            FrameHide(0)
            if BG["Frame"..BG.FB1] and not BG["Frame"..BG.FB1]:IsVisible() then
                BG["HopeFrame"..BG.FB1]:Hide()
                BG["Frame"..BG.FB1]:Show()
                bt:SetText("心愿清单")
                BG.ButtonQingKong:SetText("清空当前表格")
                BiaoGe.HopeShow = false
            else
                BG["Frame"..BG.FB1]:Hide()
                BG["HopeFrame"..BG.FB1]:Show()
                bt:SetText("关闭心愿清单")
                BG.ButtonQingKong:SetText("清空当前心愿")
                BiaoGe.HopeShow = true
            end
            PlaySound(BG.sound1)
        end)
        -- BG.FrameULD:Hide()
    end

    ------------------定时获取当前副本名称------------------
    do
        -- 获取当前副本
        local FBtable = {
            ["纳克萨玛斯"]="NAXX",
            ["黑曜石圣殿"]="NAXX",
            ["永恒之眼"]="NAXX",
            ["奥杜尔"]="ULD",
            ["十字军的试炼"]="TOC",
            ["奥妮克希亚的巢穴"]="TOC",
            ["冰冠堡垒"]="ICC",
            ["红玉圣殿"]="ICC"
        }

        local lastzone
        C_Timer.NewTicker(5, function() -- 每5秒执行一次
            if BG.DeBug then
                return
            end
            local fb = GetInstanceInfo()  -- 获取副本名称
            local _,type = IsInInstance()
            if type ~= "raid" then
                BG.FB2 = nil
            else
                for index, value in pairs(FBtable) do  -- 把中文的副本名称转换为英文简写名称
                    if fb == index then
                        BG.FB2 = value
                        break
                    else
                        BG.FB2 = nil
                    end
                end
                if lastzone ~= fb then
                    if BG.FB2 then
                        if BG.JinBenQingKong.Button then
                        BG.JinBenQingKong.Button:SetText("要清空表格<"..BG.FB2..">吗？")
                        BG.JinBenQingKong.Button:Show()
                        BG.JinBenQingKong.DongHua:SetWidth(BG.JinBenQingKong.Button:GetWidth())
                        BG.ButtonDongHua(BG.JinBenQingKong.DongHua)
                        end
                    end
                end
            end
            -- pt(fb,type,BG.FB2)
            -- pt(lastzone,fb)
            lastzone = fb
        end)
    end
    ------------------获取团队物品分配者------------------
    do
        if IsInRaid() then
            for i=1,GetNumGroupMembers() do
                local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)
                if isML then
                    BG.MasterLooter = GetUnitName("raid"..i)
                    break
                end
                BG.MasterLooter = nil
            end
        else
            BG.MasterLooter = nil
        end
        -- pt(BG.MasterLooter)
        local f=CreateFrame("Frame")
        -- f:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
        f:RegisterEvent("GROUP_ROSTER_UPDATE")
        f:SetScript("OnEvent", function(self,even,...)
            if IsInRaid() then
                for i=1,GetNumGroupMembers() do
                    local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)
                    if isML then
                        BG.MasterLooter = GetUnitName("raid"..i)
                        break
                    end
                    BG.MasterLooter = nil
                end
            else
                BG.MasterLooter = nil
            end
            -- pt(BG.MasterLooter)
        end)
    end

    -- ----------------------------------------------------------------------------
    -- 自动记录装备
    -- ----------------------------------------------------------------------------
    do
        local bt = CreateFrame("CheckButton", nil, BG.FrameSheZhi, "ChatConfigCheckButtonTemplate")
        bt:SetSize(30, 30)
        bt:SetHitRectInsets(0, -100, 0, 0);
        bt:SetPoint("TOPLEFT", BG.FrameSheZhi, "TOPLEFT", 10, -10)
        bt.Text:SetText("<自动记录装备>")
        bt:Show()
        BG.ButtonAutoLoot = bt
        if not BiaoGe.AutoLoot then
            BiaoGe.AutoLoot = 1
            bt:SetChecked(true)
        elseif BiaoGe.AutoLoot == 1 then
            bt:SetChecked(true)
        elseif BiaoGe.AutoLoot == 0 then
            bt:SetChecked(false)
        end
        bt:SetScript("OnClick", function(self)
            if self:GetChecked() then
                BiaoGe.AutoLoot = 1
            else
                BiaoGe.AutoLoot = 0
            end
            PlaySound(BG.sound1)
        end)
        -- 鼠标悬停提示
        bt:SetScript("OnEnter", function(self)
            local text = "|cffffffff< 注意事项 >|r\n\n1、橙片、飞机头、小怪掉落\n    会存到杂项里\n2、图纸不会自动保存\n"
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
            GameTooltip:ClearLines();
            GameTooltip:SetText(text)
        end)
        bt:SetScript("OnLeave",function (self)
            GameTooltip:Hide()
        end)
        -- 拾取事件通报到屏幕中上
        BG.FrameLootMsg = CreateFrame("MessageFrame", nil, UIParent)
        BG.FrameLootMsg:SetSpacing(3) -- 行间隔
        BG.FrameLootMsg:SetFadeDuration(1) -- 淡出动画的时间
        BG.FrameLootMsg:SetTimeVisible(8) -- 可见时间
        BG.FrameLootMsg:SetJustifyH("LEFT") -- 对齐格式
        BG.FrameLootMsg:SetSize(800,200) -- 大小
        BG.FrameLootMsg:SetPoint("CENTER",UIParent,"CENTER",250,400) --设置显示位置
        BG.FrameLootMsg:SetFont(STANDARD_TEXT_FONT,  20 , "OUTLINE")
        BG.FrameLootMsg:SetFrameStrata("HIGH")
        BG.FrameLootMsg:SetFrameLevel(130)
        BG.FrameLootMsg:SetHyperlinksEnabled(true)
        BG.FrameLootMsg:SetScript("OnHyperlinkEnter", function (self,link,text,button)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR",0,0);
            GameTooltip:ClearLines()
            local itemID = GetItemInfoInstant(link)
            if itemID then
            GameTooltip:SetItemByID(itemID);
            GameTooltip:Show()
            end
        end)
        BG.FrameLootMsg:SetScript("OnHyperlinkLeave", function (self,link,text,button)
            GameTooltip:Hide()
        end)
        BG.FrameLootMsg:SetScript("OnHyperlinkClick", function (self,link,text,button)
            local _,link = GetItemInfo(link)
            if button == "RightButton" then  -- 右键清除关注
                for b=1,Maxb[BG.FB2] do
                    for i=1,Maxi[BG.FB2] do
                        if BG.Frame[BG.FB2]["boss"..b]["zhuangbei"..i] then
                            if link == select(2,GetItemInfo(BG.Frame[BG.FB2]["boss"..b]["zhuangbei"..i]:GetText())) then
                                BiaoGe[BG.FB2]["boss"..b]["guanzhu"..i] = nil
                                BG.Frame[BG.FB2]["boss"..b]["guanzhu"..i]:Hide()
                                BG.FrameLootMsg:AddMessage(BG.STC_r1("已取消关注装备："..link..""))
                                return
                            end
                        end
                    end
                end
            end
            if IsShiftKeyDown() then
                _G.ChatFrame1EditBox:Show()
                _G.ChatFrame1EditBox:SetFocus()
                _G.ChatFrame1EditBox:Insert(text)
                return
            end
            if IsAltKeyDown() then
                for b=1,Maxb[BG.FB2] do
                    for i=1,Maxi[BG.FB2] do
                        if BG.Frame[BG.FB2]["boss"..b]["zhuangbei"..i] then
                            if link == select(2,GetItemInfo(BG.Frame[BG.FB2]["boss"..b]["zhuangbei"..i]:GetText())) then
                                BiaoGe[BG.FB2]["boss"..b]["guanzhu"..i] = true
                                BG.Frame[BG.FB2]["boss"..b]["guanzhu"..i]:Show()
                                BG.FrameLootMsg:AddMessage(BG.STC_g2("已成功关注装备："..link.."。团长拍卖此装备时会提醒"))
                                return
                            end
                        end
                    end
                end
            end
            ChatFrame_OnHyperlinkShow(self,link,text,button)
        end)
        -- 屏蔽交易添加
        local trade = true
        local f=CreateFrame("Frame")
        f:RegisterEvent("TRADE_SHOW")
        f:SetScript("OnEvent", function(self,...)
            trade = false
            --pt(trade)
        end)
        local f2=CreateFrame("Frame")
        f2:RegisterEvent("TRADE_CLOSED")
        f2:SetScript("OnEvent", function(self,...)
                trade = true
                --pt(trade)
        end)


        local numb
        local lasttime,time

        -- 获取BOSS战ID+
        local f=CreateFrame("Frame")
        f:RegisterEvent("BOSS_KILL")
        f:SetScript("OnEvent", function(self,even,ID)
            if BG.Loot.encounterID[BG.FB2] then
                for key, value in ipairs(BG.Loot.encounterID[BG.FB2]) do
                    if ID == value then
                        numb = key
                    end
                end
            end
            lasttime = nil
        end)

        -- 拾取事件监听
        local f = CreateFrame("Frame")
        f:RegisterEvent("CHAT_MSG_LOOT")
        f:SetScript("OnEvent",function (self,even,text,...)
            if BiaoGe.AutoLoot ~= 1 then       -- 有没勾选自动记录功能
                return
            end
            if not BG.FB2 then      -- 有没FB
                return
            end
            local _,type = IsInInstance()
            if type ~= "raid" then      -- 是否在副本
                return
            end
            local have = string.find(text,"战利品")
            if have then    -- 文本是否ROLL点
                return
            end
            have = string.find(text,"获得")
            if not have then    -- 文本有没获得
                return
            end
            if not trade then     -- 是否刚交易完里
                return
            end
            local name,link,quality,level,_,_,_,_,_,_,_,typeID=GetItemInfo(text)
            local itemId = GetItemInfoInstant(link)
            if name == "寒冰纹章" or name == "凯旋纹章" or name == "征服纹章" or name == "勇气纹章" or name == "英雄纹章" or name == "深渊水晶" then
                return
            end
            if typeID == 9 then     -- 是不是图纸
                return
            end
            if quality < 4 then    -- 是不是紫装或橙装
                return
            end

            -- 心愿装备
            local Hope
            for n=1,HopeMaxn[BG.FB2] do
                for b=1,HopeMaxb[BG.FB2] do
                    for i=1,HopeMaxi do
                        if BG.HopeFrame[BG.FB2]["nandu"..n]["boss"..b]["zhuangbei"..i] then
                            if link == select(2,GetItemInfo(BG.HopeFrame[BG.FB2]["nandu"..n]["boss"..b]["zhuangbei"..i]:GetText())) then
                                BG.FrameLootMsg:AddMessage(BG.STC_g1("你的心愿达成啦！！！>>>>> ")..link.."("..level..")"..BG.STC_g1(" <<<<<"))
                                BG.HopeFrame[BG.FB2]["nandu"..n]["boss"..b]["yidiaoluo"..i]:Show()
                                BiaoGeA.Hope[BG.FB2]["nandu"..n]["boss"..b]["yidiaoluo"..i] = true
                                Hope = true
                                PlaySoundFile(BG.sound_hope)
                            end
                        end
                    end
                end
            end

            -- 特殊物品记到杂项里
            if itemId == 45897 then  -- [重铸的远古王者之锤]
                return
            end
            if itemId == 45038 or itemId == 45693 or itemId == 47242 or itemId == 50274 or itemId == 50818 then        -- ULD橙片和飞机头，TOC北伐徽章、ICC橙片和无敌
                for i=1,Maxi[BG.FB2] do
                    if BG.Frame[BG.FB2]["boss"..Maxb[BG.FB2]-1]["zhuangbei"..i] then
                        if link == select(2,GetItemInfo(BG.Frame[BG.FB2]["boss"..Maxb[BG.FB2]-1]["zhuangbei"..i]:GetText())) then   -- 装备框是否橙片
                            if BiaoGe[BG.FB2]["ChengPian"] then
                                BiaoGe[BG.FB2]["ChengPian"] = BiaoGe[BG.FB2]["ChengPian"] + 1   -- 橙片数量+1
                                BG.Frame[BG.FB2]["boss"..Maxb[BG.FB2]-1]["zhuangbei"..i]:SetText(link.."*"..BiaoGe[BG.FB2]["ChengPian"])    -- 设置文本：橙片*数量
                                BG.FrameLootMsg:AddMessage("|cff00BFFF已自动记入表格：|r"..link.."("..level..")*"..BiaoGe[BG.FB2]["ChengPian"].." => |cffFF1493< "..BiaoGe[BG.FB2]["boss"..Maxb[BG.FB2]-1]["bossname2"].." >|r")
                                if Hope then
                                    BiaoGe[BG.FB2]["boss"..Maxb[BG.FB2]-1]["guanzhu"..i] = true
                                    BG.Frame[BG.FB2]["boss"..Maxb[BG.FB2]-1]["guanzhu"..i]:Show()
                                    BG.FrameLootMsg:AddMessage(BG.STC_g2("自动关注心愿装备："..link.."。团长拍卖此装备时会提醒"))
                                end
                            end
                            return
                        end
                        if BG.Frame[BG.FB2]["boss"..Maxb[BG.FB2]-1]["zhuangbei"..i]:GetText() == "" then    -- 装备框是否空白
                            if itemId == 45038 or itemId == 50274 then    -- 如果掉落装备为橙片
                                BiaoGe[BG.FB2]["ChengPian"] = 1     -- 橙片数量设置为1
                                BG.Frame[BG.FB2]["boss"..Maxb[BG.FB2]-1]["zhuangbei"..i]:SetText(link.."*"..BiaoGe[BG.FB2]["ChengPian"])    -- 设置文本：橙片*1
                                BG.FrameLootMsg:AddMessage("|cff00BFFF已自动记入表格：|r"..link.."("..level..")*"..BiaoGe[BG.FB2]["ChengPian"].." => |cffFF1493< "..BiaoGe[BG.FB2]["boss"..Maxb[BG.FB2]-1]["bossname2"].." >|r")
                                if Hope then
                                    BiaoGe[BG.FB2]["boss"..Maxb[BG.FB2]-1]["guanzhu"..i] = true
                                    BG.Frame[BG.FB2]["boss"..Maxb[BG.FB2]-1]["guanzhu"..i]:Show()
                                    BG.FrameLootMsg:AddMessage(BG.STC_g2("自动关注心愿装备："..link.."。团长拍卖此装备时会提醒"))
                                end
                            else
                                BG.Frame[BG.FB2]["boss"..Maxb[BG.FB2]-1]["zhuangbei"..i]:SetText(link)    -- 如果不是橙片就设置文本：装备
                                BG.FrameLootMsg:AddMessage("|cff00BFFF已自动记入表格：|r"..link.."("..level..") => |cffFF1493< "..BiaoGe[BG.FB2]["boss"..Maxb[BG.FB2]-1]["bossname2"].." >|r")
                                if Hope then
                                    BiaoGe[BG.FB2]["boss"..Maxb[BG.FB2]-1]["guanzhu"..i] = true
                                    BG.Frame[BG.FB2]["boss"..Maxb[BG.FB2]-1]["guanzhu"..i]:Show()
                                    BG.FrameLootMsg:AddMessage(BG.STC_g2("自动关注心愿装备："..link.."。团长拍卖此装备时会提醒"))
                                end
                            end
                            return
                        end
                        if BG.Frame[BG.FB2]["boss"..Maxb[BG.FB2]-1]["zhuangbei"..i+1] == nil then     -- 如果是最后一格了，就提示满了
                            BG.FrameLootMsg:AddMessage("|cffDC143C自动记录失败：|r"..link.."("..level..")。因为|cffFF1493< "..BiaoGe[BG.FB2]["boss"..Maxb[BG.FB2]-1]["bossname2"].." >|r的格子满了。。")
                            if Hope then
                                BG.FrameLootMsg:AddMessage("|cffDC143C自动关注心愿装备失败：|r"..link)
                            end
                            return
                        end
                    end
                end
            end

            -- TOC嘉奖宝箱通过读取掉落列表来记录装备
            if BG.FB2 == "TOC" then     
                for index, value in ipairs(BG.Loot.TOC.H25.boss6) do
                    if itemId == value then
                        local FB = "TOC"
                        local numb = 6
                        for i=1,Maxi[FB] do
                            if BG.Frame[FB]["boss"..numb]["zhuangbei"..i] then
                                if BG.Frame[FB]["boss"..numb]["zhuangbei"..i]:GetText() == "" then
                                    BG.Frame[FB]["boss"..numb]["zhuangbei"..i]:SetText(link)
                                    BG.FrameLootMsg:AddMessage("|cff00BFFF已自动记入表格：|r"..link.."("..level..") => |cffFF1493< "..BiaoGe[FB]["boss"..numb]["bossname2"].." >|r")
                                    return
                                end
                                if BG.Frame[FB]["boss"..numb]["zhuangbei"..i+1] == nil then
                                    BG.FrameLootMsg:AddMessage("|cffDC143C自动记录失败：|r"..link.."("..level..")。因为|cffFF1493< "..BiaoGe[FB]["boss"..numb]["bossname2"].." >|r的格子满了。。")
                                    return
                                end
                            end
                        end
                    end
                end
                for index, value in ipairs(BG.Loot.TOC.H10.boss6) do
                    if itemId == value then
                        local FB = "TOC"
                        local numb = 6
                        for i=1,Maxi[FB] do
                            if BG.Frame[FB]["boss"..numb]["zhuangbei"..i] then
                                if BG.Frame[FB]["boss"..numb]["zhuangbei"..i]:GetText() == "" then
                                    BG.Frame[FB]["boss"..numb]["zhuangbei"..i]:SetText(link)
                                    BG.FrameLootMsg:AddMessage("|cff00BFFF已自动记入表格：|r"..link.."("..level..") => |cffFF1493< "..BiaoGe[FB]["boss"..numb]["bossname2"].." >|r")
                                    return
                                end
                                if BG.Frame[FB]["boss"..numb]["zhuangbei"..i+1] == nil then
                                    BG.FrameLootMsg:AddMessage("|cffDC143C自动记录失败：|r"..link.."("..level..")。因为|cffFF1493< "..BiaoGe[FB]["boss"..numb]["bossname2"].." >|r的格子满了。。")
                                    return
                                end
                            end
                        end
                    end
                end
            end

            -- 常规物品记录到刚击杀的BOSS
            if lasttime == nil then
                lasttime = GetTime()
            end
            time = GetTime()
            if time - lasttime >= 60 then
                numb = BG.Loot.encounterID[BG.FB2]["zaxiang"]      -- 两次拾取的时间超过一定时间就变回杂项
                lasttime = time
            end
            if not numb then
                numb = BG.Loot.encounterID[BG.FB2]["zaxiang"]      -- 第一个boss前的小怪设为杂项
            end
            for i=1,Maxi[BG.FB2] do
                if BG.Frame[BG.FB2]["boss"..numb]["zhuangbei"..i] then
                    if BG.Frame[BG.FB2]["boss"..numb]["zhuangbei"..i]:GetText() == "" then
                        BG.Frame[BG.FB2]["boss"..numb]["zhuangbei"..i]:SetText(link)
                        BG.FrameLootMsg:AddMessage("|cff00BFFF已自动记入表格：|r"..link.."("..level..") => |cffFF1493< "..BiaoGe[BG.FB2]["boss"..numb]["bossname2"].." >|r")
                        if Hope then
                            BiaoGe[BG.FB2]["boss"..numb]["guanzhu"..i] = true
                            BG.Frame[BG.FB2]["boss"..numb]["guanzhu"..i]:Show()
                            BG.FrameLootMsg:AddMessage(BG.STC_g2("自动关注心愿装备："..link.."。团长拍卖此装备时会提醒"))
                        end
                        return
                    end
                    if BG.Frame[BG.FB2]["boss"..numb]["zhuangbei"..i+1] == nil then
                        BG.FrameLootMsg:AddMessage("|cffDC143C自动记录失败：|r"..link.."("..level..")。因为|cffFF1493< "..BiaoGe[BG.FB2]["boss"..numb]["bossname2"].." >|r的格子满了。。")
                        if Hope then
                            BG.FrameLootMsg:AddMessage("|cffDC143C自动关注心愿装备失败：|r"..link)
                        end
                        return
                    end
                end
            end
        end)


        -- DEBUG
        do
            function BG.DeBugLoot()
                if not BG.DeBug then return end
                local name,link,quality,level,_,_,_,_,_,_,_,typeID=GetItemInfo(45038)
                BG.Frame[BG.FB2]["boss1"]["zhuangbei1"]:SetText(link)
                BG.FrameLootMsg:AddMessage("|cff00BFFF已自动记入表格：|r"..link.."("..level..") => |cffFF1493< "..BiaoGe[BG.FB2]["boss1"]["bossname2"].." >|r")
                -- BG.FrameLootMsg:AddMessage(BG.STC_g1("你的心愿达成啦！！！>>>>> ")..link.."("..level..")"..BG.STC_g1(" <<<<<"))
                -- BG.FrameLootMsg:AddMessage(BG.STC_g2("自动关注心愿装备："..link.."。团长拍卖此装备时会提醒"))
                -- PlaySoundFile(BG.sound_hope)
                
            end

            local f = CreateFrame("Frame")
            f:RegisterEvent("CHAT_MSG_LOOT")
            f:SetScript("OnEvent",function (self,even,text,...)
                if not BG.DeBug then return end
                local name,link,quality,level,_,_,_,_,_,_,_,typeID=GetItemInfo(text)

                -- 心愿装备
                local Hope
                for n=1,HopeMaxn[BG.FB2] do
                    for b=1,HopeMaxb[BG.FB2] do
                        for i=1,HopeMaxi do
                            if BG.HopeFrame[BG.FB2]["nandu"..n]["boss"..b]["zhuangbei"..i] then
                                if link == select(2,GetItemInfo(BG.HopeFrame[BG.FB2]["nandu"..n]["boss"..b]["zhuangbei"..i]:GetText())) then
                                    BG.FrameLootMsg:AddMessage(BG.STC_g1("你的心愿达成啦！！！>>>>> ")..link.."("..level..")"..BG.STC_g1(" <<<<<"))
                                    BG.HopeFrame[BG.FB2]["nandu"..n]["boss"..b]["yidiaoluo"..i]:Show()
                                    BiaoGeA.Hope[BG.FB2]["nandu"..n]["boss"..b]["yidiaoluo"..i] = true
                                    Hope = true
                                    PlaySoundFile(BG.sound_hope)
                                end
                            end
                        end
                    end
                end
                if Hope then
                    -- BiaoGe[BG.FB2]["boss"..Maxb[BG.FB2]-1]["guanzhu"..1] = true
                    -- BG.Frame[BG.FB2]["boss"..Maxb[BG.FB2]-1]["guanzhu"..1]:Show()
                    BG.FrameLootMsg:AddMessage(BG.STC_g2("自动关注心愿装备："..link.."。团长拍卖此装备时会提醒"))
                end
            end)
        end
    end

    -- ----------------------------------------------------------------------------
    -- 交易自动记账
    -- ----------------------------------------------------------------------------
    do
            -- 交易UI的罚款输入框
        do
            BG.QianKuan = {}
            local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
            frame:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                edgeSize = 8
            })
            frame:SetBackdropColor(0.5, 0, 0.1, 0.5)
            frame:SetSize(130, 25)
            frame:Hide()
            -- frame:SetPoint("CENTER", nil, "CENTER",0,0)
            BG.QianKuan.frame = frame

            local edit = CreateFrame("EditBox", nil, frame, "InputBoxTemplate");
            edit:SetSize(70, 20)
            edit:SetPoint("RIGHT",BG.QianKuan.frame,-5,0)
            edit:SetText("")
            edit:SetTextColor(RGB("FF0000"))
            edit:SetNumeric(true)
            edit:Show()
            edit:SetAutoFocus(false)
            BG.QianKuan.edit = edit
            edit:SetScript("OnTextChanged", function(self)
                if BiaoGe.AutoJine0 == 1 then
                    local len = strlen(self:GetText())
                    local lingling
                    if len then
                        lingling = strsub(self:GetText(),len-1,len)
                    end
                    if lingling ~= "00" and tonumber(self:GetText()) and self:HasFocus() then
                        self:Insert("00")
                        self:SetCursorPosition(1)
                    end
                end
            end)
                -- 点击时
            edit:SetScript("OnMouseDown", function(self,enter)
                if enter == "RightButton" then  -- 右键清空格子
                    self:SetEnabled(false)
                    self:SetText("")
                end
            end)
            edit:SetScript("OnMouseUp", function(self,enter)
                if enter == "RightButton" then  -- 右键清空格子
                    self:SetEnabled(true)
                end
            end)

            local text = edit:CreateFontString()
            text:SetPoint("RIGHT", BG.QianKuan.edit, "LEFT", -8, 0)
            -- text:SetFontObject(GameFontNormal)    -- 普通设置方法
            text:SetFont(STANDARD_TEXT_FONT ,  14 , "OUTLINE")       -- 游戏主界面文字
            text:SetTextColor(RGB("FF0000"))
            text:SetText("欠款：")
            text:Show()
            BG.QianKuan.text = text

            local f=CreateFrame("Frame")
            f:RegisterEvent("TRADE_SHOW")
            f:SetScript("OnEvent", function(self,...)
                if not IsInRaid() then return end
                BG.QianKuan.frame:SetParent(TradeFrame)
                BG.QianKuan.frame:SetPoint("BOTTOM", TradeRecipientMoneyBg, "TOPLEFT", -10, 3)
                BG.QianKuan.frame:Show()            
                BG.QianKuan.edit:SetText("")
            end)
            local f=CreateFrame("Frame")
            f:RegisterEvent("TRADE_CLOSED")
            f:SetScript("OnEvent", function(self,...)
                BG.QianKuan.frame:Hide()
            end)

            _G.TradeFrame:SetScript("OnMouseDown", function(self,enter)
                edit:ClearFocus()
            end)


        end
            -- 交易记录核心
        do
            local bt = CreateFrame("CheckButton", nil, BG.FrameSheZhi, "ChatConfigCheckButtonTemplate")
            bt:SetSize(30, 30)
            bt:SetHitRectInsets(0, -100, 0, 0);
            bt:SetPoint("TOPLEFT", BG.ButtonAutoLoot, "BOTTOMLEFT", 0, 0)
            bt.Text:SetText("<交易自动记账>")
            bt:Show()
            BG.ButtonAutoTrade = bt
            if not BiaoGe.AutoTrade then
                BiaoGe.AutoTrade = 1
                bt:SetChecked(true)
            elseif BiaoGe.AutoTrade == 1 then
                bt:SetChecked(true)
            elseif BiaoGe.AutoTrade == 0 then
                bt:SetChecked(false)
            end
            bt:SetScript("OnClick", function(self)
                if self:GetChecked() then
                    BiaoGe.AutoTrade = 1
                else
                    BiaoGe.AutoTrade = 0
                end
                PlaySound(BG.sound1)
            end)
            -- 鼠标悬停提示
            bt:SetScript("OnEnter", function(self)
                local text = "|cffffffff< 注意事项 >|r\n\n1、需要配合自动记录装备，因为\n    如果表格里没有该交易的装备，\n    则记账失败\n2、一次交易只能记一件装备。\n    如果超过2件装备，则只会记买家，\n    不会记金额\n"
                GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
                GameTooltip:ClearLines();
                GameTooltip:SetText(text)
            end)
            bt:SetScript("OnLeave",function (self)
                GameTooltip:Hide()
            end)

            local frame = CreateFrame("MessageFrame", nil, UIParent)
            --local fonts = frame:SetFont ( "Fonts \\ FRIZQT__.TTF" ,  20 ,  "OUTLINE, MONOCHROME" )
            frame:SetSpacing(1) -- 行间隔
            frame:SetFadeDuration(1) -- 淡出动画的时间
            frame:SetTimeVisible(3) -- 可见时间
            frame:SetJustifyH("LEFT") -- 对齐格式
            frame:SetSize(600,300) -- 大小
            frame:SetPoint("CENTER",UIParent,"CENTER",250,350) --设置显示位置
            frame:SetFont(STANDARD_TEXT_FONT ,  20 , "OUTLINE")
            frame:SetFrameLevel(130)
            frame:SetFrameStrata("HIGH")
            frame:SetHyperlinksEnabled(true)
            BG.FrameTradeMsg = frame
            frame:SetScript("OnHyperlinkEnter", function (self,link,text,button)
                GameTooltip:SetOwner(self, "ANCHOR_CURSOR",0,0);
                GameTooltip:ClearLines()
                local itemID = GetItemInfoInstant(link)
                if itemID then
                GameTooltip:SetItemByID(itemID);
                GameTooltip:Show()
                end
            end)
            frame:SetScript("OnHyperlinkLeave", function (self,link,text,button)
                GameTooltip:Hide()
            end)
            frame:SetScript("OnHyperlinkClick", function (self,link,text,button)
                if IsShiftKeyDown() then
                    _G.ChatFrame1EditBox:Show()
                    _G.ChatFrame1EditBox:SetFocus()
                    _G.ChatFrame1EditBox:Insert(text)
                else
                    ChatFrame_OnHyperlinkShow(self,link,text,button)
                end
            end)

            --每次点交易确定时记录双方交易的金币和物品
            local player,target,targetmoney,playermoney,targetitems,playeritems
            local f=CreateFrame("Frame")
            f:RegisterEvent("TRADE_ACCEPT_UPDATE")
            f:SetScript("OnEvent", function(...)

                target = GetUnitName("NPC", true)
                player = UnitName("player")
                targetmoney = GetTargetTradeMoney()
                playermoney = GetPlayerTradeMoney()
                targetitems = {}
                playeritems = {}

                --只留金币，去除银桐
                if playermoney then
                    playermoney = math.modf(playermoney/10000)
                end
                --只留金币，去除银桐
                if targetmoney then
                    targetmoney = math.modf(targetmoney/10000)
                end

                for i = 1, 6 do
                    local targetitem = GetTradeTargetItemLink(i)
                    local name, texture, quantity, quality, isUsable, enchant = GetTradeTargetItemInfo(i)
                    if quality >= 4 and targetitem then
                        table.insert(targetitems,targetitem)
                    end
                    
                    local playeritem = GetTradePlayerItemLink(i)
                    local name, texture, quantity, quality, isUsable, enchant = GetTradePlayerItemInfo(i)
                    if quality >= 4 and playeritem then
                        table.insert(playeritems,playeritem)
                    end
                end
            end)
            local f=CreateFrame("Frame")
            f:RegisterEvent("UI_INFO_MESSAGE")
            f:SetScript("OnEvent", function(self,event,_,text)
                if text == ERR_TRADE_COMPLETE then
                    if BiaoGe.AutoTrade == 1 and IsInRaid() then
                        Trade(BG.Frame[BG.FB1],target,player,targetmoney,playermoney,targetitems,playeritems,BG.FrameTradeMsg,BiaoGe[BG.FB1],Maxb[BG.FB1],Maxi[BG.FB1])

                    end
                end
            end)
        end
    end

    -- ----------------------------------------------------------------------------
    -- 高亮团长发出的装备
    -- ----------------------------------------------------------------------------
    do
        local f=CreateFrame("Frame")
        f:RegisterEvent("CHAT_MSG_RAID_LEADER")
        f:RegisterEvent("CHAT_MSG_RAID_WARNING")
        f:RegisterEvent("CHAT_MSG_RAID")
        f:SetScript("OnEvent", function(self,even,text,playerName,...)
            if even == "CHAT_MSG_RAID" then
                local a = string.find(playerName,"-")
                if a then
                    playerName = strsub(playerName,1,a-1)
                end
                if playerName ~= BG.MasterLooter then
                    return
                end
            end
            -- 把超链接转换成文字
            local textonly = ""
            local cc = 1
            local aa,bb
            for i = 1, 4, 1 do            
                aa = string.find(text,"|h",cc)
                if aa then
                    bb = string.find(text,"]",aa)
                end
                if bb then
                    cc = bb+10
                end
                if aa and bb then
                    textonly = textonly..strsub(text,aa,bb)
                else
                    break
                end
            end
            -- 开始
            local yes
            for b = 1, Maxb[BG.FB1], 1 do
                for i = 1, Maxi[BG.FB1], 1 do
                    if BG.Frame[BG.FB1]["boss"..b]["zhuangbei"..i] then
                        if BG.Frame[BG.FB1]["boss"..b]["zhuangbei"..i]:GetText() ~= "" then
                            local item = GetItemInfo(BG.Frame[BG.FB1]["boss"..b]["zhuangbei"..i]:GetText())
                            if item then
                                yes = string.find(textonly,item)
                                if yes then
                                    BG.FrameDs[BG.FB1..3]["boss"..b]["ds"..i]:SetColorTexture(1,1,0,0.4)
                                    C_Timer.After(15,function ()
                                        BG.FrameDs[BG.FB1..3]["boss"..b]["ds"..i]:SetColorTexture(1,1,0,0)
                                    end)
                                    if BiaoGe[BG.FB1]["boss"..b]["guanzhu"..i] then
                                        BG.FrameLootMsg:AddMessage(BG.STC_g1("你关注的装备开始拍卖了："..BG.Frame[BG.FB1]["boss"..b]["zhuangbei"..i]:GetText().."（右键取消关注）"))
                                        PlaySoundFile(BG.sound_paimai)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            yes = nil
            for n=1,HopeMaxn[BG.FB1] do
                for b=1,HopeMaxb[BG.FB1] do
                    for i=1,HopeMaxi do
                        if BG.HopeFrame[BG.FB1]["nandu"..n]["boss"..b]["zhuangbei"..i] then
                            local item = GetItemInfo(BG.HopeFrame[BG.FB1]["nandu"..n]["boss"..b]["zhuangbei"..i]:GetText())
                            if item then
                                yes = string.find(textonly,item)
                                if yes then
                                    BG.HopeFrameDs[BG.FB1..3]["nandu"..n]["boss"..b]["ds"..i]:SetColorTexture(1,1,0,0.4)
                                    C_Timer.After(15,function ()
                                        BG.HopeFrameDs[BG.FB1..3]["nandu"..n]["boss"..b]["ds"..i]:SetColorTexture(1,1,0,0)
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    -- ----------------------------------------------------------------------------
    -- 拍卖装备的聊天记录
    -- ----------------------------------------------------------------------------
    do
        BG.FramePaiMaiMsg = CreateFrame("Frame", nil, BG.MainFrame,"BackdropTemplate")
        BG.FramePaiMaiMsg:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 16
        })
        BG.FramePaiMaiMsg:SetBackdropColor(0, 0, 0, 1)
        BG.FramePaiMaiMsg:SetPoint("CENTER")
        BG.FramePaiMaiMsg:SetSize(220,230) -- 大小
        BG.FramePaiMaiMsg:SetFrameLevel(120)
        BG.FramePaiMaiMsg:Hide()
        BG.FramePaiMaiMsg:SetScript("OnMouseUp", function(self)
        end)

        BG.FramePaiMaiMsg2 = CreateFrame("ScrollingMessageFrame", nil, BG.FramePaiMaiMsg)
        BG.FramePaiMaiMsg2:SetSpacing(1) -- 行间隔
        BG.FramePaiMaiMsg2:SetFading(false)
        BG.FramePaiMaiMsg2:SetJustifyH("LEFT") -- 对齐格式
        BG.FramePaiMaiMsg2:SetSize(BG.FramePaiMaiMsg:GetWidth()-15,BG.FramePaiMaiMsg:GetHeight()-15) -- 大小
        BG.FramePaiMaiMsg2:SetPoint("CENTER",BG.FramePaiMaiMsg) --设置显示位置
        BG.FramePaiMaiMsg2:SetMaxLines(1000)
        -- BG.paimaimsgFrame2:SetFontObject(GameTooltipText)
        BG.FramePaiMaiMsg2:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE")
        BG.FramePaiMaiMsg2:SetHyperlinksEnabled(true)
        BG.FramePaiMaiMsg2:SetScript("OnHyperlinkEnter", function (self,link,text,button)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR",0,0);
            GameTooltip:ClearLines()
            local itemID = GetItemInfoInstant(link)
            if itemID then
            GameTooltip:SetItemByID(itemID);
            GameTooltip:Show()
            end
        end)
        BG.FramePaiMaiMsg2:SetScript("OnHyperlinkLeave", function (self,link,text,button)
            GameTooltip:Hide()
        end)
        BG.FramePaiMaiMsg2:SetScript("OnHyperlinkClick", function (self,link,text,button)
            local name,link,quality,level,_,_,_,_,_,_,_,typeID=GetItemInfo(link)
            if IsShiftKeyDown() then
                _G.ChatFrame1EditBox:Show()
                _G.ChatFrame1EditBox:SetFocus()
                _G.ChatFrame1EditBox:Insert(text)
            elseif IsAltKeyDown() then
                for b = 1, Maxb[BG.FB1], 1 do
                    for i = 1, Maxi[BG.FB1], 1 do
                        if BG.Frame[BG.FB1]["boss"..b]["zhuangbei"..i] then
                            if link == select(2,GetItemInfo(BG.Frame[BG.FB1]["boss"..b]["zhuangbei"..i]:GetText())) then
                                BiaoGe[BG.FB1]["boss"..b]["guanzhu"..i] = true
                                BG.Frame[BG.FB1]["boss"..b]["guanzhu"..i]:Show()
                                BG.FrameLootMsg:AddMessage(BG.STC_g2("已成功关注装备："..link.."。团长拍卖此装备时会提醒"))
                                return
                            end
                        end
                    end
                end
            else
                ChatFrame_OnHyperlinkShow(self,link,text,button)
            end
        end)

        local bt = CreateFrame("Button",nil,BG.FramePaiMaiMsg2)   -- 到底
        bt:SetSize(30, 30)
        bt:SetPoint("BOTTOMRIGHT",BG.FramePaiMaiMsg2,"BOTTOMLEFT",-2,-10)
        bt:SetNormalTexture("Interface/ChatFrame/UI-ChatIcon-ScrollEnd-Up")
        bt:SetPushedTexture("Interface/ChatFrame/UI-ChatIcon-ScrollEnd-Down")
        bt:SetDisabledTexture("Interface/ChatFrame/UI-ChatIcon-ScrollEnd-Disabled")
        bt:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight")
        local chatbt = bt
        local texture = bt:CreateTexture(nil, "BACKGROUND") -- 高亮材质
        texture:SetAllPoints()
        texture:SetTexture("Interface/ChatFrame/UI-ChatIcon-BlinkHilight")
        texture:Hide()
        local hilighttexture = texture
        local time = 0
        C_Timer.NewTicker(1,function ()
            if time == 10000 then
                time = 0
            end
            if time%2 == 0  then
                texture:SetAlpha(0)
            else
                texture:SetAlpha(1)
            end
            time = time + 1
        end)
        bt:SetScript("OnClick", function(self)
            self:GetParent():ScrollToBottom()
            hilighttexture:Hide()
        end)
        BG.FramePaiMaiMsg2:SetScript("OnMouseWheel", function(self,delta,...)
            if delta == 1 then
                if IsShiftKeyDown() then
                    BG.FramePaiMaiMsg2:ScrollToTop()
                elseif IsControlKeyDown() then
                    BG.FramePaiMaiMsg2:ScrollUp()
                    BG.FramePaiMaiMsg2:ScrollUp()
                    BG.FramePaiMaiMsg2:ScrollUp()
                    BG.FramePaiMaiMsg2:ScrollUp()
                    BG.FramePaiMaiMsg2:ScrollUp()
                else 
                    BG.FramePaiMaiMsg2:ScrollUp()
                    BG.FramePaiMaiMsg2:ScrollUp()
                end
            elseif delta == -1 then
                if IsShiftKeyDown() then
                    BG.FramePaiMaiMsg2:ScrollToBottom()
                    hilighttexture:Hide()
                elseif IsControlKeyDown() then
                    BG.FramePaiMaiMsg2:ScrollDown()
                    BG.FramePaiMaiMsg2:ScrollDown()
                    BG.FramePaiMaiMsg2:ScrollDown()
                    BG.FramePaiMaiMsg2:ScrollDown()
                    BG.FramePaiMaiMsg2:ScrollDown()
                else
                    BG.FramePaiMaiMsg2:ScrollDown()
                    BG.FramePaiMaiMsg2:ScrollDown()
                    if BG.FramePaiMaiMsg2:AtBottom() then
                        hilighttexture:Hide()
                    end
                end
            end
        end)
        local bt = CreateFrame("Button",nil,BG.FramePaiMaiMsg2)   -- 下滚
        bt:SetSize(30, 30)
        bt:SetPoint("BOTTOM",chatbt,"TOP",0,-8)
        bt:SetNormalTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Up")
        bt:SetPushedTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Down")
        bt:SetDisabledTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Disabled")
        bt:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight")
        local chatbt = bt
        bt:SetScript("OnClick", function(self)
            self:GetParent():ScrollDown()
            self:GetParent():ScrollDown()
            if BG.FramePaiMaiMsg2:AtBottom() then
                hilighttexture:Hide()
            end
        end)
        local bt = CreateFrame("Button",nil,BG.FramePaiMaiMsg2)   -- 上滚
        bt:SetSize(30, 30)
        bt:SetPoint("BOTTOM",chatbt,"TOP",0,-8)
        bt:SetNormalTexture("Interface/ChatFrame/UI-ChatIcon-ScrollUp-Up")
        bt:SetPushedTexture("Interface/ChatFrame/UI-ChatIcon-ScrollUp-Down")
        bt:SetDisabledTexture("Interface/ChatFrame/UI-ChatIcon-ScrollUp-Disabled")
        bt:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight")
        local chatbt = bt
        bt:SetScript("OnClick", function(self)
            self:GetParent():ScrollUp()
            self:GetParent():ScrollUp()
        end)

        -- 监控聊天事件
        local f=CreateFrame("Frame")
        f:RegisterEvent("CHAT_MSG_RAID_WARNING")
        f:RegisterEvent("CHAT_MSG_RAID_LEADER")
        f:SetScript("OnEvent", function(self,even,text,playerName,...)
            local a = string.find(playerName,"-")
            if a then
                playerName = strsub(playerName,1,a-1)
            end
            local msg
            local h,m = GetGameTime()
            h = string.format("%02d",h)
            m = string.format("%02d",m)
            local time = "|cff".."808080".."("..h..":"..m..")|r"
            playerName = GetClassCFF(playerName)
            msg = time.." ".."|cffFF4500[|r"..playerName.."|cff".."FF4500".."]："..text.."|r\n"    -- 团长聊天
            BG.FramePaiMaiMsg2:AddMessage(msg)
            if not BG.FramePaiMaiMsg2:AtBottom() then
                hilighttexture:Show()
            end
        end)

        local f=CreateFrame("Frame")
        f:RegisterEvent("CHAT_MSG_RAID")
        -- f:RegisterEvent("CHAT_MSG_SAY")
        f:SetScript("OnEvent", function(self,even,text,playerName,...)
            local ML
            local a = string.find(playerName,"-")
                if a then
                    playerName = strsub(playerName,1,a-1)
                end
                if playerName == BG.MasterLooter then
                    ML = true
                end
            if string.find(text,"%d+") or string.find(string.lower(text),"p") or ML then
                local msg
                local h,m = GetGameTime()
                h = string.format("%02d",h)
                m = string.format("%02d",m)
                local time = "|cff".."808080".."("..h..":"..m..")|r"
                playerName = GetClassCFF(playerName)
                if ML then
                    msg = time.." ".."|cffFF4500[|r"..playerName.."|cff".."FF4500".."]："..text.."|r\n"    -- 物品分配者聊天
                else
                    msg = time.." ".."|cffFF7F50[|r"..playerName.."|cff".."FF7F50".."]："..text.."|r\n"    -- 团员聊天
                end
                BG.FramePaiMaiMsg2:AddMessage(msg)
                if not BG.FramePaiMaiMsg2:AtBottom() then
                    hilighttexture:Show()
                end
            end
        end)

    end

    -- ----------------------------------------------------------------------------
    -- 点击聊天添加装备
    -- ----------------------------------------------------------------------------
    do
        hooksecurefunc("SetItemRef", function(link)
            local name,link,quality,level,_,_,_,_,_,_,_,typeID=GetItemInfo(link)
            if BG.MainFrame:IsShown() and BG.lastfocuszhuangbei and BG.lastfocuszhuangbei:HasFocus() then
                if BG.FrameZhuangbeiList then
                    BG.FrameZhuangbeiList:Hide()
                end
                BG.lastfocuszhuangbei:SetText(link)
                PlaySound(BG.sound1)
                if BG.lastfocuszhuangbei2 then
                    BG.lastfocuszhuangbei2:SetFocus()
                    if BG.FrameZhuangbeiList then
                        BG.FrameZhuangbeiList:Hide()
                    end
                end
            end
            if IsAltKeyDown() then
                for b = 1, Maxb[BG.FB1], 1 do
                    for i = 1, Maxi[BG.FB1], 1 do
                        if BG.Frame[BG.FB1]["boss"..b]["zhuangbei"..i] then
                            if link == select(2,GetItemInfo(BG.Frame[BG.FB1]["boss"..b]["zhuangbei"..i]:GetText())) then
                                BiaoGe[BG.FB1]["boss"..b]["guanzhu"..i] = true
                                BG.Frame[BG.FB1]["boss"..b]["guanzhu"..i]:Show()
                                BG.FrameLootMsg:AddMessage(BG.STC_g2("已成功关注装备："..link.."。团长拍卖此装备时会提醒"))
                                return
                            end
                        end
                    end
                end
            end
        end)
    end

    -- ----------------------------------------------------------------------------
    -- 清空表格
    -- ----------------------------------------------------------------------------
    do
        local bt = CreateFrame("Button", nil, BG.MainFrame, "UIPanelButtonTemplate")
        bt:SetSize(120, 25)
        bt:SetPoint("BOTTOMLEFT", BG.MainFrame, "BOTTOMLEFT", 30, 30)
        if BG["Frame"..BG.FB1] and BG["Frame"..BG.FB1]:IsVisible() then
            bt:SetText("清空当前表格")
        else
            bt:SetText("清空当前心愿")
        end
        bt:Show()
        BG.ButtonQingKong = bt
        -- 按钮触发
        bt:SetScript("OnClick", function()
            PlaySound(BG.sound1)
            BG.Frame:QingKong(BiaoGe[BG.FB1],BG.FB1,Maxb[BG.FB1],Maxi[BG.FB1],BiaoGeA.Hope[BG.FB1])
            if BG["Frame"..BG.FB1] and BG["Frame"..BG.FB1]:IsVisible() then
                pt(BG.STC_b1("已清空表格< "..BG.FB1.." >"))
            else
                pt(BG.STC_g1("已清空心愿< "..BG.FB1.." >"))
            end
            FrameHide(0)
        end)

        ----------------进副本提示清空表格------------------
        BG.JinBenQingKong = {}
        BG.JinBenQingKong.Button = CreateFrame("Button",nil,UIParent,"BackdropTemplate")
        BG.JinBenQingKong.Button:SetSize(200, 30)
        BG.JinBenQingKong.Button:SetPoint("TOP",UIParent,"TOP",0,-200)
        BG.JinBenQingKong.Button:SetFrameStrata("TOOLTIP")
        BG.JinBenQingKong.Button:SetFrameLevel(200)
        BG.JinBenQingKong.Button:SetNormalFontObject(BG.FontBlue1)
        BG.JinBenQingKong.Button:SetHighlightFontObject(BG.FontHilight)
        BG.JinBenQingKong.Button:Hide()
            -- 窗口变小动画函数
        function BG.ButtonDongHua(button)
            local w1 = button:GetWidth()
            local Time = 4
            local T = 500
            local t1 = Time/T
            for i = T , 2 ,-1 do
                C_Timer.After(t1,function ()
                    button:SetWidth(w1*((i-1)/T))
                end)
                t1 = t1 + Time/T
            end
        end
            -- 窗口变小动画
        BG.JinBenQingKong.DongHua = CreateFrame("Button",nil,BG.JinBenQingKong.Button,"BackdropTemplate")
        BG.JinBenQingKong.DongHua:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        })
        BG.JinBenQingKong.DongHua:SetBackdropColor(0,0.75,1,0.7)
        BG.JinBenQingKong.DongHua:SetSize(BG.JinBenQingKong.Button:GetSize())
        BG.JinBenQingKong.DongHua:SetPoint("TOPLEFT",BG.JinBenQingKong.Button,"TOPLEFT",0,0)
        BG.JinBenQingKong.DongHua:SetFrameLevel(119)
        BG.JinBenQingKong.DongHua:SetScript("OnSizeChanged",function (self,Width,Height)
            local w = string.format("%u",Width)
            if w == "0" then
                C_Timer.After(0.2,function ()
                    BG.JinBenQingKong.DongHua:GetParent():Hide()
                end)
            end
        end)

        StaticPopupDialogs["QINGKONGBIAOGE"] = {
            text = "确认清空表格？",
            button1 = "是",
            button2 = "否",
            OnAccept = function()
                if BG.FB2 then
                    BG.Frame:QingKong(BiaoGe[BG.FB2],BG.FB2,Maxb[BG.FB2],Maxi[BG.FB2])
                    pt(BG.STC_b1("已清空表格< "..BG.FB2.." >"))
                end
            end,
            OnCancel = function ()
            end,
            timeout = 3,
            whileDead = true,
            hideOnEscape = true,
        }

        BG.JinBenQingKong.Button:SetScript("OnClick",function ()
            StaticPopup_Show("QINGKONGBIAOGE")
        end)
        
    end

    ------------------金额自动加0------------------
    do
        local bt = CreateFrame("CheckButton", nil, BG.FrameSheZhi, "ChatConfigCheckButtonTemplate")
        bt:SetSize(30, 30)
        bt:SetHitRectInsets(0, -100, 0, 0);
        bt:SetPoint("TOPLEFT", BG.ButtonAutoTrade, "BOTTOMLEFT", 0, 0)
        bt.Text:SetText("<金额自动加零>")
        bt:Show()
        BG.ButtonAutoJine0 = bt
        if not BiaoGe.AutoJine0 then
            BiaoGe.AutoJine0 = 1
            bt:SetChecked(true)
        elseif BiaoGe.AutoJine0 == 1 then
            bt:SetChecked(true)
        elseif BiaoGe.AutoJine0 == 0 then
            bt:SetChecked(false)
        end
        bt:SetScript("OnClick", function(self)
            if self:GetChecked() then
                BiaoGe.AutoJine0 = 1
            else
                BiaoGe.AutoJine0 = 0
            end
            PlaySound(BG.sound1)
        end)
        -- 鼠标悬停提示
        bt:SetScript("OnEnter", function(self)
            local text = "|cffffffff< 注意事项 >|r\n\n1、输入金额和欠款时自动加两个0\n"
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
            GameTooltip:ClearLines();
            GameTooltip:SetText(text)
        end)
        bt:SetScript("OnLeave",function (self)
            GameTooltip:Hide()
        end)
    end

    ------------------界面缩放------------------
    do
        BG.SuoFang = {}
            -- 添加文字"UI缩放"
        local f = BG.FrameSheZhi:CreateFontString()
        f:SetPoint("TOPLEFT", BG.ButtonAutoJine0, "BOTTOM",15,-15)
        f:SetFontObject(GameFontNormal)
        f:SetText("|cffFFFFFF<UI缩放>|r")
        f:Show()
        local s = f
        BG.SuoFang.BiaoTi = f
            -- 滑块
        local f = CreateFrame("Slider", nil, BG.FrameSheZhi, "OptionsSliderTemplate")
        f:SetSize(100, 15)
        f:SetPoint("TOP", s, "BOTTOM", 0, -3)
        f:Show()
        f:SetMinMaxValues(0.7,1.3)
        f:SetValueStep(0.1)     -- 设置滑块在拖动时是否将值限制为值步长
        f:SetObeyStepOnDrag(true)
        if not BiaoGe.Scale then
            BiaoGe.Scale = 1
        end
        f:SetValue(BiaoGe.Scale)
        BG.MainFrame:SetScale(BiaoGe.Scale)
        BG.SuoFang.HuaKuai = f
            -- 添加滑块的数字显示
        local num = BG.FrameSheZhi:CreateFontString()
        num:SetPoint("CENTER", f, "CENTER", 0, -15)
        num:SetFontObject(GameFontNormal)
        num:SetText(BiaoGe.Scale)
        num:Show()
            -- 按键触发
        f:SetScript("OnValueChanged", function(self,value)
            value = string.format("%.1f",value)
            BiaoGe.Scale = value
            num:SetText(BiaoGe.Scale)
        end)
        f:SetScript("OnMouseUp", function(self)
            BG.MainFrame:SetScale(BiaoGe.Scale)            
            PlaySound(BG.sound1)
        end)
        BG.SuoFang.ShuZi = f
    end

    ------------------UI透明度------------------
    do
        BG.TouMing = {}
            -- 添加文字"UI透明度"
        local f = BG.FrameSheZhi:CreateFontString()
        f:SetPoint("TOP", BG.SuoFang.ShuZi, "BOTTOM",0,-40)
        f:SetFontObject(GameFontNormal)
        f:SetText("|cffFFFFFF<UI透明度>|r")
        f:Show()
        local s = f
        BG.TouMing.BiaoTi = f
            -- 滑块
        local f = CreateFrame("Slider", nil, BG.FrameSheZhi, "OptionsSliderTemplate")
        f:SetSize(100, 15)
        f:SetPoint("TOP", s, "BOTTOM", 0, -3)
        f:Show()
        f:SetMinMaxValues(0.6,1)
        f:SetValueStep(0.05)     -- 设置滑块在拖动时是否将值限制为值步长
        f:SetObeyStepOnDrag(true)
        if not BiaoGe.Alpha then
            BiaoGe.Alpha = 1
        end
        f:SetValue(BiaoGe.Alpha)
        BG.MainFrame:SetAlpha(BiaoGe.Alpha)
        BG.TouMing.HuaKuai = f
            -- 添加滑块的数字显示
        local num = BG.FrameSheZhi:CreateFontString()
        num:SetPoint("CENTER", f, "CENTER", 0, -15)
        num:SetFontObject(GameFontNormal)
        num:SetText(BiaoGe.Alpha)
        num:Show()
            -- 按键触发
        f:SetScript("OnValueChanged", function(self,value)
            value = string.format("%.2f",value)
            BiaoGe.Alpha = tonumber(value)
            num:SetText(BiaoGe.Alpha)
        end)
        f:SetScript("OnMouseUp", function(self)
            BG.MainFrame:SetAlpha(BiaoGe.Alpha)
            PlaySound(BG.sound1)
        end)
        BG.TouMing.ShuZi = f
    end

    -- 生成各副本UI    
    BG.ICCUI("ICC")
    BG.TOCUI("TOC")
    BG.ULDUI("ULD")
    BG.NAXXUI("NAXX")

    -- 生成心愿UI    
    BG.HopeUI("ICC",Maxb)
    BG.HopeUI("TOC",Maxb)
    BG.HopeUI("ULD",Maxb)
    BG.HopeUI("NAXX",Maxb)

    BG.HistoryUI()
    
    ------------------检查版本过期------------------
    do
        C_Timer.After(3,function ()
            local guoqi
            local function VerGuoQi(BGVer,ver)      -- 如果版本过期则反馈true
                local BGVer = string.gsub(BGVer,"v","")
                BGVer = string.gsub(BGVer,"%.","")
                local ver = string.gsub(ver,"v","")
                ver = string.gsub(ver,"%.","")
                if tonumber(BGVer) and tonumber(ver) then
                    if tonumber(ver) > tonumber(BGVer) then
                        return true
                    end
                end
            end
            
            local function SendVerCheck(channel)    -- 发送版本请求
                C_ChatInfo.SendAddonMessage("BiaoGe", "VersionCheck", channel)
            end
            
            local f=CreateFrame("Frame")
            f:RegisterEvent("CHAT_MSG_ADDON")
            f:SetScript("OnEvent", function (self,even,...)
                if guoqi then return end
                local prefix, msg, distType, sender = ...
                if prefix == "BiaoGe" then
                    local sendername = strsplit("-", sender)
                    local playername = UnitName("player")
                    if sendername == playername then return end
                    if msg == "VersionCheck" then
                        C_ChatInfo.SendAddonMessage("BiaoGe", "MyVer-"..BG.Ver, distType)
                    elseif strfind(msg, "MyVer") then
                        local _, version = strsplit("-", msg)
                        if VerGuoQi(BG.Ver,version) then
                            pt("|cff00BFFF< BiaoGe > 版本过期提醒，最新版本是："..BG.STC_g1(version).."，你的当前版本是："..BG.STC_r1(BG.Ver))
                            pt("|cff00BFFF你可以前往curseforge搜索biaoge更新")
                            BG.ShuoMingShuText:SetText("<说明书与更新记录> "..BG.STC_r1(BG.Ver))
                            guoqi = true
                        end
                    end
                end
            end)
            
            local channel
            if IsInRaid() then
                channel = "RAID"
            elseif IsInGuild() then
                channel = "GUILD"
            end
            if channel then 
                SendVerCheck(channel) 
            end
        end)
    end
end



------------------插件载入------------------
do
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("ADDON_LOADED")
    frame:SetScript("OnEvent", function(self, event, addonName)
        if addonName == "BiaoGe" then
            BiaoGeUI()
            C_Timer.After(1,function ()
                print("|cff00BFFF< BiaoGe > 金团表格载入成功：/biaoge 或 /bge|r")
            end)
        end
    end)

    ------------------插件命令------------------
    SlashCmdList["BIAOGE"] = function()
        if BG.MainFrame and not BG.MainFrame:IsVisible() then
            BG.MainFrame:Show()
        else
            BG.MainFrame:Hide()
        end
    end
    SLASH_BIAOGE1 = "/biaoge"
    SLASH_BIAOGE2 = "/bge"

    -- 测试用
    SlashCmdList["BIAOGETEST"] = function()
        if BG.DeBugLoot then
            BG.DeBug = true
            BG.FB2 = "ULD"
            BG.DeBugLoot()
        end
    end
    SLASH_BIAOGETEST1 = "/bgdebug"
end

--AD：粉
--LD：橙
--ED：紫
--RD：蓝
--UD：绿
--CD：灰


--[[

    全局变量：
    BiaoGe       数据库
    BG.Frame      数据库对应的框体
    BG.FrameDs[FB..1]、BG.FrameDs[FB..2]、BG.FrameDs[FB..3]       底色高亮框体
    BG.FrameMaijiaList      买家下拉列表框体
    BG.FrameULD、BG.FrameTOC、、BG.FrameICC        窗口名字

    BG.lastfocuszhuangbei、BG.lastfocuszhuangbei2、BG.lastfocus      最后的光标
    BiaoGeULDUI、BiaoGeTOCUI、BiaoGeICCUI     读取副本UI

    FB1     是UI当前选择的副本
    FB2     是玩家当前所处的副本

    ]]

    -- pt(date())