-- Script para puxar NPCs perto do player e congelar (com botão GUI toggle)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

local puxarAtivo = false
local raioPuxar = 30 -- distância máxima para puxar NPCs perto do player

-- Função para puxar e congelar NPCs perto do player
local function puxarEcongelarNPCs()
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") and npc ~= char then
            local hum = npc:FindFirstChildOfClass("Humanoid")
            local npcHrp = npc:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and npcHrp then
                local dist = (npcHrp.Position - hrp.Position).Magnitude
                if dist <= raioPuxar then
                    -- Puxar para perto do player (2 studs à frente)
                    local alvoPos = hrp.CFrame * CFrame.new(0, 0, -2)
                    npcHrp.CFrame = alvoPos

                    -- Congelar: trava movimentos e ataques
                    hum.WalkSpeed = 0
                    hum.JumpPower = 0

                    for _, part in pairs(npc:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Anchored = true
                        end
                    end

                    -- Destrói scripts que podem causar ataque (opcional)
                    local brain = npc:FindFirstChildWhichIsA("Script")
                    if brain then brain:Destroy() end
                end
            end
        end
    end
end

-- Criar GUI botão toggle na tela do jogador
local ScreenGui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
ScreenGui.Name = "PuxarNPCsGui"

local button = Instance.new("TextButton", ScreenGui)
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "Puxar NPCs: OFF"
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true

button.MouseButton1Click:Connect(function()
    puxarAtivo = not puxarAtivo
    button.Text = puxarAtivo and "Puxar NPCs: ON" or "Puxar NPCs: OFF"
end)

-- Loop que roda enquanto puxar estiver ativo
RunService.Heartbeat:Connect(function()
    if puxarAtivo then
        puxarEcongelarNPCs()
    else
        -- Se quiser, pode desancorar NPCs e restaurar speed aqui quando desligar
    end
end)
