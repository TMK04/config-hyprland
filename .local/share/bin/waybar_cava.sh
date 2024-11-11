#!/bin/env bash
#----- Optimized bars animation without much CPU usage increase --------
#----- Optimized bars animation without much CPU usage increase pt2 --------

# Default values
scrDir="$(dirname "$(realpath "$0")")"
# shellcheck disable=SC1091
source "${scrDir}/globalcontrol.sh"

usage() {
    cat <<HELP
Usage: $(basename "$0") [OPTIONS]
Options:
  --bar <waybar_cava_bar>  Specify the characters to use for the bar animation (default: ▁▂▃▄▅▆▇█).
  --width <waybar_cava_width>   Specify the width of the bar.
  --range <waybar_cava_range>   Specify the range of the bar.
  --help                        Display this help message and exit.
  --restart                     Restart the waybar_cava.
  --stb <waybar_cava_stbmode>  Specify the standby mode for waybar cava (default: 0).
                                0: clean  - totally hides the module
                                1: blank  - makes module expand as spaces
                                2: full   - occupies the module with full bar
                                3: low    - makes the module display the lowest set bar
                                *: string - displays a string
HELP
    exit 1
}

# Parse command line arguments using getopt
if ! ARGS=$(getopt -o "hr" -l "help,bar:,width:,range:,restart,stb:" -n "$0" -- "$@"); then
    usage
fi

eval set -- "$ARGS"
while true; do
    case "$1" in
    --help | -h)
        usage
        ;;
    --bar)
        waybar_cava_bar="$2"
        shift 2
        ;;
    --width)
        waybar_cava_width="$2"
        shift 2
        ;;
    --range)
        waybar_cava_range="$2"
        shift 2
        ;;
    --restart) # restart by killing all waybar_cava
        pkill -f "cava -p /tmp/bar_cava_config"
        exit 0
        ;;
    --stb)
        waybar_cava_stbmode="$2"
        shift 2
        ;;
    --)
        shift
        break
        ;;
    *)
        usage
        ;;
    esac
done

bar="${waybar_cava_bar:-▁▂▃▄▅▆▇█}"

# // waybar_cava_stbmode - standby mode for waybar cava - default 0
# 0: clean - totally hides the module
# 1: blank - makes module expand as spaces
# 2: full - occupies the module with full bar
# 3: low - makes the module display the lowest set bar
# <string>: - displays a string
case ${waybar_cava_stbmode:-3} in
0)
    stbBar=''
    ;; # Clean
1)
    stbBar="‎ "
    ;; # Invisible char
2)
    stbBar="${bar: -1}"
    ;; # Full bar
3)
    stbBar="${bar:0:1}"
    ;; # Lowest bar
esac

# Calculate the length of the bar outside the loop
bar_length=${#bar}
bar_bars=$((bar_length * 2))
bar_width=${waybar_cava_width:-1}
bar_range=${waybar_cava_range:-$((bar_length - 1))}

# Create dictionary to replace char with bar
stbAscii=$(printf '0%.0s' $(seq 1 "${bar_width}")) # predicts the amount of ancii characters to be used
[ -n "${asciiBar}" ] || asciiBar="${stbAscii//0/${stbBar}}"

dict="s/;//g;s/${stbAscii}/${asciiBar}/g"
i=0
while [ $i -lt "${bar_length}" ] || [ $i -lt "${bar_width}" ]; do
    if [ $i -lt "${bar_length}" ]; then
        dict="$dict;s/$i/${bar:$i:1}/g"
    fi
    ((i++))
done

# Create cava config
config_file="/tmp/bar_cava_config"
cat >"$config_file" <<EOF
[general]
framerate = 30
bars = ${bar_bars}
bar_width = ${bar_width}
lower_cutoff_freq = 160
higher_cutoff_freq = 16000
sleep_timer = 1

[input]
method = pulse
source = auto
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = ${bar_range}
[smoothing]
noise_reduction = 12
EOF

# Call the function
cava -p "$config_file" | sed -u "${dict}" &
disown # saves a tiny bit of memory
