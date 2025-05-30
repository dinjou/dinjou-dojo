#!/usr/bin/env bash
#
# quickShim - create a system-wide shim to any executable
# Usage: qshim -n <name> -f <file>
#        qshim --name <name> --file <file>

set -euo pipefail

LINK_DIR="/usr/local/bin"

# --- argument parsing --------------------------------------------------------
name=""
file=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--name)  name="$2"; shift 2 ;;
        -f|--file)  file="$2"; shift 2 ;;
        -h|--help)  sed -n '3,9p' "$0"; exit 0 ;;
        *)          echo "[ERROR] Unknown option: $1" >&2; exit 1 ;;
    esac
done

[[ -z "$name" || -z "$file" ]] && {
    echo "[ERROR] both --name and --file are required." >&2
    exit 1
}

# --- sanity checks -----------------------------------------------------------
abs_path="$(realpath -e "$file")"       # fail if the file doesn't exist
[[ -x "$abs_path" ]] || {
    echo "[ERROR] '$abs_path' is not executable." >&2
    exit 1
}

link_path="$LINK_DIR/$name"
[[ -e "$link_path" || -L "$link_path" ]] && {
    echo "[ERROR] '$link_path' already exists. Remove it first." >&2
    exit 1
}

# --- create the shim ---------------------------------------------------------
sudo ln -s "$abs_path" "$link_path"
echo "[OK] Linked $link_path > $abs_path"

# (Optional) ensure the target is executable for all users
sudo chmod +x "$abs_path"
