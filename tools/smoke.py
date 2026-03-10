#!/usr/bin/env python3
import sys
from pathlib import Path


def main():
    rom = Path(sys.argv[1])
    if not rom.exists():
        raise SystemExit(f"missing ROM: {rom}")
    print(f"ROM ready for emulator smoke test: {rom}")


if __name__ == "__main__":
    main()
