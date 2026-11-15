<div align="center">

# TileFantasy

**A fantasy MMO concept built around faction conflict, exploration, and a persistent world.**

![Genre](https://img.shields.io/badge/genre-fantasy%20MMO-6f42c1)
![Combat](https://img.shields.io/badge/combat-turn--based-0A7F8C)
![World](https://img.shields.io/badge/world-open%20world-1f6feb)
![Status](https://img.shields.io/badge/status-in%20development-orange)

</div>

## Overview

TileFantasy is a fantasy multiplayer role-playing game project built around a shared world, four competing nations, turn-based battles, and a resource-driven progression system.

Players are intended to explore regions, fight monsters and other players, develop professions, trade, and compete for **Soul Crystals** — the central resource used for leveling, crafting, and exchange.

This repository contains design documentation, lore, art and map directories, plus separate client/server project folders. The systems described below represent the project's design; individual features should be considered planned or in progress unless confirmed in the implementation.

## Core game pillars

- **Faction identity:** four nations with distinct environments and combat roles.
- **World exploration:** open regions, cities, dungeons, and AI-managed intermediate zones.
- **Turn-based combat:** tactical encounters against monsters and other players.
- **Resource economy:** Soul Crystals as a shared progression and trade resource.
- **Player specialization:** professions, equipment, attributes, and crafting.
- **Faction conflict:** PvP outside protected cities and neutral trade areas.

## The four nations

| Nation | Environment | Role and profession |
|---|---|---|
| Steel Nation | Mountains, valleys, lakes | Sword warriors / blacksmiths |
| Arcane Nation | Floating islands | Mages / alchemists |
| Wall Nation | Icy frontier and great wall | Rangers / craftsmen |
| Soul Nation | Mysterious forests | Creature tamers / enchanters |

Each nation has its own identity, lore, and progression direction. The design also describes a personality-based nation assignment and a nation-change mechanic after repeated deaths.

## World and activities

The design documents describe several types of locations:

- **Cities:** training, professions, markets, throne chambers, museums, libraries, and guilds.
- **Neutral zone:** a protected area intended for trade between nations.
- **Intermediate zones:** changing regions with monster encounters and resource drops.
- **Primordial Portal:** the location associated with the planned global-boss event.

## Progression and economy

Soul Crystals are the central resource in the game design. They are intended to support:

- Character progression and leveling
- Crafting and profession development
- Player-to-player exchange
- Creature healing and enhancement in the Soul Nation

Characters are also described with primary attributes such as Strength, Dexterity, Intellect, Vitality, and Soul, which influence derived combat statistics.

## Combat and equipment

The design describes nation-specific combat identities, turn-based actions, weapons, armor, rings, creature companions, and skills. The complete combat balance and implementation status should be checked against the current game code.

## Repository navigation

```text
.
├── art/                 # Visual assets
├── game_doc             # Gameplay systems and mechanics
├── lore                 # Nation and world background
├── map/                 # Map-related content
├── tile_fantasy_server/ # Server-side project
├── tilesfantasy/        # Client/game project
└── todo                 # Development roadmap
```

## Development status

The repository combines design work and software project directories. It should be presented as an in-development game project, not as a released MMO with all documented systems already available.

## Project documentation

- [Gameplay design](game_doc)
- [World lore](lore)
- [Development tasks](todo)

## License

No license file was identified in the repository. Contact the author before redistributing or reusing project materials.
