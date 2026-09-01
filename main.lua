--==================================================
-- DRAKE SPEED - ROBLOX STUDIO
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

--==================================================
-- SETTINGS
--==================================================

local SPEED = 20
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

--==================================================
-- MAIN
--==================================================

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

--==================================================
-- GRADIENT
--==================================================

local Gradient = Instance.new("UIGradient")

Gradient.Color = ColorSequence.new({

	ColorSequenceKeypoint.new(
		0,
		Color3.fromRGB(0, 255, 150)
	),

	ColorSequenceKeypoint.new(
		1,
		Color3.fromRGB(0, 120, 255)
	)

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

Title.Text = "Drake"
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

SpeedBox.PlaceholderText = "
