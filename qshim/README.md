# quickShim (qshim.sh)
*v0.2 - adds basic interpreter detection*

Create a **system‑wide command alias** in one line.

`qshim.sh` is a tiny Bash helper that symlinks any executable to `/usr/local/bin/<name>`, letting you invoke it like a built‑in command.

 

## Features

* **Fast:** one command (`qshim -n NAME -f FILE`) and you’re done.
* **Safe:** refuses to overwrite existing names and checks that the target is executable.
* **Portable:** pure Bash + coreutils (`realpath`, `ln`, `chmod`).
* **Zero config:** no YAML, no JSON. *It just works™*.

 

## Requirements

| OS                 | Tested on | Notes                                                             |
| ------------------ | --------- | ----------------------------------------------------------------- |
| Linux (any distro) | ✔         | Requires `bash`, `realpath`, `sudo`                               |
| ~~macOS~~          |           | `coreutils` recommended for `realpath` (`brew install coreutils`) |

 

## Installation

> [!WARNING]
> This installation method creates a new folder `~/ubin` because that's a personal preference of mine to have a local "user bin" folder for things I'm prototyping. Since I don't have a proper build pipeline and deployment for this, I'm just doing what works for me until I decide I want one someady. 
> Moral of the story: If you don't like it, *don't copy-paste to your shell or pipe to `sh`.*

```bash
curl -o ~/ubin/qshim https://raw.githubusercontent.com/dinjou/dinjou-dojo/main/bash/qshim
chmod +x ~/ubin/qshim
echo 'export PATH="$HOME/ubin:$PATH"' >> ~/.bashrc   # if not already set
source ~/.bashrc
sh ~/ubin/qshim.sh -n qshim -f ~/ubin/qshim.sh
```

 

## Usage

```bash
qshim -n <command-name> -f <path/to/executable>
```

> [!NOTE]
> If the target isn’t already executable, qshim v0.2 auto-wraps Python, Bash, Ruby, or Node scripts. Otherwise add a proper she-bang and `chmod +x` your script file.

Examples:

```bash
# Make pivot.py available as the command “pivot”
qshim -n pivot -f ~/Documents/1-Projects/pivot/pivot.py
*fun fact, this didn't work in the previous version but was here in the readme because I'm not very bright.*

# Shim a Node script
qshim --name todo --file ./scripts/todo-cli.js
```

Output:

```
[OK]  Linked /usr/local/bin/pivot > /home/spencer/Documents/1-Projects/pivot/pivot.py
```

 

## Removing a shim

```bash
sudo rm /usr/local/bin/<command-name>
```

 

## License

MIT © 2025 Spencer Lay

