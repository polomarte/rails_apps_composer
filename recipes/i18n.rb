# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/i18n.rb
add_gem 'globalize'
add_gem 'route_translator'

stage_three do
  say_wizard "recipe installing Route Translator"

  # Copy default Carrierwave settings
  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'
  copy_from "#{repo}/i18n/route_translator.rb", 'config/initializers/route_translator.rb'

  git add: '-A' if prefer :git, true
  git commit: '-qm "Add i18n settings"' if prefer :git, true
end

__END__

name: i18n
description: "Add i18n packages"
author: polomarte

requires: []
run_after: []
category: other
