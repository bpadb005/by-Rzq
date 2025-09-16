--====================================================
-- FLY GUI V3 by XNEO (Rapi PascalCase, Full Siap Pakai)
--====================================================

--// GUI Components
local Main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Up = Instance.new("TextButton")
local Down = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local Mine = Instance.new("TextButton")
local Speed = Instance.new("TextLabel")
local Plus = Instance.new("TextButton")
local OnOff = Instance.new("TextButton")
local Mini = Instance.new("TextButton")
local Mini2 = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

--// Main Gui
Main.Name = "Main"
Main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Main.ResetOnSpawn = false

--// Frame
Frame.Parent = Main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.1003, 0, 0.3797, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)
Frame.Active = true
Frame.Draggable = true

--// Up Button
Up.Name = "Up"
Up.Parent = Frame
Up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
Up.Size = UDim2.new(0, 44, 0, 28)
Up.Font = Enum.Font.SourceSans
Up.Text = "UP"
Up.TextColor3 = Color3.fromRGB(0, 0, 0)
Up.TextSize = 14

--// Down Button
Down.Name = "Down"
Down.Parent = Frame
Down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
Down.Position = UDim2.new(0, 0, 0.4912, 0)
Down.Size = UDim2.new(0, 44, 0, 28)
Down.Font = Enum.Font.SourceSans
Down.Text = "DOWN"
Down.TextColor3 = Color3.fromRGB(0, 0, 0)
Down.TextSize = 14

--// Text Label
TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.4693, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "FLY GUI V3"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true

--// Mine Button
Mine.Name = "Mine"
Mine.Parent = Frame
Mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
Mine.Position = UDim2.new(0.2315, 0, 0.4912, 0)
Mine.Size = UDim2.new(0, 45, 0, 29)
Mine.Font = Enum.Font.SourceSans
Mine.Text = "-"
Mine.TextColor3 = Color3.fromRGB(0, 0, 0)
Mine.TextScaled = true
Mine.TextWrapped = true

--// Speed Label
Speed.Name = "Speed"
Speed.Parent = Frame
Speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
Speed.Position = UDim2.new(0.4684, 0, 0.4912, 0)
Speed.Size = UDim2.new(0, 44, 0, 28)
Speed.Font = Enum.Font.SourceSans
Speed.Text = "1"
Speed.TextColor3 = Color3.fromRGB(0, 0, 0)
Speed.TextScaled = true
Speed.TextWrapped = true

--// Plus Button
Plus.Name = "Plus"
Plus.Parent = Frame
Plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
Plus.Position = UDim2.new(0.2315, 0, 0, 0)
Plus.Size = UDim2.new(0, 45, 0, 28)
Plus.Font = Enum.Font.SourceSans
Plus.Text = "+"
Plus.TextColor3 = Color3.fromRGB(0, 0, 0)
Plus.TextScaled = true
Plus.TextWrapped = true

--// On/Off Button
OnOff.Name = "OnOff"
OnOff.Parent = Frame
OnOff.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
OnOff.Position = UDim2.new(0.7028, 0, 0.4912, 0)
OnOff.Size = UDim2.new(0, 56, 0, 28)
OnOff.Font = Enum.Font.SourceSans
OnOff.Text = "Fly"
OnOff.TextColor3 = Color3.fromRGB(0, 0, 0)
OnOff.TextSize = 14

--// Mini Button
Mini.Name = "Mini"
Mini.Parent = Frame
Mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
Mini.Size = UDim2.new(0, 45, 0, 28)
Mini.Font = Enum.Font.SourceSans
Mini.Text = "-"
Mini.TextSize = 40
Mini.Position = UDim2.new(0, 44, -1, 27)

--// Mini2 Button
Mini2.Name = "Mini2"
Mini2.Parent = Frame
Mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
Mini2.Size = UDim2.new(0, 45, 0, 28)
Mini2.Font = Enum.Font.SourceSans
Mini2.Text = "+"
Mini2.TextSize = 40
Mini2.Position = UDim2.new(0, 44, -1, 57)
Mini2.Visible = false

--// Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = Frame
CloseButton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
CloseButton.Size = UDim2.new(0, 45, 0, 28)
CloseButton.Font = Enum.Font.SourceSans
CloseButton.Text = "X"
CloseButton.TextSize = 30
CloseButton.Position = UDim2.new(0, 0, -1, 27)

------------------------------------------------
-- VARIABLES
------------------------------------------------
local Speeds = 1
local Player = game.Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")
local Flying = false
local TpWalking = false

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "FLY GUI V3";
    Text = "BY XNEO";
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
    Duration = 5
})

------------------------------------------------
-- FUNCTIONS
------------------------------------------------

-- Utility untuk aktif/nonaktif humanoid state
local function SetHumanoidStates(humanoid, enabled)
	for _, state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
		humanoid:SetStateEnabled(state, enabled)
	end
end

-- Fly Toggle
OnOff.MouseButton1Click:Connect(function()
	Flying = not Flying
	local hum = Player.Character:FindFirstChildWhichIsA("Humanoid")

	if not hum then return end

	if Flying then
		-- Disable humanoid state
		SetHumanoidStates(hum, false)
		hum:ChangeState(Enum.HumanoidStateType.Swimming)

		-- Start tpwalking
		TpWalking = true
		for i = 1, Speeds do
			task.spawn(function()
				local hb = game:GetService("RunService").Heartbeat
				while TpWalking and hb:Wait() and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						hum.Parent:TranslateBy(hum.MoveDirection)
					end
				end
			end)
		end
	else
		-- Reset humanoid state
		SetHumanoidStates(hum, true)
		hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
		TpWalking = false
	end
end)

-- Up Button
local UpConnection
Up.MouseButton1Down:Connect(function()
	UpConnection = game:GetService("RunService").RenderStepped:Connect(function()
		Player.Character.HumanoidRootPart.CFrame *= CFrame.new(0, 1, 0)
	end)
end)
Up.MouseButton1Up:Connect(function()
	if UpConnection then
		UpConnection:Disconnect()
		UpConnection = nil
	end
end)

-- Down Button
local DownConnection
Down.MouseButton1Down:Connect(function()
	DownConnection = game:GetService("RunService").RenderStepped:Connect(function()
		Player.Character.HumanoidRootPart.CFrame *= CFrame.new(0, -1, 0)
	end)
end)
Down.MouseButton1Up:Connect(function()
	if DownConnection then
		DownConnection:Disconnect()
		DownConnection = nil
	end
end)

-- Plus Button
Plus.MouseButton1Click:Connect(function()
	Speeds += 1
	Speed.Text = tostring(Speeds)
end)

-- Mine Button
Mine.MouseButton1Click:Connect(function()
	if Speeds > 1 then
		Speeds -= 1
		Speed.Text = tostring(Speeds)
	else
		Speed.Text = "cannot be less than 1"
		task.wait(1)
		Speed.Text = tostring(Speeds)
	end
end)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
	Main:Destroy()
end)

-- Mini Button
Mini.MouseButton1Click:Connect(function()
	Up.Visible = false
	Down.Visible = false
	OnOff.Visible = false
	Plus.Visible = false
	Speed.Visible = false
	Mine.Visible = false
	Mini.Visible = false
	Mini2.Visible = true
	Frame.BackgroundTransparency = 1
	CloseButton.Position = UDim2.new(0, 0, -1, 57)
end)

-- Mini2 Button
Mini2.MouseButton1Click:Connect(function()
	Up.Visible = true
	Down.Visible = true
	OnOff.Visible = true
	Plus.Visible = true
	Speed.Visible = true
	Mine.Visible = true
	Mini.Visible = true
	Mini2.Visible = false
	Frame.BackgroundTransparency = 0
	CloseButton.Position = UDim2.new(0, 0, -1, 27)
end)

------------------------------------------------
-- CHARACTER RESET FIX
------------------------------------------------
Player.CharacterAdded:Connect(function(char)
	task.wait(0.7)
	local hum = char:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.PlatformStand = false
	end
	char:FindFirstChild("Animate").Disabled = false
end)
