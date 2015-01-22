set :stage, :production

# Server
# ======================
set :rvm_type, :system
set :host, "a8e.pea.nu"

# App
#========================
set :application, 'a8e'
set :scm, :git
set :branch, "master"
set :deploy_to, "/var/www/rails/#{fetch(:application)}"

# Roles
#========================
role :app, fetch(:host)
role :web, fetch(:host)
#role :db, fetch(:host), :primary => true

# serve
server fetch(:host), roles: [:web], user: 'deploy'
