if ENV['CI_GENERATE_REPORTS'] == 'true'
  require 'ci/reporter/rake/rspec'
  task :rspec => 'ci:setup:rspec'
end

namespace :ci do
  desc 'rspec generates build report'
  task :all => ['ci:setup:rspec', 'spec']
end

