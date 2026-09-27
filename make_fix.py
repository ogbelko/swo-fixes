"""
make_fix.py - builds the "Apply Fix" download folder.

Usage:
    python make_fix.py <source folder> <output folder> "Fix name"

<source folder> holds your custom files with the SAME layout as the game's element folder:
    source\\bin\\xajh.exe
    source\\package\\interfaces\\setting_system.xml   (goes inside package\\interfaces.pck)
    source\\package\\data\\skills.data                (goes inside package\\data.pck)
A source file may also be stored zlib-compressed with a ".z" ending (skills.data.z); it is
unpacked automatically.

<output folder> is what you upload (e.g. the "fix" folder of your GitHub repo). It gets:
    fix.json   - the list the client reads (paths, MD5s, version)
    dl\\...     - the download copies; big files are zlib-compressed so each one stays under
                 GitHub's 25 MB browser-upload limit (the client unpacks them automatically)

Run it again after every change; the version number goes up by one each time. Then upload the
output folder again (files that didn't change stay identical, so re-uploading is harmless).
"""

import hashlib
import json
import os
import shutil
import sys
import zlib

COMPRESS_OVER = 256 * 1024      # compress files bigger than this (if it actually helps)
GITHUB_WEB_LIMIT = 25 * 1024 * 1024
DESCRIPTIONS = "descriptions.json"


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)
    src = os.path.abspath(sys.argv[1])
    out = os.path.abspath(sys.argv[2])
    name = sys.argv[3] if len(sys.argv) > 3 else "Fix"
    if not os.path.isdir(src):
        sys.exit(f"Source folder not found: {src}")

    manifest_path = os.path.join(out, "fix.json")
    version = 0
    if os.path.isfile(manifest_path):
        try:
            with open(manifest_path, encoding="utf-8") as f:
                version = int(json.load(f).get("version", 0))
        except (ValueError, OSError):
            version = 0

    # Optional descriptions.json in the source folder: {"bin/xajh.exe": "what it changes", ...}.
    # Shown next to each file in the client's Apply Fix window. Not installed itself.
    descs = {}
    desc_path = os.path.join(src, DESCRIPTIONS)
    if os.path.isfile(desc_path):
        with open(desc_path, encoding="utf-8-sig") as f:
            descs = {k.replace("\\", "/").lower(): v for k, v in json.load(f).items()}

    dl = os.path.join(out, "dl")
    if os.path.isdir(dl):
        shutil.rmtree(dl)
    entries, too_big = [], []
    for dirpath, _dirs, names in os.walk(src):
        for n in sorted(names):
            full = os.path.join(dirpath, n)
            rel = os.path.relpath(full, src).replace("\\", "/")
            if rel == DESCRIPTIONS:
                continue
            with open(full, "rb") as f:
                data = f.read()
            if rel.endswith(".z"):              # already-compressed source copy (e.g. skills.data.z)
                rel = rel[:-2]
                data = zlib.decompress(data)
            entry = {"path": rel, "md5": hashlib.md5(data).hexdigest()}
            if descs.get(rel.lower()):
                entry["desc"] = descs[rel.lower()]
            blob, url = data, "dl/" + rel
            if len(data) > COMPRESS_OVER:
                z = zlib.compress(data, 9)
                if len(z) < len(data):
                    blob, url = z, "dl/" + rel + ".z"
                    entry["packed"] = "zlib"
            entry["url"] = url
            dest = os.path.join(out, *url.split("/"))
            os.makedirs(os.path.dirname(dest), exist_ok=True)
            with open(dest, "wb") as f:
                f.write(blob)
            if len(blob) > GITHUB_WEB_LIMIT:
                too_big.append((rel, len(blob)))
            entries.append(entry)
    if not entries:
        sys.exit("No files found in " + src)

    entries.sort(key=lambda e: e["path"].lower())
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump({"name": name, "version": version + 1, "files": entries}, f, indent=2, ensure_ascii=False)
    print(f"Wrote {manifest_path}: {len(entries)} file(s), version {version + 1}")
    for e in entries:
        size = os.path.getsize(os.path.join(out, *e["url"].split("/")))
        print(f"   {e['path']}  ({size / 1048576:.1f} MB to download{', compressed' if e.get('packed') else ''})")
    for rel, size in too_big:
        print(f"WARNING: {rel} is {size / 1048576:.1f} MB even compressed - too big for GitHub's web "
              f"upload (25 MB); upload it with GitHub Desktop or as a Release file instead.")


if __name__ == "__main__":
    main()
