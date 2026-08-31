local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local speedStore = DataStoreService:GetDataStore("PlayerSpeed_V1")

local DEFAULT_SPEED = 80
local MIN_SPEED = 16
local MAX_SPEED = 300

local function loadSpeed(player)
	local success, data = pcall(function()
		return speedStore:GetAsync("Speed_" .. player.UserId)
	end)

	if success and typeof(data) == "number" then
		return math.clamp(data, MIN_SPEED, MAX_SPEED)
	end

	return DEFAULT_SPEED
end

local function saveSpeed(player, speed)
	pcall(function()
		speedStore:SetAsync("Speed_" .. player.UserId, speed)
	end)
end

Players.PlayerAdded:Connect(function(player)
	local speed = loadSpeed(player)

	player:SetAttribute("SavedSpeed", speed)

	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = speed
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	local speed = player:GetAttribute("SavedSpeed")

	if typeof(speed) == "number" then
		saveSpeed(player, speed)
	end
end)
