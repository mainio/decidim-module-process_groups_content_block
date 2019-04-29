# frozen_string_literal: true

source "https://rubygems.org"

require_relative "lib/decidim/process_groups_content_block/version"

ruby RUBY_VERSION

gem "decidim", Decidim::ProcessGroupsContentBlock::DECIDIM_VERSION
gem "decidim-process_groups_content_block", path: "."

gem "bootsnap", "~> 1.3"
gem "puma", "~> 3.0"
gem "uglifier", "~> 4.1"

group :development, :test do
  gem "byebug", "~> 10.0", platform: :mri

  gem "decidim-dev", Decidim::ProcessGroupsContentBlock::DECIDIM_VERSION
end

group :development do
  gem "faker", "~> 1.9"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end

group :test do
  gem "codecov", require: false
end
