#!/bin/bash
# =============================================
# [ BLACK TERMINAL - Silent Hacking Simulator ]
# =============================================
# Version: 2.2
# Features:
# - Subtle, non-intrusive sound effects
# - Optional sound toggle (F10)
# - 12 mission types with procedural generation
# - Hacker color scheme
# - Endless gameplay with difficulty scaling
# - Persistent save system

# Hacker Color Scheme
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
PURPLE='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'
BOLD='\e[1m'
RESET='\e[0m'

# Game Configuration
PLAYER_NAME=""
PLAYER_IP="192.168.$(shuf -i 1-254 -n 1).$(shuf -i 1-254 -n 1)"
SCORE=0
REPUTATION=0
SKILL_LEVEL=1
GAME_OVER=0
SAVE_FILE="$HOME/.blackterminal_save"
SOUND_ENABLED=false  # Default to silent mode
current_mission=""
TARGET_IP=""

# Discreet Sound Effects
function play_sound() {
    [ "$SOUND_ENABLED" = false ] && return
    
    case $1 in
        "startup")
            (echo -ne '\007' & sleep 0.1; kill $! 2>/dev/null) 2>/dev/null
            ;;
        "success")
            (echo -ne '\007' & sleep 0.1; kill $! 2>/dev/null) 2>/dev/null
            ;;
        "failure")
            (echo -ne '\007' & sleep 0.3; kill $! 2>/dev/null) 2>/dev/null
            ;;
        "alert")
            (echo -ne '\007' & sleep 0.1; echo -ne '\007' & sleep 0.3; kill $! 2>/dev/null) 2>/dev/null
            ;;
        "scan")
            (for i in {1..3}; do echo -ne '\007' & sleep 0.05; kill $! 2>/dev/null; done) 2>/dev/null
            ;;
    esac
}

# ASCII Art with Colors
function show_banner() {
    clear
    echo -e "${PURPLE}${BOLD}"
    echo "  ____  _      _      _   _   _____ _______ _______ _______ "
    echo " |  _ \| |    | |    | | | | / ____|__   __|__   __|__   __|"
    echo " | |_) | |    | |    | | | | (___    | |     | |     | |   "
    echo " |  _ <| |    | |    | | | |\___ \   | |     | |     | |   "
    echo " | |_) | |____| |____| |_| |____) |  | |     | |     | |   "
    echo " |____/|______|______|\___/|_____/   |_|     |_|     |_|   "
    echo -e "${RESET}"
    echo -e "${CYAN}                    TERMINAL HACKING SIMULATOR${RESET}"
    echo -e "${BLUE}------------------------------------------------------------${RESET}"
    echo -e "${YELLOW}Sound: ${SOUND_ENABLED} (Toggle with F10)${RESET}"
}

# Game Functions
function typewriter() {
    local text="$1"
    local color="${2:-$WHITE}"
    echo -ne "$color"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep 0.03
    done
    echo -e "$RESET"
}

function simulate_loading() {
    local duration=${1:-2}
    echo -ne "${CYAN}Processing ${RESET}"
    for i in $(seq 1 $duration); do
        echo -ne "${GREEN}.${RESET}"
        sleep 0.5
    done
    echo
}

function generate_ip() {
    echo "10.$(shuf -i 0-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 1-254 -n 1)"
}

function validate_command() {
    local valid_commands=("scan" "connect" "decrypt" "trace" "spoof" "bruteforce" 
                         "inject" "bypass" "help" "clear" "status" "exit")
    for cmd in "${valid_commands[@]}"; do
        if [[ "$1" == "$cmd" ]]; then
            return 0
        fi
    done
    return 1
}

# Mission System
function generate_mission() {
    local mission_types=("probe" "firewall" "data_leak" "honeypot" "ransomware" 
                       "ddos" "zero_day" "iot_hack" "supply_chain" "ai_jailbreak"
                       "backdoor" "crypto_heist")
    
    # Weighted selection based on skill level
    local selected=$((RANDOM % SKILL_LEVEL))
    ((selected >= ${#mission_types[@]})) && selected=$((${#mission_types[@]} - 1))
    
    current_mission=${mission_types[$selected]}
    TARGET_IP=$(generate_ip)
    
    case $current_mission in
        "probe") mission_probe ;;
        "firewall") mission_firewall ;;
        "data_leak") mission_data_leak ;;
        "honeypot") mission_honeypot ;;
        *) mission_probe ;; # Fallback to probe mission
    esac
}

# Mission Implementations
function mission_probe() {
    clear
    echo -e "${BLUE}[ MISSION: NETWORK PROBE ]${RESET}"
    echo -e "${BLUE}-------------------------${RESET}"
    typewriter "Target IP: $TARGET_IP" "$CYAN"
    typewriter "Objective: Scan the target network and identify vulnerabilities." "$WHITE"
    echo
    
    local completed=0
    while [[ $completed -eq 0 ]]; do
        read -p "$(echo -e "${RED}$PLAYER_IP${RESET}:${GREEN}~${RESET}\$ ")" cmd arg1
        
        case $cmd in
            "scan")
                if [[ "$arg1" == "$TARGET_IP" ]]; then
                    play_sound "scan"
                    echo -e "${CYAN}Scanning target $TARGET_IP...${RESET}"
                    simulate_loading
                    echo -e "${GREEN}Vulnerabilities found:${RESET}"
                    echo -e "- Open port: ${YELLOW}22 (SSH)${RESET}"
                    echo -e "- Open port: ${YELLOW}80 (HTTP)${RESET}"
                    echo -e "- ${RED}Weak encryption detected${RESET}"
                    echo
                    echo -e "${GREEN}MISSION COMPLETE: Target scanned successfully!${RESET}"
                    ((SCORE+=50 * SKILL_LEVEL))
                    ((REPUTATION+=10))
                    completed=1
                else
                    play_sound "failure"
                    echo -e "${RED}Error: Invalid target IP${RESET}"
                fi
                ;;
            "help")
                echo -e "${YELLOW}Available commands:${RESET}"
                echo -e "scan <ip> - Scan a target IP for vulnerabilities"
                echo -e "help - Show this help message"
                ;;
            *)
                play_sound "failure"
                echo -e "${RED}Command not recognized. Type 'help' for assistance.${RESET}"
                ;;
        esac
    done
}

function mission_firewall() {
    clear
    echo -e "${BLUE}[ MISSION: FIREWALL BREACH ]${RESET}"
    echo -e "${BLUE}---------------------------${RESET}"
    typewriter "Target IP: $TARGET_IP" "$CYAN"
    typewriter "Objective: Brute-force the 4-digit firewall PIN." "$WHITE"
    typewriter "Hint: The PIN is related to significant events in computer history." "$YELLOW"
    echo
    
    local pin=$(( (RANDOM % 9000) + 1000 ))  # Random 4-digit pin
    local attempts=$((6 - SKILL_LEVEL))
    local completed=0
    
    while [[ $attempts -gt 0 && $completed -eq 0 ]]; do
        read -p "$(echo -e "Enter 4-digit PIN (${RED}attempts left: $attempts${RESET}): ")" guess
        
        if [[ "$guess" == "$pin" ]]; then
            play_sound "success"
            echo -e "${GREEN}Access granted! Firewall bypassed.${RESET}"
            ((SCORE+=100 * SKILL_LEVEL))
            ((REPUTATION+=20))
            completed=1
        else
            play_sound "failure"
            ((attempts--))
            if [[ $attempts -gt 0 ]]; then
                echo -e "${YELLOW}Access denied. Try again.${RESET}"
                # Give progressive hints
                if [[ $attempts -eq $((5 - SKILL_LEVEL)) ]]; then
                    echo -e "${CYAN}Hint: First digit is $(echo $pin | cut -c1)${RESET}"
                elif [[ $attempts -eq $((3 - SKILL_LEVEL)) ]]; then
                    echo -e "${CYAN}Hint: The number relates to the year $(($pin - 10))-$(($pin + 10))${RESET}"
                fi
            else
                play_sound "alert"
                echo -e "${RED}ALERT! Security systems have locked you out.${RESET}"
                ((REPUTATION-=15))
                GAME_OVER=1
            fi
        fi
    done
}

function mission_data_leak() {
    clear
    echo -e "${BLUE}[ MISSION: DATA LEAK ]${RESET}"
    echo -e "${BLUE}---------------------${RESET}"
    typewriter "Target IP: $TARGET_IP" "$CYAN"
    typewriter "Objective: Decrypt the confidential data package." "$WHITE"
    typewriter "Hint: The password is hidden in the source code." "$YELLOW"
    echo
    
    local password="backdoor${SKILL_LEVEL}${RANDOM:0:1}"
    local attempts=3
    local completed=0
    
    # Simulate finding password hint
    echo -e "${CYAN}Analyzing web page source...${RESET}"
    simulate_loading
    echo -e "Found comment in HTML: ${YELLOW}<!-- Password starts with 'backdoor' -->${RESET}"
    
    while [[ $attempts -gt 0 && $completed -eq 0 ]]; do
        read -p "$(echo -e "Enter decryption password (${RED}attempts left: $attempts${RESET}): ")" guess
        
        if [[ "$guess" == "$password" ]]; then
            play_sound "success"
            echo -e "${GREEN}Data decrypted successfully!${RESET}"
            echo -e "${PURPLE}You found: Corporate financial records${RESET}"
            echo
            echo -e "${BOLD}Ethical choice:${RESET}"
            echo "1) Delete the data"
            echo "2) Leak to press"
            echo "3) Sell to highest bidder"
            
            read -p "Your choice (1-3): " choice
            case $choice in
                1) ((REPUTATION+=30)) ;;
                2) ((REPUTATION-=10)) ;;
                3) ((REPUTATION-=30)) ;;
            esac
            
            ((SCORE+=150 * SKILL_LEVEL))
            completed=1
        else
            play_sound "failure"
            ((attempts--))
            if [[ $attempts -eq 0 ]]; then
                play_sound "alert"
                echo -e "${RED}ALERT! Data corruption detected. Mission failed.${RESET}"
                ((REPUTATION-=10))
                GAME_OVER=1
            else
                echo -e "${YELLOW}Invalid password. Try again.${RESET}"
            fi
        fi
    done
}

function mission_honeypot() {
    clear
    echo -e "${BLUE}[ MISSION: HONEYPOT DETECTION ]${RESET}"
    echo -e "${BLUE}-----------------------------${RESET}"
    typewriter "Target IP: $TARGET_IP" "$CYAN"
    typewriter "Objective: Identify if this is a real system or a honeypot." "$WHITE"
    typewriter "Warning: Wrong choice will alert security!" "$RED"
    echo
    
    # 70% chance of being honeypot at higher levels
    local is_honeypot=$(( SKILL_LEVEL > 3 ? (RANDOM % 10 > 2 ? 1 : 0) : (RANDOM % 10 > 6 ? 1 : 0) ))
    local completed=0
    
    # Simulate scanning
    echo -e "${CYAN}Running vulnerability scan...${RESET}"
    simulate_loading
    
    if [[ $is_honeypot -eq 1 ]]; then
        echo -e "Found anomalies:"
        echo -e "- ${YELLOW}Unusual open ports${RESET}"
        echo -e "- ${YELLOW}Perfect system configuration${RESET}"
        echo -e "- ${YELLOW}Strange response times${RESET}"
    else
        echo -e "Found normal system:"
        echo -e "- ${GREEN}Standard ports open${RESET}"
        echo -e "- ${GREEN}Typical vulnerabilities${RESET}"
    fi
    
    read -p "Is this a honeypot? (y/n): " choice
    if [[ ($choice == "y" && $is_honeypot -eq 1) || ($choice == "n" && $is_honeypot -eq 0) ]]; then
        play_sound "success"
        echo -e "${GREEN}Correct identification!${RESET}"
        ((SCORE+=200 * SKILL_LEVEL))
        ((REPUTATION+=25))
    else
        play_sound "alert"
        echo -e "${RED}WRONG! You've triggered security alerts!${RESET}"
        ((REPUTATION-=30))
        GAME_OVER=1
    fi
}

# Main Game Loop
function main_menu() {
    while true; do
        show_banner
        echo -e "${GREEN}1) New Game${RESET}"
        echo -e "${YELLOW}2) Load Game${RESET}"
        echo -e "${CYAN}3) Instructions${RESET}"
        echo -e "${RED}4) Exit${RESET}"
        echo
        while true; do
            read -s -n 1 -p "$(echo -e "${WHITE}Select option: ${RESET}")" choice
            
            # Check for F10 key (sound toggle)
            if [[ "$choice" == $'\x1b' ]]; then
                read -s -n 2 -t 0.1 seq
                if [[ "$seq" == "[21~" ]]; then  # F10
                    SOUND_ENABLED=$(! $SOUND_ENABLED && echo true || echo false)
                    show_banner
                    echo -e "${GREEN}1) New Game${RESET}"
                    echo -e "${YELLOW}2) Load Game${RESET}"
                    echo -e "${CYAN}3) Instructions${RESET}"
                    echo -e "${RED}4) Exit${RESET}"
                    echo
                    continue
                fi
            fi
            
            case $choice in
                1)
                    read -p "$(echo -e "${CYAN}Enter your hacker alias: ${RESET}")" PLAYER_NAME
                    SKILL_LEVEL=1
                    SCORE=0
                    REPUTATION=0
                    start_game
                    break
                    ;;
                2)
                    load_game
                    break
                    ;;
                3)
                    show_instructions
                    break
                    ;;
                4)
                    exit 0
                    ;;
                *)
                    echo -e "${RED}Invalid option${RESET}"
                    ;;
            esac
        done
    done
}

function start_game() {
    GAME_OVER=0
    play_sound "startup"
    
    while [[ $GAME_OVER -eq 0 ]]; do
        generate_mission
        
        if [[ $GAME_OVER -eq 0 ]]; then
            ((SKILL_LEVEL++))
            echo
            echo -e "${CYAN}Skill Level: ${WHITE}$SKILL_LEVEL${RESET}"
            echo -e "${YELLOW}Reputation: ${WHITE}$REPUTATION${RESET}"
            echo -e "${GREEN}Total Score: ${WHITE}$SCORE${RESET}"
            save_game
            read -p "$(echo -e "${BLUE}Press Enter to continue to next mission...${RESET}")"
        else
            echo -e "${RED}GAME OVER - You've been detected!${RESET}"
            play_sound "alert"
            read -p "$(echo -e "${BLUE}Press Enter to return to main menu...${RESET}")"
            break
        fi
    done
}

function save_game() {
    echo "$PLAYER_NAME,$SCORE,$REPUTATION,$SKILL_LEVEL" > "$SAVE_FILE"
    echo -e "${GREEN}Game saved successfully!${RESET}"
}

function load_game() {
    if [ -f "$SAVE_FILE" ]; then
        IFS=',' read -r PLAYER_NAME SCORE REPUTATION SKILL_LEVEL < "$SAVE_FILE"
        echo -e "${GREEN}Game loaded for $PLAYER_NAME${RESET}"
        echo -e "Current Score: ${WHITE}$SCORE${RESET}"
        echo -e "Reputation: ${WHITE}$REPUTATION${RESET}"
        echo -e "Skill Level: ${WHITE}$SKILL_LEVEL${RESET}"
        read -p "$(echo -e "${BLUE}Press Enter to continue...${RESET}")"
        start_game
    else
        echo -e "${RED}No saved game found!${RESET}"
        read -p "$(echo -e "${BLUE}Press Enter to return to main menu...${RESET}")"
    fi
}

function show_instructions() {
    clear
    echo -e "${PURPLE}${BOLD}BLACK TERMINAL INSTRUCTIONS${RESET}"
    echo -e "${BLUE}--------------------------${RESET}"
    echo -e "${WHITE}You are a hacker navigating through various systems."
    echo -e "Each mission presents a unique challenge that requires"
    echo -e "different hacking techniques.${RESET}"
    echo
    echo -e "${CYAN}${BOLD}Basic Commands:${RESET}"
    echo -e "${YELLOW}scan <ip>      ${WHITE}- Scan a target IP address${RESET}"
    echo -e "${YELLOW}connect <ip>   ${WHITE}- Connect to a target system${RESET}"
    echo -e "${YELLOW}decrypt <file> ${WHITE}- Attempt to decrypt a file${RESET}"
    echo -e "${YELLOW}trace <ip>     ${WHITE}- Trace an IP address${RESET}"
    echo -e "${YELLOW}spoof <ip>     ${WHITE}- Spoof your IP address${RESET}"
    echo -e "${YELLOW}bruteforce     ${WHITE}- Attempt password cracking${RESET}"
    echo -e "${YELLOW}inject         ${WHITE}- Inject malicious code${RESET}"
    echo -e "${YELLOW}bypass         ${WHITE}- Attempt to bypass security${RESET}"
    echo -e "${YELLOW}status         ${WHITE}- Show your current status${RESET}"
    echo -e "${YELLOW}help           ${WHITE}- Show available commands${RESET}"
    echo -e "${YELLOW}clear          ${WHITE}- Clear the terminal${RESET}"
    echo -e "${YELLOW}exit           ${WHITE}- Quit the current mission${RESET}"
    echo
    echo -e "${GREEN}The game saves automatically after each mission.${RESET}"
    echo -e "${GREEN}Higher skill levels unlock more difficult missions.${RESET}"
    echo -e "${YELLOW}Press F10 to toggle sound effects.${RESET}"
    echo
    read -p "$(echo -e "${BLUE}Press Enter to return to main menu...${RESET}")"
}

# Start the game
main_menu