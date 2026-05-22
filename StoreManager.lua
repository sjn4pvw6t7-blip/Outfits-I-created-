-- Store Manager - Server-side store logic
-- Place this in ServerScriptService

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Load outfit data
local OutfitData = require(game.ServerStorage:WaitForChild("OutfitData"))

-- Create remotes folder
local remoteFolder = Instance.new("Folder")
remoteFolder.Name = "StoreRemotes"
remoteFolder.Parent = game.ReplicatedStorage

-- Create remotes
local getOutfitsRemote = Instance.new("RemoteFunction")
getOutfitsRemote.Name = "GetOutfits"
getOutfitsRemote.Parent = remoteFolder

local purchaseOutfitRemote = Instance.new("RemoteFunction")
purchaseOutfitRemote.Name = "PurchaseOutfit"
purchaseOutfitRemote.Parent = remoteFolder

local getPlayerOutfitsRemote = Instance.new("RemoteFunction")
getPlayerOutfitsRemote.Name = "GetPlayerOutfits"
getPlayerOutfitsRemote.Parent = remoteFolder

local applyOutfitRemote = Instance.new("RemoteFunction")
applyOutfitRemote.Name = "ApplyOutfit"
applyOutfitRemote.Parent = remoteFolder

local restoreOutfitRemote = Instance.new("RemoteFunction")
restoreOutfitRemote.Name = "RestoreOutfit"
restoreOutfitRemote.Parent = remoteFolder

-- DataStore
local playerDataStore = DataStoreService:GetDataStore("BaddieOutfits_PlayerData")

-- Player data tracking
local playerData = {}

-- Store player original outfit
local playerOriginalOutfits = {}

-- Get all outfits
getOutfitsRemote.OnServerInvoke = function(player)
	print("Player " .. player.Name .. " requested outfit list")
	return OutfitData.outfits
end

-- Get player owned outfits
getPlayerOutfitsRemote.OnServerInvoke = function(player)
	local playerUserId = "Player_" .. player.UserId
	
	if not playerData[playerUserId] then
		-- Load from DataStore
		local success, data = pcall(function()
			return playerDataStore:GetAsync(playerUserId)
		end)
		
		if success and data then
			playerData[playerUserId] = data
		else
			playerData[playerUserId] = {
				ownedOutfits = {},
				purchaseHistory = {}
			}
		end
	end
	
	local ownedTable = {}
	for _, outfitId in ipairs(playerData[playerUserId].ownedOutfits) do
		ownedTable[outfitId] = true
	end
	
	return ownedTable
end

-- Purchase outfit
purchaseOutfitRemote.OnServerInvoke = function(player, outfitId)
	local playerUserId = "Player_" .. player.UserId
	
	-- Validate outfit ID
	local outfit = nil
	for _, o in ipairs(OutfitData.outfits) do
		if o.id == outfitId then
			outfit = o
			break
		end
	end
	
	if not outfit then
		return false, "Outfit not found"
	end
	
	-- Check if player already owns it
	if not playerData[playerUserId] then
		playerData[playerUserId] = {
			ownedOutfits = {},
			purchaseHistory = {}
		}
	end
	
	for _, ownedId in ipairs(playerData[playerUserId].ownedOutfits) do
		if ownedId == outfitId then
			return false, "You already own this outfit"
		end
	end
	
	-- Deduct Robux (optional - implement with MarketplaceService if needed)
	-- For now, just add to owned outfits
	
	table.insert(playerData[playerUserId].ownedOutfits, outfitId)
	table.insert(playerData[playerUserId].purchaseHistory, {
		outfitId = outfitId,
		name = outfit.name,
		price = outfit.price,
		timestamp = os.time()
	})
	
	-- Save to DataStore
	local success = pcall(function()
		playerDataStore:SetAsync(playerUserId, playerData[playerUserId])
	end)
	
	if success then
		print("Player " .. player.Name .. " purchased outfit: " .. outfit.name)
		return true, "Purchase successful!"
	else
		return false, "Failed to save purchase"
	end
end

-- Apply outfit (try-on)
applyOutfitRemote.OnServerInvoke = function(player, outfitId)
	-- Store original outfit
	local character = player.Character
	if not character then
		return false, "Character not found"
	end
	
	local humanoid = character:FindFirstChild("Humanoid")
	local shirt = character:FindFirstChild("Shirt")
	local pants = character:FindFirstChild("Pants")
	
	-- Save original
	if not playerOriginalOutfits[player.UserId] then
		playerOriginalOutfits[player.UserId] = {
			shirtId = shirt and shirt.ShirtTemplate or "",
			pantsId = pants and pants.PantsTemplate or ""
		}
	end
	
	-- Find outfit
	local outfit = nil
	for _, o in ipairs(OutfitData.outfits) do
		if o.id == outfitId then
			outfit = o
			break
		end
	end
	
	if not outfit then
		return false, "Outfit not found"
	end
	
	-- Apply outfit
	if shirt then
		shirt.ShirtTemplate = "rbxassetid://" .. outfit.shirt_id
	else
		shirt = Instance.new("Shirt")
		shirt.ShirtTemplate = "rbxassetid://" .. outfit.shirt_id
		shirt.Parent = character
	end
	
	if pants then
		pants.PantsTemplate = "rbxassetid://" .. outfit.pants_id
	else
		pants = Instance.new("Pants")
		pants.PantsTemplate = "rbxassetid://" .. outfit.pants_id
		pants.Parent = character
	end
	
	print("Player " .. player.Name .. " trying on: " .. outfit.name)
	return true, "Outfit applied"
end

-- Restore original outfit
restoreOutfitRemote.OnServerInvoke = function(player)
	local character = player.Character
	if not character then
		return false, "Character not found"
	end
	
	if not playerOriginalOutfits[player.UserId] then
		return false, "No original outfit saved"
	end
	
	local original = playerOriginalOutfits[player.UserId]
	local shirt = character:FindFirstChild("Shirt")
	local pants = character:FindFirstChild("Pants")
	
	if shirt and original.shirtId ~= "" then
		shirt.ShirtTemplate = original.shirtId
	end
	
	if pants and original.pantsId ~= "" then
		pants.PantsTemplate = original.pantsId
	end
	
	print("Player " .. player.Name .. " outfit restored")
	return true, "Outfit restored"
end

-- Save data when player leaves
Players.PlayerRemoving:Connect(function(player)
	local playerUserId = "Player_" .. player.UserId
	
	if playerData[playerUserId] then
		local success = pcall(function()
			playerDataStore:SetAsync(playerUserId, playerData[playerUserId])
		end)
		
		if success then
			print("Saved data for " .. player.Name)
		end
	end
	
	playerData[playerUserId] = nil
	playerOriginalOutfits[player.UserId] = nil
end)

print("Store Manager loaded!")
