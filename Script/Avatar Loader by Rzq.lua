local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local backupAvatarDesc
local function backupAvatar(character)
    local humanoid = character:WaitForChild("Humanoid")
    backupAvatarDesc = humanoid:GetAppliedDescription()
end

if player.Character then
    backupAvatar(player.Character)
end
player.CharacterAdded:Connect(backupAvatar)

local function loadAvatar(username)
    if not username or username == "" then
        return false, "Username tidak boleh kosong."
    end

    local userId = (pcall(Players.GetUserIdFromNameAsync, Players, username) and Players:GetUserIdFromNameAsync(username))
    if not userId then
        return false, "Username " .. username .. " tidak ditemukan."
    end

    local character = player.Character
    if not character then
        return false, "Character tidak ada."
    end

    local humanoidDesc = (pcall(Players.GetHumanoidDescriptionFromUserId, Players, userId) and Players:GetHumanoidDescriptionFromUserId(userId))
    if not humanoidDesc then
        return false, "Gagal mendapatkan avatar dari " .. username
    end

    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
            item:Destroy()
        end
    end
    task.wait(0.1)

    if not pcall(function()
        character.Humanoid:ApplyDescriptionClientServer(humanoidDesc)
        task.wait(0.5)
    end) then
        return false, "Avatar gagal diubah ke: " .. username
    end

    return true, "Avatar berhasil diubah ke: " .. username
end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "AvatarLoader"
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
titleLabel.Text = "Avatar Loader\nby Rzq"
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

local usernameBox = Instance.new("TextBox")
usernameBox.Size = UDim2.new(1, -30, 0, 30)
usernameBox.Position = UDim2.new(0, 15, 0, 15)
usernameBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
usernameBox.PlaceholderText = "Masukkan username..."
usernameBox.Text = ""
usernameBox.TextColor3 = Color3.fromRGB(220, 220, 220)
usernameBox.Font = Enum.Font.Gotham
usernameBox.TextSize = 13
usernameBox.BorderSizePixel = 0
usernameBox.ClearTextOnFocus = false
usernameBox.Parent = contentContainerFrame

Instance.new("UICorner", usernameBox).CornerRadius = UDim.new(0, 8)

local loadButton = Instance.new("TextButton")
loadButton.Size = UDim2.new(1, -30, 0, 30)
loadButton.Position = UDim2.new(0, 15, 0, 55)
loadButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
loadButton.TextColor3 = Color3.fromRGB(230, 230, 230)
loadButton.Font = Enum.Font.GothamBold
loadButton.TextSize = 13
loadButton.Text = "Load Avatar"
loadButton.BorderSizePixel = 0
loadButton.AutoButtonColor = false
loadButton.Parent = contentContainerFrame

Instance.new("UICorner", loadButton).CornerRadius = UDim.new(0, 8)
hoverEffect(loadButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))

local restoreButton = Instance.new("TextButton")
restoreButton.Size = UDim2.new(1, -30, 0, 30)
restoreButton.Position = UDim2.new(0, 15, 0, 95)
restoreButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
restoreButton.TextColor3 = Color3.fromRGB(230, 230, 230)
restoreButton.Font = Enum.Font.GothamBold
restoreButton.TextSize = 13
restoreButton.Text = "Restore Avatar"
restoreButton.BorderSizePixel = 0
restoreButton.AutoButtonColor = false
restoreButton.Parent = contentContainerFrame

Instance.new("UICorner", restoreButton).CornerRadius = UDim.new(0, 8)
hoverEffect(restoreButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -30, 0, 50)
statusLabel.Position = UDim2.new(0, 15, 0, 118)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextWrapped = true
statusLabel.Text = "Masukkan username ￫ klik Load Avatar."
statusLabel.Parent = contentContainerFrame

loadButton.MouseButton1Click:Connect(function()
    statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    statusLabel.Text = "Memuat avatar..."
    task.spawn(function()
        local success, message = loadAvatar(usernameBox.Text)
        statusLabel.TextColor3 = success and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        statusLabel.Text = message
    end)
end)

restoreButton.MouseButton1Click:Connect(function()
    if not backupAvatarDesc then
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        statusLabel.Text = "Avatar asli belum tersimpan."
        return
    end
    statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    statusLabel.Text = "Mengembalikan avatar asli..."
    task.spawn(function()
        local success = pcall(function()
            player.Character.Humanoid:ApplyDescriptionClientServer(backupAvatarDesc)
        end)
        statusLabel.TextColor3 = success and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        statusLabel.Text = success and "Avatar asli berhasil dikembalikan." or "Gagal mengembalikan avatar asli."
    end)
end)

local isMinimized = false
local originalFrameSize = mainFrame.Size
local originalMaskSize = contentMaskFrame.Size

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized

    local targetFrameSize = isMinimized and UDim2.new(0, 220, 0, 30) or originalFrameSize
    local targetMaskSize = isMinimized and UDim2.new(1, 0, 0, 0) or originalMaskSize

    TweenService:Create(mainFrame, TweenInfo.new(0.35), { Size = targetFrameSize }):Play()
    TweenService:Create(contentMaskFrame, TweenInfo.new(0.35), { Size = targetMaskSize }):Play()

    statusLabel.Visible = not isMinimized
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame:Destroy()
end)
