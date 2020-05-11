
ssh_options[:port] = 22


set :user, "deployer"
#set :host, "104.156.245.211"
set :host, "13.209.209.124"

set :mode, "production"

set :deploy_to, "/var/www/apps/#{application}"

set :path_to_log, "#{current_path}/log/#{application}.log"
set :path_to_err, "#{current_path}/log/#{application}_err.log"
set :path_to_pid, "#{current_path}/#{application}.pid"
set :path_to_main_script, "#{current_path}/lib/server.min.js"

set :pm2_file, "pm2.json"

role :web, host
role :app, host


# refresh build every deployment
before "deploy", "build:release"
