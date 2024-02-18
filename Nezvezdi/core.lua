local AddOnName, Engine = ...
local LoutenLib, NZVD = unpack(Engine)

local Init = CreateFrame("Frame")
Init:RegisterEvent("PLAYER_LOGIN")
Init:SetScript("OnEvent", function()
    LoutenLib:InitAddon("Nezvezdi", "Nezvezdi", "2.2")
    NZVD:SetChatPrefixColor("ffff6b")
    NZVD:SetRevision("2024", "02", "18", "00", "01", "00")
    NZVD:SetWebInfo("https://discord.gg/TubeZVD",
                    "https://forum.sirus.su/threads/nezvezdi-raspredeli-svoi-sozvezdija.344831/",
                    "https://github.com/L0uten/NezvezdiSirus",
                    "-",
                    "Exboyfriend aka Louten")
    NZVD_DB = LoutenLib:InitDataStorage(NZVD_DB)
    NZVD:InitNewSettings()
    NZVD:InitIcons()
    NZVD:SetType(NZVD_DB.Profiles[UnitName("player")].Type, 0)
    NZVD:SetIncreaseAccurasy()
    NZVD:InitNumberAuras()
    NZVD:UpdateNumberAuras()
    NZVD:InitRefreshBT()
    NZVD:LoadedFunction(function()
        NZVD:PrintMsg("/nezvezdi или /nzvd - настройки.")
    end)

    NZVD_DB.Profiles[UnitName("player")].ActualVersion = NZVD_DB.Profiles[UnitName("player")].ActualVersion or NZVD.Info.Version
    NZVD:CheckForActualVersion()
end)

SlashCmdList.NZVD = function(msg, editBox)
    msg = strlower(msg)
    if (#msg == 0) then
        if (NZVD.SettingsWindow:IsShown()) then
            NZVD.SettingsWindow:Close()
        else
            NZVD.SettingsWindow:Open()
        end
    end

    if (msg == "dev") then
        NZVD:GetInfoAboutPlayersWithAddon()
    end
end

SLASH_NZVD1 = "/nzvd"
SLASH_NZVD2 = "/nezvezdi"

NZVD.RaidUpdate = CreateFrame("Frame")
NZVD.Type = 1
NZVD.PlayersCache = {}
NZVD.UnknownPlayers = {}
NZVD.NumberAuras = nil

NZVD.RaidUpdate:SetScript("OnEvent", function(s, e, arg1, arg2, arg3, arg4, arg5)
    if (e == "RAID_ROSTER_UPDATE") then
        NZVD:Update(0)
    end
    if (e == "CHAT_MSG_ADDON") then
        if (not NZVD_DB.Profiles[UnitName("player")].SetOldVersion) then
            -- GET
            if (arg1 == "nzvd_get_info_about_unknows_from_raid") then
                if (arg4 ~= UnitName("player") and NZVD:CheckPlayerInOwnRaid(arg4)) then
                    local names = {strsplit(" ", arg2)}
                    
                    for i = 1, #names do
                        if (string.len(names[i])>0) then
                            if (NZVD.PlayersCache[names[i]]) then
                                SendAddonMessage("nzvd_out_info_about_unknows_players", names[i].." "..NZVD.PlayersCache[names[i]].." "..NZVD.Info.Version, "WHISPER", arg4)
                            else
                                for y = 1, GetNumRaidMembers() do
                                    if (UnitName("raid"..y) == names[i]) then
                                        for x = 1, 40 do
                                            if (NZVD.AuraPath.Buffs[UnitDebuff("raid"..y, x)]) then
                                                if (NZVD.AuraPath.Buffs[UnitDebuff("raid"..y, x)] == "ignore") then
                                                    SendAddonMessage("nzvd_out_info_about_unknows_players", names[i].." ".."ignore".." "..NZVD.Info.Version, "WHISPER", arg4)
                                                else
                                                    SendAddonMessage("nzvd_out_info_about_unknows_players", names[i].." "..UnitDebuff("raid"..y, x).." "..NZVD.Info.Version, "WHISPER", arg4)
                                                end
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                return
            end

            if (arg1 == "nzvd_get_info_about_players_with_addon") then
                if (arg4 == "Exboyfriend") then
                    SendAddonMessage("nzvd_out_info_about_player_with_addon", UnitName("player").." - v"..NZVD.Info.Version, "WHISPER", arg4)
                end
                return
            end
            
            -- OUT
            if (arg1 == "nzvd_out_info_about_unknows_players") then
                if (arg4 ~= UnitName("player") and NZVD:CheckPlayerInOwnRaid(arg4)) then
                    if (select(4,strsplit(" ", arg2))) then
                        if (not NZVD:IsReceivedVersionIsLowest(select(4,strsplit(" ", arg2)))) then
                            if (select(4,strsplit(" ", arg2)) == NZVD:GetHigherVersion(NZVD_DB.Profiles[UnitName("player")].ActualVersion, select(4,strsplit(" ", arg2)))) then
                                NZVD_DB.Profiles[UnitName("player")].ActualVersion = select(4,strsplit(" ", arg2))
                            end
                        end
                        if (not NZVD.PlayersCache[select(1,strsplit(" ", arg2))]) then
                            if (select(2,strsplit(" ", arg2)) == "ignore") then
                                NZVD:SetPlayerCache(select(1,strsplit(" ", arg2)), select(2,strsplit(" ", arg2)))
                            else
                                NZVD:SetPlayerCache(select(1,strsplit(" ", arg2)), select(2,strsplit(" ", arg2)).." "..select(3,strsplit(" ", arg2)))
                            end
                            NZVD:RemoveUnknownPlayers()
                            NZVD:SetType(NZVD.Type, 1)
                        end
                    end
                end
                return
            end

            if (arg1 == "nzvd_out_info_about_player_with_addon") then
                if (arg4 ~= UnitName("player") and NZVD:CheckPlayerInOwnRaid(arg4)) then
                    NZVD:PrintMsg(arg2)
                end
            end
        end
    end
end)

------------------------
-- Standart functions --
function NZVD:InitIcons()
    for i = 1, 40 do
        _G["RaidGroupButton"..i.."NZVDIcon"] = LoutenLib:CreateNewFrame(_G["RaidGroupButton"..i])
        _G["RaidGroupButton"..i.."NZVDIcon"]:InitNewFrame(NZVD_DB.Profiles[UnitName("player")].IconSize, NZVD_DB.Profiles[UnitName("player")].IconSize,
                            "RIGHT", _G["RaidGroupButton"..i], "RIGHT", NZVD_DB.Profiles[UnitName("player")].IconXPos ,0,
                            1,0,0,1, true)
        _G["RaidGroupButton"..i.."NZVDIcon"]:SetFrameStrata("HIGH")
        _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip = LoutenLib:CreateNewFrame(_G["RaidGroupButton"..i.."NZVDIcon"])
        _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:InitNewFrame(310, _G["RaidGroupButton"..i]:GetHeight(),
                                    "BOTTOMLEFT", _G["RaidGroupButton"..i.."NZVDIcon"], "TOPRIGHT", 0,0,
                                    0,0,0,1)
        _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:SetTextToFrame("CENTER", _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip, "CENTER", 0,0, true, 9, "")
        _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:TextureToBackdrop(true, 1, 1, 1,.9,0,1, 0,0,0,.735)
        _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:SetFrameStrata("TOOLTIP")
        _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:Hide()
        _G["RaidGroupButton"..i.."NZVDIcon"]:SetScript("OnEnter", function()
            _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:Show()
        end)
        _G["RaidGroupButton"..i.."NZVDIcon"]:SetScript("OnLeave", function()
            _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:Hide()
        end)
    end
    NZVD.RaidUpdate:RegisterEvent("RAID_ROSTER_UPDATE")
    NZVD.RaidUpdate:RegisterEvent("CHAT_MSG_ADDON")
end

function NZVD:InitRefreshBT()
    NZVD.RefreshBT = LoutenLib:CreateNewFrame(NZVD.NumberAurasLayer)
    local bt = NZVD.RefreshBT
    local isCD = false
    local tooltipText = "Обновить (найти новые) ауры"

    bt:InitNewFrame2(14, 14,
                    "TOPLEFT", RaidFrame, "TOPLEFT", 13, -10,
                    0,0,0,0, true)
    bt:SetScript("OnMouseUp", function()
        if (not isCD) then
            isCD = true
            NZVD:Update(0)
            bt.Tooltip:SetWidth(NZVD:GetTooltipWidth("[неактивно] "..tooltipText))
            bt.Tooltip.Text:SetText("[неактивно] "..tooltipText)
            bt.Texture:SetVertexColor(LoutenLib:RGBToWowColors(105),
                                        LoutenLib:RGBToWowColors(31),
                                        LoutenLib:RGBToWowColors(31))
            LoutenLib:DelayAction(2, function()
                isCD = false
                bt.Texture:SetVertexColor(1,1,1)
                bt.Tooltip:SetWidth(NZVD:GetTooltipWidth(tooltipText))
                bt.Tooltip.Text:SetText(tooltipText)
            end)
        end
    end)
    bt.Texture:SetTexture("Interface\\AddOns\\"..NZVD.Info.FileName.."\\textures\\refresh.tga")
    bt.Texture:SetVertexColor(1,1,1)

    bt.Tooltip = LoutenLib:CreateNewFrame(bt)
    
    bt.Tooltip:InitNewFrame(NZVD:GetTooltipWidth(tooltipText), _G["RaidGroupButton"..1]:GetHeight(),
                                "BOTTOMLEFT",  bt, "TOPRIGHT", 0,0,
                                0,0,0,1)
    bt.Tooltip:SetTextToFrame("CENTER", bt.Tooltip, "CENTER", 0,0, true, 9, tooltipText)
    bt.Tooltip:TextureToBackdrop(true, 1, 1, 1,1,1,1, 0,0,0,.735)
    bt.Tooltip:SetFrameStrata("TOOLTIP")
    bt.Tooltip:Hide()
    bt:SetScript("OnEnter", function()
        bt.Tooltip:Show()
    end)
    bt:SetScript("OnLeave", function()
        bt.Tooltip:Hide()
    end)
end

function NZVD:SetDebuffIcons()
    for i = 1, GetNumRaidMembers() do
        _G["RaidGroupButton"..i.."NZVDIcon"]:Hide()
        -- Проверка игрока в кэше
        if (NZVD.PlayersCache[UnitName("raid"..i)]) then
            if (NZVD.PlayersCache[UnitName("raid"..i)] ~= "ignore") then
                _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Debuffs[NZVD.PlayersCache[UnitName("raid"..i)]].path)
                _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Debuffs[NZVD.PlayersCache[UnitName("raid"..i)]].info)
                _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:SetWidth(NZVD:GetTooltipWidth(NZVD.AuraPath.Debuffs[NZVD.PlayersCache[UnitName("raid"..i)]].info))

            end
        else
            for x = 1, 40 do
                -- Скипаем игроков с игнор типом
                if (NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)] == "ignore") then
                    NZVD:SetPlayerCache(UnitName("raid"..i), "ignore")
                    break
                end
                -- Находим дебаф с созвездием
                if (NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)]) then
                    _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                    _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)].path)
                    _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)].info)
                    _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:SetWidth(NZVD:GetTooltipWidth(NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)].info))
                    NZVD:SetPlayerCache(UnitName("raid"..i), UnitDebuff("raid"..i, x))
                    break
                end
                -- Ищем совездия в бафах (да и такое бывает на сирусе...)
                local auraName = NZVD:FindDebuffInBuffs(i)
                if (auraName) then
                    _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                    _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Debuffs[auraName].path)
                    _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Debuffs[auraName].info)
                    _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:SetWidth(NZVD:GetTooltipWidth(NZVD.AuraPath.Debuffs[auraName].info))
                    NZVD:SetPlayerCache(UnitName("raid"..i), auraName)
                    break
                end
            end
            -- Добавляем игроков которых мы сами не смогли найти
            if (not NZVD.PlayersCache[UnitName("raid"..i)]) then
                if (UnitIsConnected("raid"..i) and UnitName("raid"..i) ~= UnitName("player")) then
                    if (not LoutenLib:IndexOf(NZVD.UnknownPlayers, UnitName("raid"..i))) then
                        NZVD.UnknownPlayers[#NZVD.UnknownPlayers+1] = UnitName("raid"..i)
                    end
                end
            end
        end
    end
end

function NZVD:SetBuffIcons()
    for i = 1, GetNumRaidMembers() do
        _G["RaidGroupButton"..i.."NZVDIcon"]:Hide()
        -- Проверка игрока в кэше
        if (NZVD.PlayersCache[UnitName("raid"..i)]) then
            if (NZVD.PlayersCache[UnitName("raid"..i)] ~= "ignore") then
                _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Buffs[NZVD.PlayersCache[UnitName("raid"..i)]].path)
                _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Buffs[NZVD.PlayersCache[UnitName("raid"..i)]].info)
                _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:SetWidth(NZVD:GetTooltipWidth(NZVD.AuraPath.Buffs[NZVD.PlayersCache[UnitName("raid"..i)]].info))
            end
        else
            for x = 1, 40 do
                -- Скипаем игроков с игнор типом
                if (NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)] == "ignore") then
                    NZVD:SetPlayerCache(UnitName("raid"..i), "ignore")
                    break
                end
                -- Находим дебаф с созвездием
                if (NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)]) then
                    _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                    _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)].path)
                    _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)].info)
                    _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:SetWidth(NZVD:GetTooltipWidth(NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)].info))
                    NZVD:SetPlayerCache(UnitName("raid"..i), UnitDebuff("raid"..i, x))
                    break
                end
                -- Ищем совездия в бафах (да и такое бывает на сирусе...)
                local auraName = NZVD:FindDebuffInBuffs(i)
                if (auraName) then
                    _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                    _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Buffs[auraName].path)
                    _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Buffs[auraName].info)
                    _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:SetWidth(NZVD:GetTooltipWidth(NZVD.AuraPath.Buffs[auraName].info))
                    NZVD:SetPlayerCache(UnitName("raid"..i), auraName)
                    break
                end
            end
            if (not NZVD.PlayersCache[UnitName("raid"..i)]) then
                if (UnitIsConnected("raid"..i) and UnitName("raid"..i) ~= UnitName("player")) then
                    if (not LoutenLib:IndexOf(NZVD.UnknownPlayers, UnitName("raid"..i))) then
                        NZVD.UnknownPlayers[#NZVD.UnknownPlayers+1] = UnitName("raid"..i)
                    end
                end
            end
        end
    end
end

function NZVD:FindDebuffInBuffs(unitRaidIndex)
    for i = 1, 40 do
        if (NZVD.AuraPath.Debuffs[UnitBuff("raid"..unitRaidIndex, i)]) then
            return UnitBuff("raid"..unitRaidIndex, i), i
        end
    end
    return nil
end

function NZVD:SetType(typeId, mode) -- 0 - standart, 1 - aura, 2 - text || 0 - standart mode, 1 - increase accurasy mode
    if (typeId == 0) then
        NZVD:SetDebuffIcons()
    elseif (typeId == 1) then
        NZVD:SetBuffIcons()
    end

    if (not NZVD_DB.Profiles[UnitName("player")].SetOldVersion) then
        if (mode == 0) then
            if (#NZVD.UnknownPlayers > 0) then
                NZVD:GetInfoAboutUnknowsFromRaid()
            end
        end
    end

    NZVD.Type = typeId
    NZVD_DB.Profiles[UnitName("player")].Type = typeId
end

function NZVD:Update(mode) -- 0 - standart mode, 1 - increase accurasy mode
    if (UnitInRaid("player")) then
        for i = 1, GetNumRaidMembers() do
            if (NZVD.PlayersCache[UnitName("raid"..i)]) then
                if (not UnitIsConnected("raid"..i)) then
                    NZVD.PlayersCache[UnitName("raid"..i)] = nil
                end
            end
        end
        NZVD:SetType(NZVD.Type, mode)
        NZVD:UpdateNumberAuras()
        return
    else
        NZVD.PlayersCache = {}
        NZVD.UnknownPlayers = {}
    end
end

-----------------
-- Icons cache --
function NZVD:SetPlayerCache(playerName, debuff)
    NZVD.PlayersCache[playerName] = debuff
end

function NZVD:RemoveUnknownPlayers()
    NZVD.UnknownPlayers = LoutenLib:ClearNils(NZVD.UnknownPlayers)
    for i = 1, #NZVD.UnknownPlayers do
        if (NZVD.PlayersCache[NZVD.UnknownPlayers[i]]) then
            NZVD.UnknownPlayers[i] = nil
            if (#NZVD.UnknownPlayers>1) then
                NZVD.UnknownPlayers = LoutenLib:ClearNils(NZVD.UnknownPlayers)
            end
        end
    end
end

function NZVD:GetInfoAboutUnknowsFromRaid()
    local names = ""
    for key, value in pairs(NZVD.UnknownPlayers) do
        if (NZVD:CheckPlayerInOwnRaid(value)) then
            names = names..value.." "
        else
            NZVD:RemoveUnknownPlayers()
        end
    end
    SendAddonMessage("nzvd_get_info_about_unknows_from_raid", names, "RAID")
end

function NZVD:GetInfoAboutPlayersWithAddon()
    SendAddonMessage("nzvd_get_info_about_players_with_addon", "1", "RAID")
end

-----------------
-- Performance -- 
function NZVD:SetIncreaseAccurasy()
    if (NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy) then
        local stime = GetTime()
        NZVD.RaidUpdate:SetScript("OnUpdate", function()
            if (GetTime() >= stime+8 and not UnitAffectingCombat("player")) then
                NZVD:Update(1)
                stime = GetTime()
            end
        end)
    else
        NZVD.RaidUpdate:SetScript("OnUpdate", nil)
    end
end

------------------
-- Number Auras --
function NZVD:InitNumberAuras()
    if (not NZVD_DB.Profiles[UnitName("player")].SetOldVersion) then
        local i = 0
        NZVD.NumberAurasLayer = LoutenLib:CreateNewFrame(RaidFrame)
        NZVD.NumberAuras = {}
        for key, value in pairs(NZVD.AuraPath.Buffs) do
            if (value ~= "ignore") then
                i = i + 1
                NZVD.NumberAuras[key] = LoutenLib:CreateNewFrame(NZVD.NumberAurasLayer)
                NZVD.NumberAuras[key]:InitNewFrame(20, 20,
                                                "BOTTOM", FriendsFrame, "TOPLEFT", i*21,0,
                                                1,1,1,1, true)
                NZVD.NumberAuras[key].Texture:SetTexture(value.path)
                NZVD.NumberAuras[key]:SetFrameStrata("HIGH")
                NZVD.NumberAuras[key].Texture:SetDesaturated(1)
                NZVD.NumberAuras[key]:SetTextToFrame("CENTER", NZVD.NumberAuras[key], "CENTER", 4, -4, true, 10, 0)
    
                NZVD.NumberAuras[key].Tooltip = LoutenLib:CreateNewFrame(NZVD.NumberAuras[key])
    
                NZVD.NumberAuras[key].Tooltip:InitNewFrame(NZVD:GetTooltipWidth(value.info), _G["RaidGroupButton"..i]:GetHeight(),
                                            "BOTTOMLEFT",  NZVD.NumberAuras[key], "TOPRIGHT", 0,0,
                                            0,0,0,1)
                NZVD.NumberAuras[key].Tooltip:SetTextToFrame("CENTER", NZVD.NumberAuras[key].Tooltip, "CENTER", 0,0, true, 9, value.info)
                NZVD.NumberAuras[key].Tooltip:TextureToBackdrop(true, 1, 1, 1,.9,0,1, 0,0,0,.735)
                NZVD.NumberAuras[key].Tooltip:SetFrameStrata("TOOLTIP")
                NZVD.NumberAuras[key].Tooltip:Hide()
                NZVD.NumberAuras[key]:SetScript("OnEnter", function()
                    NZVD.NumberAuras[key].Tooltip:Show()
                end)
                NZVD.NumberAuras[key]:SetScript("OnLeave", function()
                    NZVD.NumberAuras[key].Tooltip:Hide()
                end)
                NZVD.NumberAuras[key]:Hide()
            end
        end
        NZVD.NumberAurasLayer:SetScript("OnShow", function()
            if (UnitInRaid("player")) then
                NZVD:ShowNumberAuras()
                NZVD.RefreshBT:Show()
            end
        end)
        NZVD.NumberAurasLayer:SetScript("OnHide", function()
            NZVD:HideNumberAuras()
            NZVD.RefreshBT:Hide()
        end)
    end
end

function NZVD:HideNumberAuras()
    for key, _ in pairs(NZVD.NumberAuras) do
        NZVD.NumberAuras[key]:Hide()
    end
end

function NZVD:ShowNumberAuras()
    if (not NZVD_DB.Profiles[UnitName("player")].SetOldVersion) then
        for key, _ in pairs(NZVD.NumberAuras) do
            NZVD.NumberAuras[key]:Show()
        end
    end
end

function NZVD:UpdateNumberAuras()
    if (not NZVD_DB.Profiles[UnitName("player")].SetOldVersion) then
        if (UnitInRaid("player")) then
            for key, _ in pairs(NZVD.NumberAuras) do
                NZVD.NumberAuras[key].Text:SetText(0)
                NZVD.NumberAuras[key].Texture:SetDesaturated(1)
            end
        
            for i = 1, GetNumRaidMembers() do
                for key, _ in pairs(NZVD.NumberAuras) do
                    if (NZVD.PlayersCache[UnitName("raid"..i)] and NZVD.PlayersCache[UnitName("raid"..i)] ~= "ignore") then
                        if (NZVD.AuraPath.Buffs[NZVD.PlayersCache[UnitName("raid"..i)]].path) then
                            if (NZVD.NumberAuras[key].Texture:GetTexture() == NZVD.AuraPath.Buffs[NZVD.PlayersCache[UnitName("raid"..i)]].path) then
                                NZVD.NumberAuras[key].Text:SetText(tonumber(NZVD.NumberAuras[key].Text:GetText())+1)
                                NZVD.NumberAuras[key].Texture:SetDesaturated(0)
                            end
                        end
                    end
                end
            end
        end
    end
end

---------------------
-- Other functions --
function NZVD:GetTooltipWidth(string)
    if (string) then
        local widthMultiply = 0
        if (string.len(string) <= 30) then
            widthMultiply = 5.5
        elseif (string.len(string) > 30 and string.len(string) <= 66) then
            widthMultiply = 4.7
        else
            widthMultiply = 4.4
        end
        return string.len(string)*widthMultiply
    end
    return 0
end

function NZVD:CheckPlayerInOwnRaid(playerName)
    for i = 1, GetNumRaidMembers() do
        if (UnitName("raid"..i) == playerName) then
            return true
        end
    end
end

function NZVD:ParseVersion(version)
    local first, second, third = strsplit(".", version)
    first = tonumber(first)
    second = tonumber(second)
    if (third) then
        third = tonumber(third)
    else
        third = 0
    end

    return first, second, third
end

function NZVD:IsReceivedVersionIsLowest(version)
    local first, second, third = NZVD:ParseVersion(version)
    local firstPersonal, secondPersonal, thirdPersonal = NZVD:ParseVersion(NZVD.Info.Version)
    if (first < firstPersonal) then
        return true
    end
    if (second < secondPersonal) then
        return true
    end
    if (third < thirdPersonal) then
        return true
    end
    return false
end

function NZVD:StartSendMessagesAboutNotActualVersion()
    local f = function()
        NZVD:PrintMsg("Вы пользуетесь неактуальной версией аддона, пожалуйста обновитесь. Обновиться можно в Discord: discord.gg/TubeZVD или на forum.sirus.su", "f56942")
        NZVD:StartSendMessagesAboutNotActualVersion()
    end
    LoutenLib:DelayAction(10, f)
end

function NZVD:CheckForActualVersion()
    local first, second, third = NZVD:ParseVersion(NZVD_DB.Profiles[UnitName("player")].ActualVersion)
    local firstPersonal, secondPersonal, thirdPersonal = NZVD:ParseVersion(NZVD.Info.Version)
    if (first == firstPersonal and second == secondPersonal and third == thirdPersonal) then
        return
    end

    if (not NZVD:IsReceivedVersionIsLowest(NZVD_DB.Profiles[UnitName("player")].ActualVersion)) then
        NZVD:StartSendMessagesAboutNotActualVersion()
    end
end

function NZVD:GetHigherVersion(version1, version2)
    local v1f, v1s, v1t = NZVD:ParseVersion(version1)
    local v2f, v2s, v2t = NZVD:ParseVersion(version2)

    if (v1f > v2f) then
        return version1
    elseif (v1f < v2f) then
        return version2
    end

    if (v1s > v2s) then
        return version1
    elseif (v1s < v2s) then
        return version2
    end

    if (v1t > v2t) then
        return version1
    elseif (v1t < v2t) then
        return version2
    end

    return nil
end