source 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

gem 'puppetlabs_spec_helper'
gem 'puppet-lint'
gem 'facter'
gem 'rspec-puppet'
gem 'semantic_puppet' if RUBY_VERSION < '4.0.0'

if RUBY_VERSION < '1.9'
  gem 'rspec', '~> 2.0'
  gem 'rake', '~> 0.9.6'
else
  gem 'rspec'
  gem 'rake'
end

if RUBY_VERSION < '2.0.0' && RUBY_VERSION >= '1.9.3'
  gem 'rubocop', '~> 0.41.2'
  gem 'metadata-json-lint', '~> 1.1.0'
else
  gem 'rubocop'
  gem 'metadata-json-lint'
end

if RUBY_VERSION < '2.1'
  gem 'public_suffix', '~> 1.0.0'
else
  gem 'public_suffix'
end
