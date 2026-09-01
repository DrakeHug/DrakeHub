--==================================================
-- DRAKE SPEED - SERVER
--==================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DEFAULT_SPEED = 16
local MIN_SPEED = 16
local MAX_SPEED = 300

--==================================================
-- REMOTE EVENT
--==================================================

local Remote = ReplicatedStorage:FindFirstChild("DrakeSpeedRemote")

if not Remote then
	Remote = Instance.new("RemoteEvent")
	Remote.Name = "DrakeSpeedRemote"
	Remote.Parent = ReplicatedStorage
end

--==================================================
-- PLAYER DATA
--==================================================

local playerSpeed = {}
local playerEnabled = {}

--==================================================
-- APPLY SPEED
--==================================================

local function applySpeed(player)
	local character = player.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	local enabled = playerEnabled[player]

	if enabled then
		humanoid.WalkSpeed = playerSpeed[player] or 20
	else
		humanoid.WalkSpeed = DEFAULT_SPEED
	end
end

--==================================================
-- PLAYER JOIN
--==================================================

Players.PlayerAdded:Connect(function(player)

	playerSpeed[player] = 20
	playerEnabled[player] = true

	player.CharacterAdded:Connect(function(character)

		local humanoid =
			character:WaitForChild("Humanoid", 10)

		if humanoid then
			task.wait(0.2)
			applySpeed(player)
		end

	end)

end)

--==================================================
--
