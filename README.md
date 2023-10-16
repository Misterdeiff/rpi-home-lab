# Ansible
## Requirements
1. Install Ansible in your laptop
```shell
brew install ansible
```
2. Load OS
     2.1. Use Raspberry Pi Imager and select `Raspberry Pi OS Lite 64-bit` in the SD of the Raspberry Pi
     2.2. Add your SSH key
     2.3. Don't configure WiFi
3. Connect your drive/s to Linux, run `lsblk -f` and find out their UUIDs
4. Modify variables inside `roles/common/vars/main.yml`.
5. Adjust `inventories/hosts` as needed.
6. Connect all drives included on step #4 to your Pi. 
7. Run all tasks in the playbook.

### Get a List of Playbook Tasks
``` shell
ansible-playbook -i inventories/hosts -K playbook.yml --list-tasks
```

### Run all Tasks in Playbook
```shell
ansible-playbook -i inventories/hosts -K playbook.yml
```

## Test changes
Use --check for a dry run and, in addition, use --diff to have a detail differences

```shell
ansible-playbook -i inventories/hosts -K playbook.yml -t docker --check --diff
```

### Run task with a Specific Tag - Example: Docker installation
```shell
ansible-playbook -i inventories/hosts -K playbook.yml -t docker
```


# Argon Case
More info: https://wagnerstechtalk.com/argonone/
## Argon Case button behaviour
BUTTON STATE	ACTION	                FUNCTION
OFF	        Short Press	        Turn ON
ON	        Long Press (>= 3s)	Soft Shutdown and Power Cut
ON	        Short press (<3s)	Nothing
ON	        Double tap	        Reboot
ON	        Long Press (>= 5s)	Forced Shutdown

## Argon ONE V2 fan script
By default this is the behaviour after installing the script:

CPU TEMP     FAN POWER
55’C	        10%
60’C	        55%
65’C	        100%

You can config different settings by using `argonone-config`. To uninstall: `argonone-uninstall`.

# Containers
## Plex
1. Go to http://YOUR_IP:32400/web/index.html
2. Configure your folders
3. Add server in your end device

## NetaTalk
1. Run the next lines in your MacBook. Don't forget to change the USER and PASS.

````
defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1
sudo tmutil setdestination afp://USER:PASS@rpi.local/Time\ Machine
````
2. Go to Time Machine and verify the disk is properly set.
3. (Optional) Download TimeMachineEditor
     3.1. Set backups every day
     3.2. Do not backup during the day

## Plex sobre Docker en Raspberry

Con este repo podes crear tu propio server que descarga tus series y peliculas automáticamente, y cuando finaliza, las copia al directorio `media/` donde Plex las encuentra y las agrega a tu biblioteca.

También agregué un pequeño server samba por si querés compartir los archivos por red

Todo esto es parte de unos tutoriales que estoy subiendo a [Youtube](https://www.youtube.com/playlist?list=PLqRCtm0kbeHCEoCM8TR3VLQdoyR2W1_wv)

NOTA: Esta repo fue actualizada para correr usando flexget y transmission [en este video](https://youtu.be/TqVoHWjz_tI), podés todavia acceder a la versión vieja (con rtorrent) en la branch [rtorrent](https://github.com/pablokbs/plex-rpi/tree/rtorrent)

### Requerimientos iniciales

Agregar tu usuario (cambiar `kbs` con tu nombre de usuario)

```
sudo useradd kbs -G sudo
```

Agregar esto al sudoers para correr sudo sin password

```
%sudo   ALL=(ALL:ALL) NOPASSWD:ALL
```

Agregar esta linea a `sshd_config` para que sólo tu usuario pueda hacer ssh

```
echo "AllowUsers kbs" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl enable ssh && sudo systemctl start ssh
```

Instalar paquetes básicos

```
sudo apt-get update && sudo apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
     vim \
     fail2ban \
     ntfs-3g
```

Instalar Docker

```
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
echo "deb [arch=armhf] https://download.docker.com/linux/debian \
     $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update && sudo apt-get install -y --no-install-recommends docker-ce docker-compose
```

Modificá tu docker config para que guarde los temps en el disco:

```
sudo vim /etc/default/docker
# Agregar esta linea al final con la ruta de tu disco externo montado
export DOCKER_TMPDIR="/mnt/storage/docker-tmp"
```

Agregar tu usuario al grupo docker 

```
# Add kbs to docker group
sudo usermod -a -G docker kbs
#(logout and login)
docker-compose up -d
```

Montar el disco (es necesario ntfs-3g si es que tenes tu disco en NTFS)
NOTA: en este [link](https://youtu.be/OYAnrmbpHeQ?t=5543) pueden ver la explicación en vivo

```
# usamos la terminal como root porque vamos a ejecutar algunos comandos que necesitan ese modo de ejecución
sudo su
# buscamos el disco que querramos montar (por ejemplo la partición sdb1 del disco sdb)
fdisk -l
# pueden usar el siguiente comando para obtener el UUID
ls -l /dev/disk/by-uuid/
# y simplemente montamos el disco en el archivo /etc/fstab (pueden hacerlo por el editor que les guste o por consola)
echo UUID="{nombre del disco o UUID que es único por cada disco}" {directorio donde queremos montarlo} (por ejemplo /mnt/storage) ntfs-3g defaults,auto 0 0 | \
     sudo tee -a /etc/fstab
# por último para que lea el archivo fstab
mount -a (o reiniciar)
```


### IMPORTANTE

Las raspberry son computadoras excelentes pero no muy potentes, y plex por defecto intenta transcodear los videos para ahorrar ancho de banda (en mi opinión, una HORRIBLE idea), y la chiquita raspberry no se aguanta este transcodeo "al vuelo", entonces hay que configurar los CLIENTES de plex (si, hay que hacerlo en cada cliente) para que intente reproducir el video en la máxima calidad posible, evitando transcodear y pasando el video derecho a tu tele o Chromecast sin procesar nada, de esta forma, yo he tenido 3 reproducciones concurrentes sin ningún problema. En android y iphone las opciones son muy similares, dejo un screenshot de Android acá:

<img src="https://i.imgur.com/F3kZ9Vh.png" alt="plex" width="400"/>

Más info acá: https://github.com/pablokbs/plex-rpi/issues/3


## Transmission
Download Google Chrome extension "Transmission easy client". This plugin allows you to access to the WEB GUI <Raspberry_Pi_IP>:9091/transmission/web/#files


# Improvements
- Install PiHole

# TODO
- Fix mount disks: Mount disks does not work straight without reboot