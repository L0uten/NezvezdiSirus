local AddOnName, Engine = ...
local LoutenLib, NZVD = unpack(Engine)

local Init = CreateFrame("Frame")
Init:RegisterEvent("PLAYER_LOGIN")
Init:SetScript("OnEvent", function()
    LoutenLib:InitAddon("Nezvezdi", "Nezvezdi", "1.2.2")
    NZVD:SetChatPrefixColor("ffff6b")
    NZVD:SetRevision("2023", "10", "05", "01", "02", "00")
    NZVD_DB = LoutenLib:InitDataStorage(NZVD_DB)
    NZVD:InitNewSettings()
    NZVD:InitIcons()
    NZVD:SetType(NZVD_DB.Profiles[UnitName("player")].Type, 0)
    NZVD:LoadedFunction(function()
        NZVD:PrintMsg("/nzvd - настройки.")
    end)
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

NZVD.RaidUpdate = CreateFrame("Frame")
NZVD.Type = 1
NZVD.PlayersCache = {}
NZVD.UnknownPlayers = {}

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
                                    SendAddonMessage("nzvd_out_info_about_unknows_players", names[i].." "..NZVD.PlayersCache[names[i]], "WHISPER", arg4)
                                else
                                    for y = 1, GetNumRaidMembers() do
                                        if (UnitName("raid"..y) == names[i]) then
                                            for x = 1, 40 do
                                                if (NZVD.AuraPath.Buffs[UnitDebuff("raid"..y, x)]) then
                                                    if (NZVD.AuraPath.Buffs[UnitDebuff("raid"..y, x)] == "ignore") then
                                                        SendAddonMessage("nzvd_out_info_about_unknows_players", names[i].." ".."ignore", "WHISPER", arg4)
                                                    else
                                                        SendAddonMessage("nzvd_out_info_about_unknows_players", names[i].." "..UnitDebuff("raid"..y, x), "WHISPER", arg4)
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

function NZVD:InitIcons()
    for i = 1, 40 do
        _G["RaidGroupButton"..i.."NZVDIcon"] = LoutenLib:CreateNewFrame(_G["RaidGroupButton"..i])
        _G["RaidGroupButton"..i.."NZVDIcon"]:InitNewFrame(_G["RaidGroupButton"..i]:GetHeight(), _G["RaidGroupButton"..i]:GetHeight() * 1.05,
                            "RIGHT", _G["RaidGroupButton"..i], "RIGHT", NZVD_DB.Profiles[UnitName("player")].IconXPos ,0,
                            1,0,0,1, true)
        _G["RaidGroupButton"..i.."NZVDIcon"]:SetFrameStrata("HIGH")
        _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip = LoutenLib:CreateNewFrame(_G["RaidGroupButton"..i.."NZVDIcon"])
        _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip:InitNewFrame(300, _G["RaidGroupButton"..i]:GetHeight(),
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

function NZVD:SetDebuffIcons()
    for i = 1, GetNumRaidMembers() do
        _G["RaidGroupButton"..i.."NZVDIcon"]:Hide()
        if (NZVD.PlayersCache[UnitName("raid"..i)]) then
            if (NZVD.PlayersCache[UnitName("raid"..i)] ~= "ignore") then
                _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Debuffs[NZVD.PlayersCache[UnitName("raid"..i)]].path)
                _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Debuffs[NZVD.PlayersCache[UnitName("raid"..i)]].info)
            end
        else
            for x = 1, 40 do
                if (NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)] == "ignore") then
                    NZVD:SetPlayerCache(UnitName("raid"..i), "ignore")
                    break
                end
                if (NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)]) then
                    _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                    _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)].path)
                    _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)].info)
                    NZVD:SetPlayerCache(UnitName("raid"..i), UnitDebuff("raid"..i, x))
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

function NZVD:SetBuffIcons()
    for i = 1, GetNumRaidMembers() do
        _G["RaidGroupButton"..i.."NZVDIcon"]:Hide()
        if (NZVD.PlayersCache[UnitName("raid"..i)]) then
            if (NZVD.PlayersCache[UnitName("raid"..i)] ~= "ignore") then
                _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Buffs[NZVD.PlayersCache[UnitName("raid"..i)]].path)
                _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Buffs[NZVD.PlayersCache[UnitName("raid"..i)]].info)
            end
        else
            for x = 1, 40 do
                if (NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)] == "ignore") then
                    NZVD:SetPlayerCache(UnitName("raid"..i), "ignore")
                    break
                end
                if (NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)]) then
                    _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                    _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)].path)
                    _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)].info)
                    NZVD:SetPlayerCache(UnitName("raid"..i), UnitDebuff("raid"..i, x))
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

function NZVD:SetPlayerCache(playerName, debuff)
    NZVD.PlayersCache[playerName] = debuff
end


function NZVD:CheckPlayerInOwnRaid(playerName)
    for i = 1, GetNumRaidMembers() do
        if (UnitName("raid"..i) == playerName) then
            return true
        end
    end
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
        return
    else
        NZVD.PlayersCache = {}
        NZVD.UnknownPlayers = {}
    end
end

function NZVD:GetInfoAboutPlayersWithAddon()
    SendAddonMessage("nzvd_get_info_about_players_with_addon", "1", "RAID")
end