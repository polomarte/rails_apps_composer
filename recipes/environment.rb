# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/environment.rb

stage_three do
  say_wizard "recipe coping environment files"

  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'

  # Copy default application.rb settings
  copy_from "#{repo}/environment/application.rb", 'config/application.rb'

  gsub_file 'config/application.rb', "module", "module #{@app_const_base}"

  # Copy default application.yml settings
  copy_from "#{repo}/environment/application.yml", 'config/application.yml'

  # Copy default secrets settings
  copy_from "#{repo}/environment/secrets.yml", 'config/secrets.yml'

  # Copy default development settings
  copy_from "#{repo}/environment/development.rb", 'config/environments/development.rb'

  # Copy default staging settings
  copy_from "#{repo}/environment/staging.rb", 'config/environments/staging.rb'

  # Copy default production settings
  copy_from "#{repo}/environment/production.rb", 'config/environments/production.rb'
end

__END__

name: environment
description: "Change Environment files"
author: polomarte

requires: []
run_after: [init]
category: configuration
