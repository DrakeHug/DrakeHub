local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// SETTINGS
local SPEED = 80
local speedEnabled = true -- tự bật khi vào server

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(300, 160)
main.Position = UDim2.new(0.5, -150, 0.5, -80)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

-- Gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 150)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 255))
})
gradient.Rotation = 45
gradient.Parent = main

--// TITLE / DRAG BAR
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
top.BackgroundTransparency = 0.15
top.BorderSizePixel = 0
top.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 1, 0)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Drake Speed"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

--// TOGGLE
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(130, 40)
toggle.Position = UDim2.fromOffset(15, 55)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Parent = main

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

--// SPEED BOX
local box = Instance.new("TextBox")
box.Size = UDim2.fromOffset(130, 40)
box.Position = UDim2.fromOffset(155, 55)
box.Text = tostring(SPEED)
box.PlaceholderText = "Speed"
box.ClearTextOnFocus = false
box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
box.TextColor3 = Color3.new(1, 1, 1)
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.Parent = main

Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

--// STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 30)
status.Position = UDim2.fromOffset(15, 110)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(220, 220, 220)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.Parent = main

--// UPDATE BUTTON
local function updateButton()
	if speedEnabled then
		toggle.Text = "Speed: ON"
		toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 110)
		status.Text = "Speed đang chạy: " .. SPEED
	else
		toggle.Text = "Speed: OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
		status.Text = "Speed đã tắt"
	end
end

--// APPLY SPEED
local function applySpeed()
	local character = player.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	if speedEnabled then
		humanoid.WalkSpeed = SPEED
	else
		humanoid.WalkSpeed = 16
	end
end

--// TOGGLE
toggle.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled

	updateButton()
	applySpeed()
end)

--// CHANGE SPEED
box.FocusLost:Connect(function()
	local value = tonumber(box.Text)

	if value then
		SPEED = math.clamp(value, 16, 300)
		box.Text = tostring(SPEED)

		applySpeed()

		if speedEnabled then
			status.Text = "Speed đang chạy: " .. SPEED
		end
	else
		box.Text = tostring(SPEED)
	end
end)

--// RESPAWN
player.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid")

	task.wait(0.2)

	-- luôn bật lại khi respawn
	speedEnabled = true
	updateButton()
	applySpeed()
end)

--// DRAG GUI
local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local delta = input.Position - dragStart

	main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end)

--// F1 OPEN/CLOSE
UserInputService.InputBegan:Connect(function(input, processed)

	if processed then
		return
	end

	if input.KeyCode == Enum.KeyCode.F1 then
		main.Visible = not main.Visible
	end
end)

--// START
updateButton()
applySpeed()
