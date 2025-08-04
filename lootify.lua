-- Dungeon Lootify – Auto Dungeon + Attack + Freeze + Loot + Teleport com Tween
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local plr = Players.LocalPlayer
local function safe(p) return pcall(p) end

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

-- Goto yellow door trigger
local function goToNextRoom()
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

-- Freeze NPCs
local function freezeNPCs()
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

-- Attack mobs com hitbox estendida
local function attackMobs()
    safe(function()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local tool = char:FindFirstChildOfClass("Tool")
        while task.wait(0.4) do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Humanoid") and v.Health > 0 and v.Parent ~= char then
                    local root = v.Parent:FindFirstChild("HumanoidRootPart")
                    if root and (root.Position - hrp.Position).Magnitude < 30 then
                        tweenTo(root.Position + Vector3.new(0, -2.5, 0), 0.7)
                        task.wait(0.2)
                        if tool then tool:Activate()
                        else mouse1click() end
                        task.wait(0.6)
                    end
                end
            end
        end
    end)
end

-- Coleta baús
local function openChests()
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

-- Ciclo principal
task.spawn(function()
    while true do
        goToNextRoom()
        task.wait(2)
        freezeNPCs()
        task.wait(1)
        task.spawn(attackMobs)
        task.wait(3)
        openChests()
        task.wait(5)
    end
end)
