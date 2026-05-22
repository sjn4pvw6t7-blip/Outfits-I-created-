-- Player Data Manager - Handles player data persistence
-- Place this in ServerStorage

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local PlayerDataManager = {}

-- Create DataStore
local playerDataStore = DataStoreService:GetDataStore("BaddieOutfits_PlayerData_v1")

-- Player data cache
local playerCache = {}

-- Data structure template
local function createNewPlayerData()
	return {
		ownedOutfits = {},
		purchaseHistory = {},
		totalSpent = 0,
		lastUpdated = os.time(),
		playTime = 0
	}
end

-- Get player data
function PlayerDataManager:GetPlayerData(player)
	local playerUserId = "Player_" .. player.UserId
	
	-- Return from cache if available
	if playerCache[playerUserId] then
		return playerCache[playerUserId]
	end
	
	-- Load from DataStore
	local success, data = pcall(function()
		return playerDataStore:GetAsync(playerUserId)
	end)
	
	if success then
		if data then
			playerCache[playerUserId] = data
			return data
		else
			-- Create new data
			local newData = createNewPlayerData()
			playerCache[playerUserId] = newData
			return newData
		end
	else
		print("Error loading data for player " .. player.Name .. ": " .. tostring(data))
		return createNewPlayerData()
	end
end

-- Save player data
function PlayerDataManager:SavePlayerData(player, data)
	local playerUserId = "Player_" .. player.UserId
	playerCache[playerUserId] = data
	
	local success, errorMessage = pcall(function()
		playerDataStore:SetAsync(playerUserId, data)
	end)
	
	if success then
		print("Data saved for player " .. player.Name)
		return true
	else
		print("Error saving data for player " .. player.Name .. ": " .. tostring(errorMessage))
		return false
	end
end

-- Add outfit to owned
function PlayerDataManager:AddOwnedOutfit(player, outfitId, outfitName, price)
	local data = self:GetPlayerData(player)
	
	-- Check if already owned
	for _, id in ipairs(data.ownedOutfits) do
		if id == outfitId then
			return false, "Already owned"
		end
	end
	
	-- Add to owned
	table.insert(data.ownedOutfits, outfitId)
	data.totalSpent = data.totalSpent + price
	
	-- Add to history
	table.insert(data.purchaseHistory, {
		outfitId = outfitId,
		name = outfitName,
		price = price,
		timestamp = os.time()
	})
	
	data.lastUpdated = os.time()
	
	self:SavePlayerData(player, data)
	return true, "Added to owned outfits"
end

-- Check if owns outfit
function PlayerDataManager:OwnsOutfit(player, outfitId)
	local data = self:GetPlayerData(player)
	
	for _, id in ipairs(data.ownedOutfits) do
		if id == outfitId then
			return true
		end
	end
	
	return false
end

-- Get owned outfits list
function PlayerDataManager:GetOwnedOutfits(player)
	local data = self:GetPlayerData(player)
	return data.ownedOutfits
end

-- Get purchase history
function PlayerDataManager:GetPurchaseHistory(player)
	local data = self:GetPlayerData(player)
	return data.purchaseHistory
end

-- Get total spent
function PlayerDataManager:GetTotalSpent(player)
	local data = self:GetPlayerData(player)
	return data.totalSpent
end

-- Get outfit count
function PlayerDataManager:GetOutfitCount(player)
	local data = self:GetPlayerData(player)
	return #data.ownedOutfits
end

-- Reset player data (admin only)
function PlayerDataManager:ResetPlayerData(player)
	local playerUserId = "Player_" .. player.UserId
	playerCache[playerUserId] = createNewPlayerData()
	
	local success = pcall(function()
		playerDataStore:SetAsync(playerUserId, createNewPlayerData())
	end)
	
	return success
end

-- Clear cache (call on server shutdown or maintenance)
function PlayerDataManager:ClearCache()
	playerCache = {}
end

-- Export for use in other scripts
return PlayerDataManager
