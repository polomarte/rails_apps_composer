# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/upload.rb

add_gem 'fog'
add_gem 'carrierwave'
add_gem 'mini_magick'
add_gem 'aws-sdk'

stage_three do
  say_wizard "recipe installing Carrierwave"

  # Copy default Carrierwave settings
  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'
  copy_from "#{repo}/carrierwave/settings.rb", 'config/initializers/carrierwave.rb'

# Copy default Carrierwave uploader
  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'
  copy_from "#{repo}/carrierwave/uploader.rb", 'app/uploaders/image_uploader.rb'

# Amazon Web Services Configuration
  require 'aws-sdk'

  AWS.config(
    access_key_id: ENV['POLOMARTE_COMPOSER_AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['POLOMARTE_COMPOSER_AWS_SECRET_ACCESS_KEY_ID']
  )

  s3 = AWS::S3.new
  s3.buckets.create("assets.production.#{prefs[:host_domain]}")
  s3.buckets.create("assets.staging.#{prefs[:host_domain]}")


  git add: '-A' if prefer :git, true
  git commit: '-qm "Add Upload settings"' if prefer :git, true
end

__END__

name: upload
description: "Add upload packages"
author: polomarte

requires: []
run_after: []
category: other
