# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/livereload.rb

add_gem "rack-livereload", group: :development
add_gem "guard-livereload", group: :development, require: false

stage_three do
  say_wizard "recipe config Rack-Livereload"

  # Add rack-livereload configuration.
  insert_into_file 'config/environments/development.rb', after: 'Rails.application.configure do' do
  "\n
  config.middleware.insert_after(ActionDispatch::Static, Rack::LiveReload)\n"
  end

  # Commit initial Livereload's settings
  git add: '-A' if prefer :git, true
  git commit: '-qm "Add Livereload settings"' if prefer :git, true
end

__END__

name: livereload
description: "Add Livereload packages"
author: polomarte

requires: [tests]
run_after: [tests]
category: development
