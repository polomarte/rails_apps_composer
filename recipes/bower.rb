# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/bower.rb

stage_three do
  say_wizard "recipe installing Bower"

  # Copy default bower.json
  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'
  copy_from "#{repo}/bower/bower.json", 'bower.json'

  # Add project name to bower.json
  gsub_file 'bower.json', /"name": ""/, "\"name\": \"#{@app_const_base}\""

  # This dir will keep all libs sources and shouldn't be tracked by Git.
  Dir.mkdir 'bower_components'

  # Commit initial Bower's settings
  git add: '-A' if prefer :git, true
  git commit: '-qm "rails_apps_composer: Add Bower settings"' if prefer :git, true

  begin
    `bower-installer`

    git add: '-A' if prefer :git, true
    git commit: '-qm "Install bower.json packages"' if prefer :git, true
  rescue Errno::ENOENT
    say_loud 'bower', 'You need to install bower-installer to complete this recipe:'
    say_wizard 'https://www.npmjs.org/package/bower-installer'
  end
end

__END__

name: bower
description: "Add Bower and common packages"
author: polomarte

requires: []
run_after: []
category: frontend
