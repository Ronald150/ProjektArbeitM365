#!/bin/bash

# Farben initialisieren
YELLOW="\033[33m"
RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
COLOR_END="\033[0m"

# Region definieren
REGION="us-east-1"

# Funktion: Alle Instanzen terminieren
terminate_all_instances() {
    echo -e "$YELLOW[i]$COLOR_END Suche nach laufenden Instanzen..."

    # Alle laufenden Instanzen abrufen
    INSTANCE_IDS=$(aws ec2 describe-instances \
        --filters "Name=instance-state-name,Values=running" \
        --query "Reservations[*].Instances[*].InstanceId" \
        --output text --region $REGION)

    if [ -z "$INSTANCE_IDS" ]; then
        echo -e "$YELLOW[!]$COLOR_END Keine laufenden Instanzen gefunden."
    else
        echo -e "$GREEN[+]$COLOR_END Stoppe Instanzen: $INSTANCE_IDS"
        aws ec2 terminate-instances --instance-ids $INSTANCE_IDS --region $REGION
        echo -e "$YELLOW[i]$COLOR_END Warten, bis Instanzen beendet sind..."
        aws ec2 wait instance-terminated --instance-ids $INSTANCE_IDS --region $REGION
        echo -e "$GREEN[+]$COLOR_END Instanzen erfolgreich beendet."
    fi
}

# Funktion: Sicherheitsgruppen löschen
delete_security_group() {
    local SECURITY_GROUP_NAME=$1

    echo -e "$YELLOW[i]$COLOR_END Versuche, Sicherheitsgruppe zu löschen: $SECURITY_GROUP_NAME"

    # Sicherheitsgruppen-ID abrufen
    SG_ID=$(aws ec2 describe-security-groups \
        --filters "Name=group-name,Values=$SECURITY_GROUP_NAME" \
        --query "SecurityGroups[*].GroupId" --output text --region $REGION)

    if [ -z "$SG_ID" ]; then
        echo -e "$YELLOW[!]$COLOR_END Sicherheitsgruppe $SECURITY_GROUP_NAME existiert nicht."
        return
    fi

    # Sicherheitsgruppe löschen
    echo -e "$GREEN[+]$COLOR_END Lösche Sicherheitsgruppe $SECURITY_GROUP_NAME (ID: $SG_ID)..."
    aws ec2 delete-security-group --group-id $SG_ID --region $REGION
    echo -e "$GREEN[+]$COLOR_END Sicherheitsgruppe $SECURITY_GROUP_NAME erfolgreich gelöscht."
}

# Funktion: Schlüssel löschen
delete_key_pair() {
    echo -e "$YELLOW[i]$COLOR_END Lösche Schlüssel $KEY_NAME..."
    aws ec2 delete-key-pair --key-name $KEY_NAME --region $REGION

    if [ -f "$KEY_NAME.pem" ]; then
        rm -f "$KEY_NAME.pem"
        echo -e "$GREEN[+]$COLOR_END Lokale Schlüsseldatei $KEY_NAME.pem entfernt."
    fi

    echo -e "$GREEN[+]$COLOR_END Schlüssel $KEY_NAME erfolgreich gelöscht."
}

# Hauptskript
KEY_NAME="osTicketKey"
OS_TICKET_SG="osTicket-sg"
MYSQL_SG="mysql-sg"

terminate_all_instances

delete_security_group $MYSQL_SG
delete_security_group $OS_TICKET_SG

delete_key_pair

echo -e "$GREEN[+]$COLOR_END Bereinigung abgeschlossen."
