#!/bin/bash

# ============================================================
# Anon's IP Switcher
# c0d3d By @non G00nz
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
RESET='\033[0m'

banner() {
    clear
    echo -e "${RED}"
    echo "  █████╗ ███╗   ██╗ ██████╗ ███╗   ██╗███████╗    ██╗██████╗      "
    echo " ██╔══██╗████╗  ██║██╔═══██╗████╗  ██║██╔════╝    ██║██╔══██╗     "
    echo " ███████║██╔██╗ ██║██║   ██║██╔██╗ ██║███████╗    ██║██████╔╝     "
    echo " ██╔══██║██║╚██╗██║██║   ██║██║╚██╗██║╚════██║    ██║██╔═══╝      "
    echo " ██║  ██║██║ ╚████║╚██████╔╝██║ ╚████║███████║    ██║██║          "
    echo " ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝    ╚═╝╚═╝          "
    echo -e "${CYAN}"
    echo "  ███████╗██╗    ██╗██╗████████╗ ██████╗██╗  ██╗███████╗██████╗   "
    echo "  ██╔════╝██║    ██║██║╚══██╔══╝██╔════╝██║  ██║██╔════╝██╔══██╗  "
    echo "  ███████╗██║ █╗ ██║██║   ██║   ██║     ███████║█████╗  ██████╔╝  "
    echo "  ╚════██║██║███╗██║██║   ██║   ██║     ██╔══██║██╔══╝  ██╔══██╗  "
    echo "  ███████║╚███╔███╔╝██║   ██║   ╚██████╗██║  ██║███████╗██║  ██║  "
    echo "  ╚══════╝ ╚══╝╚══╝ ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝  "
    echo -e "${YELLOW}"
    echo "          ╔══════════════════════════════════════════╗"
    echo "          ║        c0d3d By @non G00nz               ║"
    echo "          ╚══════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo -e "${MAGENTA}  [~] Tools: sol1citx | Anon4You | FDX100 | noobpk | techchipnet | Kalitorify${RESET}"
    echo -e "${MAGENTA}  [~] Net  : iproute2 | net-tools | nmcli${RESET}"
    echo -e "${WHITE}  ══════════════════════════════════════════════════════════${RESET}"
    echo ""
}

# ─── Dependency Check & Installer ───────────────────────────────────────────

TOOLS_DIR="$HOME/anons-ip-switcher-tools"

check_cmd() {
    command -v "$1" &>/dev/null
}

install_pkg() {
    local pkg="$1"
    echo -e "${YELLOW}[*] Installing $pkg...${RESET}"
    if check_cmd apt-get; then
        sudo apt-get install -y "$pkg" &>/dev/null
    elif check_cmd pacman; then
        sudo pacman -S --noconfirm "$pkg" &>/dev/null
    elif check_cmd dnf; then
        sudo dnf install -y "$pkg" &>/dev/null
    elif check_cmd yum; then
        sudo yum install -y "$pkg" &>/dev/null
    else
        echo -e "${RED}[!] Package manager not found. Install $pkg manually.${RESET}"
        return 1
    fi
}

clone_tool() {
    local name="$1"
    local url="$2"
    local dir="$TOOLS_DIR/$name"
    if [ -d "$dir" ]; then
        echo -e "${GREEN}[✓] $name already exists — skipping.${RESET}"
    else
        echo -e "${YELLOW}[*] Cloning $name...${RESET}"
        git clone "$url" "$dir" &>/dev/null && \
            echo -e "${GREEN}[✓] $name cloned successfully.${RESET}" || \
            echo -e "${RED}[!] Failed to clone $name.${RESET}"
    fi
}

download_all_tools() {
    banner
    echo -e "${CYAN}[*] Starting full toolkit installation...${RESET}"
    echo ""
    mkdir -p "$TOOLS_DIR"

    # System dependencies
    for pkg in tor git curl wget python3 python3-pip iproute2 net-tools network-manager; do
        if ! check_cmd "${pkg/network-manager/nmcli}" && ! check_cmd "$pkg"; then
            install_pkg "$pkg"
        else
            echo -e "${GREEN}[✓] $pkg already installed.${RESET}"
        fi
    done

    # pip deps for python-based tools
    echo -e "${YELLOW}[*] Installing Python deps...${RESET}"
    pip3 install requests stem 2>/dev/null

    # Clone all GitHub tools
    clone_tool "sol1citx-ip-changer"      "https://github.com/sol1citx/ip_changer"
    clone_tool "Anon4You-Ip-Changer"      "https://github.com/Anon4You/Ip-Changer"
    clone_tool "FDX100-Auto-Tor-IP"       "https://github.com/FDX100/Auto_Tor_IP_changer"
    clone_tool "noobpk-auto-change-tor"   "https://github.com/noobpk/auto-change-tor-ip"
    clone_tool "techchipnet-ip-changer"   "https://github.com/techchipnet/ip-changer"
    clone_tool "Kalitorify"               "https://github.com/brainfucksec/kalitorify"

    echo ""
    echo -e "${GREEN}[✓] All tools downloaded to: $TOOLS_DIR${RESET}"
    echo -e "${WHITE}  ══════════════════════════════════════════════════════════${RESET}"
    read -rp $'\n[Press ENTER to return to menu]'
}

# ─── System Net-Tool Functions ───────────────────────────────────────────────

show_current_ip() {
    banner
    echo -e "${CYAN}[~] Current IP Information${RESET}"
    echo -e "${WHITE}──────────────────────────────────${RESET}"
    echo -e "${YELLOW}[*] Public IP:${RESET}"
    curl -s https://api.ipify.org && echo ""
    echo ""
    echo -e "${YELLOW}[*] iproute2 (ip a):${RESET}"
    ip a 2>/dev/null || echo -e "${RED}[!] iproute2 not installed.${RESET}"
    echo ""
    echo -e "${YELLOW}[*] net-tools (ifconfig):${RESET}"
    ifconfig 2>/dev/null || echo -e "${RED}[!] net-tools not installed.${RESET}"
    echo ""
    echo -e "${YELLOW}[*] nmcli:${RESET}"
    nmcli device status 2>/dev/null || echo -e "${RED}[!] nmcli not installed.${RESET}"
    read -rp $'\n[Press ENTER to return to menu]'
}

flush_renew_ip_iproute2() {
    banner
    echo -e "${CYAN}[~] Flush & Renew IP via iproute2${RESET}"
    echo -e "${WHITE}──────────────────────────────────${RESET}"
    read -rp "Enter interface name (e.g. eth0, wlan0): " IFACE
    echo -e "${YELLOW}[*] Flushing IP on $IFACE...${RESET}"
    sudo ip addr flush dev "$IFACE" && echo -e "${GREEN}[✓] Flushed.${RESET}" || echo -e "${RED}[!] Failed.${RESET}"
    echo -e "${YELLOW}[*] Bringing interface down then up...${RESET}"
    sudo ip link set "$IFACE" down && sudo ip link set "$IFACE" up
    echo -e "${YELLOW}[*] Requesting new DHCP lease...${RESET}"
    sudo dhclient "$IFACE" 2>/dev/null || sudo dhcpcd "$IFACE" 2>/dev/null || echo -e "${RED}[!] DHCP client not found.${RESET}"
    echo -e "${GREEN}[✓] Done.${RESET}"
    read -rp $'\n[Press ENTER to return to menu]'
}

change_mac_address() {
    banner
    echo -e "${CYAN}[~] Change MAC Address via iproute2${RESET}"
    echo -e "${WHITE}──────────────────────────────────${RESET}"
    read -rp "Enter interface name (e.g. eth0, wlan0): " IFACE
    NEW_MAC=$(printf '%02x:%02x:%02x:%02x:%02x:%02x' \
        $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256)) \
        $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256)))
    echo -e "${YELLOW}[*] Setting MAC to $NEW_MAC on $IFACE...${RESET}"
    sudo ip link set dev "$IFACE" down
    sudo ip link set dev "$IFACE" address "$NEW_MAC" && echo -e "${GREEN}[✓] MAC changed to $NEW_MAC${RESET}" || echo -e "${RED}[!] Failed.${RESET}"
    sudo ip link set dev "$IFACE" up
    read -rp $'\n[Press ENTER to return to menu]'
}

nmcli_reconnect() {
    banner
    echo -e "${CYAN}[~] nmcli — Reconnect Interface${RESET}"
    echo -e "${WHITE}──────────────────────────────────${RESET}"
    nmcli device status
    echo ""
    read -rp "Enter connection/device name to reconnect: " CON
    sudo nmcli device disconnect "$CON" && sudo nmcli device connect "$CON" && \
        echo -e "${GREEN}[✓] Reconnected $CON${RESET}" || echo -e "${RED}[!] Failed.${RESET}"
    read -rp $'\n[Press ENTER to return to menu]'
}

# ─── GitHub Tool Launchers ───────────────────────────────────────────────────

launch_tool() {
    local name="$1"
    local dir="$TOOLS_DIR/$name"
    banner
    if [ ! -d "$dir" ]; then
        echo -e "${RED}[!] $name is not installed. Please run 'Download All Tools' first.${RESET}"
        read -rp $'\n[Press ENTER to return to menu]'
        return
    fi
    echo -e "${CYAN}[~] Launching $name...${RESET}"
    echo -e "${WHITE}──────────────────────────────────${RESET}"
    cd "$dir" || return

    case "$name" in
        "sol1citx-ip-changer")
            if [ -f "ip_changer.py" ]; then python3 ip_changer.py
            elif [ -f "main.py" ]; then python3 main.py
            else bash install.sh 2>/dev/null || echo -e "${RED}[!] No entry point found. Browse: $dir${RESET}"; fi ;;
        "Anon4You-Ip-Changer")
            if [ -f "ip-changer.py" ]; then python3 ip-changer.py
            elif [ -f "main.py" ]; then python3 main.py
            else bash install.sh 2>/dev/null || echo -e "${RED}[!] No entry point found. Browse: $dir${RESET}"; fi ;;
        "FDX100-Auto-Tor-IP")
            if [ -f "Auto_Tor_IP_changer.py" ]; then python3 Auto_Tor_IP_changer.py
            elif [ -f "main.py" ]; then python3 main.py
            else echo -e "${RED}[!] No entry point found. Browse: $dir${RESET}"; fi ;;
        "noobpk-auto-change-tor")
            if [ -f "autochangeip.py" ]; then python3 autochangeip.py
            elif [ -f "main.py" ]; then python3 main.py
            else echo -e "${RED}[!] No entry point found. Browse: $dir${RESET}"; fi ;;
        "techchipnet-ip-changer")
            if [ -f "ipchanger.sh" ]; then bash ipchanger.sh
            elif [ -f "ip-changer.sh" ]; then bash ip-changer.sh
            elif [ -f "main.py" ]; then python3 main.py
            else echo -e "${RED}[!] No entry point found. Browse: $dir${RESET}"; fi ;;
        "Kalitorify")
            if [ -f "kalitorify.sh" ]; then sudo bash kalitorify.sh --help
            else sudo bash install.sh 2>/dev/null || echo -e "${RED}[!] No entry point found. Browse: $dir${RESET}"; fi ;;
    esac
    cd "$OLDPWD" || true
    read -rp $'\n[Press ENTER to return to menu]'
}

# ─── Tor IP Changer (built-in) ───────────────────────────────────────────────

builtin_tor_changer() {
    banner
    echo -e "${CYAN}[~] Built-in Tor IP Auto-Changer${RESET}"
    echo -e "${WHITE}──────────────────────────────────${RESET}"

    if ! check_cmd tor; then
        echo -e "${RED}[!] Tor is not installed. Install it first via option 1.${RESET}"
        read -rp $'\n[Press ENTER to return to menu]'
        return
    fi

    echo -e "${YELLOW}[*] Starting Tor service...${RESET}"
    sudo service tor start 2>/dev/null || sudo systemctl start tor 2>/dev/null

    read -rp "How many times to rotate IP? (default 5): " ROTATIONS
    ROTATIONS=${ROTATIONS:-5}
    read -rp "Delay between rotations in seconds? (default 10): " DELAY
    DELAY=${DELAY:-10}

    echo ""
    for ((i=1; i<=ROTATIONS; i++)); do
        echo -e "${YELLOW}[*] Rotation $i/$ROTATIONS — sending NEWNYM signal...${RESET}"
        echo -e 'AUTHENTICATE ""\r\nSIGNAL NEWNYM\r\nQUIT' | nc 127.0.0.1 9051 2>/dev/null || \
        (echo "AUTHENTICATE" | nc 127.0.0.1 9051 2>/dev/null)
        sleep 2
        NEW_IP=$(curl --socks5 127.0.0.1:9050 -s https://api.ipify.org 2>/dev/null)
        echo -e "${GREEN}[✓] New Tor IP: ${WHITE}$NEW_IP${RESET}"
        [ "$i" -lt "$ROTATIONS" ] && sleep "$DELAY"
    done

    echo ""
    echo -e "${GREEN}[✓] IP rotation complete.${RESET}"
    read -rp $'\n[Press ENTER to return to menu]'
}

# ─── Main Menu ───────────────────────────────────────────────────────────────

main_menu() {
    while true; do
        banner
        echo -e "${WHITE}  [  TOOLKIT OPTIONS  ]${RESET}"
        echo ""
        echo -e "  ${GREEN}[01]${RESET} Download / Install All Tools"
        echo ""
        echo -e "  ${CYAN}─── GitHub IP Changer Tools ───────────────────${RESET}"
        echo -e "  ${GREEN}[02]${RESET} sol1citx  — ip_changer"
        echo -e "  ${GREEN}[03]${RESET} Anon4You  — Ip-Changer"
        echo -e "  ${GREEN}[04]${RESET} FDX100    — Auto_Tor_IP_changer"
        echo -e "  ${GREEN}[05]${RESET} noobpk    — auto-change-tor-ip"
        echo -e "  ${GREEN}[06]${RESET} techchipnet — ip-changer"
        echo -e "  ${GREEN}[07]${RESET} Kalitorify — Full Tor Routing"
        echo ""
        echo -e "  ${CYAN}─── Built-in Tools ────────────────────────────${RESET}"
        echo -e "  ${GREEN}[08]${RESET} Built-in Tor IP Auto-Rotator"
        echo -e "  ${GREEN}[09]${RESET} Show Current IP (iproute2 / ifconfig / nmcli)"
        echo -e "  ${GREEN}[10]${RESET} Flush & Renew IP — iproute2"
        echo -e "  ${GREEN}[11]${RESET} Change MAC Address — iproute2"
        echo -e "  ${GREEN}[12]${RESET} Reconnect Interface — nmcli"
        echo ""
        echo -e "  ${RED}[00]${RESET} Exit"
        echo ""
        echo -e "${WHITE}  ══════════════════════════════════════════════════════════${RESET}"
        read -rp $'\n  [Anon\'s IP Switcher] >> ' CHOICE

        case "$CHOICE" in
            01|1)  download_all_tools ;;
            02|2)  launch_tool "sol1citx-ip-changer" ;;
            03|3)  launch_tool "Anon4You-Ip-Changer" ;;
            04|4)  launch_tool "FDX100-Auto-Tor-IP" ;;
            05|5)  launch_tool "noobpk-auto-change-tor" ;;
            06|6)  launch_tool "techchipnet-ip-changer" ;;
            07|7)  launch_tool "Kalitorify" ;;
            08|8)  builtin_tor_changer ;;
            09|9)  show_current_ip ;;
            10)    flush_renew_ip_iproute2 ;;
            11)    change_mac_address ;;
            12)    nmcli_reconnect ;;
            00|0)
                echo -e "\n${RED}[~] Exiting Anon's IP Switcher... Stay Ghost.${RESET}\n"
                exit 0 ;;
            *)
                echo -e "${RED}[!] Invalid option.${RESET}"
                sleep 1 ;;
        esac
    done
}

# ─── Entry Point ─────────────────────────────────────────────────────────────

if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}[!] Some features require root. Consider running with sudo.${RESET}"
    sleep 1
fi

main_menu

