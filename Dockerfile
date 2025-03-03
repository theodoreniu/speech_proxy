FROM openresty/openresty:alpine

# Install OpenSSL development package
RUN apk add --no-cache openssl-dev

# Copy install script
COPY install_deps.sh /tmp/
RUN chmod +x /tmp/install_deps.sh && /tmp/install_deps.sh

# Copy configuration files
COPY conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY lua /usr/local/openresty/nginx/lua/

# Create necessary directories
RUN mkdir -p /usr/local/openresty/lualib/resty

EXPOSE 8080

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]