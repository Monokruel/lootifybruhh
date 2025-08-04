-- Dungeon Lootify – GUI + Auto Dungeon + KillAura + Freeze + Loot + Teleport
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local plr = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local function safe(p) return pcall(p) end

-- Ativos
local flags = {
    autoRoom = true,
    freeze = true,
    killAura = true,
    autoLoot = true
}

local function tweenTo(pos, duration)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local info = TweenInfo.new(duration or 1.5, Enum.EasingStyle.Quad)
    safe(function()
        local tween = TweenService:Create(hrp, info, {CFrame = CFrame.new(pos)})
        tween:Play()
        tween.Completed:Wait()
    end)
end

local function goToNextRoom()
    if not flags.autoRoom then return end
    safe(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("door") or v.BrickColor == BrickColor.new("Bright yellow")) then
                tweenTo(v.Position + Vector3.new(0, 2, 0), 2)
                task.wait(1)
                break
            end
        end
    end)
end

local function freezeNPCs()
    if not flags.freeze then return end
    safe(function()
        for _, npc in pairs(workspace:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") then
                local hum = npc:FindFirstChildOfClass("Humanoid")
                hum.WalkSpeed = 0; hum.JumpPower = 0
                for _, part in pairs(npc:GetDescendants()) do
                    if part:IsA("BasePart") then part.Anchored = true end
                end
                local brain = npc:FindFirstChildWhichIsA("Script")
                if brain then brain:Destroy() end
            end
        end
    end)
end

-- Kill Aura
task.spawn(function()
    while true do
        task.wait(0.2)
        if not flags.killAura then continue end
        safe(function()
            local char = plr.Character or plr.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local tool = char:FindFirstChildOfClass("Tool")
            for _, npc in pairs(workspace:GetDescendants()) do
                if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") and npc ~= char then
                    local hum = npc:FindFirstChildOfClass("Humanoid")
                    local root = npc:FindFirstChild("HumanoidRootPart")
                    if hum and root and hum.Health > 0 then
                        local dist = (root.Position - hrp.Position).Magnitude
                        if dist < 30 then
                            tweenTo(root.Position + Vector3.new(0, -2.5, 0), 0.5)
                            task.wait(0.1)
                            if tool then tool:Activate()
                            else mouse1click() end
                            local timeout = os.clock() + 3
                            repeat task.wait(0.1)
                            until hum.Health <= 0 or os.clock() > timeout
                        end
                    end
                end
            end
        end)
    end
end)

local function openChests()
    if not flags.autoLoot then return end
    safe(function()
        local hrp = plr.Character:WaitForChild("HumanoidRootPart")
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:lower():find("chest") then
                local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then
                    tweenTo(prompt.Parent:GetModelCFrame().Position + Vector3.new(0,1,0), 1.2)
                    task.wait(3)
                    fireproximityprompt(prompt)
                    task.wait(1)
                end
            end
        end
    end)
end

-- GUI
safe(function()
    local ScreenGui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
    ScreenGui.Name = "LootifyGui"
    local frame = Instance.new("Frame", ScreenGui)
    frame.Size = UDim2.new(0, 160, 0, 170)
    frame.Position = UDim2.new(0, 10, 0.4, 0)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true

    local function makeToggle(name, flagName, yPos)
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Position = UDim2.new(0, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 16
        btn.Text = name .. ": ON"

        btn.MouseButton1Click:Connect(function()
            flags[flagName] = not flags[flagName]
            btn.Text = name .. ": " .. (flags[flagName] and "ON" or "OFF")
        end)
    end

    makeToggle("Auto Room", "autoRoom", 10)
    makeToggle("Freeze NPCs", "freeze", 45)
    makeToggle("Kill Aura", "killAura", 80)
    makeToggle("Auto Loot", "autoLoot", 115)
end)

-- Loop principal
task.spawn(function()
    while true do
        if flags.autoRoom then goToNextRoom() end
        task.wait(2)
        if flags.freeze then freezeNPCs() end
        task.wait(2)
        if flags.autoLoot then openChests() end
        task.wait(5)
    end
end)
