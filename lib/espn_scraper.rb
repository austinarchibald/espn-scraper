%w[ boilerplate team score standing boxscore schedule recap preview date_to_week cache photo division ].each do |file|
  require_relative "espn_scraper/#{file}"
end

require_relative 'espn_scraper/schedule/league'
require_relative 'espn_scraper/schedule/team'

require_relative 'espn_scraper/railtie' if defined?(Rails)
require 'byebug' if ENV['RACK_ENV'] == 'development'

module ESPN
  LEAGUES = [
    NHL = 'nhl',
    NBA = 'nba',
    NCF = 'ncf',
    MLB = 'mlb',
    NFL = 'nfl',
    NCB = 'ncb'
  ]
end
