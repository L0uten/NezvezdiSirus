local AddOnName, Engine = ...
local LoutenLib, NZVD = unpack(Engine)

function NZVD:InitNewSettings()
    if (NZVD_DB.Profiles[UnitName("player")].NumberAurasIsShown == nil) then
        NZVD_DB.Profiles[UnitName("player")].NumberAurasIsShown = true
    end
    local StyleInRGB = NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()]
    local infoTextSize = 13

    NZVD.SettingsWindow.MenuBar:AddNewBarButton("Внешний вид")
    NZVD.SettingsWindow.MenuBar:AddNewBarButton("Производительность")

    local settings1 = NZVD.SettingsWindow.MainPanel.Windows[NZVD.SettingsWindow:GetIndexByText("Внешний вид")]
    local settings2 = NZVD.SettingsWindow.MainPanel.Windows[NZVD.SettingsWindow:GetIndexByText("Производительность")]



    -------------------------
    -- Вкладка Внешний вид --
    settings1.Category1 = LoutenLib:CreateNewFrame(settings1)
    settings1.Category1:InitNewFrame(1,1,
                                "TOPLEFT", settings1, "TOPLEFT", 35, -20-(settings1.Title:GetHeight()),
                                1,0,0,0)
    settings1.Category1:SetTextToFrame("LEFT", settings1.Category1, "LEFT", 0,0, true, infoTextSize, "Иконки")

    settings1.Info1 = LoutenLib:CreateNewFrame(settings1)
    settings1.Info1:InitNewFrame(1,1,
                                "TOPLEFT", settings1.Category1, "TOPLEFT", 0, -30,
                                1,0,0,0)
    settings1.Info1:SetTextToFrame("LEFT", settings1.Info1, "LEFT", 0,0, false, infoTextSize, "Вы можете выбрать отображение иконок:")

    NZVD_DB.Profiles[UnitName("player")].Type = NZVD_DB.Profiles[UnitName("player")].Type or 1
    settings1.Type = LoutenLib:CreateNewFrame(settings1)
    settings1.Type:InitNewFrame(120, 20,
                                "TOPLEFT", settings1.Info1, "TOPLEFT", 0, -15,
                                0,0,0,1, true)
    settings1.Type:InitNewDropDownList( StyleInRGB.red,
                                        StyleInRGB.green,
                                        StyleInRGB.blue,
                                        1,
                                        "down", "Button",
                                        "Иконки:",
                                        {"Созвездие", "Ауры"},
                                        {function()
                                            NZVD:SetType(0)
                                            settings1.Type.DropDownList:Close()
                                        end,
                                        function()
                                            NZVD:SetType(1)
                                            settings1.Type.DropDownList:Close()
                                        end})

    settings1.Info2 = LoutenLib:CreateNewFrame(settings1)
    settings1.Info2:InitNewFrame(1,1,
                                "TOPLEFT", settings1.Type, "TOPLEFT", 0, -50,
                                1,0,0,0)
    settings1.Info2:SetTextToFrame("LEFT", settings1.Info2, "LEFT", 0,0, false, infoTextSize, "Вы можете переместить иконки по горизонтали:")
                                                            
    NZVD_DB.Profiles[UnitName("player")].IconXPos = NZVD_DB.Profiles[UnitName("player")].IconXPos or -10
    settings1.SetLeftPosBT = LoutenLib:CreateNewFrame(settings1)
    settings1.SetLeftPosBT:InitNewFrame2(20,20,
                                        "TOPLEFT", settings1.Info2, "TOPLEFT", 0, -15,
                                        StyleInRGB.red,
                                        StyleInRGB.green,
                                        StyleInRGB.blue,
                                        1, true)
    settings1.SetLeftPosBT:InitNewButton2(StyleInRGB.red,
                                        StyleInRGB.green,
                                        StyleInRGB.blue,
                                        1,
                                        function()
                                            local oldX = 0
                                            settings1.SetLeftPosBT:SetScript("OnUpdate", function()
                                                if (settings1.SetLeftPosBT.IsPressed) then
                                                    for i = 1, 40 do
                                                        oldX = select(4, _G["RaidGroupButton"..i.."NZVDIcon"]:GetPoint())
                                                        if (oldX-1 >= -145) then
                                                            _G["RaidGroupButton"..i.."NZVDIcon"]:ClearAllPoints()
                                                            _G["RaidGroupButton"..i.."NZVDIcon"]:SetPoint("RIGHT", _G["RaidGroupButton"..i], "RIGHT", oldX - 1 ,0)
                                                        end
                                                    end
                                                end
                                            end)
                                        end,
                                        function()
                                            settings1.SetLeftPosBT:SetScript("OnUpdate", nil)
                                            NZVD_DB.Profiles[UnitName("player")].IconXPos = select(4, _G["RaidGroupButton1NZVDIcon"]:GetPoint())
                                        end)
    settings1.SetLeftPosBT:SetTextToFrame("CENTER", settings1.SetLeftPosBT, "CENTER", 0,0, true, 13, "<")

    settings1.SetRightPosBT = LoutenLib:CreateNewFrame(settings1)
    settings1.SetRightPosBT:InitNewFrame2(20,20,
                                        "LEFT", settings1.SetLeftPosBT, "RIGHT", 20, 0,
                                        StyleInRGB.red,
                                        StyleInRGB.green,
                                        StyleInRGB.blue,
                                        1, true)
    settings1.SetRightPosBT:InitNewButton2( StyleInRGB.red,
                                            StyleInRGB.green,
                                            StyleInRGB.blue,
                                            1,
                                            function()
                                                local oldX = 0
                                                settings1.SetRightPosBT:SetScript("OnUpdate", function()
                                                    if (settings1.SetRightPosBT.IsPressed) then
                                                        for i = 1, 40 do
                                                            oldX = select(4, _G["RaidGroupButton"..i.."NZVDIcon"]:GetPoint())
                                                            if (oldX+1 <= 5) then
                                                                _G["RaidGroupButton"..i.."NZVDIcon"]:ClearAllPoints()
                                                                _G["RaidGroupButton"..i.."NZVDIcon"]:SetPoint("RIGHT", _G["RaidGroupButton"..i], "RIGHT", oldX + 1 ,0)
                                                            end
                                                        end
                                                    end
                                                end)
                                            end,
                                            function()
                                                settings1.SetRightPosBT:SetScript("OnUpdate", nil)
                                                NZVD_DB.Profiles[UnitName("player")].IconXPos = select(4, _G["RaidGroupButton1NZVDIcon"]:GetPoint())
                                            end)
    settings1.SetRightPosBT:SetTextToFrame("CENTER", settings1.SetRightPosBT, "CENTER", 0,0, true, 13, ">")





    NZVD_DB.Profiles[UnitName("player")].IconSize = NZVD_DB.Profiles[UnitName("player")].IconSize or _G["RaidGroupButton1"]:GetHeight()
    settings1.Info3 = LoutenLib:CreateNewFrame(settings1)
    settings1.Info3:InitNewFrame(1,1,
                                "TOPLEFT", settings1.SetLeftPosBT, "TOPLEFT", 0, -50,
                                1,0,0,0)
    settings1.Info3:SetTextToFrame("LEFT", settings1.Info3, "LEFT", 0,0, false, infoTextSize, "Вы можете изменить размер иконок:")

    settings1.MinusSize = LoutenLib:CreateNewFrame(settings1)
    settings1.MinusSize:InitNewFrame2(20,20,
                                    "TOPLEFT", settings1.Info3, "TOPLEFT", 0, -15,
                                    StyleInRGB.red,
                                    StyleInRGB.green,
                                    StyleInRGB.blue,
                                    1, true)
    settings1.MinusSize:InitNewButton2( StyleInRGB.red,
                                        StyleInRGB.green,
                                        StyleInRGB.blue,
                                        1,
                                        function()
                                            settings1.MinusSize:SetScript("OnUpdate", function()
                                                if (settings1.MinusSize.IsPressed) then
                                                    for i = 1, 40 do
                                                        if (_G["RaidGroupButton"..i.."NZVDIcon"]:GetWidth()-1 >= 12) then
                                                            _G["RaidGroupButton"..i.."NZVDIcon"]:SetWidth(_G["RaidGroupButton"..i.."NZVDIcon"]:GetWidth()-1)
                                                            _G["RaidGroupButton"..i.."NZVDIcon"]:SetHeight(_G["RaidGroupButton"..i.."NZVDIcon"]:GetHeight()-1)
                                                        end
                                                    end
                                                end
                                            end)
                                        end,
                                        function()
                                            settings1.MinusSize:SetScript("OnUpdate", nil)
                                            NZVD_DB.Profiles[UnitName("player")].IconSize = _G["RaidGroupButton1NZVDIcon"]:GetHeight()
                                        end)
    settings1.MinusSize:SetTextToFrame("CENTER", settings1.MinusSize, "CENTER", 0,0, true, 13, "-")

    settings1.PlusSize = LoutenLib:CreateNewFrame(settings1)
    settings1.PlusSize:InitNewFrame2(20,20,
                                    "LEFT", settings1.MinusSize, "RIGHT", 20, 0,
                                    StyleInRGB.red,
                                    StyleInRGB.green,
                                    StyleInRGB.blue,
                                    1, true)
    settings1.PlusSize:InitNewButton2(StyleInRGB.red,
                                    StyleInRGB.green,
                                    StyleInRGB.blue,
                                    1,
                                    function()
                                        settings1.PlusSize:SetScript("OnUpdate", function()
                                            if (settings1.PlusSize.IsPressed) then
                                                for i = 1, 40 do
                                                    if (_G["RaidGroupButton"..i.."NZVDIcon"]:GetWidth()+1 <= 21) then
                                                        _G["RaidGroupButton"..i.."NZVDIcon"]:SetWidth(_G["RaidGroupButton"..i.."NZVDIcon"]:GetWidth()+1)
                                                        _G["RaidGroupButton"..i.."NZVDIcon"]:SetHeight(_G["RaidGroupButton"..i.."NZVDIcon"]:GetHeight()+1)
                                                    end
                                                end
                                            end
                                        end)
                                    end,
                                    function()
                                        settings1.PlusSize:SetScript("OnUpdate", nil)
                                        NZVD_DB.Profiles[UnitName("player")].IconSize = _G["RaidGroupButton1NZVDIcon"]:GetHeight()
                                    end)
    settings1.PlusSize:SetTextToFrame("CENTER", settings1.PlusSize, "CENTER", 0,0, true, 13, "+")

    



    settings1.Category2 = LoutenLib:CreateNewFrame(settings1)
    settings1.Category2:InitNewFrame(1,1,
                                "TOPLEFT", settings1.MinusSize, "TOPLEFT", 0, -60,
                                1,0,0,0)
    settings1.Category2:SetTextToFrame("LEFT", settings1.Category2, "LEFT", 0,0, true, infoTextSize, "Количество аур")


    settings1.Info4 = LoutenLib:CreateNewFrame(settings1)
    settings1.Info4:InitNewFrame(1,1,
                                    "TOPLEFT", settings1.Category2, "TOPLEFT", 0, -30,
                                    1,0,0,0)
    settings1.Info4:SetTextToFrame("LEFT", settings1.Info4, "LEFT", 0,0, false, infoTextSize, "Скрыть или показать иконки которые отображают количество аур:")
    settings1.HideOrShowNumberAuras = LoutenLib:CreateNewFrame(settings1)
    settings1.HideOrShowNumberAuras:InitNewFrame2(100, 20,
                                        "TOPLEFT", settings1.Info4, "TOPLEFT", 0, -15,
                                        StyleInRGB.red,
                                        StyleInRGB.green,
                                        StyleInRGB.blue,
                                        1, true)
    if (NZVD_DB.Profiles[UnitName("player")].NumberAurasIsShown) then
        settings1.HideOrShowNumberAuras:SetTextToFrame("CENTER", settings1.HideOrShowNumberAuras, "CENTER", 0,0, true, 10, "Скрыть")
    else
        settings1.HideOrShowNumberAuras:SetTextToFrame("CENTER", settings1.HideOrShowNumberAuras, "CENTER", 0,0, true, 10, "Показать")
    end
    settings1.HideOrShowNumberAuras:InitNewButton2( StyleInRGB.red,
                                                    StyleInRGB.green,
                                                    StyleInRGB.blue,
                                                    1, nil, function()
                                                        if (UnitInRaid("player")) then
                                                            if (NZVD_DB.Profiles[UnitName("player")].NumberAurasIsShown) then
                                                                NZVD:HideNumberAuras()
                                                                settings1.HideOrShowNumberAuras.Text:SetText("Показать")
                                                            else
                                                                NZVD:ShowNumberAuras()
                                                                settings1.HideOrShowNumberAuras.Text:SetText("Скрыть")
                                                            end
                                                        end
                                                        NZVD_DB.Profiles[UnitName("player")].NumberAurasIsShown = not NZVD_DB.Profiles[UnitName("player")].NumberAurasIsShown
                                                    end)






















    --------------------------------
    -- Вкладка Производительность --
    if (NZVD_DB.Profiles[UnitName("player")].SetOldVersion == nil) then
        NZVD_DB.Profiles[UnitName("player")].SetOldVersion = false
    end
    settings2.CB1 = LoutenLib:CreateNewFrame(settings2)
    settings2.CB1:InitNewFrame(1,1,
                                "TOPLEFT", settings2, "TOPLEFT", 35, -20-(settings1.Title:GetHeight()),
                                1,0,0,0)
    settings2.CB1:InitNewCheckButton(20, NZVD_DB.Profiles[UnitName("player")].SetOldVersion, "Безопасный режим (отключаются новые функции - убираются баги)", true, 10,
                                        function()
                                            NZVD_DB.Profiles[UnitName("player")].SetOldVersion = not NZVD_DB.Profiles[UnitName("player")].SetOldVersion
                                            settings2.CB1.CheckButton:SetChecked(NZVD_DB.Profiles[UnitName("player")].SetOldVersion)
                                            if (NZVD_DB.Profiles[UnitName("player")].SetOldVersion) then
                                                NZVD:Notify("Вы включили функцию отката, напишите\n/reload чтоб она заработала.")
                                                NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy = false
                                                settings2.CB2.CheckButton:SetChecked(NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy)
                                                settings2.CB2.CheckButton:Disable()
                                                if (NZVD.NumberAuras) then
                                                    NZVD:HideNumberAuras()
                                                end
                                            else
                                                settings2.CB2.CheckButton:Enable()
                                            end
                                        end)

    if (NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy == nil) then
        NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy = false
    end
    settings2.CB2 = LoutenLib:CreateNewFrame(settings2)
    settings2.CB2:InitNewFrame(1,1,
                                "TOPLEFT", settings2.CB1, "TOPLEFT", 0, -50,
                                1,0,0,0)
    settings2.CB2:InitNewCheckButton(20, NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy, "[БЕТА] Повысить точность (возможны фризы, понижение производительности, баги)", true, 9,
                                        function()
                                            NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy = not NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy
                                            settings2.CB2.CheckButton:SetChecked(NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy)
                                            NZVD:SetIncreaseAccurasy()
                                        end)

    if (NZVD_DB.Profiles[UnitName("player")].SetOldVersion) then
        NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy = false
        settings2.CB2.CheckButton:SetChecked(NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy)
        settings2.CB2.CheckButton:Disable()
    end
end