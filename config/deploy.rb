require 'capistrano/ext/multistage'
#require 'bundler/capistrano'

set :stages,          %w(prod)
#set :default_stage,   "prod"

set :default_shell, '/bin/bash -l'

set :application, "geop-website"

# 编译以后的代码所在的路径，就是要 deploy 的版本
set :repository,  "./build"

# 因为是直接编译的JS，所以没有用到 SCM
set :scm, :none

# deploy 复制文件的方式
set :deploy_via, :copy

# 压缩的方式
set :copy_compression,  :gzip

set :linked_dirs, %w{bin log tmp node_modules}

# 本地生成的压缩文件的路径
set :copy_dir, "/var/tmp"

set :default_environment, {
  'PATH' => "/usr/local/bin:$PATH",
}

# 部署时候不需要sudo
set :use_sudo, false

# 终端的类型
set :default_run_options, :pty => true

set :normalize_asset_timestamps, false
#

namespace :build do
  desc "build production release"
  task :release do
    run_locally "rm -rf ./build && mkdir -pv ./build/lib && ./node_modules/.bin/webpack && cp -Rv package.json index.html css js images build/  && cp -Rv #{pm2_file} build/"
    raise "build failed. Exit code: #{$?.exitstatus}" unless $?.exitstatus.zero?
  end
end

namespace :deploy do

  desc "start #{application}"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path}; DEBUG=geop* pm2 start ./#{pm2_file}"
  end

  desc "stop #{application}"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "DEBUG=geop* pm2 delete #{application} || echo OK"
  end

  desc "restart #{application}"
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    sleep 1
    start
  end

  desc "install nodejs dependency"
  task :npm_install do
    run "mkdir -p #{shared_path}/node_modules && ln -s #{shared_path}/node_modules #{release_path}/node_modules"
    run "cd #{release_path} && npm install --production " # --registry=https://registry.npm.taobao.org "
  end

end

after "deploy:update_code", "deploy:npm_install"
