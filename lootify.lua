local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local function increaseHitbox(size)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local handle = tool:FindFirstChild("Handle")
        if handle and handle:IsA("BasePart") then
            handle.Size = size or Vector3.new(15, 15, 15) -- tamanho grande padrão
            handle.Transparency = 0.5  -- deixa meio transparente pra não atrapalhar a visão
            handle.CanCollide = false  -- pra não travar nada
            print("Hitbox aumentada para:", handle.Size)
        else
            warn("Ferramenta sem 'Handle' ou 'Handle' não é BasePart")
        end
    else
        warn("Nenhuma ferramenta equipada")
    end
end

-- Chama a função com o tamanho desejado
increaseHitbox()
