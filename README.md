# dot-files

## Neovim Config

See `:map` within neovim to see mapped keys and their function calls.

## DevPod
Use [DevPod](https://devpod.sh/docs/getting-started/install) to host devcontainers based on their `devcontainer.json`.

1. Install DevPod CLI
```
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod
```

2. Volume in this repository to your devcontainer by adding a volume to the `docker-compose.yml` for example.
```
...
    volumes:
        - $HOME/dot-files:/path/to/dot-files
...
```

3. Add `docker` as a provider to DevPod and use it.
```
devpod provider add docker
devpod provider use docker
```

4. Build devpod workspace in the development repository.
```
devpod build --devcontainer-path ./.devcontainer/devcontainer.json
```

5. Start up the devpod instance.
```
devpod up ./ --ide none
```

6. SSH into the devpod instance.
```
ssh <WORKSPACE_NAME>.devpod
```

7. Run the `setup` script in the container.
```
cd /path/to/dot-files
./setup
```
