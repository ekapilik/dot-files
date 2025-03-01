# dot-files

## Neovim Config

### Keyboard Bindings
See `:map` within neovim to see all mapped keys and their function calls.
But, here is a highlight list:

|Mode|Keybinding|Command|
|-|-|-|
| **Git Commands** |||
|n  |`<Space>gC`  | * <Cmd>lua require("telescope.builtin").git_bcommits()<CR>|
|n  |`<Space>gc`  | * <Cmd>lua require("telescope.builtin").git_commits()<CR>|
|n  |`<Space>gs`  | * <Cmd>lua require("telescope.builtin").git_status()<CR>|
|n  |`<Space>gb`  | * <Cmd>lua require("telescope.builtin").git_branches()<CR>|
|n  |`<Space>gf`  | * <Cmd>lua require("telescope.builtin").git_files()<CR>|
| **File navigation** |||
|n  |`<Space>lg`  | * :Telescope live_grep<CR>|
|n  |`<Space>ff`  | * :Telescope find_files<CR>|
|n  |`<Space>fb`  | * :Telescope file_browser<CR>|
| **Code  navigation** |||
|n  |`gd`         | * <Cmd>lua require("telescope.builtin").lsp_definitions()<CR>|
|n  |`gr`         | * <Cmd>lua require("telescope.builtin").lsp_references()<CR>|

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
