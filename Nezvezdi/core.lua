local AddOnName, Engine = ...
LoutenLib, NZVD = unpack(Engine)

LoutenLib:InitAddon("Nezvezdi", "Nezvezdi", "1.0")
NZVD:SetChatPrefixColor("ffff6b")
NZVD:SetRevision("2023", "10", "02", "00", "00", "00")
NZVD:LoadedFunction(function()
    NZVD_DB = LoutenLib:InitDataStorage(NZVD_DB)
    NZVD:PrintMsg("/NZVD - настройки.")
    NZVD:InitNewSettings()
    NZVD:InitIcons()
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

NZVD.RaidUpdate:SetScript("OnEvent", function(s, e)
    if (e == "RAID_ROSTER_UPDATE") then
        NZVD:SetType(NZVD.Type)
    end
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
        icon.Tooltip:Hide()
        icon:SetScript("OnEnter", function()
            icon.Tooltip:Show()
        end)
        icon:SetScript("OnLeave", function()
            icon.Tooltip:Hide()
        end)
    end
    NZVD.RaidUpdate:RegisterEvent("RAID_ROSTER_UPDATE")
end

function NZVD:SetDebuffIcons()
    for i = 1, GetNumRaidMembers() do
        _G["RaidGroupButton"..i.."NZVDIcon"]:Hide()
        for x = 1, 40 do
            if (NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)]) then
                _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)].path)
                _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Debuffs[UnitDebuff("raid"..i, x)].info)
                break
            end
        end
    end
end

function NZVD:SetBuffIcons()
    for i = 1, GetNumRaidMembers() do
        _G["RaidGroupButton"..i.."NZVDIcon"]:Hide()
        for x = 1, 40 do
            if (NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)]) then
                _G["RaidGroupButton"..i.."NZVDIcon"]:Show()
                _G["RaidGroupButton"..i.."NZVDIcon"].Texture:SetTexture(NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)].path)
                _G["RaidGroupButton"..i.."NZVDIcon"].Tooltip.Text:SetText(NZVD.AuraPath.Buffs[UnitDebuff("raid"..i, x)].info)
                break
            end
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