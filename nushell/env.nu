# env.nu
#
# Installed by:
# version = "0.102.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

$env.QT_QPA_PLATFORM = "wayland"
$env.QT_QPA_PLATFORMTHEME = "qt6ct"

$env.ANDROID_HOME = ($env.HOME | path join 'android-sdk')
$env.ANDROID_SDK_ROOT = $env.ANDROID_HOME

$env.PATH = ($env.PATH | append ($env.ANDROID_HOME | path join 'platform-tools'))
$env.PATH = ($env.PATH | append ($env.ANDROID_HOME | path join 'emulator'))
$env.PATH = ($env.PATH | append ($env.ANDROID_HOME | path join 'cmdline-tools' | path join 'latest' | path join 'bin'))

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



