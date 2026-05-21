#!/bin/bash
BLOCK_ID="Bash Theme"

install_prompt() {
    local file="$HOME/.bashrc"
    touch "$file" 2>/dev/null || return

    # BUG 1 FIX: only remove if BOTH markers exist — prevents sed eating
    # everything after the start marker if the end marker is ever missing
    if grep -q "# ===== Bash Theme =====" "$file" 2>/dev/null && \
       grep -q "# ===== End Bash Theme =====" "$file" 2>/dev/null; then
        sed -i "/# ===== Bash Theme =====/,/# ===== End Bash Theme =====/d" "$file"
    fi

cat >> "$file" <<'EOF'
# ===== Bash Theme =====

# Writes result to __cpu_result — no subshell so state persists between calls
__cpu_usage() {
    local _user _nice _system _idle _iowait _irq _softirq _steal
    read -r _ _user _nice _system _idle _iowait _irq _softirq _steal _ \
        < /proc/stat 2>/dev/null || { __cpu_result=0; return; }

    local _total _diff_idle _diff_total
    _total=$(( _user + _nice + _system + _idle + _iowait + _irq + _softirq + _steal ))

    if [ -z "$__cpu_total" ]; then
        __cpu_idle=$_idle
        __cpu_total=$_total
        __cpu_result=0
        return
    fi

    _diff_idle=$(( _idle - __cpu_idle ))
    _diff_total=$(( _total - __cpu_total ))
    __cpu_idle=$_idle
    __cpu_total=$_total

    if [ "$_diff_total" -le 0 ]; then
        __cpu_result=0
    else
        __cpu_result=$(( (100 * (_diff_total - _diff_idle)) / _diff_total ))
        [ "$__cpu_result" -lt 0   ] && __cpu_result=0
        [ "$__cpu_result" -gt 100 ] && __cpu_result=100
    fi
}

__ram_usage() {
    awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}
    END{if(t>0)print int((t-a)*100/t);else print 0}' \
    /proc/meminfo 2>/dev/null || echo 0
}

__disk_usage() {
    # BUG 2 FIX: (+0) coerces empty/missing $5 to 0 instead of printing
    # an empty string that breaks integer comparisons in __prompt
    df / 2>/dev/null | awk 'NR==2{gsub(/%/,"",$5); print ($5+0)}' || echo 0
}

__prompt() {
    local CYAN GREEN RED RESET PINK BBLUE BYELLOW
    RESET="\[\e[0m\]"
    PINK="\[\e[1;95m\]"     # bright magenta — frame
    BBLUE="\[\e[1;94m\]"    # bright blue    — working dir
    CYAN="\[\e[1;96m\]"     # bright cyan    — hostname, metric labels
    GREEN="\[\e[1;92m\]"    # bright green   — user
    RED="\[\e[1;91m\]"      # bright red     — root
    BYELLOW="\[\e[1;93m\]"  # bright yellow  — @

    local USER_COLOR USERNAME PROMPT_CHAR
    if [ "$(id -u)" -eq 0 ]; then
        USER_COLOR="${RED}"
        USERNAME="root"
        PROMPT_CHAR="${RED}#❯${RESET}"
    else
        USER_COLOR="${GREEN}"
        USERNAME="\u"
        # single-quoted \$ keeps backslash-dollar literal in the variable so
        # PS1's own parser sees \$ (→ $) instead of bash expanding $❯ as $❯
        # where $< nothing > would be empty and corrupt the prompt
        PROMPT_CHAR="${GREEN}"'\$❯'"${RESET}"
    fi

    __cpu_usage
    local CPU RAM DISK
    CPU=$__cpu_result
    RAM=$(__ram_usage)
    DISK=$(__disk_usage)

    local CPU_COLOR RAM_COLOR DISK_COLOR
    if   [ "$CPU"  -ge 80 ]; then CPU_COLOR="\[\e[1;91m\]"
    elif [ "$CPU"  -ge 50 ]; then CPU_COLOR="\[\e[1;93m\]"
    else                          CPU_COLOR="\[\e[1;92m\]"; fi

    if   [ "$RAM"  -ge 80 ]; then RAM_COLOR="\[\e[1;91m\]"
    elif [ "$RAM"  -ge 50 ]; then RAM_COLOR="\[\e[1;93m\]"
    else                          RAM_COLOR="\[\e[1;92m\]"; fi

    if   [ "$DISK" -ge 90 ]; then DISK_COLOR="\[\e[1;91m\]"
    elif [ "$DISK" -ge 70 ]; then DISK_COLOR="\[\e[1;93m\]"
    else                          DISK_COLOR="\[\e[1;92m\]"; fi

    local PIPE="${RED}|${RESET}"  
    PS1="\n${PINK}╭─${RESET}${USER_COLOR}${USERNAME}${RESET}${BYELLOW}@${RESET}${CYAN}\h${RESET}\
${PINK}[${RESET}${BBLUE}\w${RESET}${PINK}]${RESET} ${PIPE} \
${CYAN}CPU:${RESET} ${CPU_COLOR}${CPU}%${RESET} ${PIPE} \
${CYAN}RAM:${RESET} ${RAM_COLOR}${RAM}%${RESET} ${PIPE} \
${CYAN}DISK:${RESET} ${DISK_COLOR}${DISK}%${RESET}
${PINK}╰─${RESET}${PROMPT_CHAR} "
}

PROMPT_COMMAND=__prompt
# ===== End Bash Theme =====
EOF
}

install_prompt
echo "Bash Theme installed. Run: source ~/.bashrc"
