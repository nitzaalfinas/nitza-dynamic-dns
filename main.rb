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

    file = File.open("/etc/nginx/sites-available/#{DOMAIN_NAME}")

    file.puts "server {

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
            #proxy_set_header X-Forwarded-Proto https;

            #error_log  /var/log/nginx/app-error.log;
            #access_log /var/log/nginx/app-access.log;
        }
    }"

    file.close
end
