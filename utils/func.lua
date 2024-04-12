local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer
local Camera = workspace.CurrentCamera
local GetPlayers = plrs.GetPlayers
local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
local mouse = lplr:GetMouse()

local GetScreenPosition = function(Vector)
    local Vec3 = Camera:WorldToViewportPoint(Vector)
    local OnScreen = Vec3.Z > 0
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

local IsTool = function(Tool)
    return Tool:IsA("Tool")
end

local IsAlive = function(Plr)
    return Plr.Character and Plr.Character:FindFirstChild("Humanoid") and Plr.Character.Humanoid.Health > 0
end

local TeamCheck = function(Plr)
    return Plr.Team ~= lplr.Team
end

local GetMousePosition = function()
    return Vector2.new(mouse.X, mouse.Y)
end

local GetGun = function(Plr)
    local Character = Plr.Character
    if not Character then return end
    for _,v in ipairs(Character:GetChildren()) do
        if not IsTool(v) then return end
        return v
    end
end

local IsPlayerVisible = function(Player)
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

local HitChance = function(Percentage)
    Percentage = math.floor(Percentage)
    local chance = math.floor(Random.new().NextNumber(Random.new(),0,1) * 100) / 100

    return chance <= Percentage / 100
end

local Direction = function(Origin, Pos)
    return (Pos - Origin).unit
end
