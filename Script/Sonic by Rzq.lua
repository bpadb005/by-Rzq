local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local HOLD_KEY = Enum.KeyCode.Q
local NORMAL_SPEED = 16
local BOOSTED_SPEED = 120
local NORMAL_JUMP_POWER = 50
local BOOSTED_JUMP_POWER = 110

local isActive = false
local character, humanoid
local allTrails = {}
local auraEmitters = {}

local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0
blur.Enabled = false
blur.Name = "SonicBlur"

local colorCorrection = Instance.new("ColorCorrectionEffect", Lighting)
colorCorrection.Enabled = false
colorCorrection.Name = "SonicColorFX"

local soundActivate = Instance.new("Sound", Workspace)
soundActivate.SoundId = "rbxassetid://139909368044571"
soundActivate.Volume = 1

local soundLoop = Instance.new("Sound", Workspace)
soundLoop.SoundId = "rbxassetid://127963242920916"
soundLoop.Volume = 0
soundLoop.Looped = true
soundLoop.PlaybackSpeed = 0.15

local TWEEN_INFO = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local EFFECT_COLORS = {
    Active = {Contrast = 0.5, Saturation = 0.6, TintColor = Color3.fromRGB(87, 216, 255)},
    Inactive = {Contrast = 0, Saturation = 0, TintColor = Color3.new(1, 1, 1)}
}

local function fadeSound(sound, targetVolume, duration)
    local startVolume = sound.Volume
    local startTime = tick()
    local id = "Fade_" .. math.random()
    RunService:BindToRenderStep(id, 200, function()
        local alpha = math.clamp((tick() - startTime) / duration, 0, 1)
        sound.Volume = startVolume + (targetVolume - startVolume) * alpha
        if alpha >= 1 then
            RunService:UnbindFromRenderStep(id)
            if targetVolume == 0 then sound:Stop() end
        end
    end)
end

local function flashScreen()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 999

    TweenService:Create(frame, TweenInfo.new(0.05), {BackgroundTransparency = 0.2}):Play()
    task.wait(0.05)
    TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    task.delay(0.35, function() gui:Destroy() end)
end

local function cameraShake(duration, magnitude)
    local start = tick()
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if tick() - start > duration then conn:Disconnect() return end
        local offset = Vector3.new(
            (math.random() - 0.5) * magnitude,
            (math.random() - 0.5) * magnitude,
            0
        )
        camera.CFrame = camera.CFrame * CFrame.new(offset)
    end)
end

local function setVisuals(enable)
    colorCorrection.Enabled = true
    blur.Enabled = true

    local target = enable and EFFECT_COLORS.Active or EFFECT_COLORS.Inactive
    local blurSize = enable and 6 or 0

    TweenService:Create(blur, TWEEN_INFO, {Size = blurSize}):Play()
    TweenService:Create(colorCorrection, TWEEN_INFO, {
        Contrast = target.Contrast,
        Saturation = target.Saturation,
        TintColor = target.TintColor
    }):Play()

    if not enable then
        task.delay(0.5, function()
            if not isActive then
                colorCorrection.Enabled = false
                blur.Enabled = false
            end
        end)
    end
end

local function createTrail(part, offset0, offset1, width)
    local a0 = Instance.new("Attachment", part)
    local a1 = Instance.new("Attachment", part)
    a0.Position = offset0
    a1.Position = offset1

    local trail = Instance.new("Trail", part)
    trail.Attachment0 = a0
    trail.Attachment1 = a1
    trail.Lifetime = 0.3
    trail.LightEmission = 1
    trail.WidthScale = NumberSequence.new(width)
    trail.Color = ColorSequence.new(Color3.fromRGB(0, 220, 255), Color3.fromRGB(255, 255, 255))
    trail.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    }

    table.insert(allTrails, trail)
end

local function createAllTrails()
    local parts = {
        "HumanoidRootPart", "LeftHand", "RightHand", "LeftFoot", "RightFoot",
        "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Torso", "Head"
    }

    local offsetPairs = {
        {Vector3.new(0, 0.3, 0), Vector3.new(0, -0.3, 0)},
        {Vector3.new(0.1, 0.4, 0), Vector3.new(0.1, -0.4, 0)},
        {Vector3.new(-0.1, 0.4, 0), Vector3.new(-0.1, -0.4, 0)},
        {Vector3.new(0.15, 0.2, 0.1), Vector3.new(0.15, -0.2, 0.1)},
        {Vector3.new(-0.15, 0.2, 0.1), Vector3.new(-0.15, -0.2, 0.1)},
        {Vector3.new(0.1, 0, 0.15), Vector3.new(0.1, 0, -0.15)},
        {Vector3.new(-0.1, 0, 0.15), Vector3.new(-0.1, 0, -0.15)},
    }

    for _, name in ipairs(parts) do
        local part = character:FindFirstChild(name)
        if part then
            for i, offsets in ipairs(offsetPairs) do
                local width = 0.05 + (i * 0.02)
                createTrail(part, offsets[1], offsets[2], width)
            end
        end
    end
end

local function destroyAllTrails()
    for _, trail in ipairs(allTrails) do
        if trail and trail.Parent then trail:Destroy() end
    end
    table.clear(allTrails)
end

local function createAuraEmitter(part)
    local attachment = Instance.new("Attachment", part)
    local particle = Instance.new("ParticleEmitter", attachment)

    particle.Texture = "rbxassetid://3442350629"
    particle.Rate = 20
    particle.Lifetime = NumberRange.new(0.2, 0.4)
    particle.Speed = NumberRange.new(3, 6)
    particle.VelocitySpread = 360
    particle.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.2), NumberSequenceKeypoint.new(1, 0.4)})
    particle.LightEmission = 1
    particle.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(1, 1)})
    particle.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
    particle.ZOffset = 1

    table.insert(auraEmitters, attachment)
end

local function createElectricAura()
    local parts = {
        "Head", "HumanoidRootPart",
        "LeftHand", "RightHand", "LeftFoot", "RightFoot",
        "Left Arm", "Right Arm", "Left Leg", "Right Leg"
    }
    for _, name in ipairs(parts) do
        local part = character:FindFirstChild(name)
        if part then createAuraEmitter(part) end
    end
end

local function destroyElectricAura()
    for _, emitter in ipairs(auraEmitters) do
        if emitter and emitter.Parent then emitter:Destroy() end
    end
    table.clear(auraEmitters)
end

local function activateSonicMode()
    if isActive or not humanoid then return end
    isActive = true

    humanoid.WalkSpeed = BOOSTED_SPEED
    humanoid.JumpPower = BOOSTED_JUMP_POWER
    camera.FieldOfView = 100

    setVisuals(true)
    soundActivate:Play()
    soundLoop.Volume = 0
    soundLoop:Play()
    fadeSound(soundLoop, 1, 0.4)

    flashScreen()
    cameraShake(0.4, 0.3)
    createAllTrails()
    createElectricAura()
end

local function deactivateSonicMode()
    if not isActive then return end
    isActive = false

    humanoid.WalkSpeed = NORMAL_SPEED
    humanoid.JumpPower = NORMAL_JUMP_POWER
    camera.FieldOfView = 70

    setVisuals(false)
    fadeSound(soundLoop, 0, 0.5)

    flashScreen()
    cameraShake(0.3, 0.2)
    destroyAllTrails()
    destroyElectricAura()
end

local function bindCharacter(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")

    humanoid.HealthChanged:Connect(function(health)
        if health <= 0 then
            deactivateSonicMode()
        end
    end)
end

player.CharacterAdded:Connect(bindCharacter)
if player.Character then bindCharacter(player.Character) end

local gui = Instance.new("ScreenGui")
gui.Name = "Sonic"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 50, 0, 25)
button.Position = UDim2.new(1, -50, 0.5, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Sonic\nby Rzq"
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true
button.AutoButtonColor = false
button.Draggable = true
button.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = button

button.MouseEnter:Connect(function()
    TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 220, 255)}):Play()
end)
button.MouseLeave:Connect(function()
    TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
end)

button.MouseButton1Click:Connect(function()
    if isActive then
        deactivateSonicMode()
    else
        activateSonicMode()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == HOLD_KEY then
        activateSonicMode()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == HOLD_KEY then
        deactivateSonicMode()
    end
end)
