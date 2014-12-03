# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/heroku.rb

stage_three do
  say_wizard 'recipe config New Relic'

# Copy default bower.json
  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'
  copy_from "#{repo}/environment/newrelic.yml", 'config/newrelic.yml'
end

__END__

name: newrelic
description: "Add New Relic settings."
author: polomarte

requires: [heroku]
run_after: []
category: configuration
