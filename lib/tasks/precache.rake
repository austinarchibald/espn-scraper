namespace :espn_scraper do
  desc 'Precaches all the necessary objects.'
  task :precache do
    ESPN::Cache.precache
  end
end
