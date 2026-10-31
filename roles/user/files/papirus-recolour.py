"""Build a Papirus overlay theme whose folders use another colour.

Papirus picks folder colours with symlinks inside its package-owned directory,
so recolouring there is undone by every update. This overlay links each folder
alias to the chosen colour's file and inherits everything else.
Usage: papirus-recolour.py <src theme dir> <overlay dir> <name> <colour>
Prints "changed" when the overlay was modified.
"""

import os
import re
import sys
from pathlib import Path


def wanted_links(src: Path, colour: str) -> dict[str, str]:
    default = re.fullmatch(
        r"folder-(.+)\.svg", os.readlink(src / "48x48/places/folder.svg")
    )
    if default is None:
        sys.exit(f"cannot determine default folder colour in {src}")
    coloured = re.compile(rf"(folder|user)-{re.escape(default.group(1))}(-.*)?\.svg")
    links = {}
    for places in sorted(src.glob("*/places")):
        real_places = places.resolve()
        for entry in places.iterdir():
            if not entry.is_symlink():
                continue
            target = entry.resolve()
            match = coloured.fullmatch(target.name)
            if match is None or target.parent != real_places:
                continue
            new = real_places / f"{match.group(1)}-{colour}{match.group(2) or ''}.svg"
            if new.is_file():
                links[f"{places.parent.name}/places/{entry.name}"] = str(new)
    return links


def main(src: Path, dst: Path, name: str, colour: str) -> bool:
    changed = False
    want = wanted_links(src, colour)

    index = (src / "index.theme").read_text()
    index = re.sub(r"(?m)^Name=.*$", f"Name={name}", index, count=1)
    index = re.sub(r"(?m)^Inherits=.*$", f"Inherits={src.name},hicolor", index, count=1)
    dst.mkdir(parents=True, exist_ok=True)
    index_path = dst / "index.theme"
    if not index_path.exists() or index_path.read_text() != index:
        index_path.write_text(index)
        changed = True

    for existing in dst.glob("*/places/*"):
        rel = str(existing.relative_to(dst))
        if rel not in want:
            existing.unlink()
            changed = True

    for rel, target in want.items():
        link = dst / rel
        if link.is_symlink() and os.readlink(link) == target:
            continue
        link.parent.mkdir(parents=True, exist_ok=True)
        if link.is_symlink() or link.exists():
            link.unlink()
        link.symlink_to(target)
        changed = True
    return changed


if __name__ == "__main__":
    if len(sys.argv) != 5:
        sys.exit(__doc__)
    if main(Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3], sys.argv[4]):
        print("changed")
