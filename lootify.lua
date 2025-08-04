local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

-- Posição central para puxar os inimigos (mude conforme sua sala)
local centroDaSala = Vector3.new(0, 5, 0)

local puxarAtivo = false
local puxarConnection = nil

local function puxarETravarInimigos()
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") then
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            if humanoid and hrp then
                hrp.CFrame = CFrame.new(centroDaSala + Vector3.new(math.random(-3,3), 3, math.random(-3,3)))
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
                for _, part in pairs(npc:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                    end
                end
                for _, scriptObj in pairs(npc:GetDescendants()) do
                    if scriptObj:IsA("Script") or scriptObj:IsA("LocalScript") then
                        scriptObj:Destroy()
                    end
                end
            end
        end
    end
end

-- Cria GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PuxarNPCsGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 50)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Ativar Puxar NPCs"
button.Parent = screenGui

button.MouseButton1Click:Connect(function()
    puxarAtivo = not puxarAtivo
    if puxarAtivo then
        button.Text = "Desativar Puxar NPCs"
        puxarConnection = RunService.Heartbeat:Connect(puxarETravarInimigos)
    else
        button.Text = "Ativar Puxar NPCs"
        if puxarConnection then
            puxarConnection:Disconnect()
            puxarConnection = nil
        end
    end
end)
