get '/' do
    'Nitza Dynamic DNS!'
end

# = ToDo
# This must be protect with password!
get '/ganti' do

    # nginx minimum config
    puts "request ip: #{request.ip}"

    "server {

        server_name your.domain.com;

        location / {
            proxy_pass http://#{request.ip}:3023;
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
end
