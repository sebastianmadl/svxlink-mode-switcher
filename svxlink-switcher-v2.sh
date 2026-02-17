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
 / __\ \ / /\ \/ /  |  \/  |___  __| |___   / __|_ __ _(_) |_ __| |_  ___ _ _ 2
 \__ \\ V /  >  <   | |\/| / _ \/ _` / -_)  \__ \ V  V / |  _/ _| ' \/ -_) '_|
 |___/ \_/  /_/\_\  |_|  |_\___/\__,_\___|  |___/\_/\_/|_|\__\__|_||_\___|_|  
BANNER
echo -e "${NC}"
echo -e "${CYAN}                    by OE1SXM / Sebastian M.${NC}"
echo ""

# ── Frage 1: Welche Config? ──────────────────────────────────────
echo -e "${YELLOW}── Schritt 1: SVXLink Konfiguration ────────────────────────${NC}"
echo ""
echo -e "  ${GREEN}0${NC}) Keine Änderung"
echo -e "  ${GREEN}1${NC}) Simplex Config  (svxlink.conf.simplex)"
echo -e "  ${GREEN}2${NC}) Duplex Config   (svxlink.conf.duplex)"
echo ""
read -p "$(echo -e "Welche Config? (${YELLOW}0${NC}, ${GREEN}1${NC} oder ${GREEN}2${NC}): ")" config_choice

case $config_choice in
    0) CONFIG_SRC=""
       CONFIG_LABEL="Keine Änderung" ;;
    1) CONFIG_SRC="/etc/svxlink/svxlink.conf.simplex"
       CONFIG_LABEL="Simplex Config" ;;
    2) CONFIG_SRC="/etc/svxlink/svxlink.conf.duplex"
       CONFIG_LABEL="Duplex Config" ;;
    *) echo -e "${RED}Ungültige Auswahl.${NC}"; exit 1 ;;
esac

echo ""

# ── Frage 2: Welcher Betriebsmodus (SA818)? ──────────────────────
echo -e "${YELLOW}── Schritt 2: Betriebsmodus (SA818S) ───────────────────────${NC}"
echo ""
echo -e "  ${GREEN}0${NC}) Keine Änderung"
echo -e "  ${GREEN}1${NC}) Simplex Betrieb"
echo -e "  ${GREEN}2${NC}) Duplex Betrieb"
echo ""
read -p "$(echo -e "Welcher Modus? (${YELLOW}0${NC}, ${GREEN}1${NC} oder ${GREEN}2${NC}): ")" mode_choice

case $mode_choice in
    0) SA818_SCRIPT=""
       MODE_LABEL="Keine Änderung" ;;
    1) SA818_SCRIPT="/opt/sa818-running.py"
       MODE_LABEL="Simplex Betrieb" ;;
    2) SA818_SCRIPT="/opt/sa818-running_duplex.py"
       MODE_LABEL="Duplex Betrieb" ;;
    *) echo -e "${RED}Ungültige Auswahl.${NC}"; exit 1 ;;
esac

# ── Zusammenfassung & Bestätigung ────────────────────────────────
echo ""
echo -e "${YELLOW}── Zusammenfassung ──────────────────────────────────────────${NC}"
echo ""
echo -e "  Config:  ${YELLOW}${CONFIG_LABEL}${NC}"
echo -e "  Modus:   ${YELLOW}${MODE_LABEL}${NC}"
echo ""

if [ -z "$CONFIG_SRC" ] && [ -z "$SA818_SCRIPT" ]; then
    read -p "$(echo -e "Trotzdem SVXLink neu starten? (${GREEN}j${NC}/${RED}n${NC}): ")" confirm
else
    read -p "$(echo -e "Jetzt anwenden? (${GREEN}j${NC}/${RED}n${NC}): ")" confirm
fi

if [[ "$confirm" != "j" && "$confirm" != "J" ]]; then
    echo ""
    echo -e "${YELLOW}Abgebrochen. Keine Änderung vorgenommen.${NC}"
    echo ""
    exit 0
fi

# ── Ausführen ────────────────────────────────────────────────────
echo ""
echo -e "${RED}>>> Wende Änderungen an...${NC}"
echo ""

STEP=1
TOTAL=1
[ -n "$SA818_SCRIPT" ] && TOTAL=$((TOTAL+1))
[ -n "$CONFIG_SRC" ]   && TOTAL=$((TOTAL+1))

if [ -n "$SA818_SCRIPT" ]; then
    echo -e "${YELLOW}  [${STEP}/${TOTAL}] Starte SA818 Script (${MODE_LABEL})...${NC}"
    sudo python3 "$SA818_SCRIPT"
    if [ $? -ne 0 ]; then
        echo -e "${RED}  FEHLER: SA818 Script fehlgeschlagen!${NC}"
        exit 1
    fi
    echo ""
    STEP=$((STEP+1))
fi

if [ -n "$CONFIG_SRC" ]; then
    echo -e "${YELLOW}  [${STEP}/${TOTAL}] Kopiere ${CONFIG_LABEL}...${NC}"
    sudo cp "$CONFIG_SRC" /etc/svxlink/svxlink.conf
    if [ $? -ne 0 ]; then
        echo -e "${RED}  FEHLER: Config konnte nicht kopiert werden!${NC}"
        exit 1
    fi
    echo ""
    STEP=$((STEP+1))
fi

echo -e "${YELLOW}  [${STEP}/${TOTAL}] Starte SVXLink neu...${NC}"
sudo systemctl restart svxlink
if [ $? -ne 0 ]; then
    echo -e "${RED}  FEHLER: SVXLink Neustart fehlgeschlagen!${NC}"
    exit 1
fi
echo ""

echo -e "${GREEN}✔ Fertig!  Config: ${CONFIG_LABEL}  |  Modus: ${MODE_LABEL}${NC}"
echo ""
