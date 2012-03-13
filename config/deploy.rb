set :application, "brokenlifts"
set :repository,  "git@github.com:sozialhelden/brokenlift.git"

set :use_sudo, false

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_via, :remote_cache
set :git_shallow_clone, 1

set :default_run_options, :pty => true # or else you'll get "sorry, you must have a tty to run sudo"

set :ssh_options, :keys => [ File.expand_path("~/.ssh/id_rsa"), File.expand_path("~/.ssh/id_dsa"), File.expand_path("~/.ssh/wheelmap_rsa") ], :forward_agent => true

set :user, 'rails'

role :web, "176.9.63.170"                          # Your HTTP server, Apache/etc
role :app, "176.9.63.170"                          # This may be the same as your `Web` server
role :db,  "176.9.63.170", :primary => true # This is where Rails migrations will run

set :port, 22022
set :deploy_to, "/var/apps/brokenlifts/production"

set :default_environment, {
  'PATH' => '/opt/ruby-enterprise/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games'
}

after  'deploy:setup',        'deploy:create_shared_config'
after  'deploy:update_code',  'deploy:symlink_configs'

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :create_shared_config do
    run "mkdir -p #{shared_path}/config/"
    run "mkdir -p #{shared_path}/tmp/cache"

    run "touch #{shared_path}/config/database.yml"
  end


  task :symlink_configs do
    run "ln -nfs #{shared_path}/tmp/var #{release_path}/tmp/var"
    run "ln -nfs #{shared_path}/tmp/cache #{release_path}/tmp/cache"

    %w(database.yml open_street_map.yml).each do |file|
      run "ln -nfs #{shared_path}/config/#{file} #{release_path}/config/#{file}"
    end
  end
end

namespace :unicorn do
  desc "Zero-downtime restart of Unicorn"
  task :restart, :except => { :no_release => true } do
    sudo "/etc/init.d/unicorn_brokenlifts_#{rails_env} restart"
  end

  desc "Start unicorn"
  task :start, :except => { :no_release => true } do
    sudo "/etc/init.d/unicorn_brokenlifts_#{rails_env} start"
  end

  desc "Stop unicorn"
  task :stop, :except => { :no_release => true } do
    sudo "/etc/init.d/unicorn_brokenlifts_#{rails_env} stop"
  end
  after "deploy:restart", "unicorn:restart"
end


# have builder check and install gems after each update_code
require 'bundler/capistrano'
set :bundle_without, [:development, :test, :metrics, :deployment]

# Set cronjob
require "whenever/capistrano"
set :whenever_command, "bundle exec whenever"
set :whenever_environment, :production
