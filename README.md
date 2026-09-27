# swo-fixes

Client fixes for **Swordsman Classic**, installed with the **Apply Fix** button in the Swordsman Online client (`swo.exe`).

- `fix/fix.json` lists each file: where it goes in the game, where to download it, and its MD5.
- `fix/dl/` holds the download copies (big ones zlib-compressed as `.z`, unpacked by the client).
  Paths follow the game's `element` folder: `package/<name>/...` is written *inside* `package/<name>.pck`, everything else is a normal file.
- `PATCH_NOTES.md` describes what the fix changes.

Client setting (Settings → Fix source):

```
https://github.com/ogbelko/swo-fixes/blob/main/fix/fix.json
```

## Updating the fix

1. Keep your custom files in a source folder laid out like the game's element folder
   (e.g. `source\bin\xajh.exe`, `source\package\data\skills.data`).
   Optional: a `descriptions.json` in the source folder (`{"bin/xajh.exe": "what it changes", ...}`)
   adds a short description to each file. The client shows it in the Apply Fix window, where
   players tick which files to install.
2. Run `python make_fix.py source fix "Swordsman Classic client fixes"`. It rewrites `fix/fix.json` and `fix/dl/` and bumps the version.
3. Upload the `fix` folder to this repo again.

Players press **Apply Fix** again. Only files that changed get downloaded.
