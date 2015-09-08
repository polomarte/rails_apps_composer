# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/upload.rb
require 'aws-sdk-v1'

add_gem 'fog'
add_gem 'carrierwave'
add_gem 'mini_magick'
add_gem 'aws-sdk'

stage_two do
  # We have tried to put this into a "before_config" but this callback didn't work.
  say_wizard "recipe checking AWS credentials"

  aws_access_info = [
    ENV['POLOMARTE_COMPOSER_AWS_ACCESS_KEY_ID'],
    ENV['POLOMARTE_COMPOSER_AWS_SECRET_ACCESS_KEY_ID']]

  raise 'AWS access variables are not defined' if aws_access_info.any?(&:nil?)

  say_wizard "recipe installing Carrierwave"

  # Copy default Carrierwave settings
  repo = 'https://raw.github.com/polomarte/polomarte_composer/master'
  copy_from "#{repo}/carrierwave/settings.rb", 'config/initializers/carrierwave.rb'

  # Copy default Carrierwave uploader
  copy_from "#{repo}/carrierwave/uploader.rb", 'app/uploaders/image_uploader.rb'

  # Amazon Web Services Configuration
  AWS.config(
    access_key_id: ENV['POLOMARTE_COMPOSER_AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['POLOMARTE_COMPOSER_AWS_SECRET_ACCESS_KEY_ID'])

  # Create buckets
  s3 = AWS::S3.new

  production_bucket_name = "assets.production.#{prefs[:host_domain]}"
  staging_bucket_name = "assets.staging.#{prefs[:host_domain]}"
  s3.buckets.create production_bucket_name
  s3.buckets.create staging_bucket_name

  # Add CORS rules
  s3.buckets[production_bucket_name].cors.add({
      allowed_methods: %w(GET),
      allowed_origins: %w(*),
      allowed_headers: %w(Authorization),
      max_age_seconds: 3600
    }, {
      allowed_methods: %w(GET POST PUT),
      allowed_origins: ["http://#{prefs[:host_domain]}"],
      allowed_headers: %w(*),
      max_age_seconds: 3600})

  s3.buckets[staging_bucket_name].cors.add({
      allowed_methods: %w(GET),
      allowed_origins: %w(*),
      allowed_headers: %w(Authorization),
      max_age_seconds: 3600
    }, {
      allowed_methods: %w(GET POST PUT),
      allowed_origins: ["http://staging.#{prefs[:host_domain]}"],
      allowed_headers: %w(*),
      max_age_seconds: 3600})

  # Create AWS user for the project
  iam = AWS::IAM.new
  user = iam.users.create(@app_name)

  # Append access keys to application.yml
  keys = user.access_keys.create

  prefs[:aws_key_id]      = keys.id
  prefs[:aws_secret_key]  = keys.secret
  prefs[:staging_fog_dir] = staging_bucket_name
  prefs[:prod_fog_dir]    = production_bucket_name

  # Generate policy
  policy = AWS::IAM::Policy.new
  policy.allow(
    resources: [
      "arn:aws:s3:::#{production_bucket_name}",
      "arn:aws:s3:::#{production_bucket_name}/*",
      "arn:aws:s3:::#{staging_bucket_name}",
      "arn:aws:s3:::#{staging_bucket_name}/*"],
    actions: [
      's3:AbortMultipartUpload',
      's3:DeleteObject',
      's3:DeleteObjectVersion',
      's3:GetBucketAcl',
      's3:GetBucketCORS',
      's3:GetObject',
      's3:GetObjectAcl',
      's3:GetObjectVersion',
      's3:GetObjectVersionAcl',
      's3:ListBucket',
      's3:ListBucketMultipartUploads',
      's3:ListBucketVersions',
      's3:ListMultipartUploadParts',
      's3:PutObject',
      's3:PutObjectAcl',
      's3:PutObjectVersionAcl',
      's3:RestoreObject'])

  # Add policy to user
  user.policies["#{@app_name}_s3_access"] = policy

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
