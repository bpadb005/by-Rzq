local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "DarkMinimalistUI"
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
titleLabel.Text = "Dark Minimalist UI\nby Rzq"
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
contentMaskFrame.Size = UDim2.new(1, 0, 1, -40)
contentMaskFrame.Position = UDim2.new(0, 0, 0, 40)
contentMaskFrame.BackgroundTransparency = 1
contentMaskFrame.ClipsDescendants = true
contentMaskFrame.Parent = mainFrame

local contentContainerFrame = Instance.new("Frame")
contentContainerFrame.Name = "ContentContainerFrame"
contentContainerFrame.Size = UDim2.new(1, 0, 1, 0)
contentContainerFrame.BackgroundTransparency = 1
contentContainerFrame.Parent = contentMaskFrame

local isMinimized = false
local originalFrameSize = mainFrame.Size

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized

    local targetFrameSize
    local targetMaskSize

    if isMinimized then
        targetFrameSize = UDim2.new(0, 290, 0, 40)
        targetMaskSize = UDim2.new(1, 0, 0, 0)
    else
        targetFrameSize = originalFrameSize
        targetMaskSize = UDim2.new(1, 0, 1, -40)
    end

    TweenService:Create(
        mainFrame,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = targetFrameSize }
    ):Play()

    TweenService:Create(
        contentMaskFrame,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = targetMaskSize }
    ):Play()
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame:Destroy()
end)

local contentLabel = Instance.new("TextLabel")
contentLabel.Name = "ContentLabel"
contentLabel.Size = UDim2.new(1, -20, 1, -50)
contentLabel.Position = UDim2.new(0, 10, 0, 45)
contentLabel.BackgroundTransparency = 1
contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
contentLabel.Text = "Tempat isi kontenmu di sini."
contentLabel.Font = Enum.Font.Gotham
contentLabel.TextSize = 14
contentLabel.TextWrapped = true
contentLabel.Parent = contentContainerFrame
