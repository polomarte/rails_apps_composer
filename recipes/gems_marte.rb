add_gem 'draper', '~> 1.3'
add_gem 'jazz_hands',
  group:  [:development, :test],
  github: 'nixme/jazz_hands',
  branch: 'bring-your-own-debugger'
add_gem'pry-byebug'
add_gem 'pry-rescue', group: [:development, :test]
add_gem 'rails_12factor', group: [:production, :staging]
add_gem 'heroku-deflater', group: [:production, :staging]
add_gem 'heroku', group: :development

__END__

name: gems_marte
description: "Additional gems."
author: polomarte

requires: [setup]
run_after: [setup]
category: configuration
