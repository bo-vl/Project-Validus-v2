local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer
local Camera = workspace.CurrentCamera
local GetPlayers = plrs.GetPlayers
local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
local mouse = lplr:GetMouse()

local functions = {}

functions.GetScreenPosition = function(Vector)
    local Vec3 = Camera:WorldToViewportPoint(Vector)
    local OnScreen = Vec3.Z > 0
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
    return Vector2.new(mouse.X, mouse.Y)
end

functions.GetGun = function(Plr)
    local Character = Plr.Character
    if not Character then return end
    for _,v in ipairs(Character:GetChildren()) do
        if not functions.IsTool(v) then return end
        return v
    end
end

functions.IsPlayerVisible = function(Player)
    local PlayerCharacter = Player.Character
    local LocalPlayerCharacter = lplr.Character
    
    if not (PlayerCharacter and LocalPlayerCharacter) then
        return false
    end 
    
    local PlayerRoot = PlayerCharacter:FindFirstChild("HumanoidRootPart")
    
    if not PlayerRoot then
        return false
    end 
    
    local CastPoints = {PlayerRoot.Position, LocalPlayerCharacter.HumanoidRootPart.Position}
    local IgnoreList = {LocalPlayerCharacter, PlayerCharacter}
    local ObscuringObjects = GetPartsObscuringTarget(Camera, CastPoints, IgnoreList)
    
    return #ObscuringObjects == 0
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
