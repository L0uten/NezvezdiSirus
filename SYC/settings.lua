local AddOnName, Engine = ...
LoutenLib, SYC = unpack(Engine)

function SYC:InitNewSettings()
    SYC.SettingsWindow.MenuBar:AddNewBarButton("Настройка аддона")

    local wi1 = SYC.SettingsWindow:GetIndexByText("Настройка аддона")
    SYC.SettingsWindow.MainPanel.Windows[wi1].Info1 = LoutenLib:CreateNewFrame(SYC.SettingsWindow.MainPanel.Windows[wi1])
    SYC.SettingsWindow.MainPanel.Windows[wi1].Info1:InitNewFrame(1,1,
                                                                "TOPLEFT", SYC.SettingsWindow.MainPanel.Windows[wi1], "TOPLEFT", 35, -30,
                                                                1,0,0,1)
    SYC.SettingsWindow.MainPanel.Windows[wi1].Info1:SetTextToFrame("LEFT", SYC.SettingsWindow.MainPanel.Windows[wi1].Info1, "LEFT", 0,0, false, 14, "Вы можете выбрать отображение иконок:")

    SYC_DB.Profiles[UnitName("player")].Type = SYC_DB.Profiles[UnitName("player")].Type or 1
    SYC.SettingsWindow.MainPanel.Windows[wi1].Type = LoutenLib:CreateNewFrame(SYC.SettingsWindow.MainPanel.Windows[wi1])
    SYC.SettingsWindow.MainPanel.Windows[wi1].Type:InitNewFrame(120, 20,
                                                                "TOPLEFT", SYC.SettingsWindow.MainPanel.Windows[wi1].Info1, "TOPLEFT", 0, -20,
                                                                0,0,0,1, true)
    SYC.SettingsWindow.MainPanel.Windows[wi1].Type:InitNewDropDownList(  SYC.SettingsWindow.WindowStylesInRGB[SYC.SettingsWindow:GetStyle()].red,
                                                                            SYC.SettingsWindow.WindowStylesInRGB[SYC.SettingsWindow:GetStyle()].green,
                                                                            SYC.SettingsWindow.WindowStylesInRGB[SYC.SettingsWindow:GetStyle()].blue,
                                                                            1,
                                                                            "down", "Button",
                                                                "Иконки:",
                                                                {"Созвездие", "Ауры"},
                                                                {function()
                                                                    SYC:SetType(0)
                                                                    SYC.SettingsWindow.MainPanel.Windows[wi1].Type.DropDownList:Close()
                                                                end,
                                                                function()
                                                                    SYC:SetType(1)
                                                                    SYC.SettingsWindow.MainPanel.Windows[wi1].Type.DropDownList:Close()
                                                                end})
end