# How To

## wpa-supplicant.conf

```
country=GB
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="your wifi name"
    psk="your wifi password"
}
```

## secrets.yml

Needs to contain the keys `erlang_cookie` and `secret_key_base`. The provided
key contains the values for my particular project, encrypted with ansible-vault.

## ~/.rpi_vault_pass

```sh
#!/bin/sh

echo password
```

`ansible-galaxy install jdauphant.nginx`

## Viktigt

iw dev wlan0 set power_save off

måste in i update_raspbian_image.sh
