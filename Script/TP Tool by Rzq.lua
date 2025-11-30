local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "TP Tool\nby Rzq"

tool.Activated:Connect(function()
    local character = player.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetPosition = mouse.Hit.Position + Vector3.new(0, 3, 0)

    local lookDirection = (mouse.Hit.Position - hrp.Position).Unit
    local targetCFrame = CFrame.new(targetPosition, targetPosition + lookDirection)

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { CFrame = targetCFrame }
    )

    tween:Play()
end)

tool.Parent = player:WaitForChild("Backpack")
