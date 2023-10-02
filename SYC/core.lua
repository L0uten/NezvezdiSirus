local AddOnName, Engine = ...
LoutenLib, SYC = unpack(Engine)

LoutenLib:InitAddon("SYC", "Shuffle Your Constellations", "1.0")
SYC:SetChatPrefixColor("ffff6b")
SYC:SetRevision("2023", "10", "02", "00", "02", "00")
SYC:LoadedFunction(function()
    SYC_DB = LoutenLib:InitDataStorage(SYC_DB)
    SYC:PrintMsg("/syc - настройки.")
    SYC:InitNewSettings()
    SYC:InitIcons()
end)

SlashCmdList.SYC = function(msg, editBox)
    msg = strlower(msg)
    if (#msg == 0) then
        if (SYC.SettingsWindow:IsShown()) then
            SYC.SettingsWindow:Close()
        else
            SYC.SettingsWindow:Open()
        end
    end
end

SLASH_SYC1 = "/syc"

SYC.RaidUpdate = CreateFrame("Frame")
SYC.Type = 1

SYC.RaidUpdate:SetScript("OnEvent", function(s, e)
    if (e == "RAID_ROSTER_UPDATE") then
        SYC:SetType(SYC.Type)
    end
end)

function SYC:InitIcons()
    for i = 1, 40 do
        _G["RaidGroupButton"..i.."SYCIcon"] = LoutenLib:CreateNewFrame(_G["RaidGroupButton"..i])
        local icon = _G["RaidGroupButton"..i.."SYCIcon"]
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
    SYC.RaidUpdate:RegisterEvent("RAID_ROSTER_UPDATE")
end

function SYC:SetDebuffIcons()
    for i = 1, GetNumRaidMembers() do
        _G["RaidGroupButton"..i.."SYCIcon"]:Hide()
        for x = 1, 40 do
            if (SYC.AuraPath.Debuffs[UnitDebuff("raid"..i, x)]) then
                _G["RaidGroupButton"..i.."SYCIcon"]:Show()
                _G["RaidGroupButton"..i.."SYCIcon"].Texture:SetTexture(SYC.AuraPath.Debuffs[UnitDebuff("raid"..i, x)].path)
                _G["RaidGroupButton"..i.."SYCIcon"].Tooltip.Text:SetText(SYC.AuraPath.Debuffs[UnitDebuff("raid"..i, x)].info)
                break
            end
        end
    end
end

function SYC:SetBuffIcons()
    for i = 1, GetNumRaidMembers() do
        _G["RaidGroupButton"..i.."SYCIcon"]:Hide()
        for x = 1, 40 do
            if (SYC.AuraPath.Buffs[UnitDebuff("raid"..i, x)]) then
                _G["RaidGroupButton"..i.."SYCIcon"]:Show()
                _G["RaidGroupButton"..i.."SYCIcon"].Texture:SetTexture(SYC.AuraPath.Buffs[UnitDebuff("raid"..i, x)].path)
                _G["RaidGroupButton"..i.."SYCIcon"].Tooltip.Text:SetText(SYC.AuraPath.Buffs[UnitDebuff("raid"..i, x)].info)
                break
            end
        end
    end
end

function SYC:SetType(typeId) -- 0 - standart, 1 - aura, 2 - text
    if (typeId == 0) then
        SYC:SetDebuffIcons()
    elseif (typeId == 1) then
        SYC:SetBuffIcons()
    end

    SYC.Type = typeId
    SYC_DB.Profiles[UnitName("player")].Type = typeId
end