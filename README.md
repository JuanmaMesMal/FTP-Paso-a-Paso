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
 - Creamos ficheros de prueba 
    - Lo comprobamos que se hayan creado
 ![Crecion archivos y comprobamos](doc/assets/img/CreacionFicheros.png)
 - Por ultimo configuramos el archivo que anteriormente se hizo una copia de seguridad para ahora poder modificar que lo que hace es darle permisos o quitarle permisos a los usuarios y poner resrticciones generales 
    - Tenemos que crear un archivo con el user de maria por que esta no estara enjaulado (nano /etc/vsftpd.chroot_list y ponemos maria)
    ![Excepcion maria de jaula](doc/assets/img/ExcepcionMaria.png)
    - Modificamos el archivo de configuracion de vsftpd
    ![Primera parte archivo](doc/assets/img/PrimeraParteArchivoConf.png)
    ![Segunda parte archivo](doc/assets/img/SegundaParteArchivoConf.png) <!-- Solo añade la ultima linea por que no entra en la captura  -->
    - Vemos desde un equipo si podemos acceder, desde mi equipo fuera de las maquinas virtuales voy a intntar acceder mediante cmd
        - Vemos que si no tengo usuario creado da error y te mete en anonimo y no tienes permisos de crear y si te sabes alguna cuenta puedes acceder con esa cuenta y contraseña
    ![Prueba cmd](doc/assets/img/PruebaMetermeCMD.png)
    - Comprobamos ahora con maria y vemos si no estamos enjaulados lo miramos desde filezilla
    ![Filezilla Maria](doc/assets/img/filezillaMaria.png)
    -Comprobamos con luis
    ![Filezilla Luis](doc/assets/img/filezillaLuis.png)

## VSFTPD Seguro Linux
 - Tenemos que crear un par de claves privadas y publicas para la privada creare un directorio privado para el root y no pueda acceder nadie y luego creare las claves
 ![Directorio privado](doc/assets/img/directorioPrivado.png)
   - creamos par de claves
 ![Par de claves](doc/assets/img/ParClaves.png)
 - Configuramos el archivo vstfpd.conf con los nuevos parametros para la conexion segura
 ![Configuracion de seguridad en el archivo vstfpd.conf ](doc/assets/img/SeguraConfiguracionArchivo.png) 
   -tengo un error de escritura y al reiniciar el servicio me salia fallado y es en la linea de allow_anon que lo siguiente es en minuscula, tengo Ssl y es ssl, cambiado esto ya sale bien.
 ![Reinicio y comprobacion del status ](doc/assets/img/ComprobacionSegura.png) 

- Comprobamos todo con luis con una conexion segura 
   - Al primer intento no me ha funcionado, he ido archivos y gestor de sitio, luego he creado un nuevo sitio metiendole los parametros de que quiero que sea segura.
   ![Crear sitio seguro](doc/assets/img/CrearLuisSeguro.png)
   - Con esto ya se inicia. 
   ![Comprobacion de que luis entra](doc/assets/img/LuisEntraSeguro.png) 
- Comrpobamos el candado de abajo un poco a la derecha que este cerrado significa que esta segura y tambien comprobamos que realiza la conexión y acepta el certificado del servidor
![Comprobacion de que entra y candado](doc/assets/img/comprobacion+candado.png) 
- Comprobamos que podemos descargar y subir archivos
![Comprobacion de que se descarga y subimos archivos](doc/assets/img/SubirDescargarArchivos.png) 
- Ahora vamos a crear un nuevo sitio pero para entrar con un anonimo.
![Creacion del sitio anonimo](doc/assets/img/SitioAnonimo.png) 
- Le damos a conectar
![Anonimo no deja](doc/assets/img/AnonimoNodeja.png) 
- Por ultimo comprobamos otra conexion, lo voy a hacer con maria que no esta enjaulada.
![Sitio de maria](doc/assets/img/SitioMariaSeguro.png) 
![Vemos si estamos dentro de maria y tenemos acceso a todo](doc/assets/img/entramosMariaSeguro.png) 



 
