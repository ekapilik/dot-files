# dot-files

## Neovim Config

### Keyboard Bindings
See `:map` within neovim to see all mapped keys and their function calls.
But, here is a highlight list:

|Mode|Keybinding|Action|
|-|-|-|
| **Git Commands** |||
|n  |`<Space>gC`  | Buffer git commits (Telescope)|
|n  |`<Space>gc`  | Git commits (Telescope)|
|n  |`<Space>gs`  | Git status (Telescope)|
|n  |`<Space>gb`  | Git branches (Telescope)|
|n  |`<Space>gf`  | Git files (Telescope)|
| **File navigation** |||
|n  |`<Space>lg`  | Live grep (Telescope)|
|n  |`<Space>ff`  | Find files (Telescope)|
|n  |`<Space>fb`  | File browser (Telescope)|
| **Code navigation (LSP)** |||
|n  |`gd`         | Go to definition (Telescope)|
|n  |`gr`         | Find references (Telescope)|
|n  |`gD`         | Go to declaration|
|n  |`K`          | Hover docs|
|n  |`<Space>rn`  | Rename symbol|
|n  |`<Space>ca`  | Code actions|
|n  |`<Space>e`   | Show diagnostic float|
|n  |`[d`         | Previous diagnostic|
|n  |`]d`         | Next diagnostic|
| **Formatting** |||
|n  |`Ctrl+f`     | Format file (Neoformat)|
| **LeetCode** |||
|n  |`:Leet`      | Open LeetCode dashboard|

## Zsh Prompt

The prompt is [Starship](https://starship.rs), configured at `starship/.config/starship.toml` and stow'd to `~/.config/starship.toml`. `zsh/.zshrc` initializes it with `eval "$(starship init zsh)"`. The `setup` script installs the `starship` binary if it's missing.

It's a powerline-style prompt (OS icon → directory → git branch/status → language versions → docker context → time), using glyphs from a [Nerd Font](https://www.nerdfonts.com/). This repo's WezTerm config points at **JetBrainsMono Nerd Font** (`wezterm.lua:21`), so install it as a Windows font (WezTerm reads fonts from the Windows font system, same as the plain JetBrains Mono font it replaces) — grab it from the [Nerd Fonts releases page](https://github.com/ryanoasis/nerd-fonts/releases) (`JetBrainsMono.zip`).

## WezTerm Config

The WezTerm config lives in `wezterm/.config/wezterm/wezterm.lua` and is stow'd to `~/.config/wezterm/` on Linux.

WezTerm runs as a Windows process, so it needs a minimal bootstrap on the Windows side that delegates to the Linux config via the WSL filesystem.

**Windows bootstrap** — create `C:\Users\<you>\.wezterm.lua` with:
```lua
return dofile('\\\\wsl.localhost\\Ubuntu-24.04\\home\\eric\\dev\\.dot-files\\wezterm\\.config\\wezterm\\wezterm.lua')
```

> Update the distro name (`Ubuntu-24.04`) and username (`eric`) if they differ on your machine.

**Prerequisites:**
- JetBrainsMono Nerd Font installed as a Windows font (WezTerm reads fonts from the Windows font system) — see [Zsh Prompt](#zsh-prompt) below

### Plugins

Loaded via WezTerm's built-in plugin manager (`wezterm.plugin.require`), which
clones and caches each repo on first launch — no extra install step needed.

- [Kanagawa](https://github.com/sravioli/kanagawa.wz) — theme, registers Wave/Dragon/Lotus variants. On stable (non-nightly) WezTerm builds, `wezterm.lua` strips the `input_selector_label_*`/`launcher_label_*` palette keys this plugin bakes in — they're nightly-only fields and otherwise spam "not a valid Palette field" errors on every launch.
- [Rosé Pine](https://github.com/neapsix/wezterm) — theme, registers Main/Moon/Dawn variants.
- Theme rotator — cycle WezTerm's built-in themes with `Super+Shift+N/P` (next/prev), `Super+Shift+R` (random), `Super+Shift+D` (back to default). Vendored inline in `wezterm.lua` rather than loaded from [wezterm-theme-rotator](https://github.com/koh-sh/wezterm-theme-rotator): upstream also hooks the status bar to show the current theme, which fights `wezterm-quota-limit` for the right status bar (both overwrite `set_right_status` on every refresh tick). The inlined version keeps only the keybindings + toast notifications, so quota owns the status bar outright.
- [Wezterm-Window-Tint](https://github.com/willytop8/Wezterm-Window-Tint) — tints the window/tab bar per project based on git root.
- [wezterm-quota-limit](https://github.com/EdenGibson/wezterm-quota-limit) — shows Claude Code API usage quota (5h/7d windows) in the right status bar. Reads credentials from the macOS Keychain or `~/.claude/.credentials.json`.

**Active by default:** `AtomOneLight`, a WezTerm built-in scheme (sourced from [iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes)). To switch the active theme by hand, set `config.color_scheme` in `wezterm.lua` to any of `Kanagawa Wave`, `Kanagawa Dragon`, `Kanagawa Lotus`, `Rose Pine`, `Rose Pine Moon`, `Rose Pine Dawn`, or any WezTerm built-in scheme.

> **Known limitation:** the theme rotator only cycles WezTerm's *built-in* schemes (`wezterm.color.get_builtin_schemes()`) — it never sees the Kanagawa/Rosé Pine schemes registered into `config.color_schemes` above, so they won't show up in rotation.

### Claude usage quota credentials on Windows

`wezterm-quota-limit` reads `%USERPROFILE%\.claude\.credentials.json` on Windows (WezTerm is a native Windows process, so `USERPROFILE` wins over `HOME`). But Claude Code itself runs in WSL and writes its OAuth token to `~/.claude/.credentials.json` on the Linux side — nothing exists at the Windows path by default, so the plugin reports "cannot load credentials."

Fix it the same way the Windows bootstrap file points at the Linux config: symlink the Windows-side path at the live WSL file, from an **elevated** PowerShell:

```powershell
New-Item -ItemType SymbolicLink -Path "C:\Users\<you>\.claude\.credentials.json" -Target "\\wsl.localhost\Ubuntu-24.04\home\<you>\.claude\.credentials.json"
```

The plugin re-reads the file on every poll, so it picks up token refreshes made by Claude Code in WSL automatically. Requires either an elevated prompt (one-time) or Developer Mode enabled (Settings > Privacy & Security > For Developers) to create the symlink without elevation.

To update all plugins, run `wezterm.plugin.update_all()` from WezTerm's debug overlay (`Ctrl+Shift+L`).

## DevPod
Use [DevPod](https://devpod.sh/docs/getting-started/install) to host devcontainers based on their `devcontainer.json`.

1. Install DevPod CLI
```bash
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod
```

2. Volume in this repository to your devcontainer by adding a volume to the `docker-compose.yml` for example.
```yaml
...
    volumes:
        - $HOME/dot-files:/path/to/dot-files
...
```

3. Add `docker` as a provider to DevPod and use it.
```bash
devpod provider add docker
devpod provider use docker
```

4. Build devpod workspace in the development repository.
```bash
devpod build --devcontainer-path ./.devcontainer/devcontainer.json
```

5. Start up the devpod instance.
```bash
devpod up ./ --ide none
```

6. SSH into the devpod instance.
```bash
ssh <WORKSPACE_NAME>.devpod
```

7. Run the `setup` script in the container.
```bash
cd /path/to/dot-files
./setup
```
