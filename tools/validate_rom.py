#!/usr/bin/env python3
import sys
from pathlib import Path


def main():
    rom = Path(sys.argv[1])
    data = rom.read_bytes()
    if data[:4] != b"NES\x1a":
        raise SystemExit("invalid iNES magic")
    if data[4] != 2:
        raise SystemExit("expected 2 PRG banks")
    if data[5] != 1:
        raise SystemExit("expected 1 CHR bank")
    print(f"validated {rom} ({len(data)} bytes)")


if __name__ == "__main__":
    main()
