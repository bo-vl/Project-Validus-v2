local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local plr = game.Players.LocalPlayer

local IsTool = function(tool)
    return tool:IsA("Tool")
end

local Tracer = function(begin, endpos)
    local tracer = Instance.new("Part")
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.Material = Enum.Material.SmoothPlastic
    tracer.Color = Color3.fromRGB(255, 0, 0)
    tracer.Size = Vector3.new(0.1, 0.1, (begin - endpos).Magnitude)
    tracer.CFrame = CFrame.new(begin, endpos) * CFrame.new(0, 0, -tracer.Size.Z / 2)
    tracer.Parent = workspace
    game.Debris:AddItem(tracer, 0.1)
end

local GetGun = function(Plr)
    local Character = Plr.Character
    if not Character then return end
    for _,v in ipairs(Character:GetChildren()) do
        if IsTool(v) then
            return v
        end
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local gun = GetGun(plr)
        if gun then
            Tracer(gun.Handle.Position, Camera.CFrame.Position + Camera.CFrame.LookVector * 1000)
        end
    end
end)