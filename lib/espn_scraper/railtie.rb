require 'rails'
require 'active_support'

module ESPN
  class Railtie < Rails::Railtie
    railtie_name :espn_scraper

    rake_tasks do
      load "tasks/precache.rake"
    end
  end
end
