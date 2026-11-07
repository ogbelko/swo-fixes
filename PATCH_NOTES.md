# Swordsman Classic — Client Patch Notes

## New in v12
**Performance** (*Client Tweaks → Performance*)
- **Higher FPS cap in the world**: the game held itself to about 77 FPS (13 ms physics step); now your graphics card or DXVK sets the limit, and the CPU rests while it waits
- **Limit FPS of background windows**: game windows that are not in front run at the Background FPS from Minimal Settings (10 if not set), also with Minimal Mode off

**Mirage Cavern** (*Client Tweaks → Mirage Cavern*)
- Minimap arrows walk you through each doorway (6 m into the next room), also where the game's own route fails or stops short
- The entrance room's arrow is left alone; each click is logged to `bin\Logs\MirageArrow.log` when that folder exists

**Top bar and Quick Settings**
- FPS / ping now sit in the top bar next to the map name, with a cogwheel that opens **Quick Settings**
- Quick Settings: name labels (names only, other guilds in red), Player kill counter, loot auto-roll, System mail auto-claim

**Gear tools** (dock to the left of the Equipment Service pages)
- **Gem Cleanser**: plans which gems to cleanse with your crystal income and does the next step with the game's own buttons
- **Multi Disassembly**: tick gear and it is disassembled piece by piece with your Disassembly Charms
- **Gem Auto-Combine**: tick gems and they are combined with your Gem Combination Charms; can keep combining what it makes
- One currency choice for all of them and the Reforge tool: **Pay with Notes first, then Coins**

**Combat and items**
- *ESC → Settings → Control Scheme* redone: **Set per key** with padlocks under keys 1–8 (Locked Target or Area Select per key)
- **Alt + right-click** an item stack to open / use the whole stack

## New Features
**Client Tweaks Window**
- *ESC → Settings → System → Client Tweaks* (button at the bottom, next to Default)
- One on/off switch for every client fix; choices are kept in `userdata\ClientTweaks.ini`

**Bag**
- Big bag with Bag / Bag 1 / Bag 2 / All views, pages, Sort Selected / Sort All
- Material / Quest / Gift tabs, Lock / Unlock / Booth / Equip buttons, coins and notes
- Bag opens maximized (switch in Client Tweaks, off by default)

**Search**
- Bag search and stash search (item name or ID), free-slot counters
- Sycee Marketplace (J) search: jumps to a matching item, never buys

**World Energy Auto-Use**
- *Self-Cultivation Settings → Healing → Rest Settings*: tick **World Energy below [0–200] auto-use item**
- Uses a World Energy Remedy (or Fresh Dragonspit Herb) from your bag when your World Energy drops to that number
- Works all the time, not only while cultivating; one item at a time

**Celestial Reforge: Auto-Reforge**
- A tool window opens on the left of the Celestial Reforge window when an item is in it
- Tick the stats and skills you want and press **Start**: it keeps reforging until the item has them, or until you press **Stop**
- Uses your normal reforge materials for every roll

**EXP**
- Warning before an EXP item with a different multiplier replaces your remaining EXP time
- Multi-EXP window works in combat and shows World Energy use per minute and time left

**Rare Animal Island**
- Boss tooltips show direction, spawn coordinates and trophy
- Jade Sung's teleport options show which boss each leads to

**Hall of Heroes**
- Entry camera scene skipped (other cutscenes still play)

**Borderless Window**
- *ESC → Settings → System → Display Mode*: pick **Borderless window**

**Night Only / Day Only**
- *ESC → Settings → System*: keep the world at night, or at midday

**Minimal Mode**
- Toggle in *ESC → Settings → System*, next to HD Texture (restart to apply)
- No more Chinese banner at the top; maps keep their normal fog

**Minimal Settings (custom Minimal Mode)**
- *ESC → Settings → System → Minimal Settings* (button at the bottom, next to Client Tweaks)
- Your own draw distances for Trees, Objects, Water and Other, plus switches for Grass, Far terrain and Ground paint
- Presets: **Ultra light**, **Balanced**, **Original** (the game's own Minimal Mode)
- **Background FPS limit** while the game window is not active, and **Players drawn** (only the nearest N)
- **Other players without costumes**: they show their normal look, like turning off Display Costume
- **Effects of others within X m**: skill and projectile effects of characters farther away are hidden
- Works while Minimal Mode is on; saved in `userdata\MinimalMode.ini`, applies at the next teleport

**FPS & Ping**
- Live FPS and ping under the minimap (ping every 3 s)

**Player Kills Counter**
- Counts the enemy players you kill this session, shown above your character portrait

**Faster Start**
- Skips the Perfect World logo, the book screen and the one-server list: straight to character select
- Only the Swordsman logo shows while the game loads

**Bar Numbers**
- 0–100 shown under the Stamina, Rage and Warsoul bars

**Mail: Get All**
- New **Get All** button in the mailbox
- Instantly claims all mail on the current page (safe zones)

**Always-Visible Player HP Bars**
- Toggle **Show Players Health Bar** in *ESC → Settings → Gameplay*

## Interface
**Chat**
- Bigger chat box by default (still resizable)
- Typing in chat no longer stops when you get hit or a window pops up
- The chat cooldown message now names the Alliance Channel correctly

**World Map**
- Bigger world map window
- Right-click a region map to go back (same as the Back button)
- Every map opens fully zoomed out
- Smaller map name labels

**Crafting**
- Wider recipe list in every crafting window, so long item names fit

## Combat
**Locked Target now works in Action mode**
- **Locked Target** skills hit your target, not the nearest enemy (no target: auto-pick)
- Set per skill bar in *ESC → Settings → Control Scheme*

**Skills follow the camera**
- Outside Action mode, hold the right mouse button while you use a skill: your character first turns to where the camera is looking

**Action Mode Camera**
- Camera is now centred directly behind your character
- Aim indicator centred on screen, just above your HP bar

**Forced Move disabled**
- Forced Move can no longer be used, including during Lost Arts skills

**Tab Targeting fixed**
- *Ignore Players* / *Ignore Monsters* (*ESC → Settings → Gameplay*) now work

## Interface & Camera
- **Settings → System redone**: Graphics, Sound, Display, Camera sections; new **Max Zoom** (15–50), **Zoom Speed**, **Compatibility mode**
- **Removed the target info popup** in mid-screen
- **Console disabled**: Shift + ö no longer opens the debug console

## Stability
**Crash after leaving instances fixed**
- The client could close at random right after leaving an instance or changing map
- Cause: both loading threads could rebuild the same shader at once; they now take turns
- Loading a new map may take slightly longer

## Installation
Close the game, then replace these files:
- `bin\xajh.exe`
- `package\interfaces.pck`
- `package\script.pck`
- `package\configs.pck`
- `package\data.pck`
- `userdata\Layout\user_*.key` (console hotkey removal)

Back up your originals first.
