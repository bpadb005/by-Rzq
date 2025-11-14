local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "ScriptHub"
mainGui.ResetOnSpawn = false
mainGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 290, 0, 340)
mainFrame.Position = UDim2.new(0.5, -145, 0.5, -170)
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
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Script Hub\nby Rzq"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

local function createHeaderButton(buttonText, buttonPosition, buttonColor)
    local headerButton = Instance.new("TextButton")
    headerButton.Size = UDim2.new(0, 22, 0, 22)
    headerButton.Position = buttonPosition
    headerButton.BackgroundColor3 = buttonColor
    headerButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    headerButton.Font = Enum.Font.GothamBold
    headerButton.TextSize = 18
    headerButton.BorderSizePixel = 0
    headerButton.AutoButtonColor = false
    headerButton.Text = buttonText
    headerButton.Parent = mainFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = headerButton

    return headerButton
end

local minimizeButton = createHeaderButton("-", UDim2.new(0, 8, 0, 7), Color3.fromRGB(60, 60, 60))
local closeButton = createHeaderButton("×", UDim2.new(1, -30, 0, 7), Color3.fromRGB(90, 40, 40))

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
contentMaskFrame.Position = UDim2.new(0, 0, 0, 35)
contentMaskFrame.BackgroundTransparency = 1
contentMaskFrame.ClipsDescendants = true
contentMaskFrame.Parent = mainFrame

local contentContainerFrame = Instance.new("Frame")
contentContainerFrame.Name = "ContentContainerFrame"
contentContainerFrame.Size = UDim2.new(1, 0, 1, 0)
contentContainerFrame.Position = UDim2.new(0, 0, 0, 0)
contentContainerFrame.BackgroundTransparency = 1
contentContainerFrame.Parent = contentMaskFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScriptList"
scrollFrame.Size = UDim2.new(1, -20, 1, -20)
scrollFrame.Position = UDim2.new(0, 10, 0, 10)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.Parent = contentContainerFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 0)
padding.PaddingLeft = UDim.new(0, 5)
padding.PaddingRight = UDim.new(0, 5)
padding.Parent = scrollFrame

local function createScriptItem(name, description, callback)
    local itemFrame = Instance.new("Frame")
    itemFrame.Size = UDim2.new(1, 0, 0, 50)
    itemFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = scrollFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = itemFrame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -70, 0, 24)
    nameLabel.Position = UDim2.new(0, 10, 0, 4)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    nameLabel.Text = name
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Parent = itemFrame

    local descriptionLabel = Instance.new("TextLabel")
    descriptionLabel.Size = UDim2.new(1, -70, 0, 25)
    descriptionLabel.Position = UDim2.new(0, 10, 0, 20)
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descriptionLabel.Text = description
    descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    descriptionLabel.Font = Enum.Font.Gotham
    descriptionLabel.TextSize = 13
    descriptionLabel.Parent = itemFrame

    local executeButton = Instance.new("TextButton")
    executeButton.Size = UDim2.new(0, 55, 0, 26)
    executeButton.Position = UDim2.new(1, -65, 0.5, -13)
    executeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    executeButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    executeButton.Font = Enum.Font.GothamBold
    executeButton.TextSize = 13
    executeButton.Text = "Run"
    executeButton.BorderSizePixel = 0
    executeButton.Parent = itemFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = executeButton

    hoverEffect(executeButton, Color3.fromRGB(45, 45, 45), Color3.fromRGB(65, 65, 65))

    executeButton.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

createScriptItem("Rzq", "Rayfield Interface Suite", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/bpadb005/by-Rzq/refs/heads/main/Rayfield%20by%20Rzq.lua'))()
end)

createScriptItem("Fly", "Fly like Admin", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/bpadb005/by-Rzq/refs/heads/main/Script/Fly%20by%20Rzq.lua'))()
end)

createScriptItem("Invisible", "Invisible Mode", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/bpadb005/by-Rzq/refs/heads/main/Script/Invisible%20by%20Rzq.lua'))()
end)

createScriptItem("Avatar Loader", "Copy Avatar + Emote", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/bpadb005/by-Rzq/refs/heads/main/Script/Avatar%20Loader%20by%20Rzq.lua'))()
end)

createScriptItem("Animation Loader", "Copy Animation + Emote", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/bpadb005/by-Rzq/refs/heads/main/Script/Animation%20Loader%20by%20Rzq.lua'))()
end)

createScriptItem("Sonic", "Sonic Mode", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/bpadb005/by-Rzq/refs/heads/main/Script/Sonic%20by%20Rzq.lua'))()
end)

local isMinimized = false
local originalMainFrameSize = mainFrame.Size
local originalContentMaskFrameSize = contentMaskFrame.Size
local lastScrollPos = 0

minimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized

	local tweenMainFrameSize
	local tweenContentMaskFrameSize

	if isMinimized then
		tweenMainFrameSize = UDim2.new(0, 290, 0, 35)
		tweenContentMaskFrameSize = UDim2.new(1, 0, 0, 0)
		lastScrollPos = scrollFrame.CanvasPosition.Y
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

	if not isMinimized then
		TweenService:Create(
			scrollFrame,
			TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ CanvasPosition = Vector2.new(0, lastScrollPos) }
		):Play()
	end
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame:Destroy()
end)
