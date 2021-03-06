#!/bin/bash

chown -R nginx:nginx /var/www

read -p "Enter domain name : " domain

doc="$""document_root""$""fastcgi_script_name";

cat > /etc/nginx/conf.d/$domain.conf << EOF
server {
        listen 80;
        server_name $domain www.$domain;
        root /var/www/$domain/public_html/;
        index index.html index.php index.htm;
        
        location / {
                try_files $uri $uri/ /index.php?$args;
                
        }
        
        location ~ \.php$ {
            fastcgi_pass unix:/run/php/php8.0-fpm.sock; 
            fastcgi_param SCRIPT_FILENAME $doc;
            include fastcgi_params;
            include snippets/fastcgi-php.conf;
        }
        
        location ~ /\.ht {
                deny all;
        }
        
}
EOF

nginx -t
