--==================================================
-- SPEED BOX CORNER
--==================================================

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

--==================================================
-- APPLY SPEED
--==================================================

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

--==================================================
-- UPDATE GUI
--==================================================

local function updateGUI()

	if speedEnabled then

		Toggle.Text = "⚡Speed: On"

		Toggle.BackgroundColor3 =
			Color3.fromRGB(0, 170, 110)

		Status.Text =
			"Speed đang chạy: " .. tostring(SPEED)

		Status.TextColor3 =
			Color3.fromRGB(0, 255, 170)

	else

		Toggle.Text = "Speed: Off"

		Toggle.BackgroundColor3 =
			Color3.fromRGB(50, 50, 55)

		Status.Text = "Speed đã tắt"

		Status.TextColor3 =
			Color3.fromRGB(220, 220, 220)

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

		SpeedBox.Text =
			tostring(SPEED)

		applySpeed()
		updateGUI()

	else

		SpeedBox.Text =
			tostring(SPEED)

	end

end)

--==================================================
-- CHARACTER / RESPAWN
--==================================================

player.CharacterAdded:Connect(function(character)

	local humanoid =
		character:WaitForChild(
			"Humanoid",
			10
		)

	if humanoid then

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

			local humanoid =
				getHumanoid()

			if humanoid
				and humanoid.WalkSpeed ~= SPEED then

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

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1

		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = true

		dragStart = input.Position
		startPosition = Main.Position

	end

end)

Top.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1

		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = false

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ~=
		Enum.UserInputType.MouseMovement

		and input.UserInputType ~=
		Enum.UserInputType.Touch then

		return

	end

	local delta =
		input.Position - dragStart

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

UserInputService.InputBegan:Connect(function(
	input,
	gameProcessed
)

	if gameProcessed then
		return
	end

	if input.KeyCode ==
		Enum.KeyCode.F1 then

		Main.Visible =
			not Main.Visible

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
