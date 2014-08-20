# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/gon.rb

add_gem "gon"

stage_three do
  say_wizard "recipe adding gon"

  if prefer :templates, 'slim'
    # Add gon to app.
    insert_into_file 'app/views/layouts/application.html.slim', after: 'csrf_meta_tags' do
    "\n
    == include_gon\n"
    end
  else
    # Add gon to app.
    insert_into_file 'app/views/layouts/application.html.erb', after: '</title>' do
    "\n
    <%= include_gon %>\n"
    end
  end

  git add: '-A' if prefer :git, true
  git commit: '-qm "Add gon gem"' if prefer :git, true

end

__END__

name: gon
description: "Add Gon gem"
author: polomarte

requires: []
run_after: []
category: other
