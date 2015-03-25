module ESPN
  class DateToWeek
    attr_accessor :league,
                  :date,
                  :game_dates

    def initialize(league, date)
      self.league = league
      self.date   = date
    end

    def self.find(league, date)
      new(league, date)
    end

    def uri
      closest_game
    end

    def closest_game
      return self.game_dates[date] if self.game_dates[date]

      closest_date = self.game_dates.keys.sort.detect do |game_date|
        (game_date > date)
      end

      return self.game_dates[closest_date]
    end

    def game_dates
      @game_dates ||= ESPN::Schedule::League.new(league).get_with_cache(false)
    end
  end
end
