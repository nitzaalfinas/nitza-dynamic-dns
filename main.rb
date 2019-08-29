get '/' do
    'Nitza Dynamic DNS!'
end

# = ToDo
# This must be protect with password!
# == Params
# port
#
get '/ganti' do

    puts "port #{params[:port]}"

    # nginx minimum config
    puts "request ip: #{request.ip}"

    `sudo rm /etc/nginx/sites-available/#{DOMAIN_NAME}`

    file_name = "#{APP_DATA_FOLDER}/#{DOMAIN_NAME}"

    # remove file before writing a new one
    `rm #{file_name}`

    file = File.open(file_name, "w")

    file.puts "
    server {

        server_name #{DOMAIN_NAME};

        location / {
            proxy_pass http://#{request.ip}:#{params[:port]};
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;

            # tambahkan ini jika ingin melihat remote address dari user (client)
            proxy_set_header   X-Real-IP          $remote_addr;
            proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;

            proxy_cache_bypass $http_upgrade;

            # tambahkan ini jika menggunakan https
            proxy_set_header X-Forwarded-Proto https;

            error_log  /var/log/nginx/#{DOMAIN_NAME}-error.log;
            access_log /var/log/nginx/#{DOMAIN_NAME}-access.log;
        }

	listen 443 ssl; # managed by Certbot
        ssl_certificate /etc/letsencrypt/live/#{DOMAIN_NAME}/fullchain.pem; # managed by Certbot
        ssl_certificate_key /etc/letsencrypt/live/#{DOMAIN_NAME}/privkey.pem; # managed by Certbot
        include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
    }
    
    server {
        if ($host = #{DOMAIN_NAME}) {
            return 301 https://$host$request_uri;
        } # managed by Certbot



        server_name #{DOMAIN_NAME};
        listen 80;
        return 404; # managed by Certbot
    } 
    "

    file.close

    `sudo mv #{file_name} /etc/nginx/sites-available/#{DOMAIN_NAME}`

    `sudo chown root:root /etc/nginx/sites-available/#{DOMAIN_NAME}`

    `sudo systemctl reload nginx.service`

    "selesai"
end
