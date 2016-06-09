add_gem 'rollbar'

def repo
  'https://raw.github.com/polomarte/polomarte_composer/master'
end

stage_three do
  run "rails generate rollbar #{prefs[:rollbar_token]}"

  if prefer :templates, 'slim'
    copy_from "#{repo}/views/_rollbar.slim", 'app/views/layouts/_rollbar.slim'

    insert_into_file 'app/views/layouts/application.html.slim', before: "== javascript_include_tag 'application'" do
      "== render 'layouts/rollbar'\n    "
    end
  else
    say 'Template setting is not Slim. Add layouts/_rollbar manually'
  end

  git add: '-A' if prefer :git, true
  git commit: '-qm "rails_apps_composer: Rollbar setup"' if prefer :git, true
end

__END__

name: rollbar
description: "Change Environment files"
author: polomarte

requires: [heroku, frontend]
run_after: [heroku, frontend]
category: configuration
