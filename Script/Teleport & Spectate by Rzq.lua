local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "Teleport|Spectate"
mainGui.ResetOnSpawn = false
mainGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 220)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = mainGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 10)
mainFrameCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 28)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Teleport | Spectate\nby Rzq"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

local function createHeaderButton(buttonText, buttonPosition, buttonColor)
    local headerButton = Instance.new("TextButton")
    headerButton.Size = UDim2.new(0, 18, 0, 18)
    headerButton.Position = buttonPosition
    headerButton.BackgroundColor3 = buttonColor
    headerButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    headerButton.Font = Enum.Font.GothamBold
    headerButton.TextSize = 16
    headerButton.BorderSizePixel = 0
    headerButton.AutoButtonColor = false
    headerButton.Text = buttonText
    headerButton.Parent = mainFrame

    local headerButtonCorner = Instance.new("UICorner")
    headerButtonCorner.CornerRadius = UDim.new(0, 5)
    headerButtonCorner.Parent = headerButton

    return headerButton
end

local minimizeButton = createHeaderButton("-", UDim2.new(0, 6, 0, 5), Color3.fromRGB(60, 60, 60))
local closeButton = createHeaderButton("×", UDim2.new(1, -26, 0, 5), Color3.fromRGB(90, 40, 40))

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
contentMaskFrame.Size = UDim2.new(1, 0, 1, -32)
contentMaskFrame.Position = UDim2.new(0, 0, 0, 32)
contentMaskFrame.BackgroundTransparency = 1
contentMaskFrame.ClipsDescendants = true
contentMaskFrame.Parent = mainFrame

local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, 0, 1, 0)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = contentMaskFrame

local listContainer = Instance.new("ScrollingFrame")
listContainer.Name = "PlayerList"
listContainer.Size = UDim2.new(0, 210, 0, 112)
listContainer.Position = UDim2.new(0.5, -105, 0, 2)
listContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
listContainer.ScrollBarThickness = 4
listContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
listContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listContainer.ScrollingDirection = Enum.ScrollingDirection.Y
listContainer.ZIndex = 3
listContainer.Parent = contentContainer

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 6)
listCorner.Parent = listContainer

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(50, 50, 50)
stroke.Parent = listContainer

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 3)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = listContainer

local listPadding = Instance.new("UIPadding")
listPadding.PaddingLeft = UDim.new(0, 4)
listPadding.PaddingTop = UDim.new(0, 4)
listPadding.Parent = listContainer

local selectedPlayer, selectedButton = nil, nil

local function updateCanvas()
	task.wait()
	listContainer.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

local function refreshList()
	local selectedName = selectedPlayer and selectedPlayer.Name or nil

	for _, child in ipairs(listContainer:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local option = Instance.new("TextButton")
			option.Name = plr.Name
			option.Size = UDim2.new(1, -8, 0, 24)
			option.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			option.TextColor3 = Color3.fromRGB(220, 220, 220)
			option.Text = plr.Name
			option.Font = Enum.Font.Gotham
			option.TextSize = 12
			option.BorderSizePixel = 0
			option.AutoButtonColor = false
			option.ZIndex = 4
			option.Parent = listContainer

			local optionCorner = Instance.new("UICorner")
			optionCorner.CornerRadius = UDim.new(0, 5)
			optionCorner.Parent = option

			option.MouseEnter:Connect(function()
				if option ~= selectedButton then
					TweenService:Create(option, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
				end
			end)

			option.MouseLeave:Connect(function()
				if option ~= selectedButton then
					TweenService:Create(option, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
				end
			end)

			option.MouseButton1Click:Connect(function()
				selectedPlayer = plr
				if selectedButton and selectedButton ~= option then
					TweenService:Create(selectedButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
				end
				selectedButton = option
				TweenService:Create(option, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 90, 90)}):Play()
			end)

			if plr.Name == selectedName then
				selectedPlayer, selectedButton, option.BackgroundColor3 = plr, option, Color3.fromRGB(90, 90, 90)
			end
		end
	end

	updateCanvas()
end

refreshList()

Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(function(leaving)
	if selectedPlayer == leaving then
		selectedPlayer = nil
		if selectedButton then
			TweenService:Create(selectedButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
			selectedButton = nil
		end
	end
	refreshList()
end)

local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(0, 210, 0, 28)
teleportButton.Position = UDim2.new(0.5, -105, 0, 120)
teleportButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
teleportButton.TextColor3 = Color3.fromRGB(230, 230, 230)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 12
teleportButton.Text = "Teleport"
teleportButton.BorderSizePixel = 0
teleportButton.Parent = contentContainer

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 6)
teleportCorner.Parent = teleportButton

hoverEffect(teleportButton, Color3.fromRGB(45, 45, 45), Color3.fromRGB(70, 70, 70))

teleportButton.MouseButton1Click:Connect(function()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local target = selectedPlayer.Character.HumanoidRootPart
		local char = player.Character or player.CharacterAdded:Wait()
		if char:FindFirstChild("HumanoidRootPart") then
			char:MoveTo(target.Position + Vector3.new(0, 2, 0))
		end
	end
end)

local spectateButton = Instance.new("TextButton")
spectateButton.Name = "SpectateButton"
spectateButton.Size = UDim2.new(0, 210, 0, 28)
spectateButton.Position = UDim2.new(0.5, -105, 0, 152)
spectateButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
spectateButton.TextColor3 = Color3.fromRGB(230, 230, 230)
spectateButton.Font = Enum.Font.GothamBold
spectateButton.TextSize = 12
spectateButton.Text = "Spectate"
spectateButton.BorderSizePixel = 0
spectateButton.Parent = contentContainer

local spectateCorner = Instance.new("UICorner")
spectateCorner.CornerRadius = UDim.new(0, 6)
spectateCorner.Parent = spectateButton

hoverEffect(spectateButton, Color3.fromRGB(45, 45, 45), Color3.fromRGB(70, 70, 70))

local isSpectating = false
local spectateConnection

spectateButton.MouseButton1Click:Connect(function()
	if not selectedPlayer or not selectedPlayer.Character then return end
	if isSpectating then
		isSpectating = false
		spectateButton.Text = "Spectate"
		if spectateConnection then spectateConnection:Disconnect() end
		camera.CameraSubject = player.Character:FindFirstChildWhichIsA("Humanoid")
		camera.CameraType = Enum.CameraType.Custom
	else
		isSpectating = true
		spectateButton.Text = "Stop Spectate"
		spectateConnection = RunService.RenderStepped:Connect(function()
			if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("Humanoid") then
				isSpectating = false
				spectateButton.Text = "Spectate"
				camera.CameraSubject = player.Character:FindFirstChildWhichIsA("Humanoid")
				if spectateConnection then spectateConnection:Disconnect() end
				return
			end
			camera.CameraSubject = selectedPlayer.Character:FindFirstChild("Humanoid")
		end)
	end
end)

Players.PlayerRemoving:Connect(function(leaving)
	if selectedPlayer == leaving then
		selectedPlayer = nil
		if isSpectating then
			isSpectating = false
			spectateButton.Text = "Spectate"
			if spectateConnection then spectateConnection:Disconnect() end
			camera.CameraSubject = player.Character:FindFirstChildWhichIsA("Humanoid")
		end
	end
	refreshList()
end)

local isMinimized = false
local originalMainFrameSize = mainFrame.Size
local originalContentMaskFrameSize = contentMaskFrame.Size

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized

    local tweenMainFrameSize
    local tweenContentMaskFrameSize

    if isMinimized then
        tweenMainFrameSize = UDim2.new(0, 240, 0, 32)
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
end)

closeButton.MouseButton1Click:Connect(function()
	mainFrame:Destroy()
end)
