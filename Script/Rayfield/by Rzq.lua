local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield by Rzq",
   Icon = 0,
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Rzq",
   ShowText = "GUI",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "by Rzq"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local Tab = Window:CreateTab("Tutorial", "activity")

local Tab = Window:CreateTab("Teleport", "map-pin")
local Section = Tab:CreateSection("Manual")

local function teleportPosition(pos)
   local player = game.Players.LocalPlayer
   if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
      player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
   end
end

local Button = Tab:CreateButton({
   Name = "Spawn",
   Callback = function()
      teleportPosition(Vector3.new(717.30, 101.00, -890.05))
   end,
})

local Section = Tab:CreateSection("Auto")

local teleportList = {
   Vector3.new(717.30, 101.00, -890.05),
   Vector3.new(84.41, 141.00, 463.26),
   Vector3.new(-401.28, 273.00, 772.38),
   Vector3.new(-588.52, 385.00, -118.45),
   Vector3.new(-487.00, 281.36, -356.03),
   Vector3.new(-1291.93, 353.00, -538.26),
   Vector3.new(-1798.55, 597.00, -436.68),
   Vector3.new(-3347.49, 685.00, -728.86),
   Vector3.new(-3366.14, 695.54, -755.33),
}

local function teleportPositions(pos)
   local player = game.Players.LocalPlayer
   if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
      player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
   end
end

local autoTeleport = false
local currentIndex = 1
local respawnAfterLast = false
local teleportDelay = 3

local Toggle = Tab:CreateToggle({
   Name = "Auto Teleport",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
        autoTeleport = Value

        if autoTeleport then
            task.spawn(function()
                while autoTeleport do
                    local pos = teleportList[currentIndex]
                    teleportPositions(pos)

                    currentIndex += 1
                    if currentIndex > #teleportList then
                        currentIndex = 1
                    end

                    if currentIndex == 1 and respawnAfterLast then
                        local player = game.Players.LocalPlayer
                        if player.Character and player.Character:FindFirstChild("Humanoid") then
                            player.Character.Humanoid.Health = 0
                        end

                        repeat
                            task.wait(0.1)
                        until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    end

                    local loopCount = math.floor(teleportDelay * 10)
                    for i = 1, loopCount do
                        if not autoTeleport then break end
                        task.wait(0.1)
                    end
                end
            end)
        end
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Auto Respawn",
   CurrentValue = false,
   Flag = "Toggle2",
   Callback = function(Value)
        respawnAfterLast = Value
   end,
})

local Slider = Tab:CreateSlider({
   Name = "Delay Teleport",
   Range = {0.1, 10},
   Increment = 0.1,
   Suffix = " detik",
   CurrentValue = teleportDelay,
   Flag = "Slider1",
   Callback = function(Value)
        teleportDelay = Value
   end,
})

local Tab = Window:CreateTab("Misc", "flame")

local Tab = Window:CreateTab("Information", "info")
local Section = Tab:CreateSection("About Me")
local Paragraph = Tab:CreateParagraph({Title = "Rzq", Content = "\n\n\n\n"})

local Section = Tab:CreateSection("Server")
local Label = Tab:CreateLabel("Place ID: " .. game.PlaceId)
local Label = Tab:CreateLabel("Server ID: " .. game.JobId)
local Label = Tab:CreateLabel("Jumlah: " .. #game.Players:GetPlayers() .. " pemain")

local function UpdatePlayerCount()
    Label:Set("Jumlah: " .. #game.Players:GetPlayers() .. " pemain")
end

UpdatePlayerCount()

game.Players.PlayerAdded:Connect(UpdatePlayerCount)
game.Players.PlayerRemoving:Connect(UpdatePlayerCount)
