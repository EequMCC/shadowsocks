#!/bin/bash
rm /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py
wget https://raw.githubusercontent.com/EequMCC/shadowsocks/master/openssl.py
mv openssl.py /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto
wget https://raw.githubusercontent.com/EequMCC/shadowsocks/master/shadowsocks && chmod +x shadowsocks && mv shadowsocks /usr/bin
