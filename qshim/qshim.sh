#!/usr/bin/env bash
# quickShim v0.2 – now with interpreter detection
# Usage: qshim -n <name> -f <file>

set -euo pipefail
LINK_DIR="/usr/local/bin"

usage() { echo "Usage: $0 -n <name> -f <file>"; exit 1; }

# --- parse ------------------------------------------------------------------
name="" ; file=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--name) name=$2; shift 2 ;;
    -f|--file) file=$2; shift 2 ;;
    -h|--help) usage ;;
    *) echo "[ERROR] Unknown option $1"; usage ;;
  esac
done
[[ -z $name || -z $file ]] && usage

abs_path=$(realpath -e "$file")               # fail if missing
link_path="$LINK_DIR/$name"

[[ -e $link_path || -L $link_path ]] && {
  echo "[ERROR] $link_path already exists" >&2; exit 1; }

# --- decide if we need a wrapper -------------------------------------------
if [[ -x $abs_path ]]; then
  # target already runnable – simple symlink
  sudo ln -s "$abs_path" "$link_path"
else
  # not executable: infer interpreter by extension
  ext=${abs_path##*.}
  case "$ext" in
    py)  interp="/usr/bin/env python3" ;;
    sh)  interp="/usr/bin/env bash"    ;;
    rb)  interp="/usr/bin/env ruby"    ;;
    js)  interp="/usr/bin/env node"    ;;
    *)   echo "[ERROR] Can't infer interpreter for *.$ext – make the file executable" >&2; exit 1 ;;
  esac

  # create a tiny wrapper
  tmp=$(mktemp)
  printf '#!/usr/bin/env bash\n%s "%s" "$@"\n' "$interp" "$abs_path" > "$tmp"
  chmod +x "$tmp"
  sudo mv "$tmp" "$link_path"
fi

echo "[OK] $name ready – just run '$name' anywhere."

