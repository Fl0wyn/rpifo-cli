#!/bin/bash

##############################################################
## Script : Afficher et extraitre les informations d'un RPI ##
##############################################################

# Style
COLOR=$(echo -e "\e[0m\e[32m") # Vert
BOLD=$(echo -e "\e[0m\e[1m")   # Gras
RESET=$(echo -e "\e[0m")       # Annuler

# Nom d'hôte
# Adresse IP
# Distribution
# Version kernel
show_hote=$(hostname)
show_ip=$(ip a show eth0 | awk 'NR == 3 {print substr($2,1, length($2)-3)}')
show_os=$(echo "$(lsb_release -d | awk '{$1="";print}') - ($(cat /etc/debian_version))" | sed -e '1s/^.//')
show_kernel=$(uname -sor)

# Température
# Temps d'utilisation
# Processus en cours
# Charge CPU
show_temp=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
show_uptime=$(uptime -p | sed 's/up //g; s/hours/Heures/g; s/days/Jours/g; s/weeks/Semaines/g; s/month/Mois/g')
show_tasks=$(top -b -n 1 | awk '/Tasks/ {print $2}')
show_loadaverage=$(cat /proc/loadavg | awk '{print $1,$2,$3}' | tr '.' ',')

# Disque SD
exec_dfJ=$(df)
exec_dfH=$(df -h)
show_sd_totalJ=$(echo "$exec_dfJ" | awk '/root/ {print $2}')
show_sd_freeJ=$(echo "$exec_dfJ" | awk '/root/ {print $4}')
show_sd_usedJ=$(echo "$exec_dfJ" | awk '/root/ {print $3}')

show_sd_totalH=$(echo "$exec_dfH" | awk '/root/ {print $2}')
show_sd_freeH=$(echo "$exec_dfH" | awk '/root/ {print $4}')
show_sd_usedH=$(echo "$exec_dfH" | awk '/root/ {print $3}')
show_sd_used_percent=$(echo "$exec_dfH" | awk '/root/ {print $5}')

# Mémoire + Swap
exec_freeJ=$(free --kilo)
exec_freeH=$(free --kilo -h)

# Mémoire
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
show_ssh=$(cat /var/log/auth.log | egrep '(sshd.*Accepted)' | tail -1 | awk '{print $11,"(Le "$2,$1,"à "$3")"}')

echo "
    ${BOLD}Nom d'hôte             ${COLOR}${show_hote}
    ${BOLD}Adresse IP             ${COLOR}${show_ip}
    ${BOLD}Distribution           ${COLOR}${show_os}
    ${BOLD}Version du Kernel      ${COLOR}${show_kernel}
    - - - - -
    ${BOLD}Température            ${COLOR}${show_temp}°
    ${BOLD}Temps d'utilisation    ${COLOR}${show_uptime}
    ${BOLD}Processus en cours     ${COLOR}${show_tasks}
    ${BOLD}Charge CPU             ${COLOR}${show_loadaverage}
    - - - - -
    ${BOLD}Taille Total           ${COLOR}${show_sd_totalH}
    ${BOLD}Taille Disponible      ${COLOR}${show_sd_freeH}
    ${BOLD}Taille Utilisée        ${COLOR}${show_sd_usedH} (${show_sd_used_percent})
    - - - - -
    ${BOLD}Mémoire Total          ${COLOR}${show_mem_totalH}
    ${BOLD}Mémoire Disponible     ${COLOR}${show_mem_freeH}
    ${BOLD}Mémoire Utilisée       ${COLOR}${show_mem_usedH} (${show_mem_used_percent}%)
    - - - - -
    ${BOLD}Swap Total             ${COLOR}${show_swap_totalH}
    ${BOLD}Swap Disponible        ${COLOR}${show_swap_freeH}
    ${BOLD}Swap Utilisée          ${COLOR}${show_swap_usedH} (${show_swap_used_percent}%)
    - - - - -
    ${BOLD}Dernière connexion SSH ${COLOR}${show_ssh}
"
