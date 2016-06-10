# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/polomarte/rails_apps_composer/blob/master/recipes/upload.rb
require 'aws-sdk'

add_gem 'fog', '~>1.36.0'
add_gem 'carrierwave', '~>0.10.0'
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

  # Amazon Web Services Configuration
  Aws.config.update({
    region: 'us-east-1',
    credentials: Aws::Credentials.new(
      ENV['POLOMARTE_COMPOSER_AWS_ACCESS_KEY_ID'],
      ENV['POLOMARTE_COMPOSER_AWS_SECRET_ACCESS_KEY_ID'])})

  # Create buckets
  s3 = Aws::S3::Client.new(region: 'us-east-1')

  production_bucket_name = "assets.production.#{prefs[:host_domain]}"
  staging_bucket_name = "assets.staging.#{prefs[:host_domain]}"
  s3.create_bucket(bucket: production_bucket_name)
  s3.create_bucket(bucket: staging_bucket_name)

  # Add CORS rules
  Aws::S3::Bucket.new(production_bucket_name).cors.put({
    cors_configuration: {
      cors_rules: [
        {
          allowed_methods: %w(GET),
          allowed_origins: %w(*),
          allowed_headers: %w(Authorization),
          max_age_seconds: 3600
        },
        {
          allowed_methods: %w(GET POST PUT),
          allowed_origins: ["http://#{prefs[:host_domain]}"],
          allowed_headers: %w(*),
          max_age_seconds: 3600
        }
      ],
    }
  })

  Aws::S3::Bucket.new(staging_bucket_name).cors.put({
    cors_configuration: {
      cors_rules: [
        {
          allowed_methods: %w(GET),
          allowed_origins: %w(*),
          allowed_headers: %w(Authorization),
          max_age_seconds: 3600
        },
        {
          allowed_methods: %w(GET POST PUT),
          allowed_origins: ["http://staging.#{prefs[:host_domain]}"],
          allowed_headers: %w(*),
          max_age_seconds: 3600
        }
      ],
    }
  })

  # Create AWS user for the project
  iam_user = Aws::IAM::User.new(@app_name).create
  iam_user_keys = iam_user.create_access_key_pair

  prefs[:aws_key_id]      = iam_user_keys.access_key_id
  prefs[:aws_secret_key]  = iam_user_keys.secret_access_key
  prefs[:staging_fog_dir] = staging_bucket_name
  prefs[:prod_fog_dir]    = production_bucket_name

  # Generate policy
  iam_user.create_policy({
    policy_name: "#{@app_name}_s3_access",
    policy_document: "{
      \"Version\":\"2008-10-17\",
      \"Statement\":[{
        \"Effect\":\"Allow\",
        \"Resource\":[
          \"arn:aws:s3:::#{production_bucket_name}\",
          \"arn:aws:s3:::#{production_bucket_name}/*\",
          \"arn:aws:s3:::#{staging_bucket_name}\",
          \"arn:aws:s3:::#{staging_bucket_name}/*\"],
        \"Action\":[
          \"s3:AbortMultipartUpload\",\"s3:DeleteObject\",\"s3:DeleteObjectVersion\",\"s3:GetBucketAcl\",\"s3:GetBucketCORS\",\"s3:GetObject\",\"s3:GetObjectAcl\",\"s3:GetObjectVersion\",\"s3:GetObjectVersionAcl\",\"s3:ListBucket\",\"s3:ListBucketMultipartUploads\",\"s3:ListBucketVersions\",\"s3:ListMultipartUploadParts\",\"s3:PutObject\",\"s3:PutObjectAcl\",\"s3:PutObjectVersionAcl\",\"s3:RestoreObject\"]}]}"
  })

  git add: '-A' if prefer :git, true
  git commit: '-qm "rails_apps_composer: Add Upload settings"' if prefer :git, true
end

__END__

name: upload
description: "Add upload packages"
author: Outra Coisa

requires: []
run_after: []
category: other
