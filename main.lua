local Players = game:GetService("Players")

local player = Players.LocalPlayer

local speedEnabled = false
local currentSpeed = 80

local MIN_SPEED = 16
local MAX_SPEED = 300

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 170)
frame.Position = UDim2.new(0.5, -140, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Speed Controller"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Toggle
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 120, 0, 40)
toggle.Position = UDim2.new(0, 15, 0, 50)
toggle.Text = "Speed: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

-- Speed input
local box = Instance.new("TextBox")
box.Size = UDim2.new(0, 120, 0, 40)
box.Position = UDim2.new(0, 145, 0, 50)
box.Text = "80"
box.PlaceholderText = "Speed"
box.ClearTextOnFocus = false
box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
box.TextColor3 = Color3.new(1, 1, 1)
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.Parent = frame

Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

-- Save button
local save = Instance.new("TextButton")
save.Size = UDim2.new(1, -30, 0, 40)
save.Position = UDim2.new(0, 15, 0, 110)
save.Text = "💾 Save Speed"
save.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
save.TextColor3 = Color3.new(1, 1, 1)
save.Font = Enum.Font.GothamBold
save.TextSize = 14
save.Parent = frame

Instance.new("UICorner", save).CornerRadius = UDim.new(0, 8)

local function getHumanoid()
	local character = player.Character or player.CharacterAdded:Wait()
	return character:WaitForChild("Humanoid")
end

local function applySpeed()
	local humanoid = getHumanoid()

	if speedEnabled then
		humanoid.WalkSpeed = currentSpeed
	else
		humanoid.WalkSpeed = 16
	end
end

-- Toggle
toggle.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled

	if speedEnabled then
		toggle.Text = "Speed: ON"
		toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 110)
	else
		toggle.Text = "Speed: OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
	end

	applySpeed()
end)

-- Change speed
box.FocusLost:Connect(function()
	local number = tonumber(box.Text)

	if number then
		currentSpeed = math.clamp(number, MIN_SPEED, MAX_SPEED)
		box.Text = tostring(currentSpeed)

		if speedEnabled then
			applySpeed()
		end
	else
		box.Text = tostring(currentSpeed)
	end
end)

-- Save
save.MouseButton1Click:Connect(function()
	local number = tonumber(box.Text)

	if number then
		currentSpeed = math.clamp(number, MIN_SPEED, MAX_SPEED)
		box.Text = tostring(currentSpeed)

		player:SetAttribute("SavedSpeed", currentSpeed)

		save.Text = "✅ Saved!"

		task.delay(1, function()
			if save then
				save.Text = "💾 Save Speed"
			end
		end)

		if speedEnabled then
			applySpeed()
		end
	end
end)

-- Load saved speed
local saved = player:GetAttribute("SavedSpeed")

if typeof(saved) == "number" then
	currentSpeed = math.clamp(saved, MIN_SPEED, MAX_SPEED)
	box.Text = tostring(currentSpeed)
end

-- Respawn
player.CharacterAdded:Connect(function()
	task.wait(0.2)

	if speedEnabled then
		applySpeed()
	end
end)
