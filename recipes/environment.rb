# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/environment.rb

def repo
  'https://raw.github.com/polomarte/polomarte_composer/master'
end

def fetch_environment_files
  say_wizard "recipe copying environment files"

  # Copy default application.rb settings
  copy_from "#{repo}/environment/application.rb", 'config/application.rb'
  gsub_file 'config/application.rb', "module", "module #{@app_const_base}"

  # Copy default secrets settings
  copy_from "#{repo}/environment/secrets.yml", 'config/secrets.yml'

  # Copy default development settings
  copy_from "#{repo}/environment/development.rb", 'config/environments/development.rb'

  # Copy default staging settings
  copy_from "#{repo}/environment/staging.rb", 'config/environments/staging.rb'

  # Copy default production settings
  copy_from "#{repo}/environment/production.rb", 'config/environments/production.rb'

  git add: '-A' if prefer :git, true
  git commit: '-qm "rails_apps_composer: Fetch and update environment files from polomarte_composer repository"' if prefer :git, true
end

def fetch_devise_initializer
  say_wizard "recipe copying devise initializer"

  gsub_file 'config/initializers/devise.rb', "Rails.application.secrets.domain_name", "ENV['DOMAIN_NAME']"
  git add: '-A' if prefer :git, true
  git commit: '-qm "rails_apps_composer: Update Devise domain_name setting"' if prefer :git, true
end

def setup_application_yml
  say_wizard "recipe setting application.yml"

  # Copy default application.yml settings
  copy_from "#{repo}/environment/application.yml", 'config/application.yml'

  gsub_file 'config/application.yml', "{{admin_email}}",    "admin@#{prefs[:host_domain]}"
  gsub_file 'config/application.yml', "{{admin_password}}", "'**#{@app_name}**'"

  gsub_file 'config/application.yml', "{{host_name}}",    prefs[:host_domain]
  gsub_file 'config/application.yml', "{{staging_host}}", "staging.#{prefs[:host_domain]}"

  gsub_file 'config/application.yml', "{{dev_secret_key}}",     `rake secret`
  gsub_file 'config/application.yml', "{{test_secret_key}}",    `rake secret`
  gsub_file 'config/application.yml', "{{staging_secret_key}}", `rake secret`
  gsub_file 'config/application.yml', "{{prod_secret_key}}",    `rake secret`

  if recipe? 'upload'
    gsub_file 'config/application.yml', "{{aws_key_id}}",      prefs[:aws_key_id]
    gsub_file 'config/application.yml', "{{aws_secret_key}}",  prefs[:aws_secret_key]
    gsub_file 'config/application.yml', "{{staging_fog_dir}}", prefs[:staging_fog_dir]
    gsub_file 'config/application.yml', "{{prod_fog_dir}}",    prefs[:prod_fog_dir]
  end

  if recipe? 'heroku'
    gsub_file 'config/application.yml', "{{new_relic_key}}",        prefs[:new_relic_key]
    gsub_file 'config/application.yml', "{{rollbar_token}}",        prefs[:rollbar_token]
    gsub_file 'config/application.yml', "{{rollbar_token_client}}", prefs[:rollbar_token_client]
    gsub_file 'config/application.yml', "{{mandrill_username}}",    prefs[:mandrill_username]
    gsub_file 'config/application.yml', "{{mandrill_apikey}}",      prefs[:mandrill_apikey]
  end

  git add: '-A' if prefer :git, true
  git commit: '-qm "rails_apps_composer: Initial settings for config/application.yml"' if prefer :git, true
end

stage_three do
  fetch_environment_files
  fetch_devise_initializer if recipe? 'devise'
  setup_application_yml

  copy_from "#{repo}/environment/envrc", '.envrc'
  git add: '-A' if prefer :git, true
  git commit: '-qm "rails_apps_composer: Add .envrc"' if prefer :git, true

  remove_file 'app/services/create_admin_service.rb'
  git add: '-A' if prefer :git, true
  git commit: '-qm "rails_apps_composer: Remove file app/services/create_admin_service.rb"' if prefer :git, true
end

__END__

name: environment
description: "Change Environment files"
author: polomarte

requires: []
run_after: [init]
category: configuration
