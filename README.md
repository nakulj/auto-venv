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

## Development

I am happy to look at pull requests. This repo uses [fishtape](https://github.com/jorgebucaran/fishtape) tests, please add some to your pull request and ensure they pass.

```
fisher install jorgebucaran/fishtape
fishtape tests/*
```

1. If you are fixing a bug, please create a test that reproduces the bug and tests the fix.
2. If you are creating a new feature, test the feature.
3. Helpful refactors are also accepted, these don't need new tests.
