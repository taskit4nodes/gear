#!/bin/bash

if [ ! $NODENAME_GEAR ]; then
	read -p "Nodename (a-z and 0-9 only): " NODENAME_GEAR
fi
echo 'Your nodename is' $NODENAME_GEAR
echo -e "\e[92mInstallation started...\e[0m"
sleep 1
echo 'export NODENAME='$NODENAME_GEAR >> $HOME/.profile
curl -s https://raw.githubusercontent.com/f5nodes/root/main/install/rust.sh | bash &>/dev/null
sudo apt install --fix-broken -y &>/dev/null
sudo apt install nano mc git mc clang curl jq htop net-tools libssl-dev llvm libudev-dev -y &>/dev/null
source $HOME/.profile &>/dev/null
source $HOME/.bashrc &>/dev/null
source $HOME/.cargo/env &>/dev/null
sleep 1

wget https://get.gear.rs/gear-v0.3.1-x86_64-unknown-linux-gnu.tar.xz
sudo tar -xvf gear-v0.3.1-x86_64-unknown-linux-gnu.tar.xz -C /root
rm gear-v0.3.1-x86_64-unknown-linux-gnu.tar.xz
chmod +x $HOME/gear &>/dev/null

sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald

sudo tee <<EOF >/dev/null /etc/systemd/system/gear.service
[Unit]
Description=Gear Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/root/gear \
    --name $NODENAME_GEAR \
    --execution wasm \
    --port 31333 \
    --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0'
Restart=always
RestartSec=10
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl restart systemd-journald &>/dev/null
sudo systemctl daemon-reload &>/dev/null
sudo systemctl enable gear &>/dev/null
sudo systemctl restart gear &>/dev/null

if [ "$language" = "uk" ]; then
    if [[ `service gear status | grep active` =~ "running" ]]; then
        echo -e "\n\e[93mGear Node\e[0m\n"
        echo -e "Подивитись логи ноди \e[92mjournalctl -n 100 -f -u gear\e[0m"
        echo -e "\e[92mCTRL + C\e[0m щоб вийти з логів\n"
        echo -e "Зробіть бекап \e[92m$HOME/.local/share/gear/chains/gear_staging_testnet_v7/network\e[0m"
    else
        echo -e "Ваша Gear нода \e[91mбула встановлена неправильно\e[39m, виконайте перевстановлення."
    fi
else
    if [[ `service gear status | grep active` =~ "running" ]]; then
        echo -e "\n\e[93mGear Node\e[0m\n"
        echo -e "Check node logs \e[92mjournalctl -n 100 -f -u gear\e[0m"
        echo -e "\e[92mCTRL + C\e[0m to exit logs\n"
        echo -e "Backup \e[92m$HOME/.local/share/gear/chains/gear_staging_testnet_v7/network\e[0m"
    else
      echo -e "Your Gear Node \e[91mwas not installed correctly\e[39m, please reinstall."
    fi
fi