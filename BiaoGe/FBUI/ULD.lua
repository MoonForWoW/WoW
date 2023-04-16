local _, ADDONSELF = ...

local Size = ADDONSELF.Size
local RGB = ADDONSELF.RGB
local GetClassRGB = ADDONSELF.GetClassRGB
local GetClassCFF = ADDONSELF.GetClassCFF
local Sumjine = ADDONSELF.Sumjine
local SumZC = ADDONSELF.SumZC
local SumJ = ADDONSELF.SumJ
local SumGZ = ADDONSELF.SumGZ
local TongBao = ADDONSELF.TongBao
local XiaoFei = ADDONSELF.XiaoFei
local Classpx = ADDONSELF.Classpx
local WCLpm = ADDONSELF.WCLpm
local WCLcolor = ADDONSELF.WCLcolor
local Trade = ADDONSELF.Trade
local Listzhuangbei = ADDONSELF.Listzhuangbei
local Maxb = ADDONSELF.Maxb
local Maxi = ADDONSELF.Maxi
local Listjine = ADDONSELF.Listjine
local BossNum = ADDONSELF.BossNum
local FrameHide = ADDONSELF.FrameHide

local pt = print

local p = {}
local preWidget
local framedown
local frameright
local red,greed,blue = 1,1,1
local touming1,touming2 = 0.2,0.4


function BG.ULDUI(FB)
    local FB = FB

    for t=1,4 do

        local bb
        if t == 3 then
            bb = 4      -- 第3列boss有4个
        else
            bb = 6       -- 其他列有6个
        end
        for b=1,bb do

            if t == 4 and b == 3 then       -- 第4列第3个boss就不再创建
                break
            end

            local ii
            if BossNum(FB,b,t) == 16 then
                ii = Maxi[FB]     -- 第16个boss是最多个格子
            elseif BossNum(FB,b,t) == 15 then
                ii = 7
            else
                ii = 5      -- 其他boss有5个格子
            end
            for i=1,ii do
                BG.FBBiaoTiUI("ULD",t,b,bb,i,ii)
                BG.FBDiSsUI("ULD",t,b,bb,i,ii)
                BG.FBZhuangBeiUI("ULD",t,b,bb,i,ii)
                BG.FBGuanZhuUI("ULD",t,b,bb,i,ii)
                BG.FBMaiJiaUI("ULD",t,b,bb,i,ii)
                BG.FBJinEUI("ULD",t,b,bb,i,ii)
                BG.FBQianKuanUI("ULD",t,b,bb,i,ii)
            end
            BG.FBBossNameUI("ULD",t,b,bb,i,ii)
            BG.FBJiShaUI("ULD",t,b,bb,i,ii)
        end
    end
    BG.FBZhiChuZongLanGongZiUI("ULD")
    -- BOSS模型
    do
        local model = CreateFrame("PlayerModel", nil, BG["Frame"..FB])
        model:SetWidth(300)
        model:SetHeight(300)
        model:SetPoint("TOP", BG.Frame[FB].boss14.zhuangbei1, "TOPLEFT", -35, 80)
        model:SetFrameLevel(101)
        model:SetAlpha(0.5)
        model:SetPortraitZoom(-0.2)
        model:SetDisplayInfo(28641)
        model:SetHitRectInsets(70,70,60,100)

        local time = GetTime()
        local c = 1
        local s = 1
        local ss = {15386,15390,15398,15399,15400,15401,15402,15403,15404,15405,15406,15407}
        model:SetScript("OnMouseUp",function ()
            if c == 1 then
                PlaySound(ss[s])
                if s == #ss then
                    s = 1
                else
                    s = s +1
                end
                time = GetTime()
                c = 2
            elseif GetTime() - time >= 10 then
                PlaySound(ss[s])
                if s == #ss then
                    s = 1
                else
                    s = s +1
                end
                time = GetTime()
            end
        end)
    end
end