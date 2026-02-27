#!/usr/bin/env bash
set -euo pipefail

# ===== Config =====
STEP="${BRIGHTNESS_STEP:-10}"   # passo em %
# ICON="${BRIGHTNESS_ICON:-display-brightness-symbolic}"  # pode ser caminho absoluto de um .svg/.png
ICON="/usr/share/icons/Papirus-Dark/64x64/status/brightness-high.svg"
APPNAME="OSD"
# APPNAME="${BRIGHTNESS_APPNAME:-Brightness}"             # nome mostrado no notif
NID_FILE="/tmp/.brightness_dunst_id"                    # p/ dunstify -r

# Fixar monitor? export DDC_DISPLAY=1 ou DDC_BUS=5
DDC_ARGS=()
[[ -n "${DDC_DISPLAY:-}" ]] && DDC_ARGS+=(--display "$DDC_DISPLAY")
[[ -n "${DDC_BUS:-}"     ]] && DDC_ARGS+=(--bus "$DDC_BUS")

have() { command -v "$1" >/dev/null 2>&1; }

read_cur_max() {
  local line cur max
  line="$(ddcutil "${DDC_ARGS[@]}" --terse getvcp 10 2>/dev/null | head -n1 | tr -s ' ')"
  [[ -z "$line" ]] && return 1
  cur="$(awk '{print $(NF-1)}' <<<"$line")"
  max="$(awk '{print $NF}' <<<"$line")"
  echo "$cur" "$max"
}

set_vcp() {
  ddcutil "${DDC_ARGS[@]}" setvcp 10 "$1" >/dev/null
}
get_icon_path() {
  local base_alt="$HOME/.local/share/icons/brightness_alt"
  local base="$HOME/.local/share/icons/brightness"

  # checa alt primeiro
  case "$1" in
    off)   [[ -f "$base_alt/off.svg" ]] && echo "$base_alt/off.svg" && return ;;
    low)   [[ -f "$base_alt/low.svg" ]] && echo "$base_alt/low.svg" && return ;;
    med)   [[ -f "$base_alt/mid.svg" ]] && echo "$base_alt/mid.svg" && return ;;
    high)  [[ -f "$base_alt/high.svg" ]] && echo "$base_alt/high.svg" && return ;;
    full)  [[ -f "$base_alt/full.svg" ]] && echo "$base_alt/full.svg" && return ;;
  esac

  # fallback para base Papirus
  echo "$base/$1.svg"
}
# Notificação estilo "Volume : 55%" com ícone
notify_compact() {
  local percent="$1"
  local title="Brilho"
  local body="Brilho : ${percent}%"
  local base="$HOME/.local/share/icons/brightness"
  local icon_key="med"

  if   (( percent <= 0 ));   then icon_key="off"
  elif (( percent < 25 ));   then icon_key="low"
  elif (( percent < 50 ));   then icon_key="med"
  elif (( percent < 85 ));   then icon_key="high"
  elif (( percent <=100));    then icon_key="full"
  fi
  local icon_path
  icon_path="$(get_icon_path "$icon_key")"

  if command -v dunstify >/dev/null; then
    local nid="0"
    if [[ -f "$NID_FILE" ]]; then
      nid="$(cat "$NID_FILE" 2>/dev/null)"
      [[ -z "$nid" || ! "$nid" =~ ^[0-9]+$ ]] && nid="0"
    fi

    nid="$(dunstify -p -r "$nid" -i "$icon_path" -a "$APPNAME" "$title" "$body" 2>/dev/null || echo 0)"
    [[ "$nid" =~ ^[0-9]+$ ]] && echo -n "$nid" > "$NID_FILE" 2>/dev/null || rm -f "$NID_FILE" 2>/dev/null

  else
    notify-send -a "$APPNAME" -i "$icon_path" \
      -h string:x-canonical-private-synchronous:brightness \
      -h string:x-dunst-stack-tag:brightness \
      -c device \
      "$title" "$body"
  fi
}


clamp() {
  local v="$1" lo="$2" hi="$3"
  (( v < lo )) && v="$lo"
  (( v > hi )) && v="$hi"
  echo "$v"
}

help() {
  cat <<EOF
Uso: brightness.sh up | down | set <0-100> | get
Variáveis: BRIGHTNESS_STEP, BRIGHTNESS_ICON, DDC_DISPLAY, DDC_BUS, BRIGHTNESS_APPNAME
EOF
}

main() {
  [[ $# -lt 1 ]] && { help; exit 1; }

  local cur max new pct
  if ! read -r cur max < <(read_cur_max); then
    echo "Falha ao ler VCP 10 via ddcutil" >&2
    exit 2
  fi

  case "$1" in
    up)
      new=$(( cur + STEP ))
      new="$(clamp "$new" 0 "$max")"
      set_vcp "$new"
      pct=$(( new * 100 / max ))
      notify_compact "$pct"
      ;;
    down)
      new=$(( cur - STEP ))
      new="$(clamp "$new" 0 "$max")"
      set_vcp "$new"
      pct=$(( new * 100 / max ))
      notify_compact "$pct"
      ;;
    set)
      [[ $# -ge 2 ]] || { echo "Faltou valor para set" >&2; exit 1; }
      local want; want="$(clamp "$2" 0 100)"
      new=$(( want * max / 100 ))
      set_vcp "$new"
      notify_compact "$want"
      ;;
    get)
      pct=$(( cur * 100 / max ))
      echo "$pct"
      ;;
    *)
      help; exit 1;;
  esac
}

main "$@"

