-- Store UI - Client-side GUI for the Baddie Outfits Store
-- Place this in StarterPlayer > StarterCharacterScripts or StarterGui

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for remotes
local remoteFolder = game.ReplicatedStorage:WaitForChild("StoreRemotes")
local getOutfitsRemote = remoteFolder:WaitForChild("GetOutfits")
local purchaseOutfitRemote = remoteFolder:WaitForChild("PurchaseOutfit")
local getPlayerOutfitsRemote = remoteFolder:WaitForChild("GetPlayerOutfits")
local applyOutfitRemote = remoteFolder:WaitForChild("ApplyOutfit")
local restoreOutfitRemote = remoteFolder:WaitForChild("RestoreOutfit")

local storeOpen = false
local selectedOutfit = nil
local allOutfits = {}
local ownedOutfits = {}

-- Create main store GUI
local function createStoreGUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "StoreGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Main background
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 900, 0, 600)
	mainFrame.Position = UDim2.new(0.5, -450, 0.5, -300)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	mainFrame.BorderSizePixel = 0
	mainFrame.Visible = false
	mainFrame.Parent = screenGui
	
	-- Gradient background
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 20)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 10, 30))
	})
	gradient.Parent = mainFrame
	
	-- Corner radius
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = mainFrame
	
	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, 0, 0, 50)
	titleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	titleLabel.BackgroundTransparency = 0.5
	titleLabel.Text = "✨ BADDIES STORE ✨"
	titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	titleLabel.TextSize = 24
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Parent = mainFrame
	
	-- Close button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 40, 0, 40)
	closeButton.Position = UDim2.new(1, -50, 0, 5)
	closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextSize = 16
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Parent = mainFrame
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeButton
	
	closeButton.MouseButton1Click:Connect(function()
		storeOpen = false
		mainFrame.Visible = false
	end)
	
	-- Left panel - Outfit list
	local listFrame = Instance.new("ScrollingFrame")
	listFrame.Name = "ListFrame"
	listFrame.Size = UDim2.new(0, 300, 0, 500)
	listFrame.Position = UDim2.new(0, 10, 0, 60)
	listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	listFrame.BorderSizePixel = 0
	listFrame.ScrollBarThickness = 12
	listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	listFrame.Parent = mainFrame
	
	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 10)
	listCorner.Parent = listFrame
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 8)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = listFrame
	
	-- Right panel - Preview
	local previewFrame = Instance.new("Frame")
	previewFrame.Name = "PreviewFrame"
	previewFrame.Size = UDim2.new(0, 560, 0, 500)
	previewFrame.Position = UDim2.new(0, 320, 0, 60)
	previewFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	previewFrame.BorderSizePixel = 0
	previewFrame.Parent = mainFrame
	
	local previewCorner = Instance.new("UICorner")
	previewCorner.CornerRadius = UDim.new(0, 10)
	previewCorner.Parent = previewFrame
	
	-- Outfit info label
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Name = "InfoLabel"
	infoLabel.Size = UDim2.new(1, -20, 0, 120)
	infoLabel.Position = UDim2.new(0, 10, 0, 10)
	infoLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	infoLabel.BackgroundTransparency = 0.3
	infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	infoLabel.TextSize = 14
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextWrapped = true
	infoLabel.Text = "Select an outfit"
	infoLabel.Parent = previewFrame
	
	-- Try on button
	local tryOnButton = Instance.new("TextButton")
	tryOnButton.Name = "TryOnButton"
	tryOnButton.Size = UDim2.new(0, 260, 0, 40)
	tryOnButton.Position = UDim2.new(0, 10, 0, 140)
	tryOnButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	tryOnButton.Text = "👗 TRY ON"
	tryOnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	tryOnButton.TextSize = 14
	tryOnButton.Font = Enum.Font.GothamBold
	tryOnButton.Parent = previewFrame
	
	local tryOnCorner = Instance.new("UICorner")
	tryOnCorner.CornerRadius = UDim.new(0, 8)
	tryOnCorner.Parent = tryOnButton
	
	-- Buy button
	local buyButton = Instance.new("TextButton")
	buyButton.Name = "BuyButton"
	buyButton.Size = UDim2.new(0, 260, 0, 40)
	buyButton.Position = UDim2.new(0, 280, 0, 140)
	buyButton.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
	buyButton.Text = "💳 BUY"
	buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyButton.TextSize = 14
	buyButton.Font = Enum.Font.GothamBold
	buyButton.Parent = previewFrame
	
	local buyCorner = Instance.new("UICorner")
	buyCorner.CornerRadius = UDim.new(0, 8)
	buyCorner.Parent = buyButton
	
	-- Restore button
	local restoreButton = Instance.new("TextButton")
	restoreButton.Name = "RestoreButton"
	restoreButton.Size = UDim2.new(0, 540, 0, 40)
	restoreButton.Position = UDim2.new(0, 10, 0, 190)
	restoreButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
	restoreButton.Text = "↩️ RESTORE ORIGINAL"
	restoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	restoreButton.TextSize = 14
	restoreButton.Font = Enum.Font.GothamBold
	restoreButton.Parent = previewFrame
	
	local restoreCorner = Instance.new("UICorner")
	restoreCorner.CornerRadius = UDim.new(0, 8)
	restoreCorner.Parent = restoreButton
	
	-- Status area
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(1, -20, 0, 240)
	statusLabel.Position = UDim2.new(0, 10, 0, 240)
	statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	statusLabel.BackgroundTransparency = 0.3
	statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	statusLabel.TextSize = 12
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.TextWrapped = true
	statusLabel.Text = "Loading store..."
	statusLabel.Parent = previewFrame
	
	-- Event handlers
	tryOnButton.MouseButton1Click:Connect(function()
		if selectedOutfit then
			applyOutfitRemote:InvokeServer(selectedOutfit.id)
			statusLabel.Text = "✅ Trying on: " .. selectedOutfit.name
		end
	end)
	
	buyButton.MouseButton1Click:Connect(function()
		if selectedOutfit then
			local success, message = purchaseOutfitRemote:InvokeServer(selectedOutfit.id)
			if success then
				statusLabel.Text = "✅ Purchased: " .. selectedOutfit.name .. " for " .. selectedOutfit.price .. " Robux!"
				ownedOutfits[selectedOutfit.id] = true
			else
				statusLabel.Text = "❌ Purchase failed: " .. (message or "Unknown error")
			end
		end
	end)
	
	restoreButton.MouseButton1Click:Connect(function()
		restoreOutfitRemote:InvokeServer()
		statusLabel.Text = "↩️ Outfit restored to original"
	end)
	
	return {
		gui = screenGui,
		mainFrame = mainFrame,
		listFrame = listFrame,
		infoLabel = infoLabel,
		statusLabel = statusLabel
	}
end

-- Load outfits into list
local function loadOutfits(uiElements)
	-- Get all outfits from server
	allOutfits = getOutfitsRemote:InvokeServer()
	ownedOutfits = getPlayerOutfitsRemote:InvokeServer()
	
	-- Clear existing list
	for _, child in pairs(uiElements.listFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	
	-- Add outfit buttons
	for _, outfit in ipairs(allOutfits) do
		local outfitButton = Instance.new("TextButton")
		outfitButton.Name = "Outfit_" .. outfit.id
		outfitButton.Size = UDim2.new(1, -16, 0, 50)
		outfitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		outfitButton.Text = outfit.name .. " - " .. outfit.price .. "R$"
		outfitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		outfitButton.TextSize = 12
		outfitButton.Font = Enum.Font.Gotham
		outfitButton.Parent = uiElements.listFrame
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = outfitButton
		
		-- Color based on rarity
		if outfit.rarity == "Common" then
			outfitButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		elseif outfit.rarity == "Rare" then
			outfitButton.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
		elseif outfit.rarity == "Epic" then
			outfitButton.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
		elseif outfit.rarity == "Legendary" then
			outfitButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		end
		
		outfitButton.MouseButton1Click:Connect(function()
			selectedOutfit = outfit
			local ownedText = ownedOutfits[outfit.id] and "✅ OWNED" or ""
			uiElements.infoLabel.Text = 
				"🎀 " .. outfit.name .. "\n\n" ..
				"⭐ Rarity: " .. outfit.rarity .. "\n" ..
				"💰 Price: " .. outfit.price .. " Robux\n" ..
				"📝 " .. outfit.description .. "\n\n" ..
				ownedText
		end)
	end
	
	-- Update canvas size
	uiElements.listFrame.CanvasSize = UDim2.new(0, 0, 0, uiElements.listFrame.UIListLayout.AbsoluteContentSize.Y)
end

-- Create the UI
local uiElements = createStoreGUI()

-- Load outfits
loadOutfits(uiElements)

-- Keyboard input to toggle store
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.B then
		storeOpen = not storeOpen
		uiElements.mainFrame.Visible = storeOpen
		if storeOpen then
			loadOutfits(uiElements)
		end
	end
end)

print("Store UI loaded! Press 'B' to open the store")
