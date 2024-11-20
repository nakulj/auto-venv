# auto-venv
Automatically activate virtual environments in fish. Based on gists by [bastibe](https://gist.github.com/bastibe/c0950e463ffdfdfada7adf149ae77c6f) and [tommyip](https://gist.github.com/tommyip/cf9099fa6053e30247e5d0318de2fb9e).

## Features

- Automatically activates Python virtual environments when entering a directory containing a venv
- Automatically deactivates virtual environments when leaving the directory
- Safely handles virtual environment inheritance in new shell sessions
- Prevents shell exits during activation/deactivation
- Works with common virtual environment directory names: `env`, `.env`, `venv`, `.venv`
- Supports git repositories by detecting the repository root

## Installation

### Using [`fisher`](https://github.com/jorgebucaran/fisher) (Recommended):
Run
```sh
fisher install nohzafk/auto-venv
```

### Manual install

Copy `conf.d/venv.fish` into your `conf.d` directory (usually `~/.config/fish/conf.d`)

## How it works

The plugin uses fish shell events and directory monitoring to:

1. Detect when you change directories and automatically activate/deactivate virtual environments
2. Handle virtual environment inheritance in new shell sessions safely
3. Implement safe activation/deactivation that won't cause the shell to exit

### Virtual Environment Detection

The plugin looks for virtual environments in the following directories:
- `env/`
- `.env/`
- `venv/`
- `.venv/`

If you're in a git repository, it will look for these directories at the repository root.
