add_gem 'activeadmin', github: 'gregbell/active_admin', tag: 'v1.0.0.pre1'

stage_two do
  say_wizard "recipe installing activeadmin"
  generate 'active_admin:install'

  say_wizard "copying assets.rb to initializer"
  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'
  copy_from "#{repo}/initializers/assets.rb", 'config/initializers/assets.rb'

  git :add => '-A' if prefer :git, true
  git :commit => %Q(-qm "rails_apps_composer: installed Active Admin") if prefer :git, true
end

__END__

name: activeadmin
description: "Adding rails admin gem to your application"
author: Outra Coisa

category: admin
requires: [setup]
run_after: [setup]
