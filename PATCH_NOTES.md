# Swordsman Classic — Client Patch Notes

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

## Installation
Close the game, then replace these files:
- `bin\xajh.exe`
- `package\interfaces.pck`
- `package\script.pck`
- `package\configs.pck`
- `package\data.pck`
- `userdata\Layout\user_*.key` (console hotkey removal)

Back up your originals first.
