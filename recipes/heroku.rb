# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/heroku.rb

require 'heroku-api'

stage_three do
  say_wizard 'recipe config Heroku'

  prefs[:heroku_app_name_staging] = "#{prefs[:heroku_app_name]}-staging"

  say_wizard 'recipe adding pgbackups on production and staging'
  run "heroku addons:add pgbackups:auto-month -a #{prefs[:heroku_app_name]}"
  run "heroku addons:add pgbackups:auto-month -a #{prefs[:heroku_app_name_staging]}"

  say_wizard 'recipe adding newrelic'
  run "heroku addons:add newrelic:stark -a #{prefs[:heroku_app_name]}"

  say_wizard 'recipe adding rollbar'
  run "heroku addons:add rollbar -a #{prefs[:heroku_app_name]}"

  say_wizard 'recipe adding logentries'
  run "heroku addons:add logentries:tryit -a #{prefs[:heroku_app_name]}"

  say_wizard 'recipe adding memcachier'
  run "heroku addons:add memcachier:dev -a #{prefs[:heroku_app_name]}"

  say_wizard 'recipe adding mandrill'
  run "heroku addons:add mandrill:starter -a #{prefs[:heroku_app_name]}"

  say_wizard 'recipe adding mailtrap'
  run "heroku addons:add mailtrap -a #{prefs[:heroku_app_name_staging]}"

  heroku_api   = Heroku::API.new
  vars         = heroku_api.get_config_vars(prefs[:heroku_app_name]).body
  vars_staging = heroku_api.get_config_vars(prefs[:heroku_app_name_staging]).body

  prefs[:new_relic_key]        = vars['NEW_RELIC_LICENSE_KEY']
  prefs[:rollbar_token]        = vars['ROLLBAR_ACCESS_TOKEN']
  prefs[:rollbar_token_client] = "GO TO THE ROLLBAR DASHBOARD AND GET ONE"
  prefs[:mandrill_username]    = vars['MANDRILL_USERNAME']
  prefs[:mandrill_apikey]      = vars['MANDRILL_APIKEY']

  # Allow domains
  heroku_api.post_domain(prefs[:heroku_app_name], prefs[:host_domain])
  heroku_api.post_domain(prefs[:heroku_app_name_staging], "stating.#{prefs[:host_domain]}")
end

__END__

name: heroku
description: "Add Heroku to your application."
author: polomarte

requires: []
run_after: []
run_before: [environment]
category: configuration
