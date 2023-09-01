# gear node

version: staging testnet v4

## Installing

1. Run the script:

```sh
. <(wget -qO- sh.f5nodes.com) gear
```

2. Enter your nodename in the input.

## Commands

#### Check node logs:

```sh
journalctl -n 100 -f -u gear
```

**CTRL + C** to exit logs

#### Delete node:

```sh
sudo systemctl stop gear
sudo systemctl disable gear
sudo rm -rf /root/.local/share/gear
sudo rm /etc/systemd/system/gear.service
sudo rm /root/gear
```

v6 upd
