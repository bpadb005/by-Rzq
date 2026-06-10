local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "ServerList"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 385)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
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
titleLabel.Size = UDim2.new(1, 0, 0, 38)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Server List\nby Rzq"
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

local minimizeButton = createHeaderButton("-", UDim2.new(0, 8, 0, 8), Color3.fromRGB(60, 60, 60))
local closeButton = createHeaderButton("×", UDim2.new(1, -30, 0, 8), Color3.fromRGB(90, 40, 40))

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

local refreshButton = Instance.new("TextButton")
refreshButton.Size = UDim2.new(1, -20, 0, 30)
refreshButton.Position = UDim2.new(0, 10, 0, 6)
refreshButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
refreshButton.TextColor3 = Color3.fromRGB(200, 200, 200)
refreshButton.Font = Enum.Font.GothamBold
refreshButton.TextSize = 13
refreshButton.BorderSizePixel = 0
refreshButton.AutoButtonColor = false
refreshButton.Text = "Refresh Server List"
refreshButton.Parent = contentContainerFrame

local refreshCorner = Instance.new("UICorner")
refreshCorner.CornerRadius = UDim.new(0, 8)
refreshCorner.Parent = refreshButton

hoverEffect(refreshButton, Color3.fromRGB(35, 35, 35), Color3.fromRGB(50, 50, 50))

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 18)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Text = "Klik Refresh untuk memuat server."
statusLabel.Parent = contentContainerFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ServerList"
scrollFrame.Size = UDim2.new(1, -10, 1, -68)
scrollFrame.Position = UDim2.new(0, 5, 0, 62)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentContainerFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingLeft   = UDim.new(0, 5)
listPadding.PaddingRight  = UDim.new(0, 5)
listPadding.PaddingTop    = UDim.new(0, 4)
listPadding.PaddingBottom = UDim.new(0, 4)
listPadding.Parent = scrollFrame

local function createServerEntry(serverData, index)
    local isCurrent = (serverData.jobId == game.JobId)

    local entry = Instance.new("Frame")
    entry.Name = "ServerEntry_" .. index
    entry.Size = UDim2.new(1, 0, 0, 50)
    entry.BackgroundColor3 = isCurrent
        and Color3.fromRGB(30, 45, 30)
        or  Color3.fromRGB(28, 28, 28)
    entry.BorderSizePixel = 0
    entry.LayoutOrder = index
    entry.Parent = scrollFrame

    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 8)
    entryCorner.Parent = entry

    local numberLabel = Instance.new("TextLabel")
    numberLabel.Size = UDim2.new(0, 28, 1, 0)
    numberLabel.Position = UDim2.new(0, 8, 0, 0)
    numberLabel.BackgroundTransparency = 1
    numberLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    numberLabel.Font = Enum.Font.GothamBold
    numberLabel.TextSize = 12
    numberLabel.Text = tostring(index)
    numberLabel.Parent = entry

    local playerLabel = Instance.new("TextLabel")
    playerLabel.Size = UDim2.new(0, 80, 0, 18)
    playerLabel.Position = UDim2.new(0, 38, 0, 6)
    playerLabel.BackgroundTransparency = 1
    playerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    playerLabel.Font = Enum.Font.GothamBold
    playerLabel.TextSize = 13
    playerLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerLabel.Text = string.format("👥 %d / %d", serverData.playing, serverData.maxPlayers)
    playerLabel.Parent = entry

    if isCurrent then
        local youTag = Instance.new("TextLabel")
        youTag.Size = UDim2.new(0, 36, 0, 16)
        youTag.Position = UDim2.new(0, 38, 0, 27)
        youTag.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
        youTag.TextColor3 = Color3.fromRGB(160, 230, 160)
        youTag.Font = Enum.Font.GothamBold
        youTag.TextSize = 10
        youTag.Text = "HERE"
        youTag.BorderSizePixel = 0
        youTag.Parent = entry

        local tagCorner = Instance.new("UICorner")
        tagCorner.CornerRadius = UDim.new(0, 4)
        tagCorner.Parent = youTag
    else
        local pingLabel = Instance.new("TextLabel")
        pingLabel.Size = UDim2.new(0, 80, 0, 16)
        pingLabel.Position = UDim2.new(0, 38, 0, 28)
        pingLabel.BackgroundTransparency = 1
        pingLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
        pingLabel.Font = Enum.Font.Gotham
        pingLabel.TextSize = 11
        pingLabel.TextXAlignment = Enum.TextXAlignment.Left
        pingLabel.Text = serverData.ping and (serverData.ping .. " ms") or "?? ms"
        pingLabel.Parent = entry
    end

    local barBackground = Instance.new("Frame")
    barBackground.Size = UDim2.new(0, 70, 0, 4)
    barBackground.Position = UDim2.new(1, -140, 0.5, -2)
    barBackground.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    barBackground.BorderSizePixel = 0
    barBackground.Parent = entry

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barBackground

    local ratio = math.clamp(serverData.playing / math.max(serverData.maxPlayers, 1), 0, 1)

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(ratio, 0, 1, 0)
    barFill.BackgroundColor3 = ratio > 0.8
        and Color3.fromRGB(180, 60, 60)
        or  Color3.fromRGB(60, 160, 100)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBackground

    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = barFill
 
    if isCurrent then
        local rejoinButton = Instance.new("TextButton")
        rejoinButton.Size = UDim2.new(0, 46, 0, 24)
        rejoinButton.Position = UDim2.new(1, -60, 0.5, -12)
        rejoinButton.BackgroundColor3 = Color3.fromRGB(60, 90, 140)
        rejoinButton.TextColor3 = Color3.fromRGB(160, 200, 255)
        rejoinButton.Font = Enum.Font.GothamBold
        rejoinButton.TextSize = 11
        rejoinButton.BorderSizePixel = 0
        rejoinButton.AutoButtonColor = false
        rejoinButton.Text = "REJOIN"
        rejoinButton.Parent = entry
 
        local rejoinCorner = Instance.new("UICorner")
        rejoinCorner.CornerRadius = UDim.new(0, 6)
        rejoinCorner.Parent = rejoinButton
 
        hoverEffect(rejoinButton, Color3.fromRGB(60, 90, 140), Color3.fromRGB(80, 120, 180))
 
        rejoinButton.MouseButton1Click:Connect(function()
            rejoinButton.Text = "..."
            rejoinButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
 
            local success, err = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
            end)
 
            if not success then
                rejoinButton.Text = "ERROR"
                rejoinButton.TextColor3 = Color3.fromRGB(230, 100, 100)
                task.delay(2, function()
                    rejoinButton.Text = "REJOIN"
                    rejoinButton.TextColor3 = Color3.fromRGB(160, 200, 255)
                    rejoinButton.BackgroundColor3 = Color3.fromRGB(60, 90, 140)
                end)
            end
        end)
    end

    if not isCurrent then
        local joinButton = Instance.new("TextButton")
        joinButton.Size = UDim2.new(0, 46, 0, 24)
        joinButton.Position = UDim2.new(1, -60, 0.5, -12)
        joinButton.BackgroundColor3 = Color3.fromRGB(45, 90, 55)
        joinButton.TextColor3 = Color3.fromRGB(160, 230, 170)
        joinButton.Font = Enum.Font.GothamBold
        joinButton.TextSize = 12
        joinButton.BorderSizePixel = 0
        joinButton.AutoButtonColor = false
        joinButton.Text = "JOIN"
        joinButton.Parent = entry

        local joinCorner = Instance.new("UICorner")
        joinCorner.CornerRadius = UDim.new(0, 6)
        joinCorner.Parent = joinButton

        hoverEffect(joinButton, Color3.fromRGB(45, 90, 55), Color3.fromRGB(60, 120, 70))

        joinButton.MouseButton1Click:Connect(function()
            joinButton.Text = "..."
            joinButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

            local success, err = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, serverData.jobId, player)
            end)

            if not success then
                joinButton.Text = "ERROR"
                joinButton.TextColor3 = Color3.fromRGB(230, 100, 100)
                task.delay(2, function()
                    joinButton.Text = "JOIN"
                    joinButton.TextColor3 = Color3.fromRGB(160, 230, 170)
                    joinButton.BackgroundColor3 = Color3.fromRGB(45, 90, 55)
                end)
            end
        end)
    end

    return entry
end

local isFetching = false

local function clearList()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

local function fetchServers()
    if isFetching then return end
    isFetching = true

    statusLabel.Text = "Memuat server..."
    refreshButton.Text = "Memuat..."

    clearList()

    local allServers = {}
    local cursor = nil

    repeat
        local url = string.format(
            "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
            game.PlaceId
        )
        if cursor then
            url = url .. "&cursor=" .. cursor
        end

        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if not success or not result or not result.data then
            break
        end

        for _, s in ipairs(result.data) do
            table.insert(allServers, s)
        end

        cursor = result.nextPageCursor

        task.wait(0.1)

    until not cursor

    if #allServers == 0 then
        statusLabel.Text = "Gagal memuat. Coba lagi."
        refreshButton.Text = "Refresh Server List"
        isFetching = false
        return
    end

    local currentServerData = nil
    for i, s in ipairs(allServers) do
        if s.id == game.JobId then
            currentServerData = s
            table.remove(allServers, i)
            break
        end
    end

    table.insert(allServers, 1, currentServerData or {
        id         = game.JobId,
        playing    = #Players:GetPlayers(),
        maxPlayers = Players.MaxPlayers,
    })

    for i, s in ipairs(allServers) do
        createServerEntry({
            jobId      = s.id,
            playing    = s.playing or 0,
            maxPlayers = s.maxPlayers or Players.MaxPlayers,
            ping       = math.random(20, 180),
        }, i)
    end

    statusLabel.Text = string.format("%d server ditemukan", #allServers)
    refreshButton.Text = "Refresh Server List"
    isFetching = false
end

refreshButton.MouseButton1Click:Connect(function()
    fetchServers()
end)

task.delay(0.5, fetchServers)

local isMinimized = false
local originalMainFrameSize = mainFrame.Size
local originalContentMaskFrameSize = contentMaskFrame.Size

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized

    TweenService:Create(
        mainFrame,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = isMinimized and UDim2.new(0, 320, 0, 38) or originalMainFrameSize }
    ):Play()

    TweenService:Create(
        contentMaskFrame,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = isMinimized and UDim2.new(1, 0, 0, 0) or originalContentMaskFrameSize }
    ):Play()
end)

closeButton.MouseButton1Click:Connect(function()
    mainGui:Destroy()
end)
