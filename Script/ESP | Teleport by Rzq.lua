local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local espEnabled = true

local function createESP(plr)
    if not plr.Character then return end
    if not plr.Character:FindFirstChild("Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = plr.Character
    end
    local head = plr.Character:FindFirstChild("Head")
    if head and not head:FindFirstChild("ESPLabel") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPLabel"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 100, 0, 16)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = plr.Name
        text.TextScaled = true
        text.TextColor3 = Color3.new(1, 1, 1)
        text.Font = Enum.Font.SourceSans
        text.Parent = billboard
    end
end

local function removeESP(plr)
    if not plr.Character then return end
    local h = plr.Character:FindFirstChild("Highlight")
    if h then h:Destroy() end
    local head = plr.Character:FindFirstChild("Head")
    if head then
        local b = head:FindFirstChild("ESPLabel")
        if b then b:Destroy() end
    end
end

task.spawn(function()
    while true do
        if espEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player then
                    if plr.Character and plr.Character:FindFirstChild("Head") then
                        createESP(plr)
                    else
                        removeESP(plr)
                    end
                end
            end
        else
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player then
                    removeESP(plr)
                end
            end
        end
        task.wait(1)
    end
end)

local function teleportToPlayer(plr)
    if not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    local tRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if root and tRoot then
        root.CFrame = CFrame.new(tRoot.Position + Vector3.new(0, 5, 0))
    end
end

mouse.Button1Down:Connect(function()
    if not espEnabled then return end
    local cam = workspace.CurrentCamera
    local closest = nil
    local closestDist = 50
    local mousePos = Vector2.new(mouse.X, mouse.Y)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local screenPos = cam:WorldToScreenPoint(hrp.Position)
            local dist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = plr
            end
        end
    end

    if closest then
        teleportToPlayer(closest)
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "ESP|Teleport"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 120, 0, 30)
button.Position = UDim2.new(0, 20, 0, 20)
button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "ESP|Teleport: ON\nby Rzq"
button.TextSize = 14
button.Font = Enum.Font.SourceSansBold
button.AutoButtonColor = true
button.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = button

button.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    button.Text = espEnabled and "ESP|Teleport: ON\nby Rzq" or "ESP|Teleport: OFF\nby Rzq"
end)

StarterGui:SetCore("SendNotification", {
    Title = "ESP|Teleport",
    Text = "Saat ON klik pemain untuk teleport.\nby Rzq",
    Duration = 5
})
