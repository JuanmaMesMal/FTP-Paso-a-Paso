#!/bin/bash
# Script de provisión para el servidor FTP seguro - Juanma

echo "Iniciando provisión del servidor FTP - Juanma"

echo "Actualizando sistema..."
apt-get update -y
apt-get upgrade -y

echo "Instalando vsftpd y OpenSSL..."
apt-get install -y vsftpd openssl

echo "Generando certificado autofirmado para FTPS..."
mkdir -p /etc/ssl/private /etc/ssl/certs

openssl req -x509 -nodes -sha256 -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/juanma.test.key \
  -out /etc/ssl/certs/juanma.test.pem \
  -subj "/C=ES/ST=Andalucia/L=Granada/O=IESZaidin/OU=DAW/CN=ftp.juanma.test"

chmod 600 /etc/ssl/private/juanma.test.key
chmod 644 /etc/ssl/certs/juanma.test.pem

echo "Creando usuarios locales: luis, maria y miguel"
useradd -m -s /bin/bash luis
useradd -m -s /bin/bash maria
useradd -m -s /bin/bash miguel

echo "luis:luis" | chpasswd
echo "maria:maria" | chpasswd
echo "miguel:miguel" | chpasswd

echo "Creando archivos de prueba en los directorios de usuarios..."
touch /home/luis/luis{1,2}.txt
touch /home/maria/maria{1,2}.txt
touch /home/miguel/miguel{1,2}.txt

chown luis:luis /home/luis/*.txt
chown maria:maria /home/maria/*.txt
chown miguel:miguel /home/miguel/*.txt

echo "Configurando VSFTPD"
echo "Guardamos el archivo de configuracion"
cp /etc/vsftpd.conf /etc/vsftpd.conf.backup

echo "Copiando configuración personalizada de vsftpd desde /vagrant/config..."
cp /vagrant/config/vsftpd.conf /etc/vsftpd.conf

echo "Reiniciando servicio vsftpd"
systemctl restart vsftpd
systemctl enable vsftp

echo "✅ Servidor FTP seguro (FTPS) configurado y listo para usar."