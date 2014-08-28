# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/tests_extra.rb

say_wizard "recipe adding extra test gems"

add_gem 'spring-commands-rspec', group: :development
add_gem 'capybara-email', group: :test
add_gem 'timecop', group: :test
add_gem 'poltergeist', group: :test
add_gem 'simplecov', group: :test, require: false

stage_two do
  say_wizard "recipe installing spring-commands-rspec"
  run 'bundle exec spring binstub rspec'

  say_wizard 'Coping spec helper'
  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'
  copy_from "#{repo}/tests/spec_helper.rb", 'spec/spec_helper.rb'

  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: extra testing framework"' if prefer :git, true
end

__END__

name: tests_extra
description: "Add extra testing framework to your application."
author: polomarte

requires: []
run_after: [tests]
category: testing

