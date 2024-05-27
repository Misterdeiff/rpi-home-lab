# Overview
This repository contains a variety of docker containers, with the majority of them oriented to have your own media server using ARR solutions. It has been built using Ansible to create every single requirement. So, in case your system goes totally down, you will only need to apply the playbook and restore your docker config. Ideally you make a regular backup with Kopia in a different drive.

I included some interesting container notes to take into account when configuring them.


# My setup
I have started this project using a Raspberry Pi 4 with 8GB RAM, that is the reason why the documentation and some files refers to it, but this project and be used in any other linux system. In addition, I also use an Argon case that includes a fan, if you don't have this case you can simply omit/remove the `argon` tasks.

I also use two HDDs: The primary one stores all the media and docker config, the second one is only for backups (a partition for Timemachine and another partition for Kopia backups).

# Requirements
1. Install Ansible in your laptop
   ```shell
   brew install ansible
   ```
2. Load OS
   - 2.1. Use Raspberry Pi Imager and select `Raspberry Pi OS Lite 64-bit` in the SD of the Raspberry Pi
   - 2.2. Add your SSH key
   - 2.3. Don't configure WiFi
3. Connect your drive/s to Linux, run `lsblk -f` and find out their UUIDs
4. Modify variables inside `roles/common/vars/main.yml`
5. Adjust `inventories/hosts` as needed.
6. Connect all drives included on step #4 to your Pi
7. Create your own Telegram Bot for notifications from ARR apps, Watchtower and disk space
8. Follow the steps under Tailscale container to get the `TAILSCALE_AUTHKEY`
9. Run all tasks in the playbook:
   ```shell
   ansible-playbook -i inventories/hosts -K playbook.yml
   ```

## Telegram
In order to create your own bot follow the next steps:
1. Create a Telegram bot with `@BotFather` (the verified one)
2. Paste your bot's token in the main.yml file and use it to create connections in the ARR apps (Overseerr, Radarr, Sonarr, Prowlarr)
3. Use `@get_id_bot` to find your bot's Channel ID. Use it to receive the notifications in that channel for the ARR apps and Watchtower (main.yml)
4. (Optional) Create a Telegram Channel to separate system notifications (Overseer approvals and container updates received in the bot directly) from the new Movies / TV Shows added (Telegram Channel for family and friends).
   4.1. Create your new channel
   4.2. Add your bot as Admin
   4.3. Use Telegram web and access your new Channel. Get the Channel ID from the URL. It usually starts with `-100`
   4.4. Use this Channel ID in the Connection configured in Radarr and Sonarr

# Useful commands

## Get a List of Playbook Tasks
``` shell
ansible-playbook -i inventories/hosts -K playbook.yml --list-tasks
```

## Run all Tasks in Playbook
```shell
ansible-playbook -i inventories/hosts -K playbook.yml
```

## Test changes
Use --check for a dry run and, in addition, use --diff to have a detail differences

```shell
ansible-playbook -i inventories/hosts -K playbook.yml -t docker --check --diff
```

## Run task with a Specific Tag - Example: Docker installation
```shell
ansible-playbook -i inventories/hosts -K playbook.yml -t docker
```

## Copy compose.yml and restart only the specified container
```shell
ansible-playbook -i inventories/hosts -K playbook.yml -t container -e "container=samba"
```


# Tools
## Argon Case
More info: https://wagnerstechtalk.com/argonone/
### Argon Case button behaviour
BUTTON STATE	ACTION	                FUNCTION
OFF	        Short Press	        Turn ON
ON	        Long Press (>= 3s)	Soft Shutdown and Power Cut
ON	        Short press (<3s)	Nothing
ON	        Double tap	        Reboot
ON	        Long Press (>= 5s)	Forced Shutdown

### Argon ONE V2 fan script
By default this is the behaviour after installing the script:

CPU TEMP     FAN POWER
55’C	        10%
60’C	        55%
65’C	        100%

You can config different settings by using `argonone-config`. To uninstall: `argonone-uninstall`.

# Container Notes
## Plex
1. Go to http://YOUR_IP:32400/web/index.html
2. Configure your folders
3. Add server in your end device

## Pi-hole
More info at https://github.com/pi-hole/docker-pi-hole/ and https://docs.pi-hole.net/

If NOT using it for DHCP, remove:
- Port `67:67/udp`
- `cap_add: - NET_ADMIN`

## Watchtower
- List of arguments: https://containrrr.dev/watchtower/arguments/
- WATCHTOWER_SCHEDULE is set to execute every Sunday at 4AM

## Kopia
- Server start commands: https://kopia.io/docs/reference/command-line/common/server-start/

## Tailscale
VPN access to your home network

1. Create an account and download the app on your client devices: https://tailscale.com/
2. Access Controls - Ensure you have the next config.
   
   This config creates a group `admin` where you are included by email. It also adds a `container` tag to be used in the tailscale container. The ACL allows only your group to access your private network, adjust it to your needs. See more examples [here](https://tailscale.com/kb/1019/subnets#add-access-rules-for-the-advertised-subnet-routes):
   ```
   "groups": {
		"group:admin": ["YOUR_EMAIL"],
	},
	"tagOwners": {
		"tag:container": ["autogroup:admin"],
	},
   "acls": [
		{
			"action": "accept",
			"src":    ["group:admin", "*"],
			"dst":    ["192.168.0.0/24:*"],
		},
	],
   ```
3. Settings > oAuth Clients > Create oAuth Client
   3.1. Add a description to identify the client e.i. "home_server"
   3.2. Mark Devices Read and Write
   3.3. Add tags > tag:container
   3.4. Generate Client
4. Add the token to the main.yml environment variable list
5. Once the tailscale container is up, access the [Tailscale dashboard > Machines](https://login.tailscale.com/admin/machines) > Options (in Tailscale machine) > Edit route settings > Check the shared subnet > Save
6. DNS > Nameservers > Add nameserver > Enter the internal IP of your server (Pi-hole should be running)
