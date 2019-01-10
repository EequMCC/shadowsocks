#!/bin/bash
show(){
    ip=$(curl ifconfig.me)
    echo "ip:$ip"
    echo "port:$port"
    echo "password:$password"
    exit
}

start(){
    ssserver -c /etc/shadowsocks.json -d start
    show()
}

stop(){
    ssserver -d stop
    exit
}

json(){
    if [ -e /etc/shadowsocks.json ];then
        del /etc/shadowsocks.json
    fi
    echo "{">>/etc/shadowsocks.json
    echo "\"server\":\"0.0.0.0\",">>/etc/shadowsocks.json
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
        start()
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
    json()
    }

echo "[1]install"
echo "[2]manage"
read -p "Please select:" sel
if [ $sel -eq 1 ];then
    sudo apt-get install python-pip
    sudo pip install shadowsocks
    config()
fi
if [ $sel -eq 2 ];then
    echo "[1]start"
    echo "[2]stop"
    echo "[3]config"
    read -p "Please select:" selm
    if [ $selm -eq 1 ];then
        start()
    fi
    if [ $selm -eq 2 ];then
        stop()
    fi
    if [ $selm -eq 3 ];then
        ssserver -d stop
        config()
    fi
fi