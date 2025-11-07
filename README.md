<h1 align="center">FTP paso a paso</h1>
<hr>

<!-- Estatus de desarrollo sacado de https://www.aluracursos.com/blog/como-escribir-un-readme-increible-en-tu-github -->
<p align="center">
  <img src="https://img.shields.io/badge/STATUS-EN%20DESARROLLO-green">
</p>

# Creacion de FTP

 - Hacemos un .gitignore para ignorar el .vagrant.
 - Copiamos el vagrantfile para tener una base funcional. y luego ir modificando lo que necesitemos 
 - Creamos una estructura basica para imagenes que podamos necesitar.

## Pasos a pasos ftp
 - Lo primero que necesitamos es tener un servidor DNS que usaremos de DNS-Paso-a-Paso
 - lo siguiente es crear en el vagrantfile otro servidor con los datos que queremos que tenga el servidor ftp otra ip diferente y un hostname diferente, y un bootstrap de aprovisionamiento diferente.
 - iniciamos un vagrant up dns para levantar el servidor de dns y comprobaremos que el bootstrap esta bien y que nuestra maquina dns este perfecta.
    - Hacemos un systemctl status bind9 para ver si esta activo y esta funcionando.
    ![Status Bind9](doc/assets/img/StatusBind9.png)
    - Lo siguiente es comprobar que funciona con dig.
    ![Comprobacion directa](doc/assets/img/ComprobacionNS.png)
    ![Comprobacion inversa](doc/assets/img/ComprobacionInversa.png)

## ftp grafico
 - Descargamos Filezilla cliente.
 ![Filezilla](doc/assets/img/filezilla.png)
 -Cramos una carpeta con un txt con datos para usarlo como ejemplo.
 ![Capeta prueba con archivo datos](doc/assets/img/prueba-datos.png)
 -Nos conectamos a ftp.cica.es y nos descargamos a nuestra carpeta el archivo que es /pub/check
 ![Conexion a cica](doc/assets/img/ConexionCica.png)
 ![Descarga Check](doc/assets/img/Descargacheck.png)
 - Para comprobarlo en el buscador de archivos, o en filezilla en la parte nuestra le damos click derecho y abrir y nos sale nuetra carpeta le he dado a abrir al archivo y bloc de notas.
 ![Comprobar check](doc/assets/img/CheckDatos.png)
 - Y desde el cliente si intentamos subir nuestro archivo no nos deja por que no tenemos permisos
  ![Subir nuestros datos ](doc/assets/img/DatosSinpermiso.png)

## VSFTPD Linux
 - Instalamos VSFTPD (apt install -y vsftpd)
 - Comprobamos que se ha instalado correctamente usamos para encontrarlo (grep ftp /etc/passwd)
 ![Comprobacion instalación](doc/assets/img/ComprobacionVSFTPD.png)
 - Comprobamos que se ha creado el directorio /srv/ftp y que el usuario es root y pertenece al grupo ftp
 ![Comprobacion directorio srv/ftp y usuario root y grupo ftp](doc/assets/img/RootFTP.png)
 - Comprobamos que usuarios no pueden acceder al servicio. (etc/ftpusers)
 ![Comprobacion Usuarios no pueden acceder](doc/assets/img/UsersDisallowed.png)
 -Ahora comprobamos que el servicio esta activo y funcionando
 ![Status VSFTPD](doc/assets/img/StatusVSFTPD.png)
 - Comprobacion que esta escuchando por el puerto 21
 <!-- Use al principio netstat -tln que pone en el pdf pero me sale command not found -->
 ![Status VSFTPD](doc/assets/img/Escucha21.png)
 - Lo siguiente es crear una copia de seguridad del archivo   pero en mi caso voy a hacer un cp y mandarlo fuera de la maquina a /vagrant/configFTP
 ![Status VSFTPD](doc/assets/img/RutaCopia.png)
 ![Status VSFTPD](doc/assets/img/copia.png)
 - Creamos usuarios (useradd -m 'nombre')  <!-- la m se utiliza para crear un directorio del usuario-->
 ![Creacion Luis](doc/assets/img/CreacionLuis.png)
 ![Creacion Maria](doc/assets/img/CreacionMaria.png)
 ![Creacion Miguel](doc/assets/img/CreacionMiguel.png)

