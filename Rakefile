require 'rspec/core/rake_task'
require 'rubygems'
require 'rake'

FileList['tasks/**/*.rake'].each { |task| import task }

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--color --format documentation'
end
