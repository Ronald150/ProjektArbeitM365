#!/bin/bash

# Aktivieren des Loggings
set -e
exec > >(tee /var/log/cleanup.log | logger -t cleanup) 2>&1

# Farben definieren
YELLOW="\033[33m"
GREEN="\033[32m"
RED="\033[31m"
COLOR_END="\033[0m"

# Sicherheitsgruppe löschen
delete_security_group() {
    local SECURITY_GROUP_NAME=$1

    echo -e "${YELLOW}[i]${COLOR_END} Versuche, Sicherheitsgruppe zu löschen: $SECURITY_GROUP_NAME"

    # Sicherheitsgruppen-ID abrufen
    SG_ID=$(aws ec2 describe-security-groups \
        --filters "Name=group-name,Values=$SECURITY_GROUP_NAME" \
        --query "SecurityGroups[*].GroupId" \
        --output text)

    if [ -z "$SG_ID" ]; then
        echo -e "${YELLOW}[!]${COLOR_END} Sicherheitsgruppe $SECURITY_GROUP_NAME existiert nicht. Überspringe."
        return
    fi

    # Abhängigkeiten prüfen (Netzwerkschnittstellen)
    DEPENDENCIES=$(aws ec2 describe-network-interfaces \
        --filters Name=group-id,Values=$SG_ID \
        --query 'NetworkInterfaces[*].NetworkInterfaceId' --output text)

    if [ -n "$DEPENDENCIES" ]; then
        echo -e "${YELLOW}[!]${COLOR_END} Sicherheitsgruppe $SECURITY_GROUP_NAME hat Abhängigkeiten. Bereinige Abhängigkeiten..."
        for NI in $DEPENDENCIES; do
            echo -e "${YELLOW}[i]${COLOR_END} Identifiziere Ressource, die Netzwerkschnittstelle $NI verwendet..."
            ATTACHMENT_ID=$(aws ec2 describe-network-interfaces --network-interface-ids $NI --query "NetworkInterfaces[0].Attachment.AttachmentId" --output text)

            if [ "$ATTACHMENT_ID" != "None" ]; then
                echo -e "${GREEN}[+]${COLOR_END} Trenne Netzwerkschnittstelle $NI (Attachment-ID: $ATTACHMENT_ID)..."
                aws ec2 detach-network-interface --attachment-id $ATTACHMENT_ID
            fi

            echo -e "${GREEN}[+]${COLOR_END} Lösche Netzwerkschnittstelle $NI..."
            aws ec2 delete-network-interface --network-interface-id $NI
        done
    fi

    echo -e "${YELLOW}[i]${COLOR_END} Lösche Sicherheitsgruppe $SECURITY_GROUP_NAME (ID: $SG_ID)..."
    aws ec2 delete-security-group --group-id $SG_ID
    echo -e "${GREEN}[+]${COLOR_END} Sicherheitsgruppe $SECURITY_GROUP_NAME erfolgreich gelöscht."
}

# Cleanup Schritte
echo -e "${YELLOW}[i]${COLOR_END} Suche nach laufenden Instanzen..."
INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text)

if [ -n "$INSTANCE_IDS" ]; then
    echo -e "${YELLOW}[i]${COLOR_END} Beende laufende Instanzen: $INSTANCE_IDS"
    aws ec2 terminate-instances --instance-ids $INSTANCE_IDS
    aws ec2 wait instance-terminated --instance-ids $INSTANCE_IDS
    echo -e "${GREEN}[+]${COLOR_END} Alle Instanzen wurden beendet."
else
    echo -e "${YELLOW}[!]${COLOR_END} Keine laufenden Instanzen gefunden."
fi

# Sicherheitsgruppen löschen
echo -e "${YELLOW}[i]${COLOR_END} Lösche Sicherheitsgruppen..."
delete_security_group "mysql-sg"
delete_security_group "osticket-sg"

# Schlüssel löschen
echo -e "${YELLOW}[i]${COLOR_END} Lösche Key-Pair..."
KEY_NAME="osTicketKey"
aws ec2 delete-key-pair --key-name $KEY_NAME
rm -f "$KEY_NAME.pem"
echo -e "${GREEN}[+]${COLOR_END} Key-Pair und lokale Datei wurden gelöscht."

echo -e "${GREEN}[+]${COLOR_END} Bereinigung abgeschlossen."
