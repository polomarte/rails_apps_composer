# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/heroku.rb

require 'platform-api'

stage_three do
  say_wizard 'recipe config Heroku'

  prefs[:heroku_app_name_staging] = "#{prefs[:heroku_app_name]}-staging"

  if recipes.include? 'newrelic'
    say_wizard 'recipe adding newrelic'
    run "heroku addons:create newrelic:wayne -a #{prefs[:heroku_app_name]}"
  end

  if recipes.include? 'rollbar'
    say_wizard 'recipe adding rollbar'
    run "heroku addons:create rollbar:free -a #{prefs[:heroku_app_name]}"
  end

  say_wizard 'recipe adding logentries'
  run "heroku addons:create logentries:le_tryit -a #{prefs[:heroku_app_name]}"

  say_wizard 'recipe adding memcachier'
  run "heroku addons:create memcachier:dev -a #{prefs[:heroku_app_name]}"

  say_wizard 'recipe adding mandrill'
  run "heroku addons:create mandrill:basic -a #{prefs[:heroku_app_name]}"

  say_wizard 'recipe adding mailtrap'
  run "heroku addons:create mailtrap:free -a #{prefs[:heroku_app_name_staging]}"

  heroku_api = PlatformAPI.connect_oauth(ENV['OUTRACOISA_HEROKU_API_KEY'])

  vars         = heroku_api.config_var.info(prefs[:heroku_app_name])
  vars_staging = heroku_api.config_var.info(prefs[:heroku_app_name_staging])

  prefs[:new_relic_key]        = vars['NEW_RELIC_LICENSE_KEY']
  prefs[:rollbar_token]        = vars['ROLLBAR_ACCESS_TOKEN']
  prefs[:rollbar_token_client] = "GO TO THE ROLLBAR DASHBOARD AND GET ONE"
  prefs[:mandrill_username]    = vars['MANDRILL_USERNAME']
  prefs[:mandrill_apikey]      = vars['MANDRILL_APIKEY']

  # Allow domains
  heroku_api.domain.create(prefs[:heroku_app_name], {hostname: prefs[:host_domain]})
  heroku_api.domain.create(prefs[:heroku_app_name_staging], {hostname: "staging.#{prefs[:host_domain]}"})
end

__END__

name: heroku
description: "Add Heroku to your application."
author: Outra Coisa

requires: []
run_after: []
run_before: [environment]
category: configuration
