#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BUILD = ROOT / "build" / "generated"
ASSETS = ROOT / "assets"


def ensure_build():
    BUILD.mkdir(parents=True, exist_ok=True)


def rows_to_tile(rows):
    plane0 = []
    plane1 = []
    for row in rows:
        b0 = 0
        b1 = 0
        for idx, ch in enumerate(row):
            val = int(ch)
            shift = 7 - idx
            b0 |= (val & 1) << shift
            b1 |= ((val >> 1) & 1) << shift
        plane0.append(b0)
        plane1.append(b1)
    return bytes(plane0 + plane1)


FONT = {
    "A": ["00111000","01000100","01000100","01111100","01000100","01000100","01000100","00000000"],
    "D": ["01111000","01000100","01000100","01000100","01000100","01000100","01111000","00000000"],
    "E": ["01111100","01000000","01000000","01111000","01000000","01000000","01111100","00000000"],
    "G": ["00111100","01000000","01000000","01011100","01000100","01000100","00111100","00000000"],
    "H": ["01000100","01000100","01000100","01111100","01000100","01000100","01000100","00000000"],
    "I": ["00111000","00010000","00010000","00010000","00010000","00010000","00111000","00000000"],
    "M": ["01000100","01101100","01010100","01010100","01000100","01000100","01000100","00000000"],
    "N": ["01000100","01100100","01010100","01001100","01000100","01000100","01000100","00000000"],
    "O": ["00111000","01000100","01000100","01000100","01000100","01000100","00111000","00000000"],
    "P": ["01111000","01000100","01000100","01111000","01000000","01000000","01000000","00000000"],
    "Q": ["00111000","01000100","01000100","01000100","01010100","01001000","00110100","00000000"],
    "R": ["01111000","01000100","01000100","01111000","01010000","01001000","01000100","00000000"],
    "S": ["00111100","01000000","01000000","00111000","00000100","00000100","01111000","00000000"],
    "T": ["01111100","00010000","00010000","00010000","00010000","00010000","00010000","00000000"],
    "U": ["01000100","01000100","01000100","01000100","01000100","01000100","00111000","00000000"],
    "V": ["01000100","01000100","01000100","01000100","01000100","00101000","00010000","00000000"],
    "W": ["01000100","01000100","01000100","01010100","01010100","01101100","01000100","00000000"],
    "Y": ["01000100","01000100","00101000","00010000","00010000","00010000","00010000","00000000"],
    " ": ["00000000"] * 8,
}


def glyph_from_bits(bit_rows):
    return [row.replace("1", "1").replace("0", "0") for row in bit_rows]


def make_bg_tiles():
    tiles = [bytes(16) for _ in range(16)]
    tiles[1] = rows_to_tile([
        "00000000","00000000","00010000","00000000",
        "00000000","00000100","00000000","00000000",
    ])
    tiles[2] = rows_to_tile([
        "22222222","21111112","21111112","21111112",
        "21111112","21111112","21111112","22222222",
    ])
    tiles[3] = rows_to_tile([
        "00000000","01111110","01010100","01010100",
        "01010100","01010100","01111110","00000000",
    ])
    tiles[4] = rows_to_tile([
        "00000000","01101100","11111110","11111110",
        "01111100","00111000","00010000","00000000",
    ])
    tiles[5] = rows_to_tile([
        "00000000","01101100","10010010","10010010",
        "01000100","00101000","00010000","00000000",
    ])
    tiles[6] = rows_to_tile([
        "00000000","00011000","00111100","01111110",
        "01111110","00111100","00011000","00000000",
    ])
    tiles[7] = rows_to_tile([
        "33333333","30000003","30000003","30000003",
        "30000003","30000003","30000003","33333333",
    ])
    index = 16
    for ch in sorted(FONT):
        tiles.append(rows_to_tile(glyph_from_bits(FONT[ch])))
        index += 1
    while len(tiles) < 256:
        tiles.append(bytes(16))
    return b"".join(tiles[:256])


def sprite_pair(left_rows, right_rows):
    return rows_to_tile(left_rows) + rows_to_tile(right_rows)


def make_sprite_tiles():
    pairs = []
    pairs.extend([
        rows_to_tile(["00111100","01111110","11111111","11111111","11111111","01111110","01111110","00111100"]),
        rows_to_tile(["00111100","01111110","11111111","11111111","11111111","01111110","01111110","00111100"]),
        rows_to_tile(["00111100","01111110","11111111","11111111","11111111","01111110","00111100","00100100"]),
        rows_to_tile(["00111100","01111110","11111111","11111111","11111111","01111110","00100100","00100100"]),
        rows_to_tile(["00111100","01111110","11111111","11111111","11111111","01111110","00111100","01000010"]),
        rows_to_tile(["00111100","01111110","11111111","11111111","11111111","01111110","01000010","01000010"]),
        rows_to_tile(["00111100","01111110","11111111","11111111","11111111","01111110","01111110","01000010"]),
        rows_to_tile(["00111100","01111110","11111111","11111111","11111111","01111110","01111110","01000010"]),
        rows_to_tile(["00111100","01111110","11111111","11111111","11111111","01111110","01011010","00100100"]),
        rows_to_tile(["00111100","01111110","11111111","11111111","11111111","01111110","00100100","01000010"]),
        rows_to_tile(["00011000","00111100","01111110","00111100","00111100","01111110","00111100","00011000"]),
        rows_to_tile(["00011000","00111100","01111110","00111100","00111100","01111110","00111100","00011000"]),
        rows_to_tile(["00011000","00111100","01111110","01111110","01111110","00111100","00111100","00011000"]),
        rows_to_tile(["00011000","00111100","01111110","01111110","01111110","00111100","00011000","00011000"]),
        rows_to_tile(["00011000","00111100","00111100","01111110","01111110","00111100","00111100","00011000"]),
        rows_to_tile(["00011000","00111100","00111100","01111110","01111110","00111100","00111100","00011000"]),
        rows_to_tile(["00000000","00011000","00111100","01111110","00111100","00111100","00111100","00011000"]),
        rows_to_tile(["00000000","00011000","00111100","01111110","00111100","00111100","00111100","00011000"]),
        rows_to_tile(["00011000","00111100","01111110","11111111","11111111","01111110","00111100","00011000"]),
        rows_to_tile(["00011000","00111100","01111110","11111111","11111111","01111110","00111100","00011000"]),
        rows_to_tile(["00011000","00111100","00111100","00111100","00111100","00111100","00111100","00011000"]),
        rows_to_tile(["00011000","00111100","00111100","00111100","00111100","00111100","00111100","00011000"]),
        rows_to_tile(["00110000","01111000","11111100","01111000","00110000","00110000","00110000","00110000"]),
        rows_to_tile(["00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000"]),
        rows_to_tile(["00110000","01111000","11111100","01111000","00110000","00110000","00110000","00110000"]),
        rows_to_tile(["00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000"]),
        rows_to_tile(["00011000","00111100","01111110","11111111","01111110","00111100","00011000","00000000"]),
        rows_to_tile(["00011000","00111100","01111110","11111111","01111110","00111100","00011000","00000000"]),
    ])
    while len(pairs) < 256:
        pairs.append(bytes(16))
    return b"".join(pairs[:256])


def make_chr():
    bg = make_bg_tiles()
    spr = make_sprite_tiles()
    (BUILD / "chr.bin").write_bytes(bg + spr)


def load_palettes():
    data = json.loads((ASSETS / "palettes" / "palettes.json").read_text())
    bg = data["bg"]
    spr = data["sprite"]
    values = [item for palette in bg for item in palette] + [item for palette in spr for item in palette]
    with (BUILD / "palettes.inc").open("w") as f:
        f.write("bg_palette_data:\n")
        f.write(".byte " + ", ".join(f"${v:02X}" for v in values) + "\n")


def char_tile(ch):
    if ch == " ":
        return 0
    alphabet = sorted(FONT)
    return 16 + alphabet.index(ch)


def blank_screen():
    return [0] * 1024


def blit_text(screen, row, col, text):
    base = row * 32 + col
    for i, ch in enumerate(text):
        screen[base + i] = char_tile(ch)


def write_screen(lines, path_label, f):
    screen = blank_screen()
    for line_row, text in lines:
        start = max(0, (32 - len(text)) // 2)
        blit_text(screen, line_row, start, text)
    f.write(f"{path_label}:\n")
    for i in range(0, 1024, 16):
        chunk = screen[i:i+16]
        f.write(".byte " + ", ".join(str(v) for v in chunk) + "\n")


def make_screens():
    with (BUILD / "screens.inc").open("w") as f:
        write_screen([(8, "DUNGEON"), (10, "QUEST"), (18, "PRESS START")], "title_screen_data", f)
        write_screen([(10, "YOU WIN"), (18, "PRESS START")], "win_screen_data", f)
        write_screen([(10, "GAME OVER"), (18, "PRESS START")], "game_over_screen_data", f)


def expand_room(grid):
    screen = [0] * 1024
    for row in range(14):
        for col in range(16):
            ch = grid[row][col]
            if ch == "#":
                tile = 2
                solid = 1
            elif ch == "D":
                tile = 3
                solid = 0
            else:
                tile = 1
                solid = 0
            nt_row = 2 + row * 2
            nt_col = col * 2
            idx = nt_row * 32 + nt_col
            screen[idx] = tile
            screen[idx + 1] = tile
            screen[idx + 32] = tile
            screen[idx + 33] = tile
    return screen


def collision_bytes(grid):
    vals = []
    for row in grid:
        for ch in row:
            vals.append(1 if ch == "#" else 0)
    return vals


def make_rooms():
    data = json.loads((ASSETS / "maps" / "rooms.json").read_text())
    rooms = data["rooms"]
    with (BUILD / "rooms.inc").open("w") as f:
        f.write("room_exit_masks:\n")
        f.write(".byte " + ", ".join(str(room["exit_mask"]) for room in rooms) + "\n")
        required_masks = []
        for room in rooms:
            mask = 0
            for idx, spawn in enumerate(room["spawns"]):
                if spawn["type"] != 0:
                    mask |= 1 << idx
            required_masks.append(mask)
        f.write("room_required_dead_masks:\n")
        f.write(".byte " + ", ".join(str(v) for v in required_masks) + "\n")
        f.write("room_screen_ptrs:\n")
        for idx in range(len(rooms)):
            f.write(f".word room_{idx}_screen\n")
        f.write("room_collision_ptrs:\n")
        for idx in range(len(rooms)):
            f.write(f".word room_{idx}_collision\n")
        f.write("room_spawn_ptrs:\n")
        for idx in range(len(rooms)):
            f.write(f".word room_{idx}_spawns\n")
        for idx, room in enumerate(rooms):
            screen = expand_room(room["grid"])
            f.write(f"room_{idx}_screen:\n")
            for i in range(0, 1024, 16):
                f.write(".byte " + ", ".join(str(v) for v in screen[i:i+16]) + "\n")
            coll = collision_bytes(room["grid"])
            f.write(f"room_{idx}_collision:\n")
            for i in range(0, 224, 16):
                f.write(".byte " + ", ".join(str(v) for v in coll[i:i+16]) + "\n")
            f.write(f"room_{idx}_spawns:\n")
            for spawn_idx in range(2):
                spawn = room["spawns"][spawn_idx]
                mask = 1 << spawn_idx
                f.write(f".byte {spawn['type']}, {spawn['x']}, {spawn['y']}, {spawn['param']}, {mask}\n")


def main():
    ensure_build()
    load_palettes()
    make_screens()
    make_rooms()
    make_chr()


if __name__ == "__main__":
    main()
