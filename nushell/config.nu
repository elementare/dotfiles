# config.nu
#
# Installed by:
# version = "0.102.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

#  ╔═╗╔═╗╦ ╦╦═╗╔═╗  ╔═╗╔═╗╔╗╔╔═╗╦╔═╗   - z0mbi3
#  ╔═╝╚═╗╠═╣╠╦╝║    ║  ║ ║║║║╠╣ ║║ ╦   - https://github.com/gh0stzk/dotfiles
#  ╚═╝╚═╝╩ ╩╩╚═╚═╝  ╚═╝╚═╝╝╚╝╚  ╩╚═╝   - My zsh conf

# 🌍 Environment Variables
$env.EDITOR = "lvim"
$env.VISUAL = $env.EDITOR
$env.TERMINAL = "wezterm"
$env.BROWSER = "waterfox"
$env.HISTORY_IGNORE = "(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
$env.GTK_THEME = "Adwaita-dark"
$env.KVFinder_PATH = "/home/elementare/GithubBinaries/parKVFinder"
$env.Flutter_PATH = "/home/elementare/FlutterSDK/flutter/bin/"
$env.YAYBUILDDIR = "/mnt/F/yay"
$env.config.show_banner = false

let sys = ["/usr/local/sbin", "/usr/local/bin", "/usr/bin", "/bin", "/usr/sbin", "/sbin"]
let cur = ($env.PATH | split row (char esep))
let clean = ($cur | where {|p| $p != "" } | uniq)

# Reconstrói o PATH com prioridade do sistema
$env.PATH = ($sys | append $clean | uniq)

# 📂 PATH Configuration
# $env.PATH = ($env.PATH | split row (char esep) | prepend [
#     "/home/elementare/.local/bin",
#     "/home/elementare/tdf/target/release",
#     "/home/elementare/.config/nushell/modules"
# ])

$env.PATH = ([
    "/home/elementare/.local/bin",
    "/home/elementare/.cargo/bin",
    "/home/elementare/.npm-global/bin",
    "/home/elementare/FlutterSDK/flutter/bin/",
    "/home/elementare/.pub-cache/bin",
    "/home/elementare/tdf/target/release",
    "/home/elementare/.config/nushell/modules",
    "/opt/android-sdk/emulator",
    "/opt/android-sdk/cmdline-tools/latest/bin",
    "/opt/android-sdk/platform-tools"
] | append $env.PATH | uniq)


# 🏠 Load custom VPN hosts if available
let vpn_hosts = ($env.HOME | path join ".vpn_hosts")

if ($vpn_hosts | path exists) and ($vpn_hosts | path type) == "file" {
    let file_content = open $vpn_hosts | lines
    let env_vars = {}

    for line in $file_content {
        # Match lines with `export VAR=value` format
        if ($line | str starts-with "export ") {
            let parts = ($line | str replace -r '^export\s+' '' | split row '=')
            if ($parts | length) == 2 {
                let var_name = $parts.0 | str trim
                let var_value = $parts.1 | str trim

                # Add to the environment dictionary
                let env_vars = ($env_vars | upsert $var_name $var_value)
            }
        }
    }

    # Apply all extracted environment variables
    load-env $env_vars
}

# 🚀 Load GHCup (Haskell toolchain) if available
if ("/home/elementare/.ghcup/env-nu" | path exists) {
    source "/home/elementare/.ghcup/env-nu"
}

# Ensure# 🖼️ Run Colorscript
/home/elementare/.local/bin/colorscript -e kaisen

# 🎨 Aliases (Converted from Zsh)
# 🎨 Aliases (Converted from Zsh, now properly formatted)
def mirrors [] {
    sudo reflector --verbose --latest 5 --country 'United States' --age 6 --sort rate --save /etc/pacman.d/mirrorlist
}

def grub-update [] {
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

def mantenimiento [] {
    yay -Sc
    sudo pacman -Scc
}

def purga [] {
    sudo pacman -Rns (pacman -Qtdq)
    sudo fstrim -av
}

def update [] {
    paru -Syu --nocombinedupgrade
}

def vm-on [] {
    sudo systemctl start libvirtd.service
}

def vm-off [] {
    sudo systemctl stop libvirtd.service
}

def musica [] {
    ncmpcpp
}

# def lsd [] {
#     lsd -a --group-directories-first
# }

def ll [] {
    lsd -la --group-directories-first
}

def cnpem [] {
    ip addr show fctvpn9f514f5d
}

# 🚀 Zellij Shortcut
def zj [] {
    zellij attach -c
}
# 🔗 Git Prompt (Converted from `vcs_info`)
# def prompt [] {
#     let branch = (git branch --show-current | complete | str trim)
#     if ($branch | is-empty) { "" } else { $"(ansi magenta)\ue725(ansi yellow)($branch)(ansi reset) " }
# }

# Define a function to display the correct directory icon
def dir_icon [] {
    if ($env.PWD == $env.HOME) {
        $"(ansi black)(ansi reset)"
    } else {
        $"(ansi cyan)(ansi reset)"
    }
}
def display_path [] {
    if ($env.PWD == $env.HOME) {
        $"(ansi red)~(ansi reset)"  # Retorna string vazia se estiver no home
    } else {
        $"(ansi red)($env.PWD)(ansi reset)"
    }
}
# Função para exibir a branch do Git apenas se estiver num repositório
def git_branch [] {
    let is_git_repo = (git rev-parse --is-inside-work-tree | complete | str trim | default "false")

    if ($is_git_repo == "true") {
        let branch = (git branch --show-current | str trim | default "")
        if ($branch | is-empty) { "" } else { $"(ansi magenta)($'(char e725)')(ansi yellow)($branch)(ansi reset)" }
    } else {
        ""
    }
}

# Função para exibir status do último comando
def exit_status [] {
    if ($env.LAST_EXIT_CODE == 0) {
        $"(ansi green)(ansi reset)"
    } else {
        $"(ansi red)(ansi reset)"
    }
}

# Definição do Prompt
def prompt [] {
    $"(ansi blue)(ansi reset) (ansi magenta)($env.USER)(ansi reset) (dir_icon) (display_path)(git_branch) (exit_status) "
}
let cargo_env = ($env.HOME | path join ".cargo/env")
if ($cargo_env | path exists) {
    open $cargo_env | lines | each {|line|
        if ($line | str starts-with "export PATH=") {
            let path_value = ($line | str replace -r 'export PATH="(.+):\$PATH"' '$1')
            $env.PATH = ($env.PATH | prepend $path_value)
        }
    }
}

# Define the Nushell Prompt

$env.PATH = ([
    ($env.HOME | path join ".luarocks" "bin"),          # ~/.luarocks/bin
    ($env.HOME | path join ".luaver" "lua" "5.1.5" "bin")  # ajuste a versão se precisar
] | append $env.PATH | uniq)
$env.PATH = ($env.PATH | append $"($env.HOME)/.npm-global/bin")
$env.PATH = ($env.PATH | append $env.Flutter_PATH)
$env.PATH = ($env.PATH | append $"($env.HOME)/.pub-cache/bin")
$env.PATH = ($env.PATH | append "/home/elementare/anaconda3/condabin")

$env.LUA_PATH = $"($env.HOME)/.luarocks/share/lua/5.1/?.lua"
$env.LUA_CPATH = $"($env.HOME)/.luarocks/lib/lua/5.1/?.so"

$env.PROMPT_COMMAND = {|| prompt}
$env.PROMPT_INDICATOR = ""
use ~/.config/nushell/modules/conda.nu

def emu [...args] {
  with-env {
    QT_QPA_PLATFORM: "xcb"
    GDK_BACKEND: "x11"
    SDL_VIDEODRIVER: "x11"
    QT_XCB_GL_INTEGRATION: "none"
  } {
    ^/opt/android-sdk/emulator/emulator ...$args
  }
}

# wrapper específico pro teu AVD
def emu-pixel [...args] {
  with-env {
    QT_QPA_PLATFORM: "xcb"
    GDK_BACKEND: "x11"
    SDL_VIDEODRIVER: "x11"
    QT_XCB_GL_INTEGRATION: "none"
  } {
    ^/opt/android-sdk/emulator/emulator -avd lektosPixel -netdelay none -netspeed full -gpu host ...$args
  }
}
