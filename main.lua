local Players = game:GetService("Players")

local player = Players.LocalPlayer

local speedEnabled = false
local currentSpeed = 80

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedTest"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(300, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "⚡ Speed Controller"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

--// Toggle
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(130, 45)
toggle.Position = UDim2.fromOffset(15, 55)
toggle.Text = "Speed: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 15
toggle.Parent = frame

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

--// Speed box
local box = Instance.new("TextBox")
box.Size = UDim2.fromOffset(130, 45)
box.Position = UDim2.fromOffset(155, 55)
box.Text = tostring(currentSpeed)
box.PlaceholderText = "Speed"
box.ClearTextOnFocus = false
box.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
box.TextColor3 = Color3.new(1, 1, 1)
box.Font = Enum.Font.Gotham
box.TextSize = 15
box.Parent = frame

Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

--// Save button
local save = Instance.new("TextButton")
save.Size = UDim2.new(1, -30, 0, 45)
save.Position = UDim2.fromOffset(15, 115)
save.Text = "💾 Save Speed"
save.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
save.TextColor3 = Color3.new(1, 1, 1)
save.Font = Enum.Font.GothamBold
save.TextSize = 15
save.Parent = frame

Instance.new("UICorner", save).CornerRadius = UDim.new(0, 8)

--// Character
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

--// Toggle Speed
toggle.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled

	if speedEnabled then
		toggle.Text = "Speed: ON"
		toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 110)
	else
		toggle.Text = "Speed: OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
	end

	applySpeed()
end)

--// Change speed
box.FocusLost:Connect(function()
	local value = tonumber(box.Text)

	if value then
		currentSpeed = math.clamp(value, 16, 300)
		box.Text = tostring(currentSpeed)

		if speedEnabled then
			applySpeed()
		end
	else
		box.Text = tostring(currentSpeed)
	end
end)

--// Save Speed
save.MouseButton1Click:Connect(function()
	local value = tonumber(box.Text)

	if value then
		currentSpeed = math.clamp(value, 16, 300)
		box.Text = tostring(currentSpeed)

		if speedEnabled then
			applySpeed()
		end

		save.Text = "✅ Speed Saved!"

		task.wait(1)

		if save then
			save.Text = "💾 Save Speed"
		end
	end
end)

--// Respawn
player.CharacterAdded:Connect(function()
	task.wait(0.5)

	if speedEnabled then
		applySpeed()
	end
end)
