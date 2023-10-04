local AddOnName, Engine = ...
LoutenLib, NZVD = unpack(Engine)

function NZVD:InitNewSettings()
    NZVD.SettingsWindow.MenuBar:AddNewBarButton("Внешний вид")

    local wi1 = NZVD.SettingsWindow:GetIndexByText("Внешний вид")
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info1 = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi1])
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info1:InitNewFrame(1,1,
                                                                "TOPLEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1], "TOPLEFT", 35, -30,
                                                                1,0,0,0)
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

    NZVD.SettingsWindow.MenuBar:AddNewBarButton("Производительность")

    local wi2 = NZVD.SettingsWindow:GetIndexByText("Производительность")
    if (NZVD_DB.Profiles[UnitName("player")].SetOldVersion == nil) then
        NZVD_DB.Profiles[UnitName("player")].SetOldVersion = false
    end
    NZVD.SettingsWindow.MainPanel.Windows[wi2].CB1 = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi2])
    NZVD.SettingsWindow.MainPanel.Windows[wi2].CB1:InitNewFrame(1,1,
                                                                "TOPLEFT", NZVD.SettingsWindow.MainPanel.Windows[wi2], "TOPLEFT", 35, -30,
                                                                1,0,0,0)
    NZVD.SettingsWindow.MainPanel.Windows[wi2].CB1:InitNewCheckButton(30, NZVD_DB.Profiles[UnitName("player")].SetOldVersion, "\"Откатить\" аддон до старой версии (отключаются некоторые новые функции)", true, 10,
                                                                        function()
                                                                            NZVD_DB.Profiles[UnitName("player")].SetOldVersion = not NZVD_DB.Profiles[UnitName("player")].SetOldVersion
                                                                            NZVD.SettingsWindow.MainPanel.Windows[wi2].CB1.CheckButton:SetChecked(NZVD_DB.Profiles[UnitName("player")].SetOldVersion)
                                                                            if (NZVD_DB.Profiles[UnitName("player")].SetOldVersion) then
                                                                                NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy = false
                                                                                NZVD.SettingsWindow.MainPanel.Windows[wi2].CB2.CheckButton:SetChecked(NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy)
                                                                                NZVD.SettingsWindow.MainPanel.Windows[wi2].CB2.CheckButton:Disable()
                                                                            else
                                                                                NZVD.SettingsWindow.MainPanel.Windows[wi2].CB2.CheckButton:Enable()
                                                                            end
                                                                        end)

    if (NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy == nil) then
        NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy = false
    end
    NZVD.SettingsWindow.MainPanel.Windows[wi2].CB2 = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi2])
    NZVD.SettingsWindow.MainPanel.Windows[wi2].CB2:InitNewFrame(1,1,
                                                                "TOPLEFT", NZVD.SettingsWindow.MainPanel.Windows[wi2].CB1, "TOPLEFT", 0, -50,
                                                                1,0,0,0)
    NZVD.SettingsWindow.MainPanel.Windows[wi2].CB2:InitNewCheckButton(30, NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy, "[БЕТА] Повысить точность (возможны фризы, понижение производительности, баги)", true, 9,
                                                                        function()
                                                                            NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy = not NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy
                                                                            NZVD.SettingsWindow.MainPanel.Windows[wi2].CB2.CheckButton:SetChecked(NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy)
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
                                                                        end)

    if (NZVD_DB.Profiles[UnitName("player")].SetOldVersion) then
        NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy = false
        NZVD.SettingsWindow.MainPanel.Windows[wi2].CB2.CheckButton:SetChecked(NZVD_DB.Profiles[UnitName("player")].IncreaseAccurasy)
        NZVD.SettingsWindow.MainPanel.Windows[wi2].CB2.CheckButton:Disable()
    end
end