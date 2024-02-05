# auto-venv
Automatically activate virtual environments in fish. Based on gists by [bastibe](https://gist.github.com/bastibe/c0950e463ffdfdfada7adf149ae77c6f) and [tommyip](https://gist.github.com/tommyip/cf9099fa6053e30247e5d0318de2fb9e).

## Installation

### Using [`fisher`](https://github.com/jorgebucaran/fisher) (Recommended):
Run
```sh
fisher install nakulj/auto-venv
```

### Manual install

Copy `conf.d/venv.fish` into your `conf.d` directory (usually `~/.config/fish/conf.d`)

## Working logic

The function is called after each directory change. It searches for a directory called `env` `.env` `venv` or `.venv` in the current working directory, or root directory of the git repo if the current directory is in a git repo. If the virtual environment is not yet activated, the fish-specific activation command for this virtual environment is sourced.
