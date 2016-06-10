add_gem 'martian_components', github: 'polomarte/martian_components', branch: 'master'

stage_two do
  say_wizard "setup Martian Components"

  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'

  say_wizard "copying db data files"
  copy_from "#{repo}/db/components_builder.rb", 'db/data/components_builder.rb'
  copy_from "#{repo}/db/xxx_components.rb", "db/data/#{Time.now.strftime('%Y%m%d%H%M%S')}_components.rb"

  say_wizard "copying db migrations"
  copy_from "#{repo}/db/xxx_create_components.rb", "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_components.rb"
  copy_from "#{repo}/db/xxx_create_images.rb", "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_images.rb"
  copy_from "#{repo}/db/xxx_create_gallery_assets.rb", "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_gallery_assets.rb"

  say_wizard "copying admin files"
  copy_from "#{repo}/admin/component.rb", "app/admin/component.rb"
  copy_from "#{repo}/admin/page_components.rb", "app/admin/page_components.rb"

  say_wizard "adding components helper"
  insert_into_file 'app/helpers/application_helper.rb', after: 'module ApplicationHelper' do
    "\n  include MartianComponents::ComponentsHelper"
  end

  say_wizard "copying assets"
  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'
  copy_from "#{repo}/assets.zip", 'assets.zip'
  `unzip assets.zip -d app`
  `rm assets.zip`

  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: setup Martian Components"' if prefer :git, true
end

__END__

name: martian_components
description: "Set up some Martian Components requirements"
author: Outra Coisa

requires: [setup, gems, gems_marte]
run_after: [setup, gems, gems_marte]
category: other
