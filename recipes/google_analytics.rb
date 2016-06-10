stage_two do
  say_wizard "recipe adding Google Analytics"
  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'
  copy_from "#{repo}/views/_analytics.slim", 'app/views/layouts/_analytics.slim'

  insert_into_file 'app/views/layouts/application.html.slim', before: '== stylesheet_link_tag "application"' do
    "\n    == render 'layouts/analytics' if Rails.env.production?\n    "
  end

  git :add => '-A' if prefer :git, true
  git :commit => %Q(-qm "rails_apps_composer: add Google Analytics") if prefer :git, true
end

__END__

name: google_analytics
description: "Adding Google Analytics"
author: Outra Coisa

category: other
requires: [setup, extras, frontend]
run_after: [setup, extras, frontend]
