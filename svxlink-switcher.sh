#!/bin/bash

# SVXLink Modus-Umschalter
# by OE1SXM / Sebastian M.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

clear
echo ""
echo -e "${CYAN}${BOLD}"
cat << 'BANNER'
  _____   ____  __   __  __         _        ___        _ _      _            
 / __\ \ / /\ \/ /  |  \/  |___  __| |___   / __|_ __ _(_) |_ __| |_  ___ _ _ 
 \__ \\ V /  >  <   | |\/| / _ \/ _` / -_)  \__ \ V  V / |  _/ _| ' \/ -_) '_|
 |___/ \_/  /_/\_\  |_|  |_\___/\__,_\___|  |___/\_/\_/|_|\__\__|_||_\___|_|  
BANNER
echo -e "${NC}"
echo -e "${CYAN}                    by OE1SXM / Sebastian M.${NC}"
echo ""
echo -e "  ${GREEN}1${NC}) Simplex Betrieb"
echo -e "  ${GREEN}2${NC}) Duplex Betrieb"
echo ""
read -p "$(echo -e "Auswahl (${GREEN}1${NC} oder ${GREEN}2${NC}): ")" choice

case $choice in
    1)
        echo ""
        echo -e "${RED}>>> Wechsle zu Simplex Betrieb...${NC}"
        echo ""

        echo -e "${YELLOW}  [1/3] Starte SA818 Simplex Script...${NC}"
        sudo python3 /opt/sa818-running.py
        if [ $? -ne 0 ]; then
            echo -e "${RED}  FEHLER: SA818 Script fehlgeschlagen!${NC}"
            exit 1
        fi
        echo ""

        echo -e "${YELLOW}  [2/3] Kopiere SVXLink Simplex Config...${NC}"
        sudo cp /etc/svxlink/svxlink.conf.simplex /etc/svxlink/svxlink.conf
        if [ $? -ne 0 ]; then
            echo -e "${RED}  FEHLER: Config konnte nicht kopiert werden!${NC}"
            exit 1
        fi
        echo ""

        echo -e "${YELLOW}  [3/3] Starte SVXLink neu...${NC}"
        sudo systemctl restart svxlink
        if [ $? -ne 0 ]; then
            echo -e "${RED}  FEHLER: SVXLink Neustart fehlgeschlagen!${NC}"
            exit 1
        fi
        echo ""

        echo -e "${GREEN}✔ Simplex Betrieb aktiv!${NC}"
        ;;

    2)
        echo ""
        echo -e "${RED}>>> Wechsle zu Duplex Betrieb...${NC}"
        echo ""

        echo -e "${YELLOW}  [1/3] Starte SA818 Duplex Script...${NC}"
        sudo python3 /opt/sa818-running_duplex.py
        if [ $? -ne 0 ]; then
            echo -e "${RED}  FEHLER: SA818 Script fehlgeschlagen!${NC}"
            exit 1
        fi
        echo ""

        echo -e "${YELLOW}  [2/3] Kopiere SVXLink Duplex Config...${NC}"
        sudo cp /etc/svxlink/svxlink.conf.duplex /etc/svxlink/svxlink.conf
        if [ $? -ne 0 ]; then
            echo -e "${RED}  FEHLER: Config konnte nicht kopiert werden!${NC}"
            exit 1
        fi
        echo ""

        echo -e "${YELLOW}  [3/3] Starte SVXLink neu...${NC}"
        sudo systemctl restart svxlink
        if [ $? -ne 0 ]; then
            echo -e "${RED}  FEHLER: SVXLink Neustart fehlgeschlagen!${NC}"
            exit 1
        fi
        echo ""

        echo -e "${GREEN}✔ Duplex Betrieb aktiv!${NC}"
        ;;

    *)
        echo -e "${RED}Ungültige Auswahl. Bitte 1 oder 2 eingeben.${NC}"
        exit 1
        ;;
esac

echo ""
