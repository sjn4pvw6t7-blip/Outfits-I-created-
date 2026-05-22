# Baddie Outfits Store - Roblox Game Project

A comprehensive baddie outfit store system for Roblox with 100 unique outfits ranging from 5-100 Robux, featuring a try-on preview system.

## Features

- **100 Baddie Outfits**: Unique outfit designs with prices from 5-100 Robux
- **Try-On Preview System**: Players can preview outfits before purchasing
- **Store Interface**: User-friendly GUI for browsing and buying outfits
- **Persistent Data**: Purchase history and owned outfits stored per player

## Project Structure

```
├── ServerScriptService/
│   ├── StoreManager.lua      # Server-side store logic
│   └── PlayerDataManager.lua # Handle player data
├── StarterGui/
│   ├── StoreUI.lua          # Store UI controller
│   └── Assets/              # UI images and designs
├── ServerStorage/
│   └── OutfitData.lua       # Outfit definitions and pricing
└── Data/
    └── BaddieOutfits.json   # Outfit configuration data
```

## Installation

1. Clone or download this repository
2. Place scripts in appropriate Roblox Studio locations
3. Configure outfit data in `OutfitData.lua`
4. Customize UI in `StoreUI.lua`
5. Test in Roblox Studio

## Usage

Players can access the store via a GUI button in the game. They can:
- Browse all 100 baddie outfits
- Try on outfits with a live preview
- Purchase outfits with Robux
- View their owned outfits

## Price Range

All outfits are priced between 5-100 Robux, distributed across quality tiers.
