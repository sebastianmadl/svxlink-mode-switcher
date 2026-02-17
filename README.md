# SVX Mode Switcher

```
  _____   ____  __   __  __         _        ___        _ _      _            
 / __\ \ / /\ \/ /  |  \/  |___  __| |___   / __|_ __ _(_) |_ __| |_  ___ _ _ 
 \__ \\ V /  >  <   | |\/| / _ \/ _` / -_)  \__ \ V  V / |  _/ _| ' \/ -_) '_|
 |___/ \_/  /_/\_\  |_|  |_\___/\__,_\___|  |___/\_/\_/|_|\__\__|_||_\___|_|  
```

**by OE1SXM / Sebastian M.**

Ein einfaches Bash-Script für Debian Bookworm, das den Betriebsmodus eines SVXLink-Nodes mit SA818S-Modul per Tastendruck zwischen **Simplex** und **Duplex** umschaltet.

---

## Was macht das Script?

Beim Start zeigt das Script ein übersichtliches Terminal-Menü. Nach Eingabe von `1` oder `2` führt es automatisch folgende Schritte aus:

1. **SA818S konfigurieren** – startet das passende Python-Script, das das SA818S-Funkmodul für den gewählten Modus programmiert
2. **SVXLink Config umkopieren** – kopiert die passende Konfigurationsdatei nach `/etc/svxlink/svxlink.conf`
3. **SVXLink neu starten** – führt `systemctl restart svxlink` aus

Jeder Schritt wird farbig im Terminal angezeigt. Bei einem Fehler bricht das Script sofort ab und gibt eine Fehlermeldung aus.

---

## Voraussetzungen

- Debian Bookworm (oder vergleichbares Debian-basiertes System)
- [SVXLink](https://www.svxlink.org/) installiert und als systemd-Service eingerichtet
- SA818S-Modul angeschlossen und die Python-Scripts vorhanden
- `sudo`-Berechtigung für den ausführenden Benutzer

---

## Benötigte Dateien

| Datei | Beschreibung |
|-------|-------------|
| `/opt/sa818-running.py` | Python-Script zur SA818S-Konfiguration für **Simplex** |
| `/opt/sa818-running_duplex.py` | Python-Script zur SA818S-Konfiguration für **Duplex** |
| `/etc/svxlink/svxlink.conf` | Aktiv verwendete SVXLink-Konfiguration (wird überschrieben) |
| `/etc/svxlink/svxlink.conf.simplex` | SVXLink-Config für Simplex-Betrieb |
| `/etc/svxlink/svxlink.conf.duplex` | SVXLink-Config für Duplex-Betrieb |

---

## Installation

### Schnellinstallation via git clone

```bash
git clone https://github.com/sebastianmadl/svxlink-mode-switcher.git
sudo mv svxlink-mode-switcher/svxlink-switcher.sh /usr/local/bin/svxlink-switcher
sudo chmod +x /usr/local/bin/svxlink-switcher
rm -rf svxlink-mode-switcher
```

Danach ist das Script von überall aufrufbar:

```bash
sudo svxlink-switcher
```

### Manuelle Installation

```bash
# 1. Script herunterladen / kopieren
nano svxlink-switcher.sh
# Inhalt einfügen, dann Ctrl+O → Enter → Ctrl+X

# 2. Ausführbar machen und verschieben
sudo mv svxlink-switcher.sh /usr/local/bin/svxlink-switcher
sudo chmod +x /usr/local/bin/svxlink-switcher
```

---

## Eigene Configs hinterlegen / umbenennen

Die Pfade zu den Configs und Python-Scripts sind direkt im Script definiert und können einfach angepasst werden.

Öffne das Script mit einem Texteditor:

```bash
sudo nano /usr/local/bin/svxlink-switcher
```

### Config-Pfade anpassen

Suche nach den folgenden Zeilen im `case`-Block und ersetze die Pfade nach Bedarf:

**Für Simplex (Option 1):**
```bash
sudo python3 /opt/sa818-running.py
sudo cp /etc/svxlink/svxlink.conf.simplex /etc/svxlink/svxlink.conf
```

**Für Duplex (Option 2):**
```bash
sudo python3 /opt/sa818-running_duplex.py
sudo cp /etc/svxlink/svxlink.conf.duplex /etc/svxlink/svxlink.conf
```

### Beispiel: Eigene Config-Namen verwenden

Wenn deine Configs z.B. `svxlink.conf.node1` und `svxlink.conf.repeater` heißen:

```bash
# Option 1 – Node Betrieb
sudo cp /etc/svxlink/svxlink.conf.node1 /etc/svxlink/svxlink.conf

# Option 2 – Repeater Betrieb
sudo cp /etc/svxlink/svxlink.conf.repeater /etc/svxlink/svxlink.conf
```

Auch die Menü-Beschriftungen lassen sich entsprechend umbenennen – suche dazu im Script nach:

```bash
echo -e "  ${GREEN}1${NC}) Simplex Betrieb"
echo -e "  ${GREEN}2${NC}) Duplex Betrieb"
```

und ersetze die Bezeichnungen nach Wunsch.

---

## Lizenz

Free to use – 73 de OE1SXM 📻
