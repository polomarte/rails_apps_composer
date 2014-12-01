# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/heroku.rb

stage_three do
  say_wizard 'recipe config Heroku'
end

__END__

name: heroku
description: "Add Heroku to your application."
author: polomarte

requires: []
run_after: [environment]
category: configuration
