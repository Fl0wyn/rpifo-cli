#!/bin/bash

# Style
COLOR=$(echo -e "\e[0m\e[32m") # Green
BOLD=$(echo -e "\e[0m\e[1m")   # Bold
RESET=$(echo -e "\e[0m")       # Cancel

show_hote=$(hostname)
show_ip=$(ip a show eth0 | awk 'NR == 3 {print substr($2,1, length($2)-3)}')
show_os=$(echo "$(lsb_release -d | awk '{$1="";print}') - ($(cat /etc/debian_version))" | sed -e '1s/^.//')
show_kernel=$(uname -srm)
show_temp=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
show_uptime=$(uptime -p | sed 's/up //g;')
show_tasks=$(top -b -n 1 | awk '/Tasks/ {print $2}')
show_loadaverage=$(cat /proc/loadavg | awk '{print $1,$2,$3}' | tr '.' ',')

# SD card
exec_dfJ=$(df)
exec_dfH=$(df -h)
show_sd_totalJ=$(echo "$exec_dfJ" | awk '/root/ {print $2}')
show_sd_freeJ=$(echo "$exec_dfJ" | awk '/root/ {print $4}')
show_sd_usedJ=$(echo "$exec_dfJ" | awk '/root/ {print $3}')

show_sd_totalH=$(echo "$exec_dfH" | awk '/root/ {print $2}')
show_sd_freeH=$(echo "$exec_dfH" | awk '/root/ {print $4}')
show_sd_usedH=$(echo "$exec_dfH" | awk '/root/ {print $3}')
show_sd_used_percent=$(echo "$exec_dfH" | awk '/root/ {print $5}')

# Memory + Swap
exec_freeJ=$(free --kilo)
exec_freeH=$(free --kilo -h)

# Memory
show_mem_totalJ=$(echo "$exec_freeJ" | awk '/Mem:/ {print $2}')
show_mem_freeJ=$(echo "$exec_freeJ" | awk '/Mem/ {print $4}')
show_mem_usedJ=$(echo "$exec_freeJ" | awk '/Mem/ {print $3}')

show_mem_totalH=$(echo "$exec_freeH" | awk '/Mem:/ {print $2}')
show_mem_freeH=$(echo "$exec_freeH" | awk '/Mem/ {print $4}')
show_mem_usedH=$(echo "$exec_freeH" | awk '/Mem/ {print $3}')
show_mem_used_percent=$(printf '%.2f\n' $(free --kilo | awk '/Mem/ {print $3/$2 * 100.0}' | tr -s '.' ','))

# Swap
show_swap_totalJ=$(echo "$exec_freeJ" | awk '/Swap:/ {print $2}')
show_swap_freeJ=$(echo "$exec_freeJ" | awk '/Swap/ {print $4}')
show_swap_usedJ=$(echo "$exec_freeJ" | awk '/Swap/ {print $3}')

show_swap_totalH=$(echo "$exec_freeH" | awk '/Swap:/ {print $2}')
show_swap_freeH=$(echo "$exec_freeH" | awk '/Swap/ {print $4}')
show_swap_usedH=$(echo "$exec_freeH" | awk '/Swap/ {print $3}')
show_swap_used_percent=$(printf '%.2f\n' $(free --kilo | awk '/Swap/ {print $3/$2 * 100.0}' | tr -s '.' ','))

# SSH
show_ssh=$(cat /var/log/auth.log | egrep '(sshd.*Accepted)' | tail -1 | awk '{print $11,"("$2,$1,"at "$3")"}')

echo "
    ${BOLD}Hostname               ${COLOR}${show_hote}
    ${BOLD}IP address             ${COLOR}${show_ip}
    ${BOLD}Distribution           ${COLOR}${show_os}
    ${BOLD}Kernel version         ${COLOR}${show_kernel}
    - - - - -
    ${BOLD}Temperature            ${COLOR}${show_temp}°
    ${BOLD}Uptime                 ${COLOR}${show_uptime}
    ${BOLD}Current process        ${COLOR}${show_tasks}
    ${BOLD}CPU load               ${COLOR}${show_loadaverage}
    - - - - -
    ${BOLD}SD total               ${COLOR}${show_sd_totalH}
    ${BOLD}SD available           ${COLOR}${show_sd_freeH}
    ${BOLD}SD use                 ${COLOR}${show_sd_usedH} (${show_sd_used_percent})
    - - - - -
    ${BOLD}Memory total           ${COLOR}${show_mem_totalH}
    ${BOLD}Memory available       ${COLOR}${show_mem_freeH}
    ${BOLD}Memory use             ${COLOR}${show_mem_usedH} (${show_mem_used_percent}%)
    - - - - -
    ${BOLD}Swap total             ${COLOR}${show_swap_totalH}
    ${BOLD}Swap available         ${COLOR}${show_swap_freeH}
    ${BOLD}Swap use               ${COLOR}${show_swap_usedH} (${show_swap_used_percent}%)
    - - - - -
    ${BOLD}Last SSH login         ${COLOR}${show_ssh}
"
