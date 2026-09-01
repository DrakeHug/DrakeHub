```lua
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
local speedEnabled = true

local MIN_SPEED = 16
local MAX_SPEED = 300
local DEFAULT_SPEED = 16

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
Main.BackgroundColor3 = Color3.fromRGB(20, 20
```
