-- Auto Hit Aura – Dano automático em inimigos a até 200 studs de distância

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

local raioDano = 200 -- Aumentado para 200 studs
local intervalo = 0.2 -- Tempo entre ataques

local function atacarAlvo()
    local char = plr.Character
    if not char then return end

    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    else
        -- Alternativa se estiver sem ferramenta
        pcall(mouse1click)
    end
end

RunService.Heartbeat:Connect(function()
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc ~= char and npc:FindFirstChildOfClass("Humanoid") then
            local hum = npc:FindFirstChildOfClass("Humanoid")
            local npcHrp = npc:FindFirstChild("HumanoidRootPart")

            if hum and hum.Health > 0 and npcHrp then
                local dist = (npcHrp.Position - hrp.Position).Magnitude
                if dist <= raioDano then
                    atacarAlvo()
                    task.wait(intervalo)
                end
            end
        end
    end
end)
