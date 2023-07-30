local plr = game.Players.LocalPlayer
local plrs = game.Players
local WorldToViewportPoint = workspace.CurrentCamera.WorldToViewportPoint
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local Settings = {
    HealthBar = false,
}

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
                    local pos, vis = WorldToViewportPoint(Camera, humanoidRootPart.Position + Vector3.new(2.5, 0, 0))
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
        healthBars:remove()
    end
end)

RunService.RenderStepped:Connect(updateHealthBars)
