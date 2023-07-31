for _, v in pairs(getconnections(game:GetService("ScriptContext").Error)) do
    v:Disable()
end

for _, v in pairs(getconnections(game:GetService("LogService").MessageOut)) do
    v:Disable()
end

local Folder = "Project Validus"
if not isfolder(Folder) then
    makefolder(Folder)
end

local plr = game:GetService("Players").LocalPlayer
local plrs = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GetMouseLocation = UserInputService.GetMouseLocation
local ValidTargetParts = {"Head", "HumanoidRootPart"}
local mouse = plr:GetMouse()
local Camera = workspace.CurrentCamera
local FindFirstChild = game.FindFirstChild
local WorldToScreen = Camera.WorldToScreenPoint
local GetPlayers = plrs.GetPlayers
local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
local Pathfinding = game:GetService("PathfindingService")
local Util = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robobo2022/Util/main/Load.lua"))()

local keys = {}
local Settings = {
    Camlock = false,
    TriggerBot = false,
    Enabled = false,
    Method = "Raycast",
    TeamCheck = false,
    TargetPart = "Head",
    HitChance = 100, 
    Smoothing = 50,
    Material = "ForceField",
    GunVisuals = false,
    Bot = false,
    Botmethod = "Tween",
    autoequipe = false,
    equipeNumber = 1,

    --Movement
    Fly = false,
    Speed = false,
    SpeedValue = 0,
    FlyValue = 0,
    SpeedMethod = "CFrame",
    FlyMethod = "CFrame",
    
    --Antiaim
    AntiAim = false,
    AntiAimType = "CFrame",
    DesyncX = 0,
    DesyncY = 0,
    DesyncZ = 0,

    --Visuals
    FovRadius = 100,
    FovVisable = false,
    FovTransparency = 0.5,
    FovTracers = false,
    FovColor = Color3.new(255, 255, 255),
    FovTracersColor = Color3.new(255, 255, 255),
    HealthBar = false,
}

local GetScreenPosition = function(Vector)
    local Vec3, OnScreen = WorldToScreen(Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

local IsTool = function(Tool)
    return Tool:IsA("Tool")
end

local IsAlive = function(Plr)
    return Plr.Character and Plr.Character:FindFirstChild("Humanoid") and Plr.Character.Humanoid.Health > 0
end

local TeamCheck = function(Plr)
    return plr.Team ~= Plr.Team
end

local GetMousePosition = function()
    return GetMouseLocation(UserInputService)
end

local Getgun = function(player)
    local character = player.Character
    if character then
        for _, child in ipairs(character:GetChildren()) do
            if IsTool(child) then
                return child
            end
        end
    end
    return nil
end

local IsPlayerVisible = function(Player)
    local PlayerCharacter = Player.Character
    local LocalPlayerCharacter = plr.Character
    
    if not (PlayerCharacter or LocalPlayerCharacter) then return end 
    
    local PlayerRoot = FindFirstChild(PlayerCharacter, Settings.TargetPart) or FindFirstChild(PlayerCharacter, "HumanoidRootPart")
    
    if not PlayerRoot then return end 
    
    local CastPoints, IgnoreList = {PlayerRoot.Position, LocalPlayerCharacter, PlayerCharacter}, {LocalPlayerCharacter, PlayerCharacter}
    local ObscuringObjects = #GetPartsObscuringTarget(Camera, CastPoints, IgnoreList)
    
    return ((ObscuringObjects == 0 and true) or (ObscuringObjects > 0 and false))
end

local HitChance = function(Percentage)
    Percentage = math.floor(Percentage)
    local chance = math.floor(Random.new().NextNumber(Random.new(),0,1) * 100) / 100

    return chance <= Percentage / 100
end

local Direction = function(Origin, Position)
    return (Position - Origin).Unit * 1000
end

local GetClosestPlayer = function()
    if not Settings.TargetPart then return end
    local Closest
    local DistanceToMouse
    for _,Player in next, GetPlayers(plrs) do
        if Player == plr then continue end
        if Settings.TeamCheck and TeamCheck(Player) then continue end
        local Character = Player.Character
        if not Character then continue end

        if Settings.VisibleCheck and not IsPlayerVisible(Player) then continue end

        local HumanoidRootPart = FindFirstChild(Character, "HumanoidRootPart")
        local Humanoid = FindFirstChild(Character, "Humanoid")
        if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then continue end

        local ScreenPosition, OnScreen = GetScreenPosition(HumanoidRootPart.Position)
        if not OnScreen then continue end

        local Distance = (GetMousePosition() - ScreenPosition).Magnitude
        if Distance <= (DistanceToMouse or Settings.FovRadius or 2000) then
            Closest = ((Settings.TargetPart == "Random" and Character[ValidTargetParts[math.random(1, #ValidTargetParts)]] or Character[Settings.TargetPart]))
            DistanceToMouse = Distance
        end
    end
    return Closest
end

local TriggerBot = function()
    if Settings.TriggerBot then
        local Closest = GetClosestPlayer()
        local mousePos = GetMousePosition()
        if Closest then
            mouse1click(mousePos)
        end
    end
end

local Camlock = function()
    local Target = GetClosestPlayer()
    if Settings.Camlock then
        if Camera then
            if IsAlive(plr) then
                if Target ~= nil then
                    local Main = CFrame.new(Camera.CFrame.Position, Target.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(Main, Settings.Smoothing / 100, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut)
                end
            end
        end
    end
end
    
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Project Validus V2.0.1',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local Silent = Tabs.Combat:AddLeftGroupbox('Silent')
local AntiAim = Tabs.Combat:AddRightGroupbox('Anti Aim')
local Fov = Tabs.Visuals:AddLeftTabbox('Fov')
local FovSettings = Fov:AddTab('Fov')
local Colors = Fov:AddTab('Colors')
local Esp = Tabs.Visuals:AddRightGroupbox('Esp')
local GunVisuals = Tabs.Visuals:AddRightGroupbox('Gun Visuals')
local Bot = Tabs.Misc:AddRightGroupbox('Bot')
local Movement = Tabs.Misc:AddLeftTabbox('Movement')
local Fly = Movement:AddTab('Fly')
local Speed = Movement:AddTab('Speed')

Silent:AddLabel('Camlock'):AddKeyPicker('Camlock', {
    Default = '',
    SyncToggleState = false,
    Mode = 'Toggle',

    Text = 'Camlock',
    NoUI = false,
    Callback = function(Value)
        Settings.Camlock = Value
    end,
})

Silent:AddLabel('Silent aim'):AddKeyPicker('Silentaim', {
    Default = '',
    SyncToggleState = false,
    Mode = 'Toggle',

    Text = 'Silent aim',
    NoUI = false,
    Callback = function(Value)
        Settings.Enabled = Value
    end,
})

Silent:AddLabel('Trigger bot'):AddKeyPicker('Triggerbot', {
    Default = '',
    SyncToggleState = false,
    Mode = 'Toggle',

    Text = 'Triggerbot',
    NoUI = false,
    Callback = function(Value)
        Settings.TriggerBot = Value
    end,
})


Silent:AddToggle('TeamCheck', {
    Text = 'Team Check',
    Default = false,
    Tooltip = 'Checkington',
    Callback = function(Value)
        Settings.TeamCheck = Value
    end
})

Silent:AddToggle('VisibleCheck', {
    Text = 'Visible Check',
    Default = false,
    Tooltip = 'Checkington',
    Callback = function(Value)
        Settings.VisibleCheck = Value
    end
})

Silent:AddDropdown('HitPart', {
    Values = {'Random', 'Head', 'HumanoidRootPart'},
    Default = 1,
    Multi = false, 
    Text = 'HitPart',
    Tooltip = 'Targetington',

    Callback = function(Value)
        Settings.HitPart = Value
    end
})

Silent:AddDropdown('MyDropdown', {
    Values = { 'Raycast', 'FindPartOnRay', 'FindPartOnRayWithWhitelist', 'FindPartOnRayWithIgnoreList'},
    Default = 1,
    Multi = false, 
    Text = 'A dropdown',
    Tooltip = 'Methington',
    Callback = function(Value)
        Settings.Method = Value
    end
})

Silent:AddSlider('hitchance', {
    Text = 'Hit Chance',
    Default = 50,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.HitChance = Value
    end
})

Silent:AddSlider('Smoothing', {
    Text = 'Camlock Smoothing',
    Default = 50,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.Smoothing = Value
    end
})

FovSettings:AddToggle('Fov Visible', {
    Text = 'Enable',
    Default = false,
    Tooltip = 'Visible',
    Callback = function(Value)
        Settings.FovVisable = Value
    end
})

Colors:AddLabel('Fov Color'):AddColorPicker('ColorPicker', {
    Default = Color3.new(1, 1, 1),
    Title = 'Fov Color',
    Transparency = 0,

    Callback = function(Value)
        Settings.FovColor = Value
    end
})

FovSettings:AddToggle('Tracers', {
    Text = 'Fov Tracers',
    Default = false,
    Tooltip = 'Visible',
    Callback = function(Value)
        Settings.FovTracers = Value
    end
})

Colors:AddLabel('Fov Tracers Color'):AddColorPicker('ColorPicker', {
    Default = Color3.new(1, 1, 1), 
    Title = 'Fov Tracers Color', 
    Transparency = 0, 

    Callback = function(Value)
        Settings.FovTracersColor = Value
    end
})

FovSettings:AddSlider('Radois', {
    Text = 'Fov Radius',
    Default = 100,
    Min = 1,
    Max = 1000,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.FovRadius = Value
    end
})

FovSettings:AddSlider('Trans', {
    Text = 'Fov Transparency',
    Default = 0.4,
    Min = 0.1,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.FovTransparency = Value
    end
})

GunVisuals:AddToggle('Gun Visuals', {
    Text = 'Enable',
    Default = false,
    Tooltip = 'Gun Visuals',
    Callback = function(Value)
        Settings.GunVisuals = Value
    end
})

GunVisuals:AddDropdown('Material', {
    Values = { 'ForceField'},
    Default = 1, 
    Multi = false,

    Text = 'Gun Material',
    Tooltip = 'Material',

    Callback = function(Value)
        Settings.Material = Value
    end
})

Bot:AddToggle('Bot', {
    Text = 'Auto Bot',
    Default = false,
    Tooltip = 'Auto Finds players',
    Callback = function(Value)
        Settings.Bot = Value
    end
})

Bot:AddDropdown('bot', {
    Values = { 'Tween', 'Walking', 'Teleport'},
    Default = 1, 
    Multi = false,

    Text = 'Bot Method',
    Tooltip = 'Material',

    Callback = function(Value)
        Settings.Botmethod = Value
    end
})

Bot:AddToggle('Bot', {
    Text = 'Auto Equipe',
    Default = false,
    Tooltip = 'equipe tool',
    Callback = function(Value)
        Settings.autoequipe = Value
    end
})

Bot:AddDropdown('bot', {
    Values = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'},
    Default = 1, 
    Multi = false,

    Text = 'Auto Equipe tool',
    Tooltip = 'equipe tool',

    Callback = function(Value)
        Settings.equipeNumber = Value
    end
})

AntiAim:AddToggle('Antiaim', {
    Text = 'Anti Aim',
    Default = false,
    Tooltip = 'Anti aim',
    Callback = function(Value)
        Settings.AntiAim = Value
    end
})

AntiAim:AddDropdown('Material', {
    Values = { 'CFrame', 'Velocity'},
    Default = 1, 
    Multi = false,

    Text = 'Anti-Aim Type',
    Tooltip = 'Anti-Aim type',

    Callback = function(Value)
        Settings.Material = Value
    end
})

AntiAim:AddSlider('Antiaim', {
    Text = 'X',
    Default = 0,
    Min = -6000,
    Max = 6000,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.DesyncX = Value
    end
})

AntiAim:AddSlider('Antiaim', {
    Text = 'Y',
    Default = 0,
    Min = 0,
    Max = 6000,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.DesyncY = Value
    end
})

AntiAim:AddSlider('Antiaim', {
    Text = 'Z',
    Default = 0,
    Min = 6000,
    Max = -6000,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.DesyncZ = Value
    end
})

Speed:AddToggle('Speed', {
    Text = 'Speed',
    Default = false,
    Tooltip = 'Speedington',
    Callback = function(Value)
        Settings.Speed = Value
    end
})

Speed:AddDropdown('Method', {
    Values = { 'CFrame', 'Velocity', 'WalkSpeed', 'MoveDirection'},
    Default = 1, 
    Multi = false,

    Text = 'Speed Method',
    Tooltip = 'Speed Method',

    Callback = function(Value)
        Settings.SpeedMethod = Value
    end
})

Speed:AddSlider('SPeed', {
    Text = 'Speed Value',
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.SpeedValue = Value
    end
})

Fly:AddToggle('Speed', {
    Text = 'Fly',
    Default = false,
    Tooltip = 'Flyington',
    Callback = function(Value)
        Settings.Fly = Value
    end
})

Fly:AddDropdown('Method', {
    Values = { 'CFrame', 'Velocity'},
    Default = 1, 
    Multi = false,

    Text = 'Fly Method',
    Tooltip = 'Fly Method',

    Callback = function(Value)
        Settings.FlyMethod = Value
    end
})

Fly:AddSlider('SPeed', {
    Text = 'fly Value',
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Settings.FlyValue = Value
    end
})

Esp:AddToggle('Healthbar', {
    Text = 'Health Bar',
    Default = false,
    Tooltip = 'Healthbar',
    Callback = function(Value)
        Settings.HealthBar = Value
    end
})

local Fly = function()
    if Settings.Fly then
        if Settings.FlyMethod == "Velocity" then
            local forward = (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
            local right = (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0)
            local up = (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0)
            local direction = (Camera.CFrame * CFrame.new(right * 5, up * 5, forward * 5)).lookVector
            plr.Character.HumanoidRootPart.Velocity = direction * Settings.FlyValue
        elseif Settings.FlyMethod == "CFrame" then
            local forward = (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
            local right = (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0)
            local up = (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0)
            local direction = (Camera.CFrame * CFrame.new(right * 5, up * 5, forward * 5)).lookVector
            plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + direction * Settings.FlyValue/100
        end
    end
end

local Speed = function()
    if Settings.Speed then
        if Settings.SpeedMethod == "WalkSpeed" then
            plr.Character.Humanoid.WalkSpeed = Settings.SpeedValue
        elseif Settings.SpeedMethod == "MoveDirection" then
            plr.Character:TranslateBy(plr.Character.Humanoid.MoveDirection * Settings.SpeedValue/100)
        elseif Settings.SpeedMethod == "Velocity" then
            plr.Character.HumanoidRootPart.Velocity = plr.Character.HumanoidRootPart.Velocity + plr.Character.Humanoid.MoveDirection * Settings.SpeedValue
        elseif Settings.SpeedMethod == "CFrame" then
            plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + plr.Character.Humanoid.MoveDirection * Settings.SpeedValue/100
        end
    end
end

local ClosestPathfinding = function()
    local Closest = nil
    local Distance = math.huge
    for _,v in ipairs(plrs:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local magnitude = (v.Character:FindFirstChild("HumanoidRootPart").Position - plr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
            if magnitude < Distance then
                Closest = v.Character.HumanoidRootPart
                Distance = magnitude
            end
        end
    end
    return Closest
end

local Walking = function()
    local closestPlayer = ClosestPathfinding()
    if Settings.Bot then
        if closestPlayer then
            local humanoidRootPart = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local targetPosition = closestPlayer.Position

                if Settings.Botmethod == "Walking" then
                    local path = Pathfinding:CreatePath({
                        AgentRadius = 2,
                        AgentHeight = 5,
                        AgentCanJump = true,
                        AgentCanClimb = true,
                        AgentJumpHeight = 8,
                        AgentMaxSlope = 45,
                    })

                    path:ComputeAsync(humanoidRootPart.Position, targetPosition)

                    if path.Status == Enum.PathStatus.Success then
                        local waypoints = path:GetWaypoints()

                        for _, waypoint in ipairs(waypoints) do
                            local distance = (humanoidRootPart.Position - targetPosition).Magnitude
                            if distance > 4 then
                                plr.Character.Humanoid:MoveTo(waypoint.Position)
                                plr.Character.Humanoid.MoveToFinished:Wait()
                                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Position)
                            else
                                break
                            end
                        end
                    end
                elseif Settings.Botmethod == "Tween" then
                    local distance = (targetPosition - humanoidRootPart.Position).Magnitude
                    local duration = distance * 0.1

                    Util.CTween:go(plr, CFrame.new(targetPosition), duration)
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Position)
                elseif Settings.Botmethod == "Teleport" then
                    local path = Pathfinding:CreatePath({
                        AgentRadius = 2,
                        AgentHeight = 5,
                        AgentCanJump = true,
                        AgentCanClimb = true,
                        AgentJumpHeight = 8,
                        AgentMaxSlope = 45,
                    })

                    path:ComputeAsync(humanoidRootPart.Position, targetPosition)

                    if path.Status == Enum.PathStatus.Success then
                        local waypoints = path:GetWaypoints()

                        for _, waypoint in ipairs(waypoints) do
                            local distance = (humanoidRootPart.Position - targetPosition).Magnitude
                            if distance > 4 then
                                plr.Character.HumanoidRootPart.CFrame = CFrame.new(waypoint.Position) + Vector3.new(0, 3, 0)
                                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Position)
                                wait(0.1)
                            else
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local Method = getnamecallmethod()
    local Args = {...}
    local self = Args[1]
    local chance = HitChance(Settings.HitChance)
    if Settings.Enabled and self == workspace and not checkcaller() and chance == true then
        if Method == "FindPartOnRayWithIgnoreList" and Settings.Method == Method then
            local A_Ray = Args[2]
            local HitPart = GetClosestPlayer()
            if HitPart then
                local Origin = A_Ray.Origin
                local Direction = Direction(Origin, HitPart.Position)
                Args[2] = Ray.new(Origin, Direction)
                return OldNamecall(unpack(Args))
            end
        elseif Method == "FindPartOnRayWithWhitelist" and Settings.Method == Method then
            local A_Ray = Args[2]
            local HitPart = GetClosestPlayer()
            if HitPart then
                local Origin = A_Ray.Origin
                local Direction = Direction(Origin, HitPart.Position)
                Args[2] = Ray.new(Origin, Direction)
                return OldNamecall(unpack(Args))
            end
        elseif (Method == "FindPartOnRay" or Method == "findPartOnRay") and Settings.Method == Method then
            local A_Ray = Args[2]
            local HitPart = GetClosestPlayer()
            if HitPart then
                local Origin = A_Ray.Origin
                local Direction = Direction(Origin, HitPart.Position)
                Args[2] = Ray.new(Origin, Direction)
                return OldNamecall(unpack(Args))
            end
        elseif Method == "Raycast" and Settings.Method == Method then
            local A_Origin = Args[2]
            local HitPart = GetClosestPlayer()
            if HitPart then
                Args[3] = Direction(A_Origin, HitPart.Position)
                return OldNamecall(unpack(Args))
            end
        end
    end
    return OldNamecall(...)
end))  
  

local healthBars = {}

local function createSquare(color, size, outlineColor)
    local square = Drawing.new("Square")
    square.Visible = false
    square.Center = true
    square.Outline = true
    square.OutlineColor = outlineColor or Color3.fromRGB(0, 0, 0)
    square.Font = 1
    square.Size = size or Vector2.new(4, 40)
    square.Color = color or Color3.fromRGB(0, 255, 0)
    return square
end

local function updateHealthBars()
    local cameraCFrame = Camera.CFrame
    for _, v in pairs(plrs:GetChildren()) do
        if v.Name ~= plr.Name then
            local healthBar = healthBars[v]
            if not healthBar then
                healthBar = createSquare(Color3.fromRGB(0, 255, 0), Vector2.new(4, 40), Color3.fromRGB(0, 0, 0))
                healthBars[v] = healthBar
            end

            if Settings.HealthBar and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local humanoidRootPart = v.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local pos, vis = Camera.WorldToViewportPoint(Camera, humanoidRootPart.Position + Vector3.new(2.5, 0, 0))
                    if vis then
                        local healthPercent = v.Character.Humanoid.Health / v.Character.Humanoid.MaxHealth

                        local distance = (cameraCFrame.Position - humanoidRootPart.Position).Magnitude
                        local scale = math.clamp(1 / (distance * 0.02), 0.5, 2.5)

                        local healthBarSize = Vector2.new(4 * scale, 40 * scale * healthPercent)

                        healthBar.Visible = true
                        healthBar.Position = Vector2.new(pos.X, pos.Y) - Vector2.new(0, healthBarSize.Y / 2)

                        if healthPercent > 0.5 then
                            healthBar.Color = Color3.fromRGB((1 - healthPercent) * 510, 255, 0)
                        else
                            healthBar.Color = Color3.fromRGB(255, healthPercent * 510, 0)
                        end

                        healthBar.Size = healthBarSize
                    else
                        healthBar.Visible = false
                    end
                else
                    healthBar.Visible = false
                end
            else
                healthBar.Visible = false
            end
        end
    end
end

plrs.PlayerAdded:Connect(function(player)
    healthBars[player] = createSquare(Color3.fromRGB(0, 255, 0), Vector2.new(4, 40), Color3.fromRGB(0, 0, 0))
end)

plrs.PlayerRemoving:Connect(function(player)
    local healthBar = healthBars[player]
    if healthBar then
        healthBar.Visible = false
        healthBars[player] = nil
        healthBar:Remove()
    end
end)

RunService.RenderStepped:Connect(updateHealthBars)

local Fov = Drawing.new("Circle")
local Tracers = Drawing.new("Line")

local Fov = function()
    if Settings.FovVisable then
        Fov.Visible = true
        Fov.Color = Settings.FovColor
        Fov.Radius = Settings.FovRadius
        Fov.Transparency = Settings.FovTransparency
        Fov.Position = Vector2.new(mouse.X, mouse.Y + 36)
    else
        Fov.Visible = false
    end
end

local Tracers = function()
    if Settings.FovTracers then
        local Closest = GetClosestPlayer()
        Tracers.Visible = true
        Tracers.Color = Settings.FovTracersColor
        Tracers.Thickness = 1
        Tracers.From = Vector2.new(mouse.X, mouse.Y + 36)
        if Closest then
            Tracers.To = Vector2.new(Camera:WorldToViewportPoint(Closest.Position).X, Camera:WorldToViewportPoint(Closest.Position).Y)
        else
            Tracers.Visible = false
        end
    else
        Tracers.Visible = false
    end
end

local GunVisuals = function()
    if Settings.GunVisuals then
        local gun = Getgun(plr)
        if gun then
            for _,v in pairs(gun:GetDescendants()) do
                if v:IsA("MeshPart") then
                    v.Material = Settings.Material
                end
            end
        end
    end
end

local AntiAim = function()
    if Settings.AntiAim then
        if Settings.AntiAimType == "CFrame" then
            local oldCf = plr.Character.HumanoidRootPart.CFrame
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(oldCf.Position) * CFrame.Angles(math.rad(Settings.DesyncX), math.rad(Settings.DesyncY), math.rad(Settings.DesyncZ))
            plr.Character.HumanoidRootPart.CFrame = oldCf
        elseif Settings.AntiAimType == "Velocity" then
            local oldVel = plr.Character.HumanoidRootPart.Velocity
            plr.Character.HumanoidRootPart.Velocity = Vector3.new(oldVel.X + Settings.DesyncX, oldVel.Y + Settings.DesyncY, oldVel.Z + Settings.DesyncZ)
            plr.Character.HumanoidRootPart.Velocity = oldVel
        end
    end
end

local Autoequipe = function()
    if Settings.autoequipe then
        local tool = plr.Backpack:GetChildren()[Settings.equipeNumber]
        if tool then
            plr.Character.Humanoid:EquipTool(tool)
        end
    end
end

plr.CharacterAdded:Connect(function()
    wait(1)
    Autoequipe()
end)

RunService.RenderStepped:Connect(function()
    GunVisuals()
    Walking()
    AntiAim()
end)

RunService.Heartbeat:Connect(function()
    Fov()
    Tracers()
    TriggerBot()
    Camlock()
    Speed()
    Fly()
end)

Library:OnUnload(function()
    Library.Unloaded = true
end)

Library:SetWatermark(('Project Validus V2 | User: ' .. plr.Name .. ' | Version: 2.0.5'))

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
local MyButton = MenuGroup:AddButton({
    Text = 'Unload',
    Func = function()
        Library:Unload()
    end,
    DoubleClick = true,
    Tooltip = 'Unload Script'
})

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
MenuGroup:AddToggle('keybindframe', {
    Text = 'Keybind Frame',
    Default = false,
    Tooltip = 'Toggles KeybindFrame',
})

Toggles.keybindframe:OnChanged(function()
    Library.KeybindFrame.Visible = Toggles.keybindframe.Value
end)

MenuGroup:AddToggle('Watermark', {
    Text = 'Watermark',
    Default = false,
    Tooltip = 'Toggles Watermark',
})

Toggles.Watermark:OnChanged(function()
    Library:SetWatermarkVisibility(Toggles.Watermark.Value)
end)

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 
ThemeManager:SetFolder(Folder)
SaveManager:SetFolder(Folder..'/Games')
SaveManager:BuildConfigSection(Tabs['UI Settings']) 
ThemeManager:ApplyToTab(Tabs['UI Settings'])