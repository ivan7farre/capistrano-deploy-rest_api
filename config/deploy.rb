# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'rest_api'
set :repo_url, 'git@github.com:ivan7farre/rest_api.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/rest_api'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug
#set :log_level, :info

# Default value for :pty is false
# set :pty, true

server "54.75.44.224", user: "deploy", roles: %w{web app db}

set :pty, true

set :ssh_options, {
  forward_agent: true,
  auth_methods: ["publickey"],
  keys: ["/$PATH/id_rsa"]
}
#set :default_env, { rbenv_bin_path: '~/.rbenv/shims' }
#SSHKit.config.command_map[:rake] = "/home/deploy/.rbenv/shims/rake"
SSHKit.config.command_map[:bundle] = "/home/deploy/.rbenv/shims/bundle"

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
#set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
set :default_env, { path: "/home/deploy/.rbenv/shims:/home/deploy/.rbenv/bin:$PATH" }
set :default_shell, '/bin/bash -l'

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  #task :migrations, :roles => :db do
  #  puts "RUNNING DB MIGRATIONS"
  #  run "cd #{current_path}; rake db:migrate RAILS_ENV=#{rails_env}"
  #end

  #after :restart, :clear_cache do
  #  on roles(:web), in: :groups, limit: 3, wait: 10 do
  #    # Here we can do anything such as:
  #    # within release_path do
  #    #   execute :rake, 'cache:clear'
  #    # end
  #  end
  #end
end

namespace :setup do
  desc "First deploy tasks"
  task :all do
    invoke 'deploy'
    invoke 'setup:install_gems'
    invoke 'db:upload_db_yml'
    invoke 'db:migrate'
    invoke 'unicorn:start'
  end

  desc "Check gems"
  task :check_gems do
    on roles(:app) do
      #execute "cd #{current_path}; bundle check"
      within "#{current_path}" do
        execute :bundle, "check" 
      end
    end
  end

  desc "Install gems"
  task :install_gems do
    on roles(:app) do
      within "#{current_path}" do
        #execute "cd #{current_path}; bundle install --path .bundle"
        execute :bundle, "install" 
      end
    end
  end
end

namespace :db do

  desc "Upload database.yml file."
  task :upload_db_yml do
    on roles(:app) do
      #execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/database.yml")), "#{current_path}/config/database.yml"
    end
  end

  desc "Create the database"
  task :migrate do
    on roles(:db) do
      within "#{current_path}" do
        execute :rake, "db:migrate"
      end
    end
  end

end

namespace :unicorn do

  desc "Start unicorn"
  task :start do
    on roles(:app) do
      puts "restarting unicorn..."
      execute "sudo /etc/init.d/unicorn-rest_api start"
    end
  end

end

