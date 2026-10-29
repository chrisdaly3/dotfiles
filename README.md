# dotfiles

macOS dev setup, managed with [chezmoi](https://www.chezmoi.io/). Assumes an Apple Silicon Mac (Homebrew in `/opt/homebrew`).

## Install on a new Mac

```sh
xcode-select --install   # git, needed before chezmoi can clone this repo
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply chrisdaly3
```

You'll be asked for:

- **Git name and email.** Saved per machine in `~/.config/chezmoi/chezmoi.toml`, so work and personal Macs can differ.
- **Projects folder**, relative to `~` (default `GITHome`). zellij's file picker opens here, and the install creates it.
- **Your password.** Once, for the Homebrew install.

### Manual installs

These aren't installed by the script.

| App | What for | Get it |
|---|---|---|
| [Ghostty](https://ghostty.org) | Terminal. Config is applied to `~/.config/ghostty/config` automatically. | [ghostty.org/download](https://ghostty.org/download), or `brew install --cask ghostty` |
| [Rectangle](https://rectangleapp.com) | Window snapping. On first launch, allow it in System Settings > Privacy & Security > Accessibility. | [rectangleapp.com](https://rectangleapp.com), or `brew install --cask rectangle` |

Also: add a GitHub SSH key. `dot_gitconfig.tmpl` rewrites `https://github.com/` to SSH, so pushes and `chezmoi update` need one.

## What the install does

`chezmoi init --apply` clones this repo, then runs the scripts in `.chezmoiscripts/` around copying configs into `~`:

| Order | Script | What it does | Runs |
|---|---|---|---|
| 1 | `run_once_before_00-install-homebrew.sh` | Installs Homebrew | Once per machine |
| 2 | `run_onchange_before_10-install-packages.sh.tmpl` | `brew bundle` on the [`Brewfile`](Brewfile) | Again whenever the Brewfile changes |
| 3 | `run_once_before_20-install-oh-my-zsh.sh` | Clones oh-my-zsh + zsh-autosuggestions + fast-syntax-highlighting | Once per machine |
| 4 | *(config files)* | Copies everything under `dot_*` into `~` | Every apply |
| 5 | `run_once_after_99-next-steps.sh.tmpl` | Creates your projects folder, prints the manual steps | Once per machine |

Safe to re-run: finished steps are skipped and nothing is uninstalled.

### Per-machine values

`.chezmoi.toml.tmpl` asks for `name`, `email` and `projectsDir` on first init. They're used in `dot_gitconfig.tmpl` and `dot_config/zellij/config.kdl.tmpl`. To change one later, edit `~/.config/chezmoi/chezmoi.toml` and run `chezmoi apply`.

## Day to day

| Task | Command |
|---|---|
| Edit a config | `chezmoi edit ~/.zshrc`, then `chezmoi apply` |
| Preview changes | `chezmoi diff` |
| Add a tool | Add a line to `Brewfile`, then `chezmoi apply` |
| Pull changes from another machine | `chezmoi update` |
