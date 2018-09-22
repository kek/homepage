# Elixir + Ansible + Raspberry Pi setup

## Initial manual provisioning the Raspberry hosts

This is the part that I wasn't able to completely automate.

Requirement:

* Vagrant

How to:

* Download a raspbian image and store it as `raspbian.img` here.
* Write a `wpa_supplicant.conf` file if you need a wifi connection.
* Run `vagrant up`.
* Run the `update-raspbian-image.sh` script from inside the Vagrant machine to
  update the image with the wifi configuration and to enable SSH.
* The SD card image is now unmounted. If additional adjustments are needed, the
  process of mounting the SD card again is described in
  `update-raspbian-image.sh`.
* Write the updated image to the Raspberry's SD card. 
* Boot the Raspberry and log in to set the hostname. It should now be able to
  be autodiscovered, but the Avahi configuration might need to be adjusted.
  Alternatively, update `hosts` in the project to use literal IP addresses. Also
  set a new password for the user `pi`.

## Preparing for running Ansible

This installs the requirements on the local machine (Ansible control host) and
authorizes it to manage the Raspberries.

Requirements:

* pip (Debian package: `python-pip`)
* The password that encodes `secrets.yml` with `ansible-vault`
* The password for the user `pi` set above.

How to:

```
pip install ansible
echo <password> > ~/.rpi_vault_pass
ansible-galaxy install -r requirements.yml
```

Then, for each host, do `ssh-copy-id pi@<hostname>` and input the password for
the `pi` user.

## Updating configuration and application

Last step. This is the only thing that needs to be done regularly after the
above is set up.

To update the configuration and/or deploy a new app version, run

```
ansible-playbook playbook.yml
```
