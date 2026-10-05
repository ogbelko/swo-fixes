# Swordsman Classic — Client Patch Notes

## New Features
**Borderless Window**
- *ESC → Settings → System → Display Mode*: pick **Borderless window**

**Night Only / Day Only**
- *ESC → Settings → System*: keep the world at night, or at midday

**Minimal Mode**
- Toggle in *ESC → Settings → System*, next to HD Texture (restart to apply)

**FPS & Ping**
- Live FPS and ping under the minimap (ping every 3 s)

**Aggro List**
- Toggle on the left side: who your target attacks + top 10 damage on it

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
