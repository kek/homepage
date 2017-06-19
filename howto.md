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

## ~/.rpi_vault_pass

```sh
#!/bin/sh

echo password
```

`ansible-galaxy install jdauphant.nginx`
