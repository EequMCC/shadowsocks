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
    ssserver -c /etc/shadowsocks.json -d start
    exit
}

stopp(){
    ssserver -d stop
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
    read -p "Start Now?[Y/N]:" stn
    if [ $stn -eq "Y" ] || [ $stn -eq "y" ];then
        startt
    else
        exit
    fi
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
    sudo apt-get install python-pip
    pip install shadowsocks
    sudo rm /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py
    wget https://raw.githubusercontent.com/EequMCC/shadowsocks/master/openssl.py
    sudo mv openssl.py /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/
    wget https://raw.githubusercontent.com/EequMCC/shadowsocks/master/startup
    sudo mv startup /etc/init.d/ && chmod +x /etc/init.d/startup
    sudo update-rc.d startup defaults
    config
fi
if [ $sel -eq 2 ];then
    echo "[1]start"
    echo "[2]stop"
    echo "[3]config"
    echo "[4]show config"
    read -p "Please select:" selm
    if [ $selm -eq 1 ];then
        startt
    fi
    if [ $selm -eq 2 ];then
        stopp
    fi
    if [ $selm -eq 3 ];then
        ssserver -d stop
        config
    fi
    if [ $selm -eq 4 ];then
        show
    fi
fi
