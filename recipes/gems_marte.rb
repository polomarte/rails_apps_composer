add_gem 'cocoon', '~> 1.2.6'
add_gem 'bourbon', '~>3.2.3' # Active Admin compat
add_gem 'draper', '~> 1.3'
add_gem 'jazz_hands', group:  [:development, :test], github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
add_gem 'pry-byebug'
add_gem 'pry-rescue', group: [:development, :test]
add_gem 'rails_12factor', group: [:production, :staging]
add_gem 'heroku-deflater', group: [:production, :staging]
add_gem 'activeadmin-wysihtml5', github: 'theo-bittencourt/activeadmin-wysihtml5'
add_gem 'formtastic-bootstrap', '~> 3.1.1'
add_gem 'pg_search', '~> 1.0.5'
add_gem 'figaro', '>= 1.0.0.rc1'
add_gem 'devise', '~>3.5.2'

__END__

name: gems_marte
description: "Additional gems."
author: polomarte

requires: [setup]
run_after: [setup]
category: configuration
