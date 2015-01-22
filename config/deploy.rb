set :log_level, :info
set :user, 'deploy'
set :application, 'a8e'
set :repo_url, 'https://github.com/konstaleskela/a8e.git'
ask :branch, 'master'
set :runner, 'deploy'
set :app_server, :puma

# fixes for capistrano-puma
namespace :puma do
  desc 'Provision env before puma:start'
    task :fix_bug_env do
      set :rails_env, (fetch(:rails_env) || fetch(:stage))
    end

  before "puma:start", "puma:fix_bug_env"

  desc 'Create needed directories if nonexistent'
    task :create_directories do
      on roles(:app) do
        execute "mkdir -p #{shared_path}/tmp/sockets"
        execute "mkdir -p #{shared_path}/log"
      end
    end
  before "puma:start", :create_directories
end
