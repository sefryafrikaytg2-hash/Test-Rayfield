local Rayfield = loadstring(game:HttpGet("https://sirius-team.ct.ws/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Blox Fruits PVP & Mastery Hub",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by TenshiDev",
    Icon = 0,
})

local CombatTab = Window:CreateTab("⚔️ Combat")
local ESPTab = Window:CreateTab("👀 ESP")
local MasteryTab = Window:CreateTab("🔥 Auto Mastery")
local MiscTab = Window:CreateTab("⚙️ Misc")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local killAuraEnabled = false
local autoInstinctEnabled = false
local fastAttackEnabled = false
local killAuraRange = 20
local instinctRange = 30

local killAuraConn
local autoInstinctConn
local fastAttackConn

-- Kill Aura (auto combo/attack nearby enemies)
CombatTab:CreateToggle({
    Name = "Kill Aura (Auto Combo)",
    CurrentValue = false,
    Callback = function(Value)
        killAuraEnabled = Value
        if killAuraEnabled then
            if killAuraConn then killAuraConn:Disconnect() end
            killAuraConn = RunService.Heartbeat:Connect(function()
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
                local root = LocalPlayer.Character.HumanoidRootPart
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 then
                        local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
                        if dist <= killAuraRange then
                            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool then
                                tool:Activate()
                                task.spawn(function()
                                    for i = 1, 5 do
                                        tool:Activate()
                                        task.wait(0.08)
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
        else
            if killAuraConn then killAuraConn:Disconnect() killAuraConn = nil end
        end
    end
})

CombatTab:CreateSlider({
    Name = "Kill Aura Range",
    Range = {10, 50},
    Increment = 1,
    CurrentValue = 20,
    Callback = function(Value)
        killAuraRange = Value
    end
})

-- Auto Instinct (auto dodge attacks/projectiles)
CombatTab:CreateToggle({
    Name = "Auto Instinct (Dodge Attacks)",
    CurrentValue = false,
    Callback = function(Value)
        autoInstinctEnabled = Value
        if autoInstinctEnabled then
            if autoInstinctConn then autoInstinctConn:Disconnect() end
            autoInstinctConn = RunService.Heartbeat:Connect(function()
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
                local root = LocalPlayer.Character.HumanoidRootPart
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("projectile") or obj.Name:lower():find("attack") or obj.Name:lower():find("ball")) then
                        local dist = (obj.Position - root.Position).Magnitude
                        if dist <= instinctRange then
                            local dodgeDir = (root.Position - obj.Position).Unit * 40
                            root.CFrame = root.CFrame + Vector3.new(dodgeDir.X, 0, dodgeDir.Z)
                            task.wait(0.1)
                        end
                    end
                end
            end)
            Rayfield:Notify({Title = "Auto Instinct", Content = "Auto dodge activated! Avoid projectiles/attacks.", Duration = 4})
        else
            if autoInstinctConn then autoInstinctConn:Disconnect() autoInstinctConn = nil end
        end
    end
})

CombatTab:CreateSlider({
    Name = "Instinct Dodge Range",
    Range = {10, 60},
    Increment = 1,
    CurrentValue = 30,
    Callback = function(Value)
        instinctRange = Value
    end
})

-- Fast Attack
CombatTab:CreateToggle({
    Name = "Fast Attack",
    CurrentValue = false,
    Callback = function(Value)
        fastAttackEnabled = Value
        if fastAttackEnabled then
            if fastAttackConn then fastAttackConn:Disconnect() end
            fastAttackConn = RunService.RenderStepped:Connect(function()
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end)
        else
            if fastAttackConn then fastAttackConn:Disconnect() fastAttackConn = nil end
        end
    end
})

-- Player ESP
ESPTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr \~= LocalPlayer and plr.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = plr.Character

                    local billboard = Instance.new("BillboardGui")
                    billboard.Adornee = plr.Character:FindFirstChild("Head") or plr.Character
                    billboard.Size = UDim2.new(0, 250, 0, 60)
                    billboard.StudsOffset = Vector3.new(0, 4, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = plr.Character

                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.new(1,1,1)
                    text.TextStrokeTransparency = 0
                    text.TextScaled = true
                    text.Parent = billboard

                    spawn(function()
                        while billboard.Parent do
                            local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
                            local hp = hum and math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) or "?"
                            local equipped = "Unknown"
                            if plr.Character then
                                local tool = plr.Character:FindFirstChildOfClass("Tool")
                                if tool then equipped = tool.Name end
                                if tool and (tool.Name:find("Godhuman") or tool.Name:find("Death Step")) then equipped = "GodHuman" end
                                if tool and tool.Name:find("Magma") then equipped = "Magma Fruit" end
                                if tool and (tool.Name:find("Cursed Dual Katana") or tool.Name:find("CDK")) then equipped = "CDK" end
                                if tool and (tool.Name:find("Skull Guitar") or tool.Name:find("Soul Guitar")) then equipped = "Skull Guitar" end
                            end
                            text.Text = plr.Name .. " | HP: " .. hp .. " | " .. equipped
                            task.wait(1)
                        end
                    end)
                end
            end
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character then
                    local hl = plr.Character:FindFirstChildOfClass("Highlight")
                    if hl then hl:Destroy() end
                    local bb = plr.Character:FindFirstChildOfClass("BillboardGui")
                    if bb then bb:Destroy() end
                end
            end
        end
    end
})

-- Auto Mastery
local masteryType = "Melee"
local autoMasteryEnabled = false
local autoMasteryConn

MasteryTab:CreateDropdown({
    Name = "Mastery Type",
    Options = {"Melee", "Sword", "Blox Fruits", "Gun"},
    CurrentOption = "Melee",
    Callback = function(Option)
        masteryType = Option
        Rayfield:Notify({Title = "Auto Mastery", Content = "Selected: " .. Option .. " (Equip matching tool first!)", Duration = 4})
    end
})

MasteryTab:CreateToggle({
    Name = "Auto Mastery (Farm Quest Enemies / Tiki Outpost)",
    CurrentValue = false,
    Callback = function(Value)
        autoMasteryEnabled = Value
        if autoMasteryEnabled then
            Rayfield:Notify({Title = "Auto Mastery", Content = "Started! Equip " .. masteryType .. " tool and stay near enemies.", Duration = 5})
            if autoMasteryConn then autoMasteryConn:Disconnect() end
            autoMasteryConn = RunService.Heartbeat:Connect(function()
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
                local root = LocalPlayer.Character.HumanoidRootPart

                local target = nil
                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                        -- Priority: Quest enemy
                        if LocalPlayer.PlayerGui.Main.Quest.Visible then
                            local questTitle = LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                            if enemy.Name:find(questTitle:match("%w+")) then
                                target = enemy
                                break
                            end
                        end
                        -- Fallback: Tiki Outpost / Submerged Island enemies (Sea 3) or any nearby
                        if (enemy.Name:find("Isle") or enemy.Name:find("Sun") or enemy.Name:find("Serpent") or enemy.Name:find("Skull") or enemy.Name:find("Champion") or enemy.Name:find("Pirate") or enemy.Name:find("Marine")) and (enemy.HumanoidRootPart.Position - root.Position).Magnitude < 120 then
                            target = enemy
                            break
                        end
                    end
                end

                if target then
                    root.CFrame = target.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                    local tool = LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool") or LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                    if tool then
                        if (masteryType == "Melee" and tool.ToolTip == "Melee") or
                           (masteryType == "Sword" and tool.ToolTip == "Sword") or
                           (masteryType == "Blox Fruits" and tool.ToolTip == "Blox Fruit") or
                           (masteryType == "Gun" and (tool.Name:find("Skull Guitar") or tool.Name:find("Soul Guitar"))) then
                            tool.Parent = LocalPlayer.Character
                            tool:Activate()
                            task.wait(0.15)  -- Adjust for combo speed
                        end
                    end
                end
            end)
        else
            if autoMasteryConn then autoMasteryConn:Disconnect() autoMasteryConn = nil end
            Rayfield:Notify({Title = "Auto Mastery", Content = "Stopped.", Duration = 3})
        end
    end
})

-- Close Window
MiscTab:CreateButton({
    Name = "Close Window",
    Callback = function()
        Rayfield:Destroy()
    end
})

Rayfield:Notify({
    Title = "Hub Loaded!",
    Content = "PVP & Auto Mastery ready for all Seas (Sea 1/2/3). Equip tool & start!",
    Duration = 6
})
