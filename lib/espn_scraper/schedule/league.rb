module ESPN::Schedule
  class League
    attr_accessor :league

    def initialize(league)
      self.league = league
    end

    def self.find(league)
      new(league).get_with_cache
    end

    def get_with_cache(just_keys = true)
      return (Date.new(2014, 9, 1)..Date.new(2015, 5, 4)).to_a if league == 'nhl'
      return (Date.new(2014, 9, 1)..Date.new(2015, 5, 4)).to_a if league == 'ncb'
      return (Date.new(2014, 9, 1)..Date.new(2015, 5, 4)).to_a if league == 'nba'
      return (Date.new(2015, 3, 5)..Date.new(2015, 10, 1)).to_a if league == 'mlb'

      games = ESPN::Cache.fetch("date_and_uri_#{league}", expires_in: 1.year) do
        get
      end

      games = games.keys.sort if just_keys
      games
    end

    def get
      {}.tap do |hash|
        weeks.each do |week|
          uri = base_uri + week.attributes['href'].value
          next if week.content.match(/All-Star/) && league == 'ncf'

          ESPN.get(uri).css('h4.games-date').each do |game_date|
            date = if game_date.content == "Today's Games"
                     Time.now.in_time_zone("Mountain Time (US & Canada)").to_date
                   else
                     Date.parse(game_date.content)
                   end

            hash[date] = uri
          end
        end
      end
    end

    def base_uri
      "#{league}/scoreboard"
    end

    def seasons
      @seasons ||= markup.css('.seasontype a')
    end

    def weeks
      @weeks ||= if league == 'nfl'
                   seasons.map do |season|
                     ESPN.get(base_uri + season.attributes['href'].value).css('.week a')
                   end.flatten + markup.css('.week a')
                 else
                   markup.css('.week a')
                 end
    end

    private

    def markup
      @markup ||= ESPN.get "#{league}/scoreboard"
    end
  end
end
