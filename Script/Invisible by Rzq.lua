local function StartInvisibleScript()
local Keybind = "E"
local Transparency = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local realCharacter = player.Character or player.CharacterAdded:Wait()
local isInvisible = false
local canInvis = true
local fakeCharacter
local anchorPart
local pseudoAnchor
local storedPosition

local function createFakeCharacter()
	realCharacter.Archivable = true
	local clone = realCharacter:Clone()
	local part = Instance.new("Part")
	part.Anchored = true
	part.Size = Vector3.new(200, 1, 200)
	part.CFrame = CFrame.new(0, -500, 0)
	part.CanCollide = true
	part.Parent = workspace
	clone.Parent = workspace
	clone:MoveTo(part.Position + Vector3.new(0, 5, 0))
	for _, v in pairs(realCharacter:GetChildren()) do
		if v:IsA("LocalScript") then
			local s = v:Clone()
			s.Disabled = true
			s.Parent = clone
		end
	end
	if Transparency then
		for _, v in pairs(clone:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = 0.7
				v.Material = Enum.Material.SmoothPlastic
				v.CastShadow = false
				if v.Name == "HumanoidRootPart" then
					v.Transparency = 1
					v.CanCollide = false
				end
			elseif v:IsA("Decal") or v:IsA("Texture") then
				v.Transparency = 1
			end
		end
	end
	fakeCharacter = clone
	anchorPart = part
	pseudoAnchor = fakeCharacter:WaitForChild("HumanoidRootPart")
end

local function onCharacterRespawn()
	canInvis = false
	realCharacter = player.Character or player.CharacterAdded:Wait()
	canInvis = true
	isInvisible = false
	if fakeCharacter then fakeCharacter:Destroy() end
	if anchorPart then anchorPart:Destroy() end
	createFakeCharacter()
end

local function toggleInvisibility()
	if not isInvisible then
		storedPosition = realCharacter:WaitForChild("HumanoidRootPart").CFrame
		local storedCF = realCharacter.HumanoidRootPart.CFrame
		realCharacter.HumanoidRootPart.CFrame = fakeCharacter.HumanoidRootPart.CFrame
		fakeCharacter.HumanoidRootPart.CFrame = storedCF
		realCharacter.Humanoid:UnequipTools()
		player.Character = fakeCharacter
		workspace.CurrentCamera.CameraSubject = fakeCharacter:WaitForChild("Humanoid")
		pseudoAnchor = realCharacter.HumanoidRootPart
		for _, v in pairs(fakeCharacter:GetChildren()) do
			if v:IsA("LocalScript") then v.Disabled = false end
		end
		isInvisible = true
	else
		local storedCF = fakeCharacter.HumanoidRootPart.CFrame
		fakeCharacter.HumanoidRootPart.CFrame = realCharacter.HumanoidRootPart.CFrame
		realCharacter.HumanoidRootPart.CFrame = storedCF
		fakeCharacter.Humanoid:UnequipTools()
		player.Character = realCharacter
		workspace.CurrentCamera.CameraSubject = realCharacter:WaitForChild("Humanoid")
		pseudoAnchor = fakeCharacter.HumanoidRootPart
		for _, v in pairs(fakeCharacter:GetChildren()) do
			if v:IsA("LocalScript") then v.Disabled = true end
		end
		isInvisible = false
	end
end

local function bindFakeDeath()
	if not fakeCharacter then return end
	local humanoid = fakeCharacter:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Died:Connect(function()
			if not storedPosition then
				storedPosition = CFrame.new(0, 10, 0)
			end
			if player.Character ~= realCharacter then
				player.Character = realCharacter
				workspace.CurrentCamera.CameraSubject = realCharacter:WaitForChild("Humanoid")
			end
			if realCharacter:FindFirstChild("HumanoidRootPart") then
				realCharacter.HumanoidRootPart.CFrame = storedPosition + Vector3.new(0, 3, 0)
			end
			if fakeCharacter then fakeCharacter:Destroy() end
			if anchorPart then anchorPart:Destroy() end
			isInvisible = false
			canInvis = true
			createFakeCharacter()
			bindFakeDeath()
		end)
	end
end

RunService.RenderStepped:Connect(function()
	if pseudoAnchor then
		pseudoAnchor.CFrame = anchorPart.CFrame * CFrame.new(0, 5, 0)
	end
end)

player.CharacterAppearanceLoaded:Connect(onCharacterRespawn)
realCharacter:WaitForChild("Humanoid").Died:Connect(function()
	if fakeCharacter then fakeCharacter:Destroy() end
end)

createFakeCharacter()
bindFakeDeath()

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "Invisible"
mainGui.ResetOnSpawn = false
mainGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 200)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = mainGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 12)
mainFrameCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Invisible\nby Rzq"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

local function createHeaderButton(buttonText, buttonPosition, buttonColor)
    local headerButton = Instance.new("TextButton")
    headerButton.Size = UDim2.new(0, 20, 0, 20)
    headerButton.Position = buttonPosition
    headerButton.BackgroundColor3 = buttonColor
    headerButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    headerButton.Font = Enum.Font.GothamBold
    headerButton.TextSize = 16
    headerButton.BorderSizePixel = 0
    headerButton.AutoButtonColor = false
    headerButton.Text = buttonText
    headerButton.Parent = mainFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = headerButton

    return headerButton
end

local minimizeButton = createHeaderButton("-", UDim2.new(0, 5, 0, 5), Color3.fromRGB(60, 60, 60))
local closeButton = createHeaderButton("×", UDim2.new(1, -25, 0, 5), Color3.fromRGB(90, 40, 40))

local function hoverEffect(hoverTarget, normalColor, hoverColor)
    hoverTarget.MouseEnter:Connect(function()
        hoverTarget.BackgroundColor3 = hoverColor
    end)
    hoverTarget.MouseLeave:Connect(function()
        hoverTarget.BackgroundColor3 = normalColor
    end)
end

hoverEffect(minimizeButton, Color3.fromRGB(60, 60, 60), Color3.fromRGB(80, 80, 80))
hoverEffect(closeButton, Color3.fromRGB(90, 40, 40), Color3.fromRGB(120, 50, 50))

local contentMaskFrame = Instance.new("Frame")
contentMaskFrame.Name = "ContentMaskFrame"
contentMaskFrame.Size = UDim2.new(1, 0, 1, -35)
contentMaskFrame.Position = UDim2.new(0, 0, 0, 30)
contentMaskFrame.BackgroundTransparency = 1
contentMaskFrame.ClipsDescendants = true
contentMaskFrame.Parent = mainFrame

local contentContainerFrame = Instance.new("Frame")
contentContainerFrame.Name = "ContentContainerFrame"
contentContainerFrame.Size = UDim2.new(1, 0, 1, 0)
contentContainerFrame.BackgroundTransparency = 1
contentContainerFrame.Parent = contentMaskFrame

local invisibleButton = Instance.new("TextButton")
invisibleButton.Size = UDim2.new(1, -30, 0, 30)
invisibleButton.Position = UDim2.new(0, 15, 0, 10)
invisibleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
invisibleButton.TextColor3 = Color3.fromRGB(230, 230, 230)
invisibleButton.Font = Enum.Font.GothamBold
invisibleButton.TextSize = 13
invisibleButton.Text = "Invisible [" .. Keybind .. "]"
invisibleButton.BorderSizePixel = 0
invisibleButton.AutoButtonColor = false
invisibleButton.Parent = contentContainerFrame

Instance.new("UICorner", invisibleButton).CornerRadius = UDim.new(0, 8)
hoverEffect(invisibleButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -30, 0, 50)
statusLabel.Position = UDim2.new(0, 15, 0, 30)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextWrapped = true
statusLabel.Text = "Status: Visible"
statusLabel.Parent = contentContainerFrame

local noteLabel = Instance.new("TextLabel")
noteLabel.Size = UDim2.new(1, -30, 0, 60)
noteLabel.Position = UDim2.new(0, 15, 0, 70)
noteLabel.BackgroundTransparency = 1
noteLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
noteLabel.Font = Enum.Font.Gotham
noteLabel.TextSize = 12
noteLabel.TextWrapped = true
noteLabel.TextYAlignment = Enum.TextYAlignment.Top
noteLabel.TextXAlignment = Enum.TextXAlignment.Left
noteLabel.RichText = true
noteLabel.Text = [[<b>Note:</b>
Ketika karakter asli mati / respawn,
tekan tombol <b>"Re-Execute"</b>. Hal ini
agar script Invisible dapat bekerja kembali dengan normal.]]
noteLabel.Parent = contentContainerFrame

local reexecuteButton = Instance.new("TextButton")
reexecuteButton.Size = UDim2.new(0.33, 0, 0, 20)
reexecuteButton.Position = UDim2.new(0.335, 0, 0, 140)
reexecuteButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
reexecuteButton.TextColor3 = Color3.fromRGB(230, 230, 230)
reexecuteButton.Font = Enum.Font.GothamBold
reexecuteButton.TextSize = 13
reexecuteButton.Text = "Re-Execute"
reexecuteButton.BorderSizePixel = 0
reexecuteButton.AutoButtonColor = false
reexecuteButton.Parent = contentContainerFrame

Instance.new("UICorner", reexecuteButton).CornerRadius = UDim.new(0, 8)
hoverEffect(reexecuteButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))

local function updateStatus()
	if isInvisible then
		statusLabel.Text = "Status: Invisible"
		statusLabel.TextColor3 = Color3.fromRGB(120, 200, 120)
	else
		statusLabel.Text = "Status: Visible"
		statusLabel.TextColor3 = Color3.fromRGB(200, 120, 120)
	end
end

invisibleButton.MouseButton1Click:Connect(function()
	toggleInvisibility()
	updateStatus()
end)

reexecuteButton.MouseButton1Click:Connect(function()
    if isInvisible then
        toggleInvisibility()
        updateStatus()
        task.wait(0.2)
    end

    mainGui:Destroy()
    task.wait(0.1)
    StartInvisibleScript()
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode.Name:lower() == Keybind:lower() and canInvis then
		toggleInvisibility()
		updateStatus()
	end
end)

local isMinimized = false
local originalMainFrameSize = mainFrame.Size
local originalContentMaskFrameSize = contentMaskFrame.Size

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized

    local tweenMainFrameSize
    local tweenContentMaskFrameSize

    if isMinimized then
        tweenMainFrameSize = UDim2.new(0, 220, 0, 30)
        tweenContentMaskFrameSize = UDim2.new(1, 0, 0, 0)
    else
        tweenMainFrameSize = originalMainFrameSize
        tweenContentMaskFrameSize = originalContentMaskFrameSize
    end

    TweenService:Create(
        mainFrame,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = tweenMainFrameSize }
    ):Play()

    TweenService:Create(
        contentMaskFrame,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = tweenContentMaskFrameSize }
    ):Play()

    statusLabel.Visible = not isMinimized
end)

closeButton.MouseButton1Click:Connect(function()
    if isInvisible then
        toggleInvisibility()
        updateStatus()
    end
    
    mainGui:Destroy()
end)

updateStatus()
end

StartInvisibleScript()
