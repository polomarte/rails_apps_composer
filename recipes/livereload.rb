# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/livereload.rb
#
# Middleware insertion is already done in environment.rb recipe

add_gem 'listen', '~> 3.0.5', group: :development
add_gem 'rack-livereload', '~> 0.3.16', group: :development
add_gem 'guard-livereload', '~> 2.3.0', group: :development, require: false
add_gem 'rb-fsevent', '~> 0.9.7', group: :development, require: false

stage_three do
  say_wizard "recipe config Rack-Livereload"

  # Commit initial Livereload's settings
  git add: '-A' if prefer :git, true
  git commit: '-qm "Add Livereload settings"' if prefer :git, true
end

__END__

name: livereload
description: "Add Livereload packages"
author: Outra Coisa

requires: []
run_after: []
category: development
