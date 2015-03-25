$:.push File.expand_path("../lib", __FILE__)
require 'espn_scraper/version'

Gem::Specification.new do |s|
  s.name        = 'espn_scraper'
  s.version     = ESPN::VERSION
  s.date        = '2013-04-07'
  s.summary     = "ESPN Scraper"
  s.description = "a simple scraping api for espn stats and data"
  s.authors     = [ "aj0strow", "mikesilvis" ]
  s.email       = 'alexander.ostrow@gmail.com'
  s.homepage    = 'http://github.com/aj0strow/espn-scraper'

  s.add_dependency 'httparty'
  s.add_dependency 'nokogiri'
  s.add_dependency 'addressable'
  s.add_dependency 'activesupport'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'rr'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- test`.split("\n")
end
