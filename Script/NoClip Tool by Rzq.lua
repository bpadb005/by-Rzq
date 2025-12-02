local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local noClip = false
local connection

local function toggleNoClip()
    noClip = not noClip

    if noClip then
        connection = RunService.Stepped:Connect(function()
            local character = player.Character
            if not character then return end

            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)

        StarterGui:SetCore("SendNotification", {
            Title = "Notification",
            Text = "NoClip ON\nby Rzq",
            Duration = 1.5
        })

    else
        if connection then
            connection:Disconnect()
        end

        local character = player.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end

        StarterGui:SetCore("SendNotification", {
            Title = "Notification",
            Text = "NoClip OFF\nby Rzq",
            Duration = 1.5
        })
    end
end

local tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "NoClip Tool\nby Rzq"

tool.Activated:Connect(function()
    toggleNoClip()
end)

tool.Parent = player:WaitForChild("Backpack")
