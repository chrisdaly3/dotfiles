# dotfiles

My macOS dev environment, managed with [chezmoi](https://www.chezmoi.io/). One command takes a fresh Mac to a working setup: shell, prompt, terminal, editor, and daily-driver tools.

## Install on a new Mac

```sh
xcode-select --install
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply chrisdaly3
```

You'll be asked for:

- **Git name and email.** Asked once per machine and saved locally in `~/.config/chezmoi/chezmoi.toml`, so work and personal Macs can differ.
- **Projects folder**, relative to `~` (default `GITHome`). zellij's file picker opens here, and the install creates it.
- **Your password.** Once, for the Homebrew install.

Expect 10 to 20 minutes, mostly Homebrew downloads. When it finishes it prints a short list of manual steps (SSH key for GitHub, starting the Docker VM).

Assumes an Apple Silicon Mac (Homebrew in `/opt/homebrew`).

## What's included

| Area | Tools | Config |
|---|---|---|
| Terminal | [Ghostty](https://ghostty.org), Fira Code Nerd Font, Monaspace | `dot_config/ghostty/config` |
| Shell | zsh, oh-my-zsh (+ zsh-autosuggestions, fast-syntax-highlighting) | `dot_zshrc` |
| Prompt | starship | `dot_config/starship.toml` |
| Multiplexer | zellij (auto-attaches to a `main` session) | `dot_config/zellij/` |
| Editor | Helix, with language servers for Go, Markdown, YAML, TS/JS, HTML/CSS, Tailwind, Svelte, bash, Docker | `dot_config/helix/` |
| File manager | yazi (run `ya` to `cd` into the folder you exit on) | `dot_config/yazi/` |
| Git | gh, lazygit, delta, diffnav | `dot_gitconfig.tmpl` |
| Go | go, gopls, delve, mockery, gofumpt | |
| Containers | colima, docker, buildx, compose | |
| CLI utilities | ripgrep, fd, bat, fzf, tree, glow, coreutils, gnu-sed, gawk | |
| Mac apps | Rectangle (window snapping), f.lux (night colors) | |

The full package list is the [`Brewfile`](Brewfile).

## How the install works

`chezmoi init --apply` clones this repo, then runs the scripts in `.chezmoiscripts/` around copying the config files into `~`:

| Order | Script | What it does | Runs |
|---|---|---|---|
| 1 | `run_once_before_00-install-homebrew.sh` | Installs Homebrew and Apple's command line tools | Once per machine |
| 2 | `run_onchange_before_10-install-packages.sh.tmpl` | `brew bundle` on the Brewfile: formulae, apps, fonts, npm language servers, Go tools | Again whenever the Brewfile changes |
| 3 | `run_once_before_20-install-oh-my-zsh.sh` | Clones oh-my-zsh and its two plugins | Once per machine |
| 4 | *(config files)* | Copies everything under `dot_*` into `~` | Every apply |
| 5 | `run_once_after_99-next-steps.sh.tmpl` | Creates your projects folder, prints the manual steps | Once per machine |

Everything is safe to re-run: finished steps are skipped and nothing is uninstalled.

### Per-machine values

`.chezmoi.toml.tmpl` asks for git name, email and projects folder the first time. Files ending in `.tmpl` fill those in: `dot_gitconfig.tmpl` (name, email) and `dot_config/zellij/config.kdl.tmpl` (projects folder). To change an answer later, edit `~/.config/chezmoi/chezmoi.toml` and run `chezmoi apply`.

## Day to day

| Task | Command |
|---|---|
| Edit a config | `chezmoi edit ~/.zshrc`, then `chezmoi apply` |
| Preview changes before applying | `chezmoi diff` |
| Add a new tool | Add a line to `Brewfile` (`brew`, `cask`, `npm` or `go`), then `chezmoi apply` |
| Pull changes from another machine | `chezmoi update` |
| Save changes | `chezmoi cd`, then commit and push as usual |

## Notes

- **Shell startup is cached.** `dot_zshrc` caches the output of `brew shellenv` and `starship init` in `~/.cache/zsh-init/`. The cache rebuilds itself after a `brew upgrade`. If anything looks off, `rm -rf ~/.cache/zsh-init`.
- **GitHub over SSH.** `dot_gitconfig.tmpl` rewrites `https://github.com/` to SSH. Set up a key before pushing (the install prints how).
- **Not managed here:** macOS system settings, App Store apps, SSH keys, and anything work-specific.
