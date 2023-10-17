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

## Transmission
Download Google Chrome extension "Transmission easy client". This plugin allows you to access to the WEB GUI <Raspberry_Pi_IP>:9091/transmission/web/#files

# Improvements
- Install PiHole

# TODO
- Fix mount disks: Mount disks does not work straight without reboot