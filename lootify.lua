-- CONFIGURAÇÕES
local pullRadius = 400
local speedIncrement = 5

-- PEGAR PLAYER E REFERÊNCIAS
local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- FUNÇÃO: Neutralizar NPC
local function neutralizeNPC(npc)
    pcall(function()
        npc.HumanoidRootPart.CFrame = hrp.CFrame
    end)
    pcall(function()
        npc.Humanoid.WalkSpeed = 0
    end)
    pcall(function()
        npc.HumanoidRootPart.Anchored = true
    end)
    pcall(function()
        npc.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end)

    -- DESATIVAR ATAQUES
    for _, child in ipairs(npc:GetChildren()) do
        if child:IsA("Script") and child.Name:lower():find("attack") then
            pcall(function() child.Disabled = true end)
        end
    end

    -- DESATIVAR SKILLS
    for _, child in ipairs(npc:GetChildren()) do
        if child:IsA("Script") and child.Name:lower():find("skill") then
            pcall(function() child.Disabled = true end)
        end
    end

    -- DESATIVAR AI
    pcall(function()
        if npc:FindFirstChild("AIController") then
            npc.AIController.Disabled = true
        end
    end)
end

-- LOOP PRINCIPAL
game:GetService("RunService").Heartbeat:Connect(function()
    local npcFolder = workspace:FindFirstChild("NPCs") or workspace:FindFirstChild("Enemies")
    if npcFolder then
        for _, npc in ipairs(npcFolder:GetChildren()) do
            if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") then
                local dist = (npc.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist <= pullRadius then
                    neutralizeNPC(npc)
                end
            end
        end
    end
end)

-- CRIAR GUI PARA AUMENTAR VELOCIDADE
local function createSpeedGUI()
    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.Name = "SpeedControl"

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = UDim2.new(0, 10, 0, 10)
    button.Text = "Aumentar Velocidade"
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = screenGui

    button.MouseButton1Click:Connect(function()
        humanoid.WalkSpeed = humanoid.WalkSpeed + speedIncrement
    end)
end

createSpeedGUI()
