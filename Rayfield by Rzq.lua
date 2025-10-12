local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield by Rzq",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Rzq",
   ShowText = "GUI", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Tutorial", "activity") -- Title, Image

local Tab = Window:CreateTab("Teleport", "map-pin") -- Title, Image
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
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        autoTeleport = Value

        if autoTeleport then
            task.spawn(function()
                while autoTeleport do
                    -- === Teleport ke posisi saat ini ===
                    local pos = teleportList[currentIndex]
                    teleportPositions(pos)

                    -- === Atur indeks untuk teleport berikutnya ===
                    currentIndex += 1
                    if currentIndex > #teleportList then
                        currentIndex = 1
                    end

                    -- === Respawn jika sampai di lokasi terakhir ===
                    if currentIndex == 1 and respawnAfterLast then
                        local player = game.Players.LocalPlayer
                        if player.Character and player.Character:FindFirstChild("Humanoid") then
                            player.Character.Humanoid.Health = 0 -- respawn
                        end

                        -- Tunggu karakter respawn siap
                        repeat
                            task.wait(0.1)
                        until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    end

                    -- === Delay antar teleport ===
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
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
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
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        teleportDelay = Value
   end,
})

local Tab = Window:CreateTab("Misc", "flame") -- Title, Image

local Tab = Window:CreateTab("Information", "info") -- Title, Image
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
