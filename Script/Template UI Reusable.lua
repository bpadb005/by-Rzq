--// Template UI Reusable (Dark Minimalist Rounded + Smooth Minimize)

--// === LocalScript: Dark Minimalist UI Template ===
--// Reusable GUI Templat

--// Services
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

--// === GUI Utama ===
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

--// === Frame Utama ===
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 290, 0, 340)
frame.Position = UDim2.new(0.5, -145, 0.5, -170)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

--// === Header / Title ===
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BorderSizePixel = 0
title.Text = "Template UI"
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

--// === Fungsi Pembuat Tombol Header ===
local function createHeaderButton(text, pos, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 22, 0, 22)
	btn.Position = pos
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.fromRGB(230, 230, 230)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Text = text
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

--// Tombol Minimize dan Close
local minimizeBtn = createHeaderButton("-", UDim2.new(0, 8, 0, 7), Color3.fromRGB(60, 60, 60))
local closeBtn = createHeaderButton("×", UDim2.new(1, -30, 0, 7), Color3.fromRGB(90, 40, 40))

--// Hover Effect
local function hoverEffect(btn, normal, hover)
	btn.MouseEnter:Connect(function() btn.BackgroundColor3 = hover end)
	btn.MouseLeave:Connect(function() btn.BackgroundColor3 = normal end)
end

hoverEffect(minimizeBtn, Color3.fromRGB(60, 60, 60), Color3.fromRGB(80, 80, 80))
hoverEffect(closeBtn, Color3.fromRGB(90, 40, 40), Color3.fromRGB(120, 50, 50))

--// === Kontainer Konten ===
local contentMask = Instance.new("Frame")
contentMask.Size = UDim2.new(1, 0, 1, -40)
contentMask.Position = UDim2.new(0, 0, 0, 40)
contentMask.BackgroundTransparency = 1
contentMask.ClipsDescendants = true
contentMask.Parent = frame

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, 0)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = contentMask

--// === Animasi Minimize / Expand ===
local minimized = false
local originalSize = frame.Size

minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	local targetSize = minimized and UDim2.new(0, 290, 0, 40) or originalSize
	local maskTarget = minimized and UDim2.new(1, 0, 0, 0) or UDim2.new(1, 0, 1, -40)

	TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = targetSize
	}):Play()

	TweenService:Create(contentMask, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = maskTarget
	}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
	frame:Destroy()
end)

--// === Contoh Isi (Opsional, bisa hapus) ===
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 1, -50)
label.Position = UDim2.new(0, 10, 0, 45)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(200, 200, 200)
label.Text = "Tempat isi kontenmu di sini."
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.TextWrapped = true
label.Parent = contentContainer
