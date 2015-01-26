set :log_level, :info
set :user, 'deploy'
set :application, 'a8e'
set :repo_url, 'https://github.com/nles/a8e.git'
ask :branch, 'master'
set :runner, 'deploy'
set :app_server, :puma
