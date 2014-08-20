# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/heroku.rb

add_gem 'rails_12factor', group: [:production, :staging]
add_gem 'heroku-deflater', group: [:production, :staging]
add_gem 'heroku', group: :development

stage_two do
  git add: '-A' if prefer :git, true
  git commit: '-qm "rails_apps_composer: Add Heroku settings"' if prefer :git, true
end

__END__

name: heroku
description: "Add Heroku to your application."
author: polomarte

requires: []
run_after: []
category: configuration
