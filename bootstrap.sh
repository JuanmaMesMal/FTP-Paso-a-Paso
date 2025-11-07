#!/bin/bash
# Script de provisión para el servidor DNS - Juanma

echo "Actualizando sistema..."
apt-get update -y
apt-get upgrade -y

echo "Instalando BIND9..."
apt-get install -y bind9 bind9utils bind9-doc

echo "Configurando BIND..."
# Copiamos los ficheros de configuración desde /vagrant/config
cp /vagrant/config/named.conf.options /etc/bind/named.conf.options
cp /vagrant/config/named.conf.local /etc/bind/named.conf.local
cp /vagrant/config/juanma.test.dns /var/lib/bind/juanma.test.dns
cp /vagrant/config/juanma.test.rev /var/lib/bind/juanma.test.rev

# Asegurar permisos correctos
chown bind:bind /var/lib/bind/*.dns /var/lib/bind/*.rev

# Forzamos IPv4 solo (como dice el PDF en /etc/default/named)
sed -i 's/OPTIONS=.*/OPTIONS="-u bind -4"/' /etc/default/named

echo "Reiniciando BIND..."
systemctl restart bind9
systemctl enable bind9
