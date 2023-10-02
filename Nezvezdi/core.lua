local AddOnName, Engine = ...
LoutenLib, NZVD = unpack(Engine)

LoutenLib:InitAddon("Nezvezdi", "Nezvezdi", "1.01")
NZVD:SetChatPrefixColor("ffff6b")
NZVD:SetRevision("2023", "10", "02", "00", "01", "00")
NZVD:LoadedFunction(function()
    NZVD_DB = LoutenLib:InitDataStorage(NZVD_DB)
    NZVD:PrintMsg("/nzvd - настройки.")
    NZVD:InitNewSettings()
    NZVD:InitIcons()
    NZVD:SetType(NZVD_DB.Profiles[UnitName("player")].Type)
    -- NZVD:FindConst()
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
end

SLASH_NZVD1 = "/nzvd"

NZVD.RaidUpdate = CreateFrame("Frame")
NZVD.Type = 1
NZVD.PlayersCache = {}
NZVD.PlayerDebuffName = nil

NZVD.RaidUpdate:SetScript("OnEvent", function(s, e, arg1, arg2, arg3, arg4, arg5)
    if (e == "RAID_ROSTER_UPDATE") then
        for i = 1, GetNumRaidMembers() do
            if (NZVD.PlayersCache[UnitName("raid"..i)]) then
                if (not UnitIsConnected("raid"..i)) then
                    NZVD.PlayersCache[UnitName("raid"..i)] = nil
                end
            end
        end
        NZVD:SetType(NZVD.Type)
        return
    end
    -- if (e == "CHAT_MSG_ADDON") then
    --     if (arg1 == "nzvd_get_unit_debuff_from_unit") then
    --         if (NZVD:CheckPlayerInOwnRaid(arg4)) then
    --             NZVD:SendUnitDebuffFromUnit(arg4)
    --             return
    --         end
    --     end

    --     if (arg1 == "nzvd_send_unit_debuff_from_unit") then
    --         if (NZVD:CheckPlayerInOwnRaid(arg4)) then
    --             NZVD:SetPlayerCache(arg4, arg2)
    --             NZVD:SetType(NZVD.Type)
    --             return
    --         end
    --     end
    -- end
end)

function NZVD:InitIcons()
    for i = 1, 40 do
        _G["RaidGroupButton"..i.."NZVDIcon"] = LoutenLib:CreateNewFrame(_G["RaidGroupButton"..i])
        local icon = _G["RaidGroupButton"..i.."NZVDIcon"]
        icon:InitNewFrame(_G["RaidGroupButton"..i]:GetHeight(), _G["RaidGroupButton"..i]:GetHeight() * 1.05,
                            "RIGHT", _G["RaidGroupButton"..i], "RIGHT", -10 ,0,
                            1,0,0,1, true)
        icon.Tooltip = LoutenLib:CreateNewFrame(icon)
        icon.Tooltip:InitNewFrame(300, _G["RaidGroupButton"..i]:GetHeight(),
                                    "BOTTOMLEFT", icon, "TOPRIGHT", 0,0,
                                    0,0,0,1)
        icon.Tooltip:SetTextToFrame("CENTER", icon.Tooltip, "CENTER", 0,0, true, 9, "")
        icon.Tooltip:TextureToBackdrop(true, 1, 1, 1,.9,0,1, 0,0,0,.735)
        icon.Tooltip:SetFrameStrata("TOOLTIP")
        icon.Tooltip:Hide()
        icon:SetScript("OnEnter", function()
            icon.Tooltip:Show()
        end)
        icon:SetScript("OnLeave", function()
            icon.Tooltip:Hide()
        end)
    end
    NZVD.RaidUpdate:RegisterEvent("RAID_ROSTER_UPDATE")
    -- NZVD.RaidUpdate:RegisterEvent("CHAT_MSG_ADDON")
end

function NZVD:SetDebuffIcons()
    for i = 1, GetNumRaidMembers() do
        _G["RaidGroupButton"..i.."NZVDIcon"]:Hide()
        if (NZVD.PlayersCache[UnitName("raid"..i)]) then
            _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
            _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Debuffs[NZVD.PlayersCache[UnitName("raid"..i)]].path)
            _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Debuffs[NZVD.PlayersCache[UnitName("raid"..i)]].info)
        else
            for x = 1, 40 do
                if (NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)]) then
                    _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                    _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)].path)
                    _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)].info)
                    NZVD:SetPlayerCache(UnitName("raid"..i), UnitDebuff("raid"..i, x))
                    break
                end
            end
            -- if (not NZVD.PlayersCache[UnitName("raid"..i)]) then
            --     if (UnitIsConnected("raid"..i)) then
            --         NZVD:GetUnitDebuffFromUnit(UnitName("raid"..i))
            --     end
            -- end
        end
    end
end

function NZVD:SetBuffIcons()
    for i = 1, GetNumRaidMembers() do
        _G["RaidGroupButton"..i.."NZVDIcon"]:Hide()
        if (NZVD.PlayersCache[UnitName("raid"..i)]) then
            _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
            _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Buffs[NZVD.PlayersCache[UnitName("raid"..i)]].path)
            _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Buffs[NZVD.PlayersCache[UnitName("raid"..i)]].info)
        else
            for x = 1, 40 do
                if (NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)]) then
                    _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                    _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)].path)
                    _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)].info)
                    NZVD:SetPlayerCache(UnitName("raid"..i), UnitDebuff("raid"..i, x))
                    break
                end
            end
            -- if (not NZVD.PlayersCache[UnitName("raid"..i)]) then
            --     if (UnitIsConnected("raid"..i)) then
            --         NZVD:GetUnitDebuffFromUnit(UnitName("raid"..i))
            --     end
            -- end
        end
    end
end

function NZVD:SetType(typeId) -- 0 - standart, 1 - aura, 2 - text
    if (typeId == 0) then
        NZVD:SetDebuffIcons()
    elseif (typeId == 1) then
        NZVD:SetBuffIcons()
    end

    NZVD.Type = typeId
    NZVD_DB.Profiles[UnitName("player")].Type = typeId
end

function NZVD:FindConst()
    for i = 1, 40 do
        if (strfind(UnitDebuff("player", i), "Созвездие")) then
            NZVD.PlayerDebuffName = UnitDebuff("player", i)
            return
        end
    end
end

function NZVD:SetPlayerCache(playerName, debuff)
    NZVD.PlayersCache[playerName] = debuff
end


-- function NZVD:CheckPlayerInOwnRaid(playerName)
--     for i = 1, GetNumRaidMembers() do
--         if (UnitName("raid"..i) == playerName) then
--             return true
--         end
--     end
-- end

-- function NZVD:GetUnitDebuffFromUnit(playerName)
--     SendAddonMessage("nzvd_get_unit_debuff_from_unit", "1", "WHISPER", playerName)
-- end

-- function NZVD:SendUnitDebuffFromUnit(playerName)
--     SendAddonMessage("nzvd_send_unit_debuff_from_unit", NZVD.PlayerDebuffName, "WHISPER", playerName)
-- end