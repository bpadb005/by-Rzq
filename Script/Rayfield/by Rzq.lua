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
      teleportPosition(Vector3.new(335.15, 15.72, 181.39))
   end,
})

local Section = Tab:CreateSection("Auto")

local teleportList = {
   Vector3.new(329.54, 15.52, 172.52),
   Vector3.new(324.65, 11.59, 144.86),
   Vector3.new(320.81, 11.61, 133.51),
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
   Name = "Auto Teleport 1x",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
        if Value then
         task.spawn(function()
            for _, pos in ipairs(teleportList) do
               teleportPositions(pos)

               local loopCount = math.floor(teleportDelay * 10)
               for i = 1, loopCount do
                  task.wait(0.1)
               end
            end

            pcall(function()
               Rayfield.Flags.Toggle1:Set(false)
            end)
         end)
      end
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Auto Teleport",
   CurrentValue = false,
   Flag = "Toggle2",
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
   Flag = "Toggle3",
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
local Section = Tab:CreateSection("Player")

local currentWalkSpeed = 16
local currentJumpPower = 50

local WalkSpeedSlider = Tab:CreateSlider({
   Name = "Walk Speed (default 16)",
   Range = {0, 300},
   Increment = 1,
   Suffix = " studs/detik",
   CurrentValue = 16,
   Flag = "Slider2",
   Callback = function(Value)
        currentWalkSpeed = Value

        local Character = game.Players.LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
   end,
})

local JumpPowerSlider = Tab:CreateSlider({
   Name = "Jump Power (default 50)",
   Range = {0, 500},
   Increment = 1,
   Suffix = " power",
   CurrentValue = 50,
   Flag = "Slider3",
   Callback = function(Value)
        currentJumpPower = Value

        local Character = game.Players.LocalPlayer.Character
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.UseJumpPower = true
            Character.Humanoid.JumpPower = Value
        end
   end,
})

local player = game.Players.LocalPlayer

player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.UseJumpPower = true
    humanoid.WalkSpeed = currentWalkSpeed
    humanoid.JumpPower = currentJumpPower
end)

local Button = Tab:CreateButton({
   Name = "Reset To Default",
   Callback = function()
      currentWalkSpeed = 16
      currentJumpPower = 50

      WalkSpeedSlider:Set(16)
      JumpPowerSlider:Set(50)

      local Character = game.Players.LocalPlayer.Character
      local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

      if Humanoid then
         Humanoid.WalkSpeed = 16
         Humanoid.UseJumpPower = true
         Humanoid.JumpPower = 50
      end
   end,
})

game.Players.LocalPlayer.CharacterAdded:Connect(function(Character)
   local Humanoid = Character:WaitForChild("Humanoid")

   Humanoid.UseJumpPower = true
   Humanoid.WalkSpeed = currentWalkSpeed
   Humanoid.JumpPower = currentJumpPower
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local InfiniteJumpEnabled = false
local InfiniteJumpConnection

local Toggle = Tab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "Toggle4",
   Callback = function(Value)
      InfiniteJumpEnabled = Value

      if Value then
         if not InfiniteJumpConnection then
            InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
               if InfiniteJumpEnabled then
                  local Character = LocalPlayer.Character
                  local Humanoid = Character and Character:FindFirstChild("Humanoid")

                  if Humanoid then
                     Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                  end
               end
            end)
         end
      end
   end,
})

local Button = Tab:CreateButton({
   Name = "Disable Gameplay Paused",
   Callback = function()
      game
         :GetService("CoreGui")
         .RobloxGui["CoreScripts/NetworkPause"]
         :Destroy()
   end,
})

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
