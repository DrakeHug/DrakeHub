--==================================================
-- DRAKE SPEED - ROBLOX STUDIO
--==================================================
print("[DrakeSpeed] SCRIPT STARTED")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

--==================================================
-- SETTINGS
--==================================================

local SPEED = 25
local speedEnabled = true -- TỰ BẬT KHI VÀO SERVER

local MIN_SPEED = 16
local MAX_SPEED = 300

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DrakeSpeed"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(360, 190)
Main.Position = UDim2.new(0.5, -180, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

-- Gradient
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 150)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 255))
})
Gradient.Rotation = 45
Gradient.Parent = Main

--==================================================
-- TOP BAR
--==================================================

local Top = Instance.new("Frame")
Top.Name = "Top"
Top.Size = UDim2.new(1, 0, 0, 45)
Top.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Top.BackgroundTransparency = 0.15
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Drake Speed"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

--==================================================
-- TOGGLE
--==================================================

local Toggle = Instance.new("TextButton")
Toggle.Name = "Toggle"
Toggle.Size = UDim2.fromOffset(155, 45)
Toggle.Position = UDim2.fromOffset(20, 65)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 15
Toggle.BorderSizePixel = 0
Toggle.Parent = Main

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = Toggle

--==================================================
-- SPEED BOX
--==================================================

local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.Size = UDim2.fromOffset(155, 45)
SpeedBox.Position = UDim2.fromOffset(185, 65)
SpeedBox.Text = tostring(SPEED)
SpeedBox.PlaceholderText = "Speed"
SpeedBox.ClearTextOnFocus = false
SpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SpeedBox.TextColor3 = Color3.new(1, 1, 1)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 15
SpeedBox.BorderSizePixel = 0
SpeedBox.Parent = Main

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = SpeedBox

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -40, 0, 35)
Status.Position = UDim2.fromOffset(20, 125)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.new(1, 1, 1)
Status.Font = Enum.Font.Gotham
Status.TextSize = 13
Status.Parent = Main

--==================================================
-- FUNCTIONS
--==================================================

local function getCharacter()
	return player.Character
end

local function getHumanoid()
	local character = getCharacter()

	if not character then
		return nil
	end

	return character:FindFirstChildOfClass("Humanoid")
end

local function applySpeed()
	local humanoid = getHumanoid()

	if not humanoid then
		return
	end

	if speedEnabled then
		humanoid.WalkSpeed = SPEED
	else
		humanoid.WalkSpeed = 16
	end
end

local function updateGUI()
	if speedEnabled then

		Toggle.Text = "⚡ Speed: ON"
		Toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 110)

		Status.Text = "Speed đang chạy: " .. tostring(SPEED)
		Status.TextColor3 = Color3.fromRGB(0, 255, 170)

	else

		Toggle.Text = "Speed: OFF"
		Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)

		Status.Text = "Speed đã tắt"
		Status.TextColor3 = Color3.fromRGB(220, 220, 220)

	end
end

--==================================================
-- TOGGLE BUTTON
--==================================================

Toggle.MouseButton1Click:Connect(function()

	speedEnabled = not speedEnabled

	updateGUI()
	applySpeed()

end)

--==================================================
-- CHANGE SPEED
--==================================================

SpeedBox.FocusLost:Connect(function()

	local value = tonumber(SpeedBox.Text)

	if value then

		SPEED = math.clamp(
			value,
			MIN_SPEED,
			MAX_SPEED
		)

		SpeedBox.Text = tostring(SPEED)

		applySpeed()
		updateGUI()

	else

		SpeedBox.Text = tostring(SPEED)

	end

end)

--==================================================
-- CHARACTER / RESPAWN
--==================================================

player.CharacterAdded:Connect(function(character)

	local humanoid = character:WaitForChild("Humanoid", 10)

	if humanoid then

		-- TỰ BẬT LẠI SAU KHI RESPAWN
		speedEnabled = true

		updateGUI()

		task.wait(0.2)

		applySpeed()

	end

end)

--==================================================
-- KEEP SPEED
--==================================================

task.spawn(function()

	while ScreenGui.Parent do

		task.wait(0.2)

		if speedEnabled then

			local humanoid = getHumanoid()

			if humanoid and humanoid.WalkSpeed ~= SPEED then
				humanoid.WalkSpeed = SPEED
			end

		end

	end

end)

--==================================================
-- DRAG GUI
--==================================================

local dragging = false
local dragStart
local startPosition

Top.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true

		dragStart = input.Position
		startPosition = Main.Position

	end

end)

Top.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false

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

	Main.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,

		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)

end)

--==================================================
-- F1 OPEN / CLOSE
--==================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)

	if gameProcessed then
		return
	end

	if input.KeyCode == Enum.KeyCode.F1 then

		Main.Visible = not Main.Visible

	end

end)

--==================================================
-- START
--==================================================

updateGUI()

task.wait(0.5)

applySpeed()

print("[Drake Speed] Loaded")
print("[Drake Speed] Speed:", SPEED)
print("[Drake Speed] Enabled:", speedEnabled)
