local AddOnName, Engine = ...
LoutenLib, NZVD = unpack(Engine)

function NZVD:InitNewSettings()
    NZVD.SettingsWindow.MenuBar:AddNewBarButton("Настройка аддона")

    local wi1 = NZVD.SettingsWindow:GetIndexByText("Настройка аддона")
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info1 = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi1])
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info1:InitNewFrame(1,1,
                                                                "TOPLEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1], "TOPLEFT", 35, -30,
                                                                1,0,0,1)
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info1:SetTextToFrame("LEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1].Info1, "LEFT", 0,0, false, 14, "Вы можете выбрать отображение иконок:")

    NZVD_DB.Profiles[UnitName("player")].Type = NZVD_DB.Profiles[UnitName("player")].Type or 1
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Type = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi1])
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Type:InitNewFrame(120, 20,
                                                                "TOPLEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1].Info1, "TOPLEFT", 0, -20,
                                                                0,0,0,1, true)
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Type:InitNewDropDownList(  NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].red,
                                                                            NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].green,
                                                                            NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].blue,
                                                                            1,
                                                                            "down", "Button",
                                                                "Иконки:",
                                                                {"Созвездие", "Ауры"},
                                                                {function()
                                                                    NZVD:SetType(0)
                                                                    NZVD.SettingsWindow.MainPanel.Windows[wi1].Type.DropDownList:Close()
                                                                end,
                                                                function()
                                                                    NZVD:SetType(1)
                                                                    NZVD.SettingsWindow.MainPanel.Windows[wi1].Type.DropDownList:Close()
                                                                end})
end