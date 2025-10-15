local player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 220)
frame.Position = UDim2.new(0.5, -120, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Text = "Teleport & Spectate\nby Rzq"
title.BorderSizePixel = 0
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local function createHeaderButton(text, pos, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 18, 0, 18)
	btn.Position = pos
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.fromRGB(230, 230, 230)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Text = text
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
	return btn
end

local minimizeBtn = createHeaderButton("-", UDim2.new(0, 6, 0, 5), Color3.fromRGB(60, 60, 60))
local closeBtn = createHeaderButton("×", UDim2.new(1, -26, 0, 5), Color3.fromRGB(90, 40, 40))

local function hoverEffect(btn, normal, hover)
	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = hover
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = normal
	end)
end

hoverEffect(minimizeBtn, Color3.fromRGB(60, 60, 60), Color3.fromRGB(80, 80, 80))
hoverEffect(closeBtn, Color3.fromRGB(90, 40, 40), Color3.fromRGB(120, 50, 50))

local contentMask = Instance.new("Frame")
contentMask.Size = UDim2.new(1, 0, 1, -32)
contentMask.Position = UDim2.new(0, 0, 0, 32)
contentMask.BackgroundTransparency = 1
contentMask.ClipsDescendants = true
contentMask.Parent = frame

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, 0)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = contentMask

local minimized = false
local originalSize = frame.Size
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	local targetSize = minimized and UDim2.new(0, 240, 0, 32) or originalSize
	local maskTarget = minimized and UDim2.new(1, 0, 0, 0) or UDim2.new(1, 0, 1, -32)
	TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
	TweenService:Create(contentMask, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = maskTarget}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
	frame:Destroy()
end)

local listContainer = Instance.new("ScrollingFrame")
listContainer.Size = UDim2.new(0, 210, 0, 112)
listContainer.Position = UDim2.new(0.5, -105, 0, 2)
listContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
listContainer.ScrollBarThickness = 4
listContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
listContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listContainer.ScrollingDirection = Enum.ScrollingDirection.Y
listContainer.ZIndex = 3
listContainer.Parent = contentContainer
Instance.new("UICorner", listContainer).CornerRadius = UDim.new(0, 6)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(50, 50, 50)
stroke.Parent = listContainer

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 3)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = listContainer

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 4)
padding.PaddingTop = UDim.new(0, 4)
padding.Parent = listContainer

local selectedPlayer = nil
local selectedButton = nil

local function updateCanvas()
	task.wait()
	listContainer.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

local function refreshList()
	for _, c in ipairs(listContainer:GetChildren()) do
		if c:IsA("TextButton") then
			c:Destroy()
		end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local option = Instance.new("TextButton")
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
			Instance.new("UICorner", option).CornerRadius = UDim.new(0, 5)

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
		end
	end
	updateCanvas()
end

refreshList()

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

Players.PlayerAdded:Connect(refreshList)

local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0, 210, 0, 28)
tpButton.Position = UDim2.new(0.5, -105, 0, 120)
tpButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
tpButton.TextColor3 = Color3.fromRGB(230, 230, 230)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 12
tpButton.Text = "Teleport"
tpButton.Parent = contentContainer
Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 6)
hoverEffect(tpButton, Color3.fromRGB(45, 45, 45), Color3.fromRGB(70, 70, 70))

tpButton.MouseButton1Click:Connect(function()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local target = selectedPlayer.Character.HumanoidRootPart
		local char = player.Character or player.CharacterAdded:Wait()
		if char:FindFirstChild("HumanoidRootPart") then
			char:MoveTo(target.Position + Vector3.new(0, 2, 0))
		end
	end
end)

local spectateButton = Instance.new("TextButton")
spectateButton.Size = UDim2.new(0, 210, 0, 28)
spectateButton.Position = UDim2.new(0.5, -105, 0, 152)
spectateButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
spectateButton.TextColor3 = Color3.fromRGB(230, 230, 230)
spectateButton.Font = Enum.Font.GothamBold
spectateButton.TextSize = 12
spectateButton.Text = "Spectate"
spectateButton.Parent = contentContainer
Instance.new("UICorner", spectateButton).CornerRadius = UDim.new(0, 6)
hoverEffect(spectateButton, Color3.fromRGB(45, 45, 45), Color3.fromRGB(70, 70, 70))

local camera = workspace.CurrentCamera
local spectating = false
local connection = nil

spectateButton.MouseButton1Click:Connect(function()
	if not selectedPlayer or not selectedPlayer.Character then
		return
	end
	if spectating then
		spectating = false
		spectateButton.Text = "Spectate"
		if connection then
			connection:Disconnect()
		end
		camera.CameraSubject = player.Character:FindFirstChildWhichIsA("Humanoid")
		camera.CameraType = Enum.CameraType.Custom
	else
		spectating = true
		spectateButton.Text = "Stop Spectate"
		connection = RunService.RenderStepped:Connect(function()
			if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("Humanoid") then
				spectating = false
				spectateButton.Text = "Spectate"
				camera.CameraSubject = player.Character:FindFirstChildWhichIsA("Humanoid")
				if connection then
					connection:Disconnect()
				end
				return
			end
			camera.CameraSubject = selectedPlayer.Character:FindFirstChild("Humanoid")
		end)
	end
end)

Players.PlayerRemoving:Connect(function(leaving)
	if selectedPlayer == leaving then
		selectedPlayer = nil
		if spectating then
			spectating = false
			spectateButton.Text = "Spectate"
			if connection then
				connection:Disconnect()
			end
			camera.CameraSubject = player.Character:FindFirstChildWhichIsA("Humanoid")
		end
	end
	refreshList()
end)

Players.PlayerAdded:Connect(refreshList)
