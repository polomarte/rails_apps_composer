# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/wysihtml5.rb

add_gem 'activeadmin-wysihtml5', github: 'mindvolt/activeadmin-wysihtml5'

stage_three do
  say_wizard "recipe config wysihtml5"

  # Copy default bower.json
  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'
  copy_from "#{repo}/inputs/default_wysiwyg_input.rb", 'app/inputs/default_wysiwyg_input.rb'

  append_to_file 'app/assets/stylesheets/active_admin.css.scss' do <<-FILE
// Fix wysihtml5 field
body.active_admin form .activeadmin-wysihtml5
  float: left !important

body.active_admin form li.default_wysiwyg
  overflow: auto
FILE
  end

  # Commit initial wysihtml5's settings
  git add: '-A' if prefer :git, true
  git commit: '-qm "Add wysihtml5 settings"' if prefer :git, true
end

__END__

name: wysihtml5
description: "Add wysihtml5 to active_admin"
author: polomarte

requires: []
run_after: [admin]
category: frontend
