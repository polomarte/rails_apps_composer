stage_two do
  say_wizard "setup Puma"

  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'

  copy_from "#{repo}/puma.rb", 'config/puma.rb'
  copy_from "#{repo}/Procfile", 'Procfile'

  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: setup Puma"' if prefer :git, true
end

__END__

name: puma
description: "Set up Puma"
author: Outra Coisa

requires: [setup, gems]
run_after: [setup, gems]
category: other
