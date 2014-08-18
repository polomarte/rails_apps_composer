# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/heroku.rb

  add_gem 'rails_12factor', :group => [:production, :staging]
  add_gem 'heroku-deflater', :group => [:production, :staging]

__END__

name: heroku
description: "Add Heroku to your application."
author: polomarte

requires: []
run_after: []
category: configuration
