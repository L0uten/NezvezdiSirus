local AddOnName, Engine = ...
local LoutenLib, NZVD = unpack(Engine)

function NZVD:InitNewSettings()
    NZVD.SettingsWindow.MenuBar:AddNewBarButton("Внешний вид")

    local wi1 = NZVD.SettingsWindow:GetIndexByText("Внешний вид")
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info1 = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi1])
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info1:InitNewFrame(1,1,
                                                                "TOPLEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1], "TOPLEFT", 35, -20-(NZVD.SettingsWindow.MainPanel.Windows[wi1].Title:GetHeight()),
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

    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info2 = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi1])
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info2:InitNewFrame(1,1,
                                                                "TOPLEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1].Type, "TOPLEFT", 0, -50,
                                                                1,0,0,0)
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info2:SetTextToFrame("LEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1].Info2, "LEFT", 0,0, false, 14, "Вы можете переместить иконки по горизонтали:")
                                                            
    NZVD_DB.Profiles[UnitName("player")].IconXPos = NZVD_DB.Profiles[UnitName("player")].IconXPos or -10
    NZVD.SettingsWindow.MainPanel.Windows[wi1].SetLeftPosBT = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi1])
    NZVD.SettingsWindow.MainPanel.Windows[wi1].SetLeftPosBT:InitNewFrame2(20,20,
                                                                "TOPLEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1].Info2, "TOPLEFT", 0, -20,
                                                                NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].red,
                                                                NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].green,
                                                                NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].blue,
                                                                1, true)
    NZVD.SettingsWindow.MainPanel.Windows[wi1].SetLeftPosBT:InitNewButton2(NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].red,
                                                                            NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].green,
                                                                            NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].blue,
                                                                            1,
                                                                            function()
                                                                                local oldX = 0
                                                                                NZVD.SettingsWindow.MainPanel.Windows[wi1].SetLeftPosBT:SetScript("OnUpdate", function()
                                                                                    if (NZVD.SettingsWindow.MainPanel.Windows[wi1].SetLeftPosBT.IsPressed) then
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
                                                                                NZVD.SettingsWindow.MainPanel.Windows[wi1].SetLeftPosBT:SetScript("OnUpdate", nil)
                                                                                NZVD_DB.Profiles[UnitName("player")].IconXPos = select(4, _G["RaidGroupButton1NZVDIcon"]:GetPoint())
                                                                            end)
    NZVD.SettingsWindow.MainPanel.Windows[wi1].SetLeftPosBT:SetTextToFrame("CENTER", NZVD.SettingsWindow.MainPanel.Windows[wi1].SetLeftPosBT, "CENTER", 0,0, true, 13, "<")

    NZVD.SettingsWindow.MainPanel.Windows[wi1].SetRightPosBT = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi1])
    NZVD.SettingsWindow.MainPanel.Windows[wi1].SetRightPosBT:InitNewFrame2(20,20,
                                                                "LEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1].SetLeftPosBT, "RIGHT", 20, 0,
                                                                NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].red,
                                                                NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].green,
                                                                NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].blue,
                                                                1, true)
    NZVD.SettingsWindow.MainPanel.Windows[wi1].SetRightPosBT:InitNewButton2(NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].red,
                                                                            NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].green,
                                                                            NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].blue,
                                                                            1,
                                                                            function()
                                                                                local oldX = 0
                                                                                NZVD.SettingsWindow.MainPanel.Windows[wi1].SetRightPosBT:SetScript("OnUpdate", function()
                                                                                    if (NZVD.SettingsWindow.MainPanel.Windows[wi1].SetRightPosBT.IsPressed) then
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
                                                                                NZVD.SettingsWindow.MainPanel.Windows[wi1].SetRightPosBT:SetScript("OnUpdate", nil)
                                                                                NZVD_DB.Profiles[UnitName("player")].IconXPos = select(4, _G["RaidGroupButton1NZVDIcon"]:GetPoint())
                                                                            end)
    NZVD.SettingsWindow.MainPanel.Windows[wi1].SetRightPosBT:SetTextToFrame("CENTER", NZVD.SettingsWindow.MainPanel.Windows[wi1].SetRightPosBT, "CENTER", 0,0, true, 13, ">")





    NZVD_DB.Profiles[UnitName("player")].IconSize = NZVD_DB.Profiles[UnitName("player")].IconSize or _G["RaidGroupButton1"]:GetHeight()
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info3 = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi1])
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info3:InitNewFrame(1,1,
                                                                "TOPLEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1].SetLeftPosBT, "TOPLEFT", 0, -50,
                                                                1,0,0,0)
    NZVD.SettingsWindow.MainPanel.Windows[wi1].Info3:SetTextToFrame("LEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1].Info3, "LEFT", 0,0, false, 14, "Вы можете изменить размер иконок:")

    NZVD.SettingsWindow.MainPanel.Windows[wi1].MinusSize = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi1])
    NZVD.SettingsWindow.MainPanel.Windows[wi1].MinusSize:InitNewFrame2(20,20,
                                                                "TOPLEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1].Info3, "TOPLEFT", 0, -20,
                                                                NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].red,
                                                                NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].green,
                                                                NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].blue,
                                                                1, true)
    NZVD.SettingsWindow.MainPanel.Windows[wi1].MinusSize:InitNewButton2(NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].red,
                                                                            NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].green,
                                                                            NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].blue,
                                                                            1,
                                                                            function()
                                                                                NZVD.SettingsWindow.MainPanel.Windows[wi1].MinusSize:SetScript("OnUpdate", function()
                                                                                    if (NZVD.SettingsWindow.MainPanel.Windows[wi1].MinusSize.IsPressed) then
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
                                                                                NZVD.SettingsWindow.MainPanel.Windows[wi1].MinusSize:SetScript("OnUpdate", nil)
                                                                                NZVD_DB.Profiles[UnitName("player")].IconSize = _G["RaidGroupButton1NZVDIcon"]:GetHeight()
                                                                            end)
    NZVD.SettingsWindow.MainPanel.Windows[wi1].MinusSize:SetTextToFrame("CENTER", NZVD.SettingsWindow.MainPanel.Windows[wi1].MinusSize, "CENTER", 0,0, true, 13, "-")

    NZVD.SettingsWindow.MainPanel.Windows[wi1].PlusSize = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi1])
    NZVD.SettingsWindow.MainPanel.Windows[wi1].PlusSize:InitNewFrame2(20,20,
                                                                "LEFT", NZVD.SettingsWindow.MainPanel.Windows[wi1].MinusSize, "RIGHT", 20, 0,
                                                                NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].red,
                                                                NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].green,
                                                                NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].blue,
                                                                1, true)
    NZVD.SettingsWindow.MainPanel.Windows[wi1].PlusSize:InitNewButton2(NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].red,
                                                                            NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].green,
                                                                            NZVD.SettingsWindow.WindowStylesInRGB[NZVD.SettingsWindow:GetStyle()].blue,
                                                                            1,
                                                                            function()
                                                                                NZVD.SettingsWindow.MainPanel.Windows[wi1].PlusSize:SetScript("OnUpdate", function()
                                                                                    if (NZVD.SettingsWindow.MainPanel.Windows[wi1].PlusSize.IsPressed) then
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
                                                                                NZVD.SettingsWindow.MainPanel.Windows[wi1].PlusSize:SetScript("OnUpdate", nil)
                                                                                NZVD_DB.Profiles[UnitName("player")].IconSize = _G["RaidGroupButton1NZVDIcon"]:GetHeight()
                                                                            end)
    NZVD.SettingsWindow.MainPanel.Windows[wi1].PlusSize:SetTextToFrame("CENTER", NZVD.SettingsWindow.MainPanel.Windows[wi1].PlusSize, "CENTER", 0,0, true, 13, "+")







    NZVD.SettingsWindow.MenuBar:AddNewBarButton("Производительность")

    local wi2 = NZVD.SettingsWindow:GetIndexByText("Производительность")
    if (NZVD_DB.Profiles[UnitName("player")].SetOldVersion == nil) then
        NZVD_DB.Profiles[UnitName("player")].SetOldVersion = false
    end
    NZVD.SettingsWindow.MainPanel.Windows[wi2].CB1 = LoutenLib:CreateNewFrame(NZVD.SettingsWindow.MainPanel.Windows[wi2])
    NZVD.SettingsWindow.MainPanel.Windows[wi2].CB1:InitNewFrame(1,1,
                                                                "TOPLEFT", NZVD.SettingsWindow.MainPanel.Windows[wi2], "TOPLEFT", 35, -20-(NZVD.SettingsWindow.MainPanel.Windows[wi1].Title:GetHeight()),
                                                                1,0,0,0)
    NZVD.SettingsWindow.MainPanel.Windows[wi2].CB1:InitNewCheckButton(30, NZVD_DB.Profiles[UnitName("player")].SetOldVersion, "Безопасный режим (отключаются новые функции - убираются баги)", true, 10,
                                                                        function()
                                                                            NZVD_DB.Profiles[UnitName("player")].SetOldVersion = not NZVD_DB.Profiles[UnitName("player")].SetOldVersion
                                                                            NZVD.SettingsWindow.MainPanel.Windows[wi2].CB1.CheckButton:SetChecked(NZVD_DB.Profiles[UnitName("player")].SetOldVersion)
                                                                            if (NZVD_DB.Profiles[UnitName("player")].SetOldVersion) then
                                                                                NZVD:Notify("Вы включили функцию отката, напишите\n /reload чтоб она заработала.")
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