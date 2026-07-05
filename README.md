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

## WezTerm Config

The WezTerm config lives in `wezterm/.config/wezterm/wezterm.lua` and is stow'd to `~/.config/wezterm/` on Linux.

WezTerm runs as a Windows process, so it needs a minimal bootstrap on the Windows side that delegates to the Linux config via the WSL filesystem.

**Windows bootstrap** — create `C:\Users\<you>\.wezterm.lua` with:
```lua
return dofile('\\\\wsl.localhost\\Ubuntu-24.04\\home\\eric\\dev\\.dot-files\\wezterm\\.config\\wezterm\\wezterm.lua')
```

> Update the distro name (`Ubuntu-24.04`) and username (`eric`) if they differ on your machine.

**Prerequisites:**
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/) installed as a Windows font (WezTerm reads fonts from the Windows font system)

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
