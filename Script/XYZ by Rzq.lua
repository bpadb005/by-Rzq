local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "XYZ"
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
titleLabel.Text = "XYZ\nby Rzq"
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

    local headerButtonCorner = Instance.new("UICorner")
    headerButtonCorner.CornerRadius = UDim.new(0, 6)
    headerButtonCorner.Parent = headerButton

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
contentMaskFrame.Size = UDim2.new(1, 0, 1, -40)
contentMaskFrame.Position = UDim2.new(0, 0, 0, 42)
contentMaskFrame.BackgroundTransparency = 1
contentMaskFrame.ClipsDescendants = true
contentMaskFrame.Parent = mainFrame

local contentContainerFrame = Instance.new("Frame")
contentContainerFrame.Name = "ContentContainerFrame"
contentContainerFrame.Size = UDim2.new(1, 0, 1, 0)
contentContainerFrame.BackgroundTransparency = 1
contentContainerFrame.Parent = contentMaskFrame

local buttonContainerFrame = Instance.new("Frame")
buttonContainerFrame.Name = "ButtonContainerFrame"
buttonContainerFrame.Size = UDim2.new(1, 0, 0, 110)
buttonContainerFrame.BackgroundTransparency = 1
buttonContainerFrame.Parent = contentContainerFrame

local buttonListLayout = Instance.new("UIListLayout")
buttonListLayout.Padding = UDim.new(0, 6)
buttonListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
buttonListLayout.FillDirection = Enum.FillDirection.Vertical
buttonListLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
buttonListLayout.Parent = buttonContainerFrame

local xyzLabel = Instance.new("TextLabel")
xyzLabel.Name = "XYZLabel"
xyzLabel.Size = UDim2.new(1, -30, 0, 24)
xyzLabel.Position = UDim2.new(0, 15, 0, 0)
xyzLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
xyzLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
xyzLabel.Font = Enum.Font.Code
xyzLabel.TextSize = 14
xyzLabel.TextXAlignment = Enum.TextXAlignment.Center
xyzLabel.Text = "X:- | Y:- | Z:-"
xyzLabel.Parent = buttonContainerFrame

local xyzLabelCorner = Instance.new("UICorner")
xyzLabelCorner.CornerRadius = UDim.new(0, 6)
xyzLabelCorner.Parent = xyzLabel

RunService.RenderStepped:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local pos = hrp.Position
        xyzLabel.Text = string.format("X:%.2f | Y:%.2f | Z:%.2f", pos.X, pos.Y, pos.Z)
    else
        xyzLabel.Text = "X:- | Y:- | Z:-"
    end
end)

local function createButton(buttonText, buttonColor)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 32)
    button.BackgroundColor3 = buttonColor
    button.Text = buttonText
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 0
    button.AutoButtonColor = false

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = buttonColor:Lerp(Color3.new(1,1,1), 0.1)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = buttonColor
    end)

    return button
end

local xyzScrollFrame = Instance.new("ScrollingFrame")
xyzScrollFrame.Name = "XYZScrollFrame"
xyzScrollFrame.Size = UDim2.new(1, -10, 1, -160)
xyzScrollFrame.Position = UDim2.new(0, 5, 0, 150)
xyzScrollFrame.BackgroundTransparency = 1
xyzScrollFrame.BorderSizePixel = 0
xyzScrollFrame.ScrollBarThickness = 6
xyzScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
xyzScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
xyzScrollFrame.CanvasSize = UDim2.new(0,0,0,0)
xyzScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
xyzScrollFrame.ClipsDescendants = true
xyzScrollFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.None
xyzScrollFrame.Parent = contentContainerFrame

local xyzScrollLayout = Instance.new("UIListLayout")
xyzScrollLayout.Padding = UDim.new(0, 4)
xyzScrollLayout.Parent = xyzScrollFrame

local savedXYZ = {}

local function updateXYZList()
    for _, child in pairs(xyzScrollFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = xyzScrollFrame

    if #savedXYZ == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, -10, 0, 22)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "Belum ada XYZ tersimpan."
        emptyLabel.TextColor3 = Color3.fromRGB(150,150,150)
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 13
        emptyLabel.TextXAlignment = Enum.TextXAlignment.Center
        emptyLabel.Parent = xyzScrollFrame
        return
    end

    for i, pos in ipairs(savedXYZ) do
        local entryFrame = Instance.new("Frame")
        entryFrame.Size = UDim2.new(1, -10, 0, 24)
        entryFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
        entryFrame.BorderSizePixel = 0
        entryFrame.Parent = xyzScrollFrame

        local entryCorner = Instance.new("UICorner")
        entryCorner.CornerRadius = UDim.new(0, 6)
        entryCorner.Parent = entryFrame

        local entryLabel = Instance.new("TextLabel")
        entryLabel.Size = UDim2.new(1, -70, 1, 0)
        entryLabel.BackgroundTransparency = 1
        entryLabel.TextColor3 = Color3.fromRGB(200,200,200)
        entryLabel.Font = Enum.Font.Code
        entryLabel.TextSize = 13
        entryLabel.TextXAlignment = Enum.TextXAlignment.Left
        entryLabel.Text = string.format("%d. (%.2f, %.2f, %.2f)", i, pos.X, pos.Y, pos.Z)
        entryLabel.Parent = entryFrame

        local labelPadding = Instance.new("UIPadding")
        labelPadding.PaddingLeft = UDim.new(0, 8)
        labelPadding.Parent = entryLabel

        local teleportButton = Instance.new("TextButton")
        teleportButton.Size = UDim2.new(0, 18, 0, 18)
        teleportButton.Position = UDim2.new(1, -50, 0, 3)
        teleportButton.BackgroundColor3 = Color3.fromRGB(70,160,240)
        teleportButton.TextColor3 = Color3.fromRGB(255,255,255)
        teleportButton.Font = Enum.Font.GothamBold
        teleportButton.TextSize = 14
        teleportButton.Text = "￫"
        teleportButton.BorderSizePixel = 0
        teleportButton.Parent = entryFrame

        local teleportButtonCorner = Instance.new("UICorner")
        teleportButtonCorner.CornerRadius = UDim.new(0, 6)
        teleportButtonCorner.Parent = teleportButton

        teleportButton.MouseButton1Click:Connect(function()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(pos)
            end
        end)

        local deleteButton = Instance.new("TextButton")
        deleteButton.Size = UDim2.new(0, 18, 0, 18)
        deleteButton.Position = UDim2.new(1, -27, 0, 3)
        deleteButton.BackgroundColor3 = Color3.fromRGB(180,50,50)
        deleteButton.TextColor3 = Color3.fromRGB(255,255,255)
        deleteButton.Font = Enum.Font.GothamBold
        deleteButton.TextSize = 16
        deleteButton.Text = "×"
        deleteButton.BorderSizePixel = 0
        deleteButton.Parent = entryFrame

        local deleteButtonCorner = Instance.new("UICorner")
        deleteButtonCorner.CornerRadius = UDim.new(0,6)
        deleteButtonCorner.Parent = deleteButton

        deleteButton.MouseButton1Click:Connect(function()
            table.remove(savedXYZ, i)
            updateXYZList()
        end)
    end
end

local saveButton = createButton("Simpan", Color3.fromRGB(50,170,90))
saveButton.Parent = buttonContainerFrame
saveButton.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        table.insert(savedXYZ, hrp.Position)
        updateXYZList()
    end
end)

local clearButton = createButton("Hapus Semua", Color3.fromRGB(200,50,50))
clearButton.Parent = buttonContainerFrame
clearButton.MouseButton1Click:Connect(function()
    savedXYZ = {}
    updateXYZList()
end)

local copyButton = createButton("Salin Semua", Color3.fromRGB(60,120,220))
copyButton.Parent = buttonContainerFrame
copyButton.MouseButton1Click:Connect(function()
    if #savedXYZ == 0 then
        setclipboard("Tidak ada XYZ tersimpan.")
        return
    end
    local lines = {}
    for i, pos in ipairs(savedXYZ) do
        table.insert(lines, string.format("[%d] (%.2f, %.2f, %.2f)", i, pos.X, pos.Y, pos.Z))
    end
    setclipboard(table.concat(lines, "\n"))
end)

updateXYZList()

local isMinimized = false
local originalMainFrameSize = mainFrame.Size
local originalContentMaskFrameSize = contentMaskFrame.Size
local lastScrollPos = 0

minimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized

	local tweenMainFrameSize
	local tweenContentMaskFrameSize

	if isMinimized then
		tweenMainFrameSize = UDim2.new(0, 290, 0, 40)
		tweenContentMaskFrameSize = UDim2.new(1, 0, 0, 0)
		lastScrollPos = xyzScrollFrame.CanvasPosition.Y
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
			xyzScrollFrame,
			TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ CanvasPosition = Vector2.new(0, lastScrollPos) }
		):Play()
	end
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame:Destroy()
end)
