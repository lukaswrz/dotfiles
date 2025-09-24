$env.PATH = ($env.PATH | prepend ~/.local/bin)

if (which nix | is-not-empty) {
  $env.PATH = ($env.PATH | prepend (($env.XDG_STATE_HOME? | default ~/.local/state) | path join nix/profile/bin))
}

if (which rg | is-not-empty) {
  $env.RIPGREP_CONFIG_PATH = ($env.XDG_CONFIG_HOME? | default ~/.config) | path join ripgrep/ripgreprc
}

if (which hx | is-not-empty) {
  $env.EDITOR = "hx"
  $env.VISUAL = "hx"
}

$env.config = {
  show_banner: false,
  edit_mode: 'vi',
  rm: {
    always_trash: true,
  },
  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

      direnv export json | from json | default {} | load-env
      if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
        $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
      }
    }]
  }
}

if (which starship | is-not-empty) {
  mkdir ($nu.data-dir | path join "vendor/autoload")
  starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
}
