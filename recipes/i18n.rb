# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/i18n.rb
add_gem 'globalize'
add_gem 'route_translator'

stage_three do
  say_wizard "recipe installing Route Translator"

  # Copy default Route Translator settings
  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'
  copy_from "#{repo}/i18n/route_translator.rb", 'config/initializers/route_translator.rb'

  # Copy default locale files
  copy_from "#{repo}/locales/models.pt-BR.yml", 'config/locales/models.pt-BR.yml'
  copy_from "#{repo}/locales/models.en.yml", 'config/locales/models.en.yml'

  copy_from "#{repo}/locales/admin.forms.pt-BR.yml", 'config/locales/admin.forms.pt-BR.yml'

  repo = 'https://raw.github.com/justinfrench/formtastic/master/'
  copy_from "#{repo}/lib/locale/en.yml", 'config/locales/admin.forms.en.yml'

  repo = 'https://raw.github.com/activeadmin/activeadmin/master'
  copy_from "#{repo}/config/locales/pt-BR.yml", 'config/locales/active_admin.pt-BR.yml'
  copy_from "#{repo}/config/locales/en.yml", 'config/locales/active_admin.en.yml'

  repo = 'https://raw.github.com/svenfuchs/rails-i18n/master'
  copy_from "#{repo}/rails/locale/pt-BR.yml", 'config/locales/rails.pt-BR.yml'
  copy_from "#{repo}/rails/locale/en.yml", 'config/locales/rails.en.yml'

  repo = 'https://raw.github.com/tigrish/devise-i18n/master'
  copy_from "#{repo}/locales/pt-BR.yml", 'config/locales/devise.pt-BR.yml'
  copy_from "#{repo}/locales/en.yml", 'config/locales/devise.en.yml'

  remove_file 'config/locales/pt-BR.yml'
  remove_file 'config/locales/en.yml'

  git add: '-A' if prefer :git, true
  git commit: '-qm "rails_apps_composer: Add i18n settings"' if prefer :git, true
end

__END__

name: i18n
description: "Add i18n packages"
author: polomarte

requires: []
run_after: []
category: other
