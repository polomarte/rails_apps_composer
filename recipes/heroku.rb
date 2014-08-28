# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/heroku.rb

add_gem 'rails_12factor', group: [:production, :staging]
add_gem 'heroku-deflater', group: [:production, :staging]
add_gem 'heroku', group: :development

stage_three do
  say_wizard "recipe config Heroku keys"

  gsub_file 'config/application.yml', "__host_domain", "#{prefs[:host_domain]}"
  gsub_file 'config/application.yml', "__aws_key_id", "#{prefs[:aws_key_id]}"
  gsub_file 'config/application.yml', "__aws_secret_key", "#{prefs[:aws_secret_key]}"
  gsub_file 'config/application.yml', "admin@domain_name", "admin@#{prefs[:host_domain]}"
  gsub_file 'config/application.yml', "**app_name**", "**#{@app_name}**"
  gsub_file 'config/application.yml', "__new_relic_key", "#{prefs[:new_relic_key]}"
  gsub_file 'config/application.yml', "__rollbar_token", "#{prefs[:rollbar_token]}"
  gsub_file 'config/application.yml', "__rollbar_token_client", "#{prefs[:rollbar_token_client]}"

  gsub_file 'config/application.yml', "__dev_mailtrap_user", "#{prefs[:dev_mailtrap_user]}"
  gsub_file 'config/application.yml', "__dev_mailtrap_password", "#{prefs[:dev_mailtrap_password]}"
  gsub_file 'config/application.yml', "__dev_secret_key", "#{prefs[:dev_secret_key]}"

  gsub_file 'config/application.yml', "__test_secret_key", "#{prefs[:test_secret_key]}"

  gsub_file 'config/application.yml', "__staging_host", "#{prefs[:staging_host]}"
  gsub_file 'config/application.yml', "__staging_fog_dir", "#{prefs[:staging_fog_dir]}"
  gsub_file 'config/application.yml', "__staging_mailtrap_user", "#{prefs[:staging_mailtrap_user]}"
  gsub_file 'config/application.yml', "__staging_mailtrap_pwd", "#{prefs[:staging_mailtrap_pwd]}"
  gsub_file 'config/application.yml', "__staging_secret_key", "#{prefs[:staging_secret_key]}"

  gsub_file 'config/application.yml', "__prod_host", "#{prefs[:prod_host]}"
  gsub_file 'config/application.yml', "__prod_fog_dir", "#{prefs[:prod_fog_dir]}"
  gsub_file 'config/application.yml', "__prod_mailtrap_user", "#{prefs[:prod_mailtrap_user]}"
  gsub_file 'config/application.yml', "__prod_mailtrap_pwd", "#{prefs[:prod_mailtrap_pwd]}"
  gsub_file 'config/application.yml', "__prod_secret_key", "#{prefs[:prod_secret_key]}"

  git add: '-A' if prefer :git, true
  git commit: '-qm "rails_apps_composer: Add Heroku settings"' if prefer :git, true
end

__END__

name: heroku
description: "Add Heroku to your application."
author: polomarte

requires: []
run_after: [environment]
category: configuration
