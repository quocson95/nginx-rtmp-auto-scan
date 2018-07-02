# NGINX systemd service file
touch  /lib/systemd/system/nginx.service 
cat <<EOF > /lib/systemd/system/nginx.service 
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target
 
[Service]
Type=forking
PIDFile=/server/nginx/logs/nginx.pid
ExecStartPre=/server/nginx/sbin/nginx -t
ExecStart=/server/nginx/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true
 
[Install]
WantedBy=multi-user.target
EOF
systemctl enable nginx
systemctl start nginx
