local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local localKey = "Rzq"
local useOnlineKey = false
local onlineKeyURL = "https://pastebin.com/raw/xxxxxxxx"
local scriptURL = "https://raw.githubusercontent.com/bpadb005/by-Rzq/refs/heads/main/ScriptHub.lua"

local function getOnlineKey()
    local key = nil
    local success, err = pcall(function()
        key = game:HttpGet(onlineKeyURL)
    end)
    if success and key then
        return key:gsub("%s+", "")
    else
        return nil
    end
end

local onlineKey = nil
if useOnlineKey then
    onlineKey = getOnlineKey()
end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "KeySystem"
mainGui.ResetOnSpawn = false
mainGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 160)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = mainGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 10)
mainFrameCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.BorderSizePixel = 0
titleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.Text = "Key System"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 22, 0, 22)
closeButton.Position = UDim2.new(1, -30, 0, 7)
closeButton.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
closeButton.TextColor3 = Color3.fromRGB(230, 230, 230)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Text = "×"
closeButton.BorderSizePixel = 0
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -40, 0, 35)
keyBox.Position = UDim2.new(0, 20, 0, 55)
keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyBox.PlaceholderText = "Masukkan key..."
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(230, 230, 230)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.BorderSizePixel = 0
keyBox.ClearTextOnFocus = false
keyBox.Parent = mainFrame

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 8)
keyBoxCorner.Parent = keyBox

local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(1, -40, 0, 35)
submitButton.Position = UDim2.new(0, 20, 0, 100)
submitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
submitButton.TextColor3 = Color3.fromRGB(230, 230, 230)
submitButton.Font = Enum.Font.GothamBold
submitButton.TextSize = 15
submitButton.BorderSizePixel = 0
submitButton.Text = "Submit"
submitButton.Parent = mainFrame

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 8)
submitCorner.Parent = submitButton

local isChecking = false

local function isKeyCorrect(inputKey)
    if useOnlineKey and onlineKey then
        return inputKey == onlineKey
    else
        return inputKey == localKey
    end
end

local function fadeObject(object, duration)
    duration = duration or 0.4

    local props = {}

    if object:IsA("Frame") or object:IsA("TextButton") 
       or object:IsA("TextBox") or object:IsA("TextLabel") then
        props.BackgroundTransparency = 1
    end

    if object:IsA("TextButton") or object:IsA("TextBox") 
       or object:IsA("TextLabel") then
        props.TextTransparency = 1
    end

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, props)
    
    tween:Play()
    return tween
end

submitButton.MouseButton1Click:Connect(function()
    if isChecking then return end
    isChecking = true

    submitButton.Text = "Checking..."
    submitButton.Active = false

    local inputKey = keyBox.Text:gsub("%s+", "")
    task.wait(0.7)

    if isKeyCorrect(inputKey) then
        submitButton.Text = "Key Benar"

        local originalColor = submitButton.BackgroundColor3
        submitButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)

        task.wait(1.5)

        submitButton.BackgroundColor3 = originalColor

        local fadeTween = fadeObject(mainFrame, 0.4)
        fadeObject(titleLabel, 0.4)
        fadeObject(keyBox, 0.4)
        fadeObject(submitButton, 0.4)
        fadeObject(closeButton, 0.4)

        fadeTween.Completed:Wait()
        mainGui:Destroy()

        local success, err = pcall(function()
            loadstring(game:HttpGet(scriptURL))()
        end)
        if not success then warn(err) end
    else
        submitButton.Text = "Key Salah"

        local originalColor = submitButton.BackgroundColor3
        submitButton.BackgroundColor3 = Color3.fromRGB(150, 40, 40)

        task.wait(1.5)

        submitButton.BackgroundColor3 = originalColor
        submitButton.Text = "Submit"
        submitButton.Active = true
    end

    isChecking = false
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame:Destroy()
end)
