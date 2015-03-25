require 'rake/testtask'
require 'irb'
require 'irb/completion'
require_relative './lib/espn_scraper'
load 'lib/tasks/precache.rake'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/espn_scraper_test/*_test.rb', 'test/espn_scraper_test/schedule/*_test.rb']
  t.verbose = true
end

task default: :test

namespace :espn_scraper do
  desc 'Open a console with espn_scraper required'
  task :console do
    ARGV.clear
    IRB.start
  end
end
