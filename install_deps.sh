#!/bin/sh

# Install necessary build tools
apk add --no-cache git

# Install lua-resty-http
cd /usr/local/openresty/lualib
git clone https://github.com/ledgetech/lua-resty-http.git
mkdir -p resty/
cp lua-resty-http/lib/resty/http* resty/
rm -rf lua-resty-http

# Install lua-resty-openssl
git clone https://github.com/fffonion/lua-resty-openssl.git
cp -r lua-resty-openssl/lib/resty/openssl* resty/
rm -rf lua-resty-openssl

# Set permissions
chmod -R 755 /usr/local/openresty/lualib/resty
