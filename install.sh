#!/bin/bash

BLOCK_ID="Bash Theme"

install_prompt() {
    local file="$HOME/.bashrc"

    touch "$file" 2>/dev/null || return
    grep -q "$BLOCK_ID" "$file" 2>/dev/null && return

cat >> "$file" <<'EOF'

# ===== Bash Theme =====

__cpu_usage() {
    read -r cpu user nice system idle iowait irq softirq steal _ < /proc/stat 2>/dev/null || {
        echo 0; return
    }

    total=$((user + nice + system + idle + iowait + irq + softirq + steal))

    if [ -z "$__cpu_total" ]; then
        __cpu_idle=$idle
        __cpu_total=$total
        echo 0
        return
    fi

    diff_idle=$((idle - __cpu_idle))
    diff_total=$((total - __cpu_total))

    __cpu_idle=$idle
    __cpu_total=$total

    [ "$diff_total" -le 0 ] && echo 0 && return
    echo $(( (100 * (diff_total - diff_idle)) / diff_total ))
}

__ram_usage() {
    awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2}
    END {if (t>0) print int((t-a)*100/t); else print 0}' /proc/meminfo 2>/dev/null || echo 0
}

__disk_usage() {
    df / 2>/dev/null | awk 'NR==2 {gsub(/%/,"",$5); print $5}' || echo 0
}

__prompt() {
    local st=$?

    # COLORS
    CYAN="\[\e[96m\]"        
    BLUE="\[\e[94m\]"        
    GREEN="\[\e[92m\]"       
    RED="\[\e[1;31m\]"       
    YELLOW="\[\e[1;33m\]"   
    RESET="\[\e[0m\]"

    # USER COLOR RULE
    if [ "$(id -u)" -eq 0 ]; then
        USER_COLOR="${RED}"       
        USERNAME="root"
    else
        USER_COLOR="${GREEN}"     
        USERNAME="\u"
    fi

    CPU=$(__cpu_usage)
    RAM=$(__ram_usage)
    DISK=$(__disk_usage)
    TM=$(date +%H:%M 2>/dev/null || echo "--:--")

    PIPE="${RED}|${RESET}"

    PS1="
${CYAN}╭─${RESET} ${USER_COLOR}${USERNAME}${RESET}@${CYAN}\h${RESET} ${PIPE} \
${BLUE}\w${RESET} ${PIPE} \
${YELLOW}${TM}${RESET} ${PIPE} \
${BLUE}CPU${RESET} ${GREEN}${CPU}%${RESET} ${PIPE} \
${BLUE}RAM${RESET} ${GREEN}${RAM}%${RESET} ${PIPE} \
${BLUE}DISK${RESET} ${GREEN}${DISK}%${RESET}
${CYAN}╰─${RESET} ${CYAN}➤${RESET} "
}

PROMPT_COMMAND=__prompt

# ===== End Bash Theme =====
EOF
}

install_prompt

source "$HOME/.bashrc" 2>/dev/null

echo "Bash Theme installed."
echo "Run: source ~/.bashrc"
