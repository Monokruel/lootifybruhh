-- Dano automático em NPCs próximos ao jogador (até 200 studs)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local raio = 200
local dano = 10

RunService.Heartbeat:Connect(function()
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc ~= char then
            local hum = npc:FindFirstChildOfClass("Humanoid")
            local npcHrp = npc:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and npcHrp then
                local dist = (npcHrp.Position - hrp.Position).Magnitude
                if dist <= raio then
                    pcall(function()
                        hum:TakeDamage(dano)
                    end)
                end
            end
        end
    end
end)
