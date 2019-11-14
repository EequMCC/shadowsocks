#!/bin/bash
show(){
    ip=$(cat /etc/shadowsocks.json | sed -n 2p)
    portt=$(cat /etc/shadowsocks.json | sed -n 3p)
    passwordd=$(cat /etc/shadowsocks.json | sed -n 6p)
    echo -e "\033[42;37m\"ip\":$ip\033[0m"
    echo -e "\033[42;37m\"port\":$portt\033[0m"
    echo -e "\033[42;37m\"password\":$passwordd\033[0m"
    exit
}

startt(){
    wget https://raw.githubusercontent.com/EequMCC/shadowsocks/master/alert.sh && chmod +x alert.sh && ./alert.sh
    exit
}

json(){
    if [ -e /etc/shadowsocks.json ];then
        rm -f /etc/shadowsocks.json
    fi
    echo "{">>/etc/shadowsocks.json
    echo "\"server\":\"$ip\",">>/etc/shadowsocks.json
    echo "\"server_port\":$port,">>/etc/shadowsocks.json
    echo "\"local_address\": \"127.0.0.1\",">>/etc/shadowsocks.json
    echo "\"local_port\":1080,">>/etc/shadowsocks.json
    echo "\"password\":\"$password\",">>/etc/shadowsocks.json
    echo "\"timeout\":300,">>/etc/shadowsocks.json
    echo "\"method\":\"aes-256-cfb\",">>/etc/shadowsocks.json
    echo "\"fast_open\": false">>/etc/shadowsocks.json
    echo "}">>/etc/shadowsocks.json
    startt
}

config(){
    read -p "Please input port(default\"8388\"):" port
    read -p "Please input password(default\"ppasswordd\"):" password
    if [ -z $port ];then
        port=8388
    fi
    if [ -z $password ];then
        password="ppasswordd"
    fi
    ip=$(curl ifconfig.me)
    json
    }

echo "[1]install"
echo "[2]manage"
read -p "Please select:" sel
if [ $sel -eq 1 ];then
    apt-get install python-pip
    pip install shadowsocks
    wget https://raw.githubusercontent.com/EequMCC/shadowsocks/master/shadowsocks && chmod +x shadowsocks && mv shadowsocks /usr/bin
    config
fi
if [ $sel -eq 2 ];then
    echo "[1]start"
    echo "[2]stop"
    echo "[3]config"
    echo "[4]show config"
    read -p "Please select:" selm
    if [ $selm -eq 1 ];then
        ssserver -c /etc/shadowsocks.json -d start
    fi
    if [ $selm -eq 2 ];then
        ssserver -d stop
    fi
    if [ $selm -eq 3 ];then
        ssserver -d stop
        config
    fi
    if [ $selm -eq 4 ];then
        show
    fi
fi
