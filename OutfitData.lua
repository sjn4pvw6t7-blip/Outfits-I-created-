-- Baddie Outfits Data
-- 100 unique baddie outfits with prices from 5-100 Robux

local OutfitData = {
	store_name = "Baddies",
	total_outfits = 100,
	outfits = {}
}

-- Helper function to generate outfit data
local function createOutfit(id, name, description, price, rarity)
	return {
		id = id,
		name = name,
		description = description,
		price = price,
		rarity = rarity,
		shirt_id = 0,
		pants_id = 0,
		accessories = {}
	}
end

-- Generate 100 baddie outfits with varying prices (5-100 Robux)
-- Rarity distribution: Common (5-15R), Rare (20-40R), Epic (45-75R), Legendary (80-100R)

local outfits = {
	-- Tier 1: Common (5-15 Robux) - Outfits 1-25
	createOutfit(1, "Classic Baddie", "Timeless baddie aesthetic", 5, "Common"),
	createOutfit(2, "Street Style", "Urban baddie vibes", 5, "Common"),
	createOutfit(3, "Leather Goddess", "Black leather everything", 7, "Common"),
	createOutfit(4, "Crop Top Confidence", "Bold crop top look", 8, "Common"),
	createOutfit(5, "Bandage Fits", "Trendy bandage dress", 5, "Common"),
	createOutfit(6, "Latex Dreams", "Glossy latex vibes", 10, "Common"),
	createOutfit(7, "Mesh Magic", "Fishnet mesh outfit", 6, "Common"),
	createOutfit(8, "Monochrome Baddie", "All black everything", 5, "Common"),
	createOutfit(9, "Chain Link", "Chains and attitude", 9, "Common"),
	createOutfit(10, "Baby Tee Era", "Y2K baddie style", 7, "Common"),
	createOutfit(11, "Bodysuit Bliss", "Sleek bodysuit", 8, "Common"),
	createOutfit(12, "Hot Pants Special", "High-waisted hotpants", 6, "Common"),
	createOutfit(13, "Sequin Sparkle", "Glittery baddie", 10, "Common"),
	createOutfit(14, "Corset Couture", "Corset top stunning", 9, "Common"),
	createOutfit(15, "Platform Princess", "With platform accessories", 11, "Common"),
	createOutfit(16, "Sheer Confidence", "Sheer layered look", 12, "Common"),
	createOutfit(17, "Gothic Glamour", "Dark and edgy", 8, "Common"),
	createOutfit(18, "Holographic Hype", "Futuristic baddie", 13, "Common"),
	createOutfit(19, "Velvet Vibes", "Soft velvet outfit", 7, "Common"),
	createOutfit(20, "Studded Statement", "Studded everything", 14, "Common"),
	createOutfit(21, "Silk Seduction", "Satin and silk elegance", 11, "Common"),
	createOutfit(22, "Denim Diva", "Premium denim look", 8, "Common"),
	createOutfit(23, "Metallic Madness", "Silver and gold accents", 15, "Common"),
	createOutfit(24, "Mesh Magic 2", "Double mesh layers", 9, "Common"),
	createOutfit(25, "Neon Nights", "Bright neon colors", 12, "Common"),
	
	-- Tier 2: Rare (20-40 Robux) - Outfits 26-50
	createOutfit(26, "Diamond Baddie", "Crystal embellished", 20, "Rare"),
	createOutfit(27, "Fur Fantasy", "Luxury fur trim", 25, "Rare"),
	createOutfit(28, "Lace Luxe", "Premium lace details", 22, "Rare"),
	createOutfit(29, "Swarovski Stunner", "Crystal-studded", 30, "Rare"),
	createOutfit(30, "Feather Fever", "Feather boa accent", 24, "Rare"),
	createOutfit(31, "Plaid Baddie", "Edgy plaid pattern", 18, "Rare"),
	createOutfit(32, "Animal Print", "Leopard and tiger print", 26, "Rare"),
	createOutfit(33, "Vinyl Vision", "Shiny vinyl material", 21, "Rare"),
	createOutfit(34, "Beaded Beauty", "Hand-beaded look", 28, "Rare"),
	createOutfit(35, "Serpent Style", "Snake skin texture", 23, "Rare"),
	createOutfit(36, "Rainbow Rebel", "Colorful baddie", 32, "Rare"),
	createOutfit(37, "Gold Rush", "Golden accessories", 27, "Rare"),
	createOutfit(38, "Purple Reign", "Royal purple tones", 20, "Rare"),
	createOutfit(39, "Rose Gold Radiance", "Rose gold shimmer", 29, "Rare"),
	createOutfit(40, "Neon Angel", "Angelic neon glow", 31, "Rare"),
	createOutfit(41, "Midnight Mystique", "Dark mysterious vibe", 25, "Rare"),
	createOutfit(42, "Candy Pink", "Hot pink baddie", 19, "Rare"),
	createOutfit(43, "Electric Blue", "Vibrant blue accent", 26, "Rare"),
	createOutfit(44, "Liquid Silver", "Metallic liquid look", 34, "Rare"),
	createOutfit(45, "Pearl Perfection", "Pearl white elegance", 28, "Rare"),
	createOutfit(46, "Sunset Silhouette", "Orange and pink gradient", 33, "Rare"),
	createOutfit(47, "Ocean Vibes", "Turquoise and blue", 22, "Rare"),
	createOutfit(48, "Forest Feline", "Green nature baddie", 24, "Rare"),
	createOutfit(49, "Cherry Bomb", "Red hot baddie", 30, "Rare"),
	createOutfit(50, "Cosmic Cutie", "Space-themed outfit", 35, "Rare"),
	
	-- Tier 3: Epic (45-75 Robux) - Outfits 51-75
	createOutfit(51, "Celestial Crown", "Celestial theme", 45, "Epic"),
	createOutfit(52, "Phoenix Rising", "Fire and flames", 52, "Epic"),
	createOutfit(53, "Mermaid Magic", "Iridescent scales", 48, "Epic"),
	createOutfit(54, "Diamond Dust", "Sparkly diamonds", 55, "Epic"),
	createOutfit(55, "Butterfly Beauty", "Butterfly wing design", 50, "Epic"),
	createOutfit(56, "Midnight Black", "Ultimate black outfit", 46, "Epic"),
	createOutfit(57, "Goddess Glory", "Divine appearance", 60, "Epic"),
	createOutfit(58, "Rebel Rocker", "Rock star baddie", 53, "Epic"),
	createOutfit(59, "Cyber Punk", "Futuristic cyberpunk", 58, "Epic"),
	createOutfit(60, "Enchanted Evening", "Magical glow", 51, "Epic"),
	createOutfit(61, "Royal Jewels", "Crown and jewelry", 65, "Epic"),
	createOutfit(62, "Vampire Vixen", "Dark vampire style", 47, "Epic"),
	createOutfit(63, "Angel Wings", "Wings attached", 62, "Epic"),
	createOutfit(64, "Demon Diva", "Devilish horns", 57, "Epic"),
	createOutfit(65, "Aurora Borealis", "Northern lights colors", 66, "Epic"),
	createOutfit(66, "Starlight Supreme", "Star-covered", 54, "Epic"),
	createOutfit(67, "Onyx Obsidian", "Deep black shine", 49, "Epic"),
	createOutfit(68, "Sapphire Seduction", "Deep blue luxury", 61, "Epic"),
	createOutfit(69, "Ruby Radiance", "Deep red elegance", 63, "Epic"),
	createOutfit(70, "Emerald Envy", "Green gem theme", 52, "Epic"),
	createOutfit(71, "Platinum Princess", "Silver luxury", 68, "Epic"),
	createOutfit(72, "Golden Goddess", "All gold luxury", 70, "Epic"),
	createOutfit(73, "Crystal Clear", "Transparent chic", 56, "Epic"),
	createOutfit(74, "Prism Power", "Rainbow refraction", 64, "Epic"),
	createOutfit(75, "Quantum Queen", "Advanced tech look", 72, "Epic"),
	
	-- Tier 4: Legendary (80-100 Robux) - Outfits 76-100
	createOutfit(76, "Absolute Icon", "True icon status", 80, "Legendary"),
	createOutfit(77, "Supreme Baddie", "Ultimate baddie", 85, "Legendary"),
	createOutfit(78, "Fashion Forward", "Trend-setting outfit", 90, "Legendary"),
	createOutfit(79, "Red Carpet", "Awards show worthy", 95, "Legendary"),
	createOutfit(80, "Luxury Life", "High fashion couture", 100, "Legendary"),
	createOutfit(81, "Exclusive Elite", "Members only", 88, "Legendary"),
	createOutfit(82, "VIP Treatment", "VIP exclusive", 92, "Legendary"),
	createOutfit(83, "Platinum Crown", "Top tier", 87, "Legendary"),
	createOutfit(84, "Diamond Dynasty", "Diamond empire", 96, "Legendary"),
	createOutfit(85, "Royal Flush", "Royalty theme", 91, "Legendary"),
	createOutfit(86, "Infinity Stone", "Mystical infinity", 82, "Legendary"),
	createOutfit(87, "Black Panther", "Sleek dark cat", 86, "Legendary"),
	createOutfit(88, "White Tiger", "Exotic white", 89, "Legendary"),
	createOutfit(89, "Golden Phoenix", "Mythical phoenix", 98, "Legendary"),
	createOutfit(90, "Silver Dragon", "Dragon mythology", 94, "Legendary"),
	createOutfit(91, "Cosmic Queen", "Universe ruler", 99, "Legendary"),
	createOutfit(92, "Dimensional Shift", "Reality bending", 83, "Legendary"),
	createOutfit(93, "Nebula Nova", "Star burst energy", 84, "Legendary"),
	createOutfit(94, "Supernova Style", "Explosive style", 100, "Legendary"),
	createOutfit(95, "Time Traveler", "Future fashion", 93, "Legendary"),
	createOutfit(96, "Parallel Universe", "Alternate reality", 81, "Legendary"),
	createOutfit(97, "Transcendence", "Beyond perfection", 97, "Legendary"),
	createOutfit(98, "Ultimate Power", "Maximum power", 80, "Legendary"),
	createOutfit(99, "Eternal Beauty", "Timeless beauty", 100, "Legendary"),
	createOutfit(100, "Legendary Status", "The ultimate baddie", 100, "Legendary"),
}

-- Populate the outfits table
for i, outfit in ipairs(outfits) do
	OutfitData.outfits[i] = outfit
end

return OutfitData
