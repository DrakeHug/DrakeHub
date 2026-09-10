--==================================================
-- DRAKE SPEED + JUMP
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local SPEED = 20
local MIN_SPEED = 16
local MAX_SPEED = 300
local SpeedEnabled = true

local JUMP_POWER = 75
local MIN_JUMP = 50
local MAX_JUMP = 300
local JumpEnabled = true

--==================================================
-- XÓA GUI CŨ
--==================================================

local OldGui = PlayerGui:FindFirstChild("DrakeSpeed")

if OldGui then
	OldGui:Destroy()
end

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DrakeSpeed"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(360, 270)
Main.Position = UDim2.new(0.5, -180, 0.5, -135)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

--==================================================
-- GRADIENT
--==================================================

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
Title.Text = "Drake"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

--==================================================
-- SPEED TOGGLE
--==================================================

local Toggle = Instance.new("TextButton")
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
-- JUMP TOGGLE
--==================================================

local JumpToggle = Instance.new("TextButton")
JumpToggle.Size = UDim2.fromOffset(155, 45)
JumpToggle.Position = UDim2.fromOffset(20, 120)
JumpToggle.TextColor3 = Color3.new(1, 1, 1)
JumpToggle.Font = Enum.Font.GothamBold
JumpToggle.TextSize = 15
JumpToggle.BorderSizePixel = 0
JumpToggle.Parent = Main

local JumpToggleCorner = Instance.new("UICorner")
JumpToggleCorner.CornerRadius = UDim.new(0, 8)
JumpToggleCorner.Parent = JumpToggle

--==================================================
-- JUMP POWER BOX
--==================================================

local JumpBox = Instance.new("TextBox")
JumpBox.Size = UDim2.fromOffset(155, 45)
JumpBox.Position = UDim2.fromOffset(185, 120)
JumpBox.Text = tostring(JUMP_POWER)
JumpBox.PlaceholderText = "Jump Power"
JumpBox.ClearTextOnFocus = false
JumpBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
JumpBox.TextColor3 = Color3.new(1, 1, 1)
JumpBox.Font = Enum.Font.Gotham
JumpBox.TextSize = 15
JumpBox.BorderSizePixel = 0
JumpBox.Parent = Main

local JumpBoxCorner = Instance.new("UICorner")
JumpBoxCorner.CornerRadius = UDim.new(0, 8)
JumpBoxCorner.Parent = JumpBox

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -40, 0, 70)
Status.Position = UDim2.fromOffset(20, 180)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.new(1, 1, 1)
Status.Font = Enum.Font.Gotham
Status.TextSize = 13
Status.TextWrapped = true
Status.Parent = Main

--==================================================
-- HUMANOID
--==================================================

local function GetHumanoid()

	local Character = Player.Character

	if not Character then
		return nil
	end

	return Character:FindFirstChildOfClass("Humanoid")
end

--==================================================
-- APPLY SPEED
--==================================================

local function ApplySpeed()

	local Humanoid = GetHumanoid()

	if not Humanoid then
		return
	end

	if SpeedEnabled then
		Humanoid.WalkSpeed = SPEED
	else
		Humanoid.WalkSpeed = 16
	end
end

--==================================================
-- APPLY JUMP
--==================================================

local function ApplyJump()

	local Humanoid = GetHumanoid()

	if not Humanoid then
		return
	end

	-- Dùng JumpPower
	Humanoid.UseJumpPower = true

	if JumpEnabled then
		Humanoid.JumpPower = JUMP_POWER
	else
		Humanoid.JumpPower = 50
	end
end

--==================================================
-- APPLY ALL
--==================================================

local function ApplyAll()

	ApplySpeed()
	ApplyJump()

end

--==================================================
-- UPDATE GUI
--==================================================

local function UpdateGUI()

	-- SPEED

	if SpeedEnabled then

		Toggle.Text = "⚡ Speed: On"

		Toggle.BackgroundColor3 =
			Color3.fromRGB(0, 170, 110)

	else

		Toggle.Text = "Speed: Off"

		Toggle.BackgroundColor3 =
			Color3.fromRGB(50, 50, 55)

	end

	-- JUMP

	if JumpEnabled then

		JumpToggle.Text = "🦘 Jump: On"

		JumpToggle.BackgroundColor3 =
			Color3.fromRGB(0, 150, 220)

	else

		JumpToggle.Text = "Jump: Off"

		JumpToggle.BackgroundColor3 =
			Color3.fromRGB(50, 50, 55)

	end

	-- STATUS

	if SpeedEnabled and JumpEnabled then

		Status.Text =
			"Speed: " .. tostring(SPEED) ..
			"   |   Jump: " .. tostring(JUMP_POWER)

		Status.TextColor3 =
			Color3.fromRGB(0, 255, 170)

	elseif SpeedEnabled then

		Status.Text =
			"Speed: " .. tostring(SPEED) ..
			"   |   Jump: Off"

		Status.TextColor3 =
			Color3.fromRGB(0, 255, 170)

	elseif JumpEnabled then

		Status.Text =
			"Speed: Off" ..
			"   |   Jump: " .. tostring(JUMP_POWER)

		Status.TextColor3 =
			Color3.fromRGB(0, 200, 255)

	else

		Status.Text = "Speed: Off   |   Jump: Off"

		Status.TextColor3 =
			Color3.fromRGB(220, 220, 220)

	end

end

--==================================================
-- SPEED TOGGLE
--==================================================

Toggle.Activated:Connect(function()

	SpeedEnabled = not SpeedEnabled

	ApplySpeed()
	UpdateGUI()

end)

--==================================================
-- CHANGE SPEED
--==================================================

SpeedBox.FocusLost:Connect(function()

	local Value = tonumber(SpeedBox.Text)

	if not Value then

		SpeedBox.Text = tostring(SPEED)

		return

	end

	Value = math.floor(Value)

	SPEED = math.clamp(
		Value,
		MIN_SPEED,
		MAX_SPEED
	)

	SpeedBox.Text = tostring(SPEED)

	ApplySpeed()
	UpdateGUI()

end)

--==================================================
-- JUMP TOGGLE
--==================================================

JumpToggle.Activated:Connect(function()

	JumpEnabled = not JumpEnabled

	ApplyJump()
	UpdateGUI()

end)

--==================================================
-- CHANGE JUMP POWER
--==================================================

JumpBox.FocusLost:Connect(function()

	local Value = tonumber(JumpBox.Text)

	if not Value then

		JumpBox.Text = tostring(JUMP_POWER)

		return

	end

	Value = math.floor(Value)

	JUMP_POWER = math.clamp(
		Value,
		MIN_JUMP,
		MAX_JUMP
	)

	JumpBox.Text = tostring(JUMP_POWER)

	ApplyJump()
	UpdateGUI()

end)

--==================================================
-- RESPAWN
--==================================================

Player.CharacterAdded:Connect(function(Character)

	local Humanoid =
		Character:WaitForChild("Humanoid", 10)

	if Humanoid then

		task.wait(0.2)

		ApplyAll()

	end

end)

--==================================================
-- KEEP SPEED + JUMP
--==================================================

task.spawn(function()

	while ScreenGui.Parent do

		task.wait(0.2)

		if SpeedEnabled then
			ApplySpeed()
		end

		if JumpEnabled then
			ApplyJump()
		end

	end

end)

--==================================================
-- DRAG
--==================================================

local Dragging = false
local DragStart
local StartPosition

Top.InputBegan:Connect(function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then

		Dragging = true
		DragStart = Input.Position
		StartPosition = Main.Position

	end

end)

Top.InputEnded:Connect(function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then

		Dragging = false

	end

end)

UserInputService.InputChanged:Connect(function(Input)

	if not Dragging then
		return
	end

	if Input.UserInputType ~= Enum.UserInputType.MouseMovement
		and Input.UserInputType ~= Enum.UserInputType.Touch then

		return

	end

	local Delta = Input.Position - DragStart

	Main.Position = UDim2.new(
		StartPosition.X.Scale,
		StartPosition.X.Offset + Delta.X,
		StartPosition.Y.Scale,
		StartPosition.Y.Offset + Delta.Y
	)

end)

--==================================================
-- F1
--==================================================

UserInputService.InputBegan:Connect(function(Input, GameProcessed)

	if GameProcessed then
		return
	end

	if Input.KeyCode == Enum.KeyCode.F1 then

		Main.Visible = not Main.Visible

	end

end)

--==================================================
-- START
--==================================================

UpdateGUI()

task.wait(0.3)

ApplyAll()

print("[Drake] Loaded")
print("[Drake] Speed:", SPEED)
print("[Drake] Jump Power:", JUMP_POWER)
