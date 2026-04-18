# Niri Tab Labels

A [Noctalia](https://noctalia.dev) plugin that draws per-column text labels — `[1/2] Alacritty`, `[2/2] Firefox`, etc. — for niri's tabbed-column-display mode (`Mod+W`).
Niri's native `tab-indicator` only renders a coloured pixel strip; this plugin adds the text.

## Status

Under development.
Once stable it'll (probably) be submitted to the [Noctalia plugin registry](https://github.com/noctalia-dev/noctalia-plugins) so it can be enabled from *Settings → Plugins* in the shell.

## Development (or usage in the meantime)

Symlink your checkout into Noctalia's plugin folder; edits hot-reload on save.

```sh
ln -s "$PWD" ~/.config/noctalia/plugins/niri-tab-labels
```

If the shell gets stuck, restart it:

```sh
pkill -f 'qs -c noctalia-shell' && setsid qs -c noctalia-shell &
```
