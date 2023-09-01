#!/bin/bash
sudo systemctl stop gear
$HOME/gear purge-chain -y
wget https://get.gear.rs/gear-v0.3.1-x86_64-unknown-linux-gnu.tar.xz
sudo tar -xvf gear-v0.3.1-x86_64-unknown-linux-gnu.tar.xz -C /root
rm gear-v0.3.1-x86_64-unknown-linux-gnu.tar.xz
sudo systemctl start gear
sleep 2
sudo systemctl stop gear
cd $HOME/.local/share/gear/chains
mkdir -p gear_staging_testnet_v7/network/
sudo cp gear_staging_testnet_v6/network/secret_ed25519 gear_staging_testnet_v7/network/secret_ed25519
sudo systemctl start gear
if [ "$language" = "uk" ]; then
    if [[ `service gear status | grep active` =~ "running" ]]; then
        echo -e "\n\e[93mGear Node Updated!\e[0m\n"
        echo -e "Подивитись логи ноди \e[92mjournalctl -n 100 -f -u gear\e[0m"
        echo -e "\e[92mCTRL + C\e[0m щоб вийти з логів\n"
        echo -e "Зробіть бекап \e[92m$HOME/.local/share/gear/chains/gear_staging_testnet_v7/network\e[0m"
    else
        echo -e "\e[91mПомилка\e[39m під час оновлення Gear ноди."
    fi
else
    if [[ `service gear status | grep active` =~ "running" ]]; then
        echo -e "\n\e[93mGear Node Updated!\e[0m\n"
        echo -e "Check node logs \e[92mjournalctl -n 100 -f -u gear\e[0m"
        echo -e "\e[92mCTRL + C\e[0m to exit logs\n"
        echo -e "Backup \e[92m$HOME/.local/share/gear/chains/gear_staging_testnet_v7/network\e[0m"
    else
        echo -e "\e[91mError\e[39m while updating Gear node."
    fi
fi