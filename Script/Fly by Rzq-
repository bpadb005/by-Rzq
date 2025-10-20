local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "Fly"
mainGui.Parent = player:WaitForChild("PlayerGui")
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = mainGui
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.Position = UDim2.new(0.1, 0, 0.38, 0)
mainFrame.Size = UDim2.new(0, 190, 0, 57)
mainFrame.Active = true
mainFrame.Draggable = true

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Position = UDim2.new(0.43, 0, 0, 0)
titleLabel.Size = UDim2.new(0, 108, 0, 28)
titleLabel.Font = Enum.Font.SourceSans
titleLabel.Text = "Fly by Rzq"
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.TextWrapped = true
titleLabel.TextSize = 20

local upButton = Instance.new("TextButton")
local downButton = Instance.new("TextButton")
local plusButton = Instance.new("TextButton")
local minusButton = Instance.new("TextButton")
local speedLabel = Instance.new("TextLabel")
local ONOFFButton = Instance.new("TextButton")
local minimizeButton = Instance.new("TextButton")
local maximizeButton = Instance.new("TextButton")
local closeButton = Instance.new("TextButton")

local function makeButton(button, parent, pos, size, text)
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.Position = pos
    button.Size = size
    button.Font = Enum.Font.SourceSans
    button.Text = text
    button.TextColor3 = Color3.fromRGB(0, 0, 0)
    button.TextWrapped = true
    button.TextSize = 20
end

makeButton(upButton, mainFrame, UDim2.new(0, 0, 0, 0), UDim2.new(0, 40, 0, 28), "↑")
makeButton(downButton, mainFrame, UDim2.new(0, 0, 0.512, 0), UDim2.new(0, 40, 0, 28), "↓")
makeButton(plusButton, mainFrame, UDim2.new(0.215, 0, 0, 0), UDim2.new(0, 40, 0, 28), "+")
makeButton(minusButton, mainFrame, UDim2.new(0.215, 0, 0.512, 0), UDim2.new(0, 40, 0, 28), "-")
makeButton(ONOFFButton, mainFrame, UDim2.new(0.675, 0, 0.512, 0), UDim2.new(0, 62, 0, 28), "Fly")
makeButton(minimizeButton, mainFrame, UDim2.new(0, 41, -1, 27), UDim2.new(0, 40, 0, 28), "−")
minimizeButton.TextSize = 20
makeButton(maximizeButton, mainFrame, UDim2.new(0, 41, -1, 57), UDim2.new(0, 40, 0, 28), "+")
maximizeButton.TextSize = 20
maximizeButton.Visible = false
makeButton(closeButton, mainFrame, UDim2.new(0, 0, -1, 27), UDim2.new(0, 40, 0, 28), "×")
closeButton.TextSize = 20

speedLabel.Name = "speedLabel"
speedLabel.Parent = mainFrame
speedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Position = UDim2.new(0.43, 0, 0.512, 0)
speedLabel.Size = UDim2.new(0, 45, 0, 28)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Text = "50"
speedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
speedLabel.TextWrapped = true
speedLabel.TextSize = 20

local flyEnabled = false
local flySpeed = 50
local acceleration = 6
local rotationSmoothness = 4
local bodyVelocity
local bodyGyro
local flyConnection
local lastLookDirection = Vector3.new(0, 0, 0)
local holdingUp = false
local holdingDown = false

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getRootPart()
    return getCharacter():FindFirstChild("HumanoidRootPart")
end

local function waitForControlModule()
    local playerModule = player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
    return require(playerModule):GetControls()
end

local function getInputVector(controlModule)
    local moveVector = Vector3.zero
    if controlModule then
        local success, controlVec = pcall(function()
            return controlModule:GetMoveVector()
        end)
        if success and controlVec and controlVec.Magnitude > 0.05 then
            return controlVec
        end
    end
    local humanoid = getCharacter():FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.MoveDirection.Magnitude > 0.05 then
        return humanoid.MoveDirection
    end
    return Vector3.zero
end

local function startFly()
    local root = getRootPart()
    if not root then return end
    flyEnabled = true
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Parent = root
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Parent = root
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 5000
    bodyGyro.D = 500
    local humanoid = getCharacter():FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.PlatformStand = true end
    local camera = workspace.CurrentCamera
    lastLookDirection = camera.CFrame.LookVector
    local controlModule = waitForControlModule()
    if flyConnection then flyConnection:Disconnect() end
    flyConnection = RunService.Heartbeat:Connect(function(dt)
        if not flyEnabled then return end
        local moveVec = getInputVector(controlModule)
        local targetVelocity = Vector3.zero
        if moveVec.Magnitude > 0 then
            targetVelocity = camera.CFrame:VectorToWorldSpace(moveVec).Unit * flySpeed
        end
        if holdingUp then targetVelocity = targetVelocity + Vector3.new(0, flySpeed, 0) end
        if holdingDown then targetVelocity = targetVelocity + Vector3.new(0, -flySpeed, 0) end
        bodyVelocity.Velocity = bodyVelocity.Velocity:Lerp(targetVelocity, math.clamp(dt * acceleration, 0, 1))
        local smoothedLook = lastLookDirection:Lerp(camera.CFrame.LookVector, math.clamp(dt * rotationSmoothness, 0, 1))
        lastLookDirection = smoothedLook
        bodyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + smoothedLook)
    end)
end

local function stopFly()
    flyEnabled = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    if flyConnection then flyConnection:Disconnect() end
    local humanoid = getCharacter():FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.PlatformStand = false end
    holdingUp = false
    holdingDown = false
end

local speeds = flySpeed

ONOFFButton.MouseButton1Click:Connect(function()
    if not flyEnabled then
        startFly()
        ONOFFButton.Text = "Stop"
    else
        stopFly()
        ONOFFButton.Text = "Fly"
    end
end)

plusButton.MouseButton1Click:Connect(function()
    speeds = speeds + 10
    flySpeed = speeds
    speedLabel.Text = tostring(speeds)
end)

minusButton.MouseButton1Click:Connect(function()
    if speeds > 10 then
        speeds = speeds - 10
        flySpeed = speeds
        speedLabel.Text = tostring(speeds)
    else
        speedLabel.Text = "Min 10"
        wait(0.8)
        speedLabel.Text = tostring(speeds)
    end
end)

upButton.MouseButton1Down:Connect(function() holdingUp = true end)
upButton.MouseButton1Up:Connect(function() holdingUp = false end)
downButton.MouseButton1Down:Connect(function() holdingDown = true end)
downButton.MouseButton1Up:Connect(function() holdingDown = false end)

closeButton.MouseButton1Click:Connect(function()
    mainGui:Destroy()
    stopFly()
end)

minimizeButton.MouseButton1Click:Connect(function()
    upButton.Visible = false
    downButton.Visible = false
    plusButton.Visible = false
    minusButton.Visible = false
    speedLabel.Visible = false
    ONOFFButton.Visible = false
    minimizeButton.Visible = false
    maximizeButton.Visible = true
    mainFrame.BackgroundTransparency = 1
    closeButton.Position = UDim2.new(0, 0, -1, 57)
end)

maximizeButton.MouseButton1Click:Connect(function()
    upButton.Visible = true
    downButton.Visible = true
    plusButton.Visible = true
    minusButton.Visible = true
    speedLabel.Visible = true
    ONOFFButton.Visible = true
    minimizeButton.Visible = true
    maximizeButton.Visible = false
    mainFrame.BackgroundTransparency = 0
    closeButton.Position = UDim2.new(0, 0, -1, 27)
end)
