FROM ubuntu:18.04

RUN apt-get update && apt-get install -y gcc git make g++ libssl-dev  libpcre3 libpcre3-dev zlib1g-dev wget

RUN mkdir -p /server/nginx/sbin \
mkdir -p /server/nginx/conf \
mkdir -p /server/conf \
mkdir /source


RUN cd /source && wget https://nginx.org/download/nginx-1.14.0.tar.gz && \
 tar -xzf nginx-1.14.0.tar.gz && git clone https://github.com/arut/nginx-rtmp-module.git && \
# RUN git clone https://github.com/gnolizuh/BLSS.git BLSS
# RUN ./configure --sbin-path=/server/nginx/sbin/nginx --prefix=/server/nginx/  --add-module=/source/BLSS  --with-http_mp4_module  --with-pcre  --with-http_ssl_module
	cd nginx-1.14.0 && ./configure --sbin-path=/server/nginx/sbin/nginx --prefix=/server/nginx/  --add-module=/source/nginx-rtmp-module  --with-http_mp4_module  --with-pcre  --with-http_ssl_module && \
make -j7 && make install

# Set ENV
ENV nginx_conf /server/conf/
#Copy nginx configuration
# COPY nginx.conf ${nginx_conf}
COPY start.sh /start.sh
RUN chmod +x /start.sh
# COPY web ui
# COPY www /server/www
RUN rm -rf /source
EXPOSE 80 443 8997 8080
# ENTRYPOINT ["/start.sh"]
CMD ["/server/nginx/sbin/nginx","-c", "/server/conf/nginx.conf", "-g", "daemon off;"]

