local _, ADDONSELF = ...

local pt = print
------------------函数：是否空表------------------
local function Size(t)
    local s = 0;
    for k, v in pairs(t) do
        if v ~= nil then s = s + 1 end
    end
    return s;
end
ADDONSELF.Size = Size
------------------函数：第几个BOSS------------------
local function BossNum(FB,b,t)
    local back = 0
    if FB == "ICC" then
        if t == 1 then
            t = 0
        elseif t == 2 then
            t = 6
        elseif t == 3 then
            t = 12
        end
    elseif FB == "TOC" then
        if t == 1 then
            t = 0
        elseif t == 2 then
            t = 5
        elseif t == 3 then
            t = 8
        end
    elseif FB == "ULD" then
        if t == 1 then
            t = 0
        elseif t == 2 then
            t = 6
        elseif t == 3 then
            t = 12
        elseif t == 4 then
            t = 16
        end
    elseif FB == "NAXX" then
        if t == 1 then
            t = 0
        elseif t == 2 then
            t = 6
        elseif t == 3 then
            t = 12
        elseif t == 4 then
            t = 16
        end
    end    
    back = b + t
    return back
end
ADDONSELF.BossNum = BossNum

------------------函数：把16进制颜色转换成0-1RGB------------------
local function RGB(hex)
    local red = string.sub(hex, 1, 2)
    local green = string.sub(hex, 3, 4)
    local blue = string.sub(hex, 5, 6)
 
    red = tonumber(red, 16)/255
    green = tonumber(green, 16)/255
    blue = tonumber(blue, 16)/255
    return red,green,blue
end
ADDONSELF.RGB = RGB

------------------函数：获取名字的职业颜色RGB------------------
local function GetClassRGB(name)
    local _,class = UnitClass(name)
    local c1,c2,c3
    if class then
        c1,c2,c3 = GetClassColor(class)
    end
    return c1,c2,c3
end
ADDONSELF.GetClassRGB = GetClassRGB

------------------函数：获取名字的职业颜色CFF代码（|cffFFFFFF名字|r）------------------
local function GetClassCFF(name)
    local _,class = UnitClass(name)
    local c4 = ""
    if class then
        c4 = select(4,GetClassColor(class))
        c4 = "|c"..c4..name.."|r"
        return c4
    else
        return name
    end
end
ADDONSELF.GetClassCFF = GetClassCFF

------------------函数：总收入------------------
local function Sumjine(BiaoGeFB,MaxbFB,MaxiFB)
    local sum = 0
    local n = 0
    for b = 1, MaxbFB, 1 do
        for i = 1, MaxiFB, 1 do
            if BiaoGeFB["boss"..b]["jine"..i] then
                n = tonumber(BiaoGeFB["boss"..b]["jine"..i])
                if n then
                    sum = sum + n
                end
            end

        end                
    end
    return sum
end
ADDONSELF.Sumjine = Sumjine

------------------函数：总支出------------------
local function SumZC(BiaoGeFB,MaxbFB,MaxiFB)
    local sum = 0
    local n = 0
    for i = 1, MaxiFB, 1 do
        if BiaoGeFB["boss"..MaxbFB+1]["jine"..i] then
            n = tonumber(BiaoGeFB["boss"..MaxbFB+1]["jine"..i])
            if n then
                sum = sum + n
            end
        end
    end
    return sum
end
ADDONSELF.SumZC = SumZC

------------------函数：净收入------------------
local function SumJ(BiaoGeFB,MaxbFB,MaxiFB)
    local jing = 0
    local n1 = tonumber(BiaoGeFB["boss"..MaxbFB+2]["jine1"])
    local n2 = tonumber(BiaoGeFB["boss"..MaxbFB+2]["jine2"])
    if n1 and n2 then
        jing = n1 - n2
    end
    return jing
end
ADDONSELF.SumJ = SumJ

------------------函数：人均工资------------------
local function SumGZ(BiaoGeFB,MaxbFB,MaxiFB)
    local gz = 0
    local n1 = tonumber(BiaoGeFB["boss"..MaxbFB+2]["jine3"])
    local n2 = tonumber(BiaoGeFB["boss"..MaxbFB+2]["jine4"])
    if n1 and n2 then
        gz = math.modf(n1 / n2)
    end
    return gz
end
ADDONSELF.SumGZ = SumGZ

------------------函数：通报账单------------------
local function TongBao(BiaoGeFB,MaxbFB,MaxiFB)
    ------------------装备------------------
    local TongBaozhuangbei1 = {}
    local TongBaojine1 = {}
    for b = 1, MaxbFB-1, 1 do     -- 把数据先导入表格1
        for i = 1, MaxiFB, 1 do
            if BiaoGeFB["boss"..b]["zhuangbei"..i] then
                if BiaoGeFB["boss"..b]["zhuangbei"..i] ~= "" and not tonumber(BiaoGeFB["boss"..b]["zhuangbei"..i]) and tonumber(BiaoGeFB["boss"..b]["jine"..i]) then
                    table.insert(TongBaozhuangbei1,BiaoGeFB["boss"..b]["zhuangbei"..i])
                    table.insert(TongBaojine1,tonumber(BiaoGeFB["boss"..b]["jine"..i]))
                end
            end
        end
    end

    local TongBaozhuangbei2 = {}
    local TongBaojine2 = {}
    for t=1,#TongBaojine1 do      -- 找到表格1里最小的数值
        local max = nil
        for k,v in ipairs(TongBaojine1) do
            if tonumber(v) and v ~= 0 then
                if max == nil then
                    max=v
                end
                if max < v then
                    max = v
                end
            end
        end
        if not max then
            break
        end
        --pt(min)
        for i = 1, #TongBaojine1 do     -- 把该最小数值所对应的金额和装备导入表格2
            if TongBaojine1[i] == max then
                table.insert(TongBaozhuangbei2,TongBaozhuangbei1[i])
                table.insert(TongBaojine2,TongBaojine1[i])
                table.remove(TongBaozhuangbei1,i)        -- 删掉表格1里的这个装备
                table.remove(TongBaojine1,i)        -- 删掉表格1里的这个金额
            end
        end
    end
    return TongBaozhuangbei2,TongBaojine2
end
ADDONSELF.TongBao = TongBao

------------------函数：通报消费排名-----------------
local function XiaoFei(BiaoGeFB,MaxbFB,MaxiFB)
    local XiaoFei1 = {}    -- 消费列表（买家，金额）
    local XiaoFei2 = {}    -- 买家名字
    local XiaoFei3 = {}    -- 个人消费合计
    local XiaoFei4 = {}    -- 排序后的个人消费合计
    local num = 1
    for b=1,MaxbFB do
        for i=1,MaxiFB do
            if BiaoGeFB["boss"..b]["maijia"..i] then
                if BiaoGeFB["boss"..b]["maijia"..i] ~= "" then
                    if not XiaoFei1[num] then
                        XiaoFei1[num] = {}
                    end
                    local jine = BiaoGeFB["boss"..b]["jine"..i]
                    if jine == "" then
                        jine = 0
                    end
                    table.insert(XiaoFei1[num],BiaoGeFB["boss"..b]["maijia"..i])
                    table.insert(XiaoFei1[num],jine)
                    num = num + 1
                    if Size(XiaoFei2) == 0 then
                        table.insert(XiaoFei2,BiaoGeFB["boss"..b]["maijia"..i])
                    else
                        local yes = true
                        for index, value in ipairs(XiaoFei2) do
                            if value == BiaoGeFB["boss"..b]["maijia"..i] then
                                yes = false
                            end
                        end
                        if yes then
                            table.insert(XiaoFei2,BiaoGeFB["boss"..b]["maijia"..i])
                        end
                    end
                end
            end
        end
    end
    for ii=1,#XiaoFei2 do
        local sum = 0
        for i=1,#XiaoFei1 do
            if XiaoFei2[ii] == XiaoFei1[i][1] then
                sum = sum + XiaoFei1[i][2]
            end
        end
        if not XiaoFei3[ii] then
            XiaoFei3[ii] = {}
        end
        table.insert(XiaoFei3[ii],XiaoFei2[ii])
        table.insert(XiaoFei3[ii],sum)
    end

    for t=1,#XiaoFei3 do          -- 找到最大数值
        local max = nil
        for k,v in ipairs(XiaoFei3) do
            if max == nil then
                max=v[2]
            end
            if max < v[2] then
                max = v[2]
            end
        end
        if not max then
            break
        end
        for i = 1, #XiaoFei3 do
            if XiaoFei3[i][2] == max then
                if not XiaoFei4[t] then
                    XiaoFei4[t] = {}
                end
                table.insert(XiaoFei4[t],XiaoFei3[i][1])
                table.insert(XiaoFei4[t],XiaoFei3[i][2])

                table.remove(XiaoFei3,i)
                break
            end
        end
    end
    return XiaoFei4
end
ADDONSELF.XiaoFei = XiaoFei

------------------函数：通报欠款-----------------
local function QianKuan(BiaoGeFB,MaxbFB,MaxiFB)
    local QianKuan1 = {}    -- 欠款列表（装备，买家，欠款）
    local QianKuan2 = {}    -- 欠款的买家名字
    local QianKuan3 = {}    -- 个人欠款合计
    local num = 1
    for b=1,MaxbFB do
        for i=1,MaxiFB do
            if BiaoGeFB["boss"..b]["qiankuan"..i] then
                if BiaoGeFB["boss"..b]["qiankuan"..i] ~= "" and BiaoGeFB["boss"..b]["qiankuan"..i] ~= "0" then
                    if not QianKuan1[num] then
                        QianKuan1[num] = {}
                    end
                    table.insert(QianKuan1[num],BiaoGeFB["boss"..b]["zhuangbei"..i])
                    table.insert(QianKuan1[num],BiaoGeFB["boss"..b]["maijia"..i])
                    table.insert(QianKuan1[num],BiaoGeFB["boss"..b]["qiankuan"..i])
                    num = num + 1
                    if Size(QianKuan2) == 0 then
                        table.insert(QianKuan2,BiaoGeFB["boss"..b]["maijia"..i])
                    else
                        local yes = true
                        for index, value in ipairs(QianKuan2) do
                            if value == BiaoGeFB["boss"..b]["maijia"..i] then
                                yes = false
                            end
                        end
                        if yes then
                            table.insert(QianKuan2,BiaoGeFB["boss"..b]["maijia"..i])
                        end
                    end
                end
            end
        end
    end
    for ii=1,#QianKuan2 do
        local sum = 0
        for i=1,#QianKuan1 do
            if QianKuan2[ii] == QianKuan1[i][2] then
                sum = sum + QianKuan1[i][3]
            end
        end
        if not QianKuan3[ii] then
            QianKuan3[ii] = {}
        end
        table.insert(QianKuan3[ii],QianKuan2[ii])
        table.insert(QianKuan3[ii],sum)
    end
    return QianKuan1,QianKuan3
end
ADDONSELF.QianKuan = QianKuan
------------------函数：买家按职业排序-----------------
local function Classpx()
    local Classpxname1 = {}
    local Classpxclass1 = {}
    local Classpxid = {}
    local num = GetNumGroupMembers()
    local raid
    for i = 1, num, 1 do
        raid = "raid"..i
        local name = UnitName(raid)
        local _,class,id = UnitClass(raid)
        table.insert(Classpxname1,name)      -- 保存名字
        table.insert(Classpxclass1,class)       -- 保存职业
        table.insert(Classpxid,id)       -- 保存职业ID
    end

    local Classpxname2 = {}
    local Classpxclass2 = {}
    for i = 1, num, 1 do
        if Classpxid[i] == 6 then       -- DK
            table.insert(Classpxname2,Classpxname1[i])
            table.insert(Classpxclass2,Classpxclass1[i])
        end
    end
    for i = 1, num, 1 do
        if Classpxid[i] == 2 then       -- QS
            table.insert(Classpxname2,Classpxname1[i])
            table.insert(Classpxclass2,Classpxclass1[i])
        end
    end
    for i = 1, num, 1 do
        if Classpxid[i] == 1 then       -- ZS
            table.insert(Classpxname2,Classpxname1[i])
            table.insert(Classpxclass2,Classpxclass1[i])
        end
    end
    for i = 1, num, 1 do
        if Classpxid[i] == 7 then       -- SM
            table.insert(Classpxname2,Classpxname1[i])
            table.insert(Classpxclass2,Classpxclass1[i])
        end
    end
    for i = 1, num, 1 do
        if Classpxid[i] == 3 then       -- LR
            table.insert(Classpxname2,Classpxname1[i])
            table.insert(Classpxclass2,Classpxclass1[i])
        end
    end
    for i = 1, num, 1 do
        if Classpxid[i] == 11 then       -- XD
            table.insert(Classpxname2,Classpxname1[i])
            table.insert(Classpxclass2,Classpxclass1[i])
        end
    end
    for i = 1, num, 1 do
        if Classpxid[i] == 4 then       -- DZ
            table.insert(Classpxname2,Classpxname1[i])
            table.insert(Classpxclass2,Classpxclass1[i])
        end
    end
    for i = 1, num, 1 do
        if Classpxid[i] == 8 then       -- FS
            table.insert(Classpxname2,Classpxname1[i])
            table.insert(Classpxclass2,Classpxclass1[i])
        end
    end
    for i = 1, num, 1 do
        if Classpxid[i] == 9 then       -- SS
            table.insert(Classpxname2,Classpxname1[i])
            table.insert(Classpxclass2,Classpxclass1[i])
        end
    end
    for i = 1, num, 1 do
        if Classpxid[i] == 5 then       -- MS
            table.insert(Classpxname2,Classpxname1[i])
            table.insert(Classpxclass2,Classpxclass1[i])
        end
    end
    return Classpxname2,Classpxclass2
end
ADDONSELF.Classpx = Classpx

------------------函数：买家下拉列表------------------    
local function Listmaijia(maijia)  
    -- 背景框
    BG.FrameMaijiaList = CreateFrame("Frame", nil, BG.MainFrame, "BackdropTemplate");
    BG.FrameMaijiaList:SetWidth(300);
    BG.FrameMaijiaList:SetHeight(230);
    BG.FrameMaijiaList:SetFrameLevel(120)
    BG.FrameMaijiaList:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16
    })
    BG.FrameMaijiaList:SetBackdropColor(0, 0, 0, 1)
    BG.FrameMaijiaList:SetPoint("TOPLEFT",maijia,"BOTTOMLEFT",-9,2);
    BG.FrameMaijiaList:Show()
    BG.FrameMaijiaList:SetScript("OnMouseUp", function(self)
    end)
    -- 聊天记录
    if BG.FramePaiMaiMsg then
        BG.FramePaiMaiMsg:SetParent(BG.FrameMaijiaList)
        BG.FramePaiMaiMsg:ClearAllPoints()
        BG.FramePaiMaiMsg:SetPoint("TOPRIGHT",BG.FrameMaijiaList,"TOPLEFT",0,0)
        BG.FramePaiMaiMsg:Show()
        BG.FramePaiMaiMsg2:ScrollToBottom()
    end

    -- 下拉列表
    local framedown
    local frameright = BG.FrameMaijiaList
    local Classpxname,Classpxclass = Classpx()
    for t=1,3 do
        for i=1,10 do
            local button=CreateFrame("EditBox",nil,BG.FrameMaijiaList,"InputBoxTemplate")
            button:SetSize(90, 20)
            button:SetFrameLevel(125)
            if t >= 2 and i == 1 then
                button:SetPoint("TOPLEFT", frameright, "TOPLEFT", 97, 0)
                frameright = button
            end
            if t == 1 and i == 1 then
                button:SetPoint("TOPLEFT", frameright, "TOPLEFT", 10, -5)
                frameright = button
            end
            if i > 1 then
                button:SetPoint("TOPLEFT", framedown, "BOTTOMLEFT", 0, -2)
            end
            if Classpxname then
                if Classpxname[(t-1)*10+i] then
                    button:SetText(Classpxname[(t-1)*10+i])
                end
                if Classpxname[(t-1)*10+i] then
                    button:SetTextColor(GetClassRGB(Classpxname[(t-1)*10+i]))
                end
            end
            button:Show()
            -- 点击名字时触发
            button:SetScript("OnMouseDown", function(self,enter)
                if enter == "RightButton" then  -- 右键清空格子
                    if BG.lastfocus then
                        BG.lastfocus:ClearFocus()
                    end
                    return
                end
                if Classpxname then
                    if Classpxname[(t-1)*10+i] then
                        maijia:SetText(Classpxname[(t-1)*10+i])
                        maijia:SetTextColor(GetClassRGB(Classpxname[(t-1)*10+i]))
                        -- maijia:ClearFocus()
                    end
                end
                BG.FrameMaijiaList:Hide()
            end)
            framedown = button
        end
    end
end
ADDONSELF.Listmaijia = Listmaijia

------------------函数：装备下拉列表------------------    
local function Listzhuangbei(zhuangbei,bossnum,FB,BiaoGeguanzhu,BGFrameguanzhu,hopenandu)  
    local p = GetRaidDifficultyID()
    local nandu
    local lootlink = {}
    local lootlevel = {}
    if p == 3 or p == 175 then
        nandu = "P10"
    elseif p == 4 or p == 176 then
        nandu = "P25"
    elseif p == 5 or p == 193 then
        nandu = "H10"
    elseif p == 6 or p == 194 then
        nandu = "H25"
    end
    if hopenandu then
        if hopenandu == 1 then
            nandu = "P10"
        elseif hopenandu == 2 then
            nandu = "P25"
        elseif hopenandu == 3 then
            nandu = "H10"
        elseif hopenandu == 4 then
            nandu = "H25"
        end
    end
    -- pt(FB,nandu)
    if BG.Loot[FB][nandu] then
        if BG.Loot[FB][nandu]["boss"..bossnum] then
            local sum = #BG.Loot[FB][nandu]["boss"..bossnum]
            for index, value in ipairs(BG.Loot[FB][nandu]["boss"..bossnum]) do
                local name,link,quality,level,_,_,_,_,_,_,_,typeID=GetItemInfo(value)
                table.insert(lootlink,link)
                table.insert(lootlevel,level)
            end
            -- 背景框    
            BG.FrameZhuangbeiList = CreateFrame("Frame", nil, BG.MainFrame, "BackdropTemplate");
            BG.FrameZhuangbeiList:SetWidth(480);
            BG.FrameZhuangbeiList:SetHeight(230);
            BG.FrameZhuangbeiList:SetFrameLevel(120)
            BG.FrameZhuangbeiList:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                edgeSize = 16
            })
            BG.FrameZhuangbeiList:SetBackdropColor(0, 0, 0, 1)
            BG.FrameZhuangbeiList:SetPoint("TOPLEFT",zhuangbei,"BOTTOMLEFT",-9,2);
            BG.FrameZhuangbeiList:Show()
            BG.FrameZhuangbeiList:SetScript("OnMouseUp", function(self)
            end);
            -- 提示文字
            local text = BG.FrameZhuangbeiList:CreateFontString()
            text:SetPoint("TOPLEFT",BG.FrameZhuangbeiList,"BOTTOMLEFT",3,0)
            -- text:SetFontObject(GameFontNormal)    -- 普通设置方法
            text:SetFont(STANDARD_TEXT_FONT,14,"OUTLINE")       -- 游戏主界面文字
            if hopenandu then
                text:SetText(BG.STC_b1("（ALT+点击可设置为已掉落，SHIFT+点击可发送装备）"))
            else
                text:SetText(BG.STC_b1("（ALT+点击可关注装备，SHIFT+点击可发送装备）"))
            end
            -- 下拉列表
            local framedown
            local frameright = BG.FrameZhuangbeiList

            if #lootlink == sum then
                for t=1,3 do
                    for i=1,10 do
                        local button=CreateFrame("EditBox",nil,BG.FrameZhuangbeiList,"InputBoxTemplate")
                        button:SetSize(150, 20)
                        button:SetFrameLevel(125)
                        local icon = button:CreateTexture(nil, 'ARTWORK')
                        icon:SetPoint('LEFT', -4, 0)
                        icon:SetSize(16, 16)
                        if t >= 2 and i == 1 then
                            button:SetPoint("TOPLEFT", frameright, "TOPLEFT", 157, 0)
                            frameright = button
                        end
                        if t == 1 and i == 1 then
                            button:SetPoint("TOPLEFT", frameright, "TOPLEFT", 10, -5)
                            frameright = button
                        end
                        if i > 1 then
                            button:SetPoint("TOPLEFT", framedown, "BOTTOMLEFT", 0, -2)
                        end
                        if lootlink[(t-1)*10+i] then
                            button:SetText(lootlink[(t-1)*10+i].."|cff".."9370DB".."("..lootlevel[(t-1)*10+i]..")")
                            button:SetTextInsets(14,0,0,0)
                            local itemID = select(1, GetItemInfoInstant(lootlink[(t-1)*10+i]))
                            local itemIcon = GetItemIcon(itemID)
                            if itemIcon then
                                icon:SetTexture(itemIcon)
                            else
                                icon:SetTexture("nil")
                            end
                        end
                        button:Show()
                        -- 鼠标悬停在装备时
                        button:SetScript("OnEnter", function(self) 
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT",-50,0);
                            GameTooltip:ClearLines();
                            local Link = button:GetText()
                            local itemID = select(1, GetItemInfoInstant(Link))
                            if itemID then
                            GameTooltip:SetItemByID(itemID);
                            GameTooltip:Show()
                            end
                        end)
                        button:SetScript("OnLeave", function(self) 
                            GameTooltip:Hide() 
                        end)
                        -- 点击时触发
                        button:SetScript("OnMouseDown", function(self,enter)
                            if enter == "RightButton" then  -- 右键清空格子
                                if BG.lastfocus then
                                    BG.lastfocus:ClearFocus()
                                end
                                return
                            end
                            if lootlink[(t-1)*10+i] then
                                if IsShiftKeyDown() then
                                    _G.ChatFrame1EditBox:Show()
                                    _G.ChatFrame1EditBox:SetFocus()
                                    _G.ChatFrame1EditBox:Insert(lootlink[(t-1)*10+i])
                                    zhuangbei:ClearFocus()
                                    return
                                end
                                zhuangbei:SetText(lootlink[(t-1)*10+i])
                                if IsAltKeyDown() then
                                    BiaoGeguanzhu = true
                                    BGFrameguanzhu:Show()
                                end
                            end
                            BG.FrameZhuangbeiList:Hide()
                            zhuangbei:ClearFocus()
                        end)
                        framedown = button
                    end
                end
            else
                C_Timer.After(0.2,function ()
                    lootlink = {}
                    lootlevel = {}
                    for index, value in ipairs(BG.Loot[FB][nandu]["boss"..bossnum]) do
                        local name,link,quality,level,_,_,_,_,_,_,_,typeID=GetItemInfo(value)
                        table.insert(lootlink,link)
                        table.insert(lootlevel,level)
                    end
                    for t=1,3 do
                        for i=1,10 do
                            local button=CreateFrame("EditBox",nil,BG.FrameZhuangbeiList,"InputBoxTemplate")
                            button:SetSize(150, 20)
                            button:SetFrameLevel(125)
                            local icon = button:CreateTexture(nil, 'ARTWORK')
                            icon:SetPoint('LEFT', -4, 0)
                            icon:SetSize(16, 16)
                            if t >= 2 and i == 1 then
                                button:SetPoint("TOPLEFT", frameright, "TOPLEFT", 157, 0)
                                frameright = button
                            end
                            if t == 1 and i == 1 then
                                button:SetPoint("TOPLEFT", frameright, "TOPLEFT", 10, -5)
                                frameright = button
                            end
                            if i > 1 then
                                button:SetPoint("TOPLEFT", framedown, "BOTTOMLEFT", 0, -2)
                            end
                            if lootlink[(t-1)*10+i] then
                                button:SetText(lootlink[(t-1)*10+i].."|cff".."9370DB".."("..lootlevel[(t-1)*10+i]..")")
                                button:SetTextInsets(14,0,0,0)
                                local itemID = select(1, GetItemInfoInstant(lootlink[(t-1)*10+i]))
                                local itemIcon = GetItemIcon(itemID)
                                if itemIcon then
                                    icon:SetTexture(itemIcon)
                                else
                                    icon:SetTexture("nil")
                                end
                            end
                            button:Show()
                            -- 鼠标悬停在装备时
                            button:SetScript("OnEnter", function(self) 
                                GameTooltip:SetOwner(self, "ANCHOR_RIGHT",-70,0);
                                GameTooltip:ClearLines();
                                local Link = button:GetText()
                                local itemID = select(1, GetItemInfoInstant(Link))
                                if itemID then
                                GameTooltip:SetItemByID(itemID);
                                GameTooltip:Show()
                                end
                            end)
                            button:SetScript("OnLeave", function(self) 
                                GameTooltip:Hide() 
                            end)
                            -- 点击时触发
                            button:SetScript("OnMouseDown", function(self,enter)
                                if enter == "RightButton" then  -- 右键清空格子
                                    if BG.lastfocus then
                                        BG.lastfocus:ClearFocus()
                                    end
                                    return
                                end
                                if lootlink[(t-1)*10+i] then
                                    if IsShiftKeyDown() then
                                        _G.ChatFrame1EditBox:Show()
                                        _G.ChatFrame1EditBox:SetFocus()
                                        _G.ChatFrame1EditBox:Insert(lootlink[(t-1)*10+i])
                                        zhuangbei:ClearFocus()
                                        return
                                    end
                                    zhuangbei:SetText(lootlink[(t-1)*10+i])
                                    if IsAltKeyDown() then
                                        BiaoGeguanzhu = true
                                        BGFrameguanzhu:Show()
                                    end
                                end
                                BG.FrameZhuangbeiList:Hide()
                                zhuangbei:ClearFocus()
                            end)
                            framedown = button
                        end
                    end
                end)
            end
        end
    end
end
ADDONSELF.Listzhuangbei = Listzhuangbei

------------------函数：金额下拉列表------------------
local function Listjine(jine,FB,b,i)
    -- 背景框
    BG.FrameJineList = CreateFrame("Frame", nil, BG.MainFrame, "BackdropTemplate");
    BG.FrameJineList:SetWidth(95);
    BG.FrameJineList:SetHeight(230);
    BG.FrameJineList:SetFrameLevel(120)
    BG.FrameJineList:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16
    })
    BG.FrameJineList:SetBackdropColor(0, 0, 0, 1)
    BG.FrameJineList:SetPoint("TOPLEFT",jine,"BOTTOMLEFT",-9,2);
    BG.FrameJineList:Show()
    BG.FrameJineList:SetScript("OnMouseUp", function(self)
    end)

    local text = BG.FrameJineList:CreateFontString()
    text:SetPoint("TOP",BG.FrameJineList,"TOP",0,-10)
    text:SetFontObject(GameFontNormal)    -- 普通设置方法
    text:SetText("欠款金额")
    text:SetTextColor(1,0,0)

    local edit = CreateFrame("EditBox", nil, BG.FrameJineList, "InputBoxTemplate");
    edit:SetSize(80, 20)
    edit:SetTextColor(1,0,0)
    edit:SetPoint("TOP",text,"BOTTOM",2,-5)
    if BiaoGe[FB]["boss"..b]["qiankuan"..i] then
        if BiaoGe[FB]["boss"..b]["qiankuan"..i] == "" or BiaoGe[FB]["boss"..b]["qiankuan"..i] == 0 then
            edit:SetText("")
        else
            edit:SetText(BiaoGe[FB]["boss"..b]["qiankuan"..i])
        end
    end
    edit:SetNumeric(true)
    edit:SetAutoFocus(false)
    BG.FrameQianKuanEdit = edit
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
        BiaoGe[FB]["boss"..b]["qiankuan"..i] = self:GetText()
        if BiaoGe[FB]["boss"..b]["qiankuan"..i] == "" or BiaoGe[FB]["boss"..b]["qiankuan"..i] == "0" then
            BG.Frame[FB]["boss"..b]["qiankuan"..i]:Hide()
        else
            BG.Frame[FB]["boss"..b]["qiankuan"..i]:Show()
        end
    end)
    edit:SetScript("OnEscapePressed", function(self)
        BG.FrameJineList:Hide()
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
end
ADDONSELF.Listjine  = Listjine


------------------函数：WCL------------------
local function Expand(v)
	local switch = {
		["V"] = function()
			return "VOA"
		end,
		["X"] = function()
			return "NAX"
		end,
		["D"] = function()
			return "ULD"
		end,				
		["A"] = function()
			return "|cFFE5CC80"
		end,
		["L"] = function()
			return "|cFFFF8000"
		end,
		["S"] = function()
			return "|cFFE26880"
		end,
		["N"] = function()
			return "|cFFBE8200"
		end,
		["E"] = function()
			return "|cFFA335EE"
		end,
		["R"] = function()
			return "|cFF0070FF"
		end,
		["U"] = function()
			return "|cFF1EFF00"
		end,
		["C"] = function()
			return "|cFF666666"
		end,
		["%"] = function()
			return "% "
		end
	}
	local fenshu = ""
	local max = strlen(v)
	for j = 1, max do
		local ts = strsub(v, j, j)
		local f = switch[ts]
		if f then
			fenshu = fenshu .. f()
		else
			fenshu = fenshu .. ts
		end
	end
	return fenshu
end

local function WCLpm()
    if type(WP_Database) ~= "table" then
        return
    end
    local updatetime = WP_Database.LASTUPDATE
    local wclname1 = {}     -- 单纯的名字
    local wclname2 = {}     -- 带颜色字符的名字
    local wclfenshu1 = {}       -- 单纯的数字分数
    local wclfenshu2 = {}       -- 短字符串分数
    local wclfenshu3 = {}       -- 带颜色字符的分数
    local num=GetNumGroupMembers()
    if not IsInRaid() then
        num = 1
    end
    for i=1,num do
        local fenshu1       -- 单纯的数字分数
        local fenshu2       -- 短字符串分数
        local fenshu3       -- 带颜色字符的分数
        local name = UnitName("raid"..i)
        if not IsInRaid() then
            name = UnitName("player")
        end
        local _,class = UnitClass("raid"..i)
        if not IsInRaid() then
            _,class = UnitClass("player")
        end
        local _,_,_,color = GetClassColor(class)
        for k,v in pairs(WP_Database) do        -- WP_Database = {["Rainforce"]="ED:(平衡)12892/79.6%RX:(平衡)16641/63.1%LV:(守护)45/98.4%|1"}
            if k == name then       -- 如果在WCL数据里找到该名团员名字
                local a = string.find(v,"/")
                fenshu1 = tonumber(strsub(v,a+1,a+4))
                local b = string.find(v,":")
                fenshu2 = strsub(v,b+1,a+5)
                local max = strlen(v)
                local vv = strsub(v, 1, max-2).."|r".."|r".."|r"
                fenshu3 = Expand(vv)      -- 获取并转换带颜色的WCL分数
                

            end
        end

        table.insert(wclname1,name)      -- 保存单纯的名字到表

        name = "|c"..color..name.."|r"
        table.insert(wclname2,name)      -- 保存带颜色字符串的名字到表

        if not fenshu1 then
            fenshu1 = 0
        end
        table.insert(wclfenshu1,fenshu1)        -- 保存单纯的数字分数到表

        if not fenshu2 then
            fenshu2 = "没有WCL记录"
        end
        table.insert(wclfenshu2,fenshu2)      -- 保存短字符串分数到表

        if not fenshu3 then
            fenshu3 = "没有WCL记录"
        end
        table.insert(wclfenshu3,fenshu3)      -- 保存带颜色字符串分数到表
    end
    -- 开始排序
    local wclname4 = {}     -- 单纯的名字
    local wclname5 = {}     -- 带颜色字符的名字
    local wclfenshu4 = {}       -- 单纯的分数
    local wclfenshu5 = {}       -- 短字符串分数
    local wclfenshu6 = {}       -- 带颜色字符的分数
    for t=1,#wclfenshu1 do          -- 找到最大数值
        local max = nil
        for k,v in ipairs(wclfenshu1) do
            if tonumber(v)  then
                if max == nil then
                    max=v
                end
                if max < v then
                    max = v
                end
            end
        end
        if not max then
            break
        end
        for i = 1, #wclfenshu1 do
            if wclfenshu1[i] == max then   
                table.insert(wclname4,wclname1[i])       -- 保存单纯的名字到表
                table.insert(wclname5,wclname2[i])       -- 保存带颜色字符串的名字到表
                table.insert(wclfenshu4,wclfenshu1[i])      -- 保存单纯的分数到表
                table.insert(wclfenshu5,wclfenshu2[i])      -- 保存短字符串分数到表
                table.insert(wclfenshu6,wclfenshu3[i])      -- 保存带颜色字符串分数到表

                table.remove(wclname1,i)
                table.remove(wclname2,i)
                table.remove(wclfenshu1,i)
                table.remove(wclfenshu2,i)
                table.remove(wclfenshu3,i)
            end
        end
    end
    return wclname4,wclname5,wclfenshu4,wclfenshu5,wclfenshu6,updatetime       -- 单纯的名字，带颜色字符串的名字，单纯的分数，短字符串分数，带颜色字符串分数，更新日期
end
ADDONSELF.WCLpm = WCLpm

-- 按WCL分数上标记
local function WCLcolor(fenshu)
    local f = tonumber(fenshu)
    local b    -- 标记
    if f then
        if f >= 99 then       -- 星星：粉
            b = "{rt1}"
        elseif f >= 95 then     -- 大饼：橙
            b = "{rt2}"
        elseif f >= 75 then     -- 紫菱：紫
            b = "{rt3}"     
        elseif f >= 5 then     -- 方块：蓝
            b = "{rt6}"
        elseif f >= 25 then     -- 三角：绿
            b = "{rt4}"
        elseif f > 0 then     -- 骷髅：灰
            b = "{rt8}"
        elseif f == 0 then
            b = "{rt7}"     -- 叉叉：无
        end
    else
        b = "{rt7}"     -- 叉叉：无
    end
    return b
end 
ADDONSELF.WCLcolor = WCLcolor

------------------函数：交易自动记录买家和金额------------------
local function Trade(BGFrameFB,target,player,targetmoney,playermoney,targetitems,playeritems,msgFrame,BiaoGeFB,MaxbFB,MaxiFB)
    -- 双方都给出装备
    if targetitems[1] and playeritems[1] then
        msgFrame:AddMessage("|cffDC143C< 交易记账失败 >|r\n因为双方都给了装备\n插件要死机咯")
        return
    end
    local qiankuan = 0
    if BG.QianKuan.edit then
        if tonumber(BG.QianKuan.edit:GetText()) then
            qiankuan = qiankuan + tonumber(BG.QianKuan.edit:GetText())
        end
    end
    -- 玩家给出金额，得到装备（玩家买装备情景）
    if targetitems[1] then
        local yes
        for items = 1 , #targetitems do
            for b = 1, MaxbFB, 1 do
                for i = 1, MaxiFB, 1 do
                    if BGFrameFB["boss"..b]["zhuangbei"..i] then
                        if select(2,GetItemInfo(BGFrameFB["boss"..b]["zhuangbei"..i]:GetText())) == targetitems[items] then
                            if BGFrameFB["boss"..b]["maijia"..i]:GetText() == "" and BGFrameFB["boss"..b]["jine"..i]:GetText() == "" then
                                BGFrameFB["boss"..b]["maijia"..i]:SetText(player)
                                BGFrameFB["boss"..b]["maijia"..i]:SetTextColor(GetClassRGB(player))
                                if #targetitems == 1 then
                                    BGFrameFB["boss"..b]["jine"..i]:SetText(playermoney+qiankuan)
                                    local qiankuantext = ""
                                    if qiankuan ~= 0 then
                                        BiaoGeFB["boss"..b]["qiankuan"..i] = qiankuan
                                        BGFrameFB["boss"..b]["qiankuan"..i]:Show()
                                        qiankuantext = "|cffFF0000（欠款"..qiankuan.."）|r"
                                    end
                                    msgFrame:AddMessage("|cff00BFFF< 交易记账成功 >|r\n装备："..targetitems[1].."\n买家："..GetClassCFF(player).."\n金额：|cffFFD700"..playermoney+qiankuan.."|rg"..qiankuantext.."\nBOSS：|cffFF1493< "..BiaoGeFB["boss"..b]["bossname2"].." >|r")
                                else
                                    msgFrame:AddMessage("|cffDC143C< 交易记账失败 >|r\n因为你交易了超过1件装备\n这些装备只记录了买家，没记录金额或欠款")
                                end
                                yes = true
                                break
                            end
                        end
                    end
                end
                if yes then
                    break
                end
            end
        end
        if not yes then
            msgFrame:AddMessage("|cffDC143C< 交易记账失败 >|r\n表格里没找到此次交易的装备")
        end
    end
    -- 玩家给出装备，得到金钱（团长情景）
    if playeritems[1] then
        local yes
        for items = 1 , #playeritems do
            for b = 1, MaxbFB, 1 do
                for i = 1, MaxiFB, 1 do
                    if BGFrameFB["boss"..b]["zhuangbei"..i] then
                        if select(2,GetItemInfo(BGFrameFB["boss"..b]["zhuangbei"..i]:GetText())) == playeritems[items] then
                            if BGFrameFB["boss"..b]["maijia"..i]:GetText() == "" and BGFrameFB["boss"..b]["jine"..i]:GetText() == "" then
                                BGFrameFB["boss"..b]["maijia"..i]:SetText(target)
                                BGFrameFB["boss"..b]["maijia"..i]:SetTextColor(GetClassRGB(target))
                                if #playeritems == 1 then
                                    BGFrameFB["boss"..b]["jine"..i]:SetText(targetmoney+qiankuan)
                                    local qiankuantext = ""
                                    if qiankuan ~= 0 then
                                        BiaoGeFB["boss"..b]["qiankuan"..i] = qiankuan
                                        BGFrameFB["boss"..b]["qiankuan"..i]:Show()
                                        qiankuantext = "|cffFF0000（欠款"..qiankuan.."）|r"
                                    end
                                    msgFrame:AddMessage("|cff00BFFF< 交易记账成功 >|r\n装备："..playeritems[1].."\n买家："..GetClassCFF(target).."\n金额：|cffFFD700"..targetmoney+qiankuan.."|rg"..qiankuantext.."\nBOSS：|cffFF1493< "..BiaoGeFB["boss"..b]["bossname2"].." >|r")
                                else
                                    msgFrame:AddMessage("|cffDC143C< 交易记账失败 >|r\n因为你交易了超过1件装备\n这些装备只记录了买家，没记录金额或欠款")
                                end
                                yes = true
                                break
                            end
                        end
                    end
                end
                if yes then
                    break
                end
            end
        end
        if not yes then
            msgFrame:AddMessage("|cffDC143C< 交易记账失败 >|r\n表格里没找到此次交易的装备")
        end
    end
end
ADDONSELF.Trade = Trade

------------------函数：窗口切换动画------------------
local function FrameDongHua(frame,h2,w2)
    local h1 = frame:GetHeight()
    local w1 = frame:GetWidth()
    local Time = 0.5
    local T = 50
    local t1 = Time/T    
    local t2 = Time/T  
    if w1 > w2 then
        for i = T , 1 ,-1 do
            C_Timer.After(t1,function ()
                frame:SetWidth(w2+(w1-w2)*((i-1)/T))       -- 窗口变小
            end)
            t1 = t1 + Time/T
        end    
    elseif w2 > w1 then
        for i = 1 , T ,1 do
            C_Timer.After(t1,function ()
                frame:SetWidth(w1+(w2-w1)*(i/T))       -- 窗口变大
            end)
            t1 = t1 + Time/T
        end
    end
    if h1 > h2 then
        for i = T , 1 ,-1 do
            C_Timer.After(t2,function ()
                frame:SetHeight(h2+(h1-h2)*((i-1)/T))       -- 窗口变小
            end)
            t2 = t2 + Time/T
        end    
    elseif h2 > h1 then
        for i = 1 , T ,1 do
            C_Timer.After(t2,function ()
                frame:SetHeight(h1+(h2-h1)*(i/T))       -- 窗口变大
            end)
            t2 = t2 + Time/T
        end
    end
end
ADDONSELF.FrameDongHua = FrameDongHua

------------------函数：隐藏窗口------------------
local function FrameHide(num)   -- num是0就取消焦点，其他数字就不取消焦点
    if num == 0 then
        if BG.lastfocus then
            BG.lastfocus:ClearFocus()
        end
    end
    if BG.FrameZhuangbeiList then
        BG.FrameZhuangbeiList:Hide()
    end
    if BG.FrameMaijiaList then
        BG.FrameMaijiaList:Hide()
    end
    if BG.FrameJineList then
        BG.FrameJineList:Hide()
    end
    if BG.FrameSheZhi then
        BG.FrameSheZhi:Hide()
    end
end
ADDONSELF.FrameHide = FrameHide

------------------函数：清空表格------------------
function BG.Frame:QingKong(BiaoGeFB,FB,MaxbFB,MaxiFB,BiaoGeAFB)
    if BG["Frame"..FB] and BG["Frame"..FB]:IsVisible() or not BiaoGeAFB then
        for b=1,MaxbFB do
            for i=1,MaxiFB do
                if self[FB]["boss"..b]["zhuangbei"..i] then
                    self[FB]["boss"..b]["zhuangbei"..i]:SetText("")
                    self[FB]["boss"..b]["maijia"..i]:SetText("")
                    self[FB]["boss"..b]["jine"..i]:SetText("")
                    self[FB]["boss"..b]["qiankuan"..i]:Hide()
                    self[FB]["boss"..b]["guanzhu"..i]:Hide()
                    BiaoGeFB["boss"..b]["qiankuan"..i] = ""
                    BiaoGeFB["boss"..b]["guanzhu"..i] = nil
                end
            end
            if self[FB]["boss"..b]["time"] then
                self[FB]["boss"..b]["time"]:SetText("")
                BiaoGeFB["boss"..b]["time"] = nil
            end
        end
        for i=1,5 do
            self[FB]["boss"..MaxbFB+1]["jine"..i]:SetText("")
        end
        if BiaoGeFB["ChengPian"] then
            BiaoGeFB["ChengPian"] = nil
        end
    else
        for n=1,4 do
            for b=1,MaxbFB-1 do
                for i=1,2 do
                    if BG.HopeFrame[FB]["nandu"..n]["boss"..b]["zhuangbei"..i] then
                        BG.HopeFrame[FB]["nandu"..n]["boss"..b]["zhuangbei"..i]:SetText("")
                        BiaoGeAFB["nandu"..n]["boss"..b]["yidiaoluo"..i] = nil
                    end
                end
            end
        end
    end
end

------------------函数：给文本上颜色------------------
function BG.STC_b1(text)
    if text then
        local t
        t = "|cff".."00BFFF"..text.."|r"
        return t
    end
end

function BG.STC_r1(text)
    if text then
        local t
        t = "|cff".."FF0000"..text.."|r"
        return t
    end
end

function BG.STC_g1(text)
    if text then
        local t
        t = "|cff".."00FF00"..text.."|r"
        return t
    end
end
function BG.STC_g2(text)
    if text then
        local t
        t = "|cff".."90EE90"..text.."|r"
        return t
    end
end

function BG.Hope(button,FB)
    button:SetScript("OnTextChanged", function(self)
        local itemText = button:GetText()
        local itemID = select(1, GetItemInfoInstant(itemText))
        local name,link,quality,level,_,_,_,_,_,_,_,typeID=GetItemInfo(itemText)
        local function SendHopeItemID(itemID,channel)    -- 发送请求
            C_ChatInfo.SendAddonMessage("BiaoGe", "Hope-"..itemID, channel)
        end

        local function SendHopeTrue(itemID,name)    -- 发送确认
            C_ChatInfo.SendAddonMessage("BiaoGe", "True-"..itemID, "WHISPER", name)
        end

        local channel
        if IsInRaid() then
            channel = "RAID"
        end
        if channel then
            SendHopeItemID(itemID,channel) 
        end

        local only
        local num = 0
        local f=CreateFrame("Frame")
        f:RegisterEvent("CHAT_MSG_ADDON")
        f:SetScript("OnEvent", function (self,even,...)
            num = num + 1
            pt(num)
            local prefix, msg, distType, sender = ...
            if prefix ~= "BiaoGe" then return end
            if distType ~= "RAID" then return end
            -- if only then return end
            if strfind(msg, "Hope") then

                local _, itemID = strsplit("-", msg)
                itemID = tonumber(itemID)
                if not itemID then return end
                for n=1,4 do
                    for b=1,20 do
                        for i=1,2 do
                            if BG.HopeFrame[FB]["nandu"..n]["boss"..b]["zhuangbei"..i] then
                                if itemID == GetItemInfoInstant(BG.HopeFrame[FB]["nandu"..n]["boss"..b]["zhuangbei"..i]:GetText()) then
                                    -- SendHopeTrue(itemID,sender)
                                    C_ChatInfo.SendAddonMessage("BiaoGe", "True-"..itemID, "WHISPER", sender)
                                    -- pt(sender)
                                end
                            end
                        end
                    end
                end
            end
            
            -- pt(GetTime(),...)
            -- only = true
        end)

        -- local num = 0

        -- local only
        -- local f=CreateFrame("Frame")
        -- f:RegisterEvent("CHAT_MSG_ADDON")
        -- f:SetScript("OnEvent", function (self,even,...)
        --     local prefix, msg, distType, sender = ...
        --     if prefix ~= "BiaoGe" then return end
        --     if distType ~= "WHISPER" then return end
        --     if only then return end
        --     if strfind(msg, "True") then
        --         local _, itemID = strsplit("-", msg)
        --         itemID = tonumber(itemID)
        --         if not itemID then return end
        --         if itemID == GetItemInfoInstant(BG.lasthope:GetText()) then
        --             num = num + 1
        --         end
        --     end
        --     only = true
        -- end)
    end)
end