require File.expand_path('lib/data_mapper/noisy_failures/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'sbf-dm-noisy-failures'
  s.version     = DataMapper::NoisyFailures::VERSION
  s.required_ruby_version = '>= 2.7.8'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['opensource_firespring']
  s.email       = ['opensource@firespring.com']
  s.homepage    = 'https://github.com/dtao/dm-noisy-failures'
  s.summary     = 'Noisy (and descriptive) failures for DataMapper'
  s.description = 'This library replaces the default behavior of DataMapper by raising exceptions with descriptive error messages whenever DB ' \
                  'operations are not successfully completed.'
  s.license     = 'MIT'

  s.add_dependency 'data_mapper'
  s.files        = Dir['{lib}/**/*.rb']
  s.require_path = 'lib'
  s.add_runtime_dependency('sbf-dm-core',     '~> 1.3.0.beta')
end
