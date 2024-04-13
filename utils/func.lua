local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer
local Camera = workspace.CurrentCamera
local WorldToScreen = Camera.WorldToScreenPoint
local GetPlayers = plrs.GetPlayers
local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
local mouse = lplr:GetMouse()
local UserInputService = game:GetService("UserInputService")
local GetMouseLocation = UserInputService.GetMouseLocation

local functions = {}

functions.GetScreenPosition = function(Vector)
    local Vec3, OnScreen = WorldToScreen(Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

functions.IsTool = function(Tool)
    return Tool:IsA("Tool")
end

functions.IsAlive = function(Plr)
    return Plr.Character and Plr.Character:FindFirstChild("Humanoid") and Plr.Character.Humanoid.Health > 0
end

functions.TeamCheck = function(Plr)
    return Plr.Team ~= lplr.Team
end

functions.GetMousePosition = function()
    return GetMouseLocation(UserInputService)
end

functions.GetGun = function(Plr)
    local Character = lplr.Character
    if not Character then return end
    for _,v in ipairs(Character:GetChildren()) do
        if functions.IsTool(v) then
            return v
        end
    end
end

functions.HitChance = function(Percentage)
    Percentage = math.floor(Percentage)
    local chance = math.floor(Random.new().NextNumber(Random.new(),0,1) * 100) / 100

    return chance <= Percentage / 100
end

functions.Direction = function(Origin, Pos)
    return (Pos - Origin).Unit * 1000
end

return functions
