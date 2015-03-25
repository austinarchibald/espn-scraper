module ESPN::Schedule
  class Team
    attr_accessor :league, :name

    def initialize(league, name)
      self.league = league
      self.name   = name
    end

    def self.find(league, team)
      new(league, team).get_with_cache
    end

    def get_with_cache
      ESPN::Cache.fetch("by_team_#{league}_#{name}", expires_in: 1.day) do
        get
      end
    end

    def get
      data = {}
      data[:league]     = self.league
      data[:team_name]  = self.name

      data[:games] = markup.css('.oddrow, .evenrow').map do |row|
        tds = row.xpath('td')
        next if tds.count == 1
        next if row.content.match(/BYE WEEK/)
        next if tds[2].content.match(/Postponed|Canceled/)

        {}.tap do |game_info|
          starting_index = league == 'nfl' ? 1 : 0
          time_string = "#{tds[starting_index + 2].content.match(/^\d*:\d\d (PM|AM)/)} EST"
          time = (Time.parse(time_string) rescue nil) if !time_string.match(/^[WL]/)
          is_over = !time && !tds[starting_index + 2].content.match(/TBD|TBA|Half/)
          date = Date.parse("#{tds[starting_index].content} #{Date.today.year}")

          game_info[:over] = is_over
          game_info[:date] = if !is_over && Date.today > date
                               date + 1.year
                             else
                               date
                             end

          game_info[:date] = if is_over && Date.today < date
                               date - 1.year
                             else
                               date
                             end

          game_info[:opponent] = ESPN.parse_data_name_from(tds[starting_index + 1])
          game_info[:opponent_name] = tds[(starting_index.to_i + 1)].at_css('.team-name').content.to_s.gsub(/#\d*/, '').strip
          game_info[:is_away] = !!tds[(starting_index.to_i + 1)].content.match(/^@/)

          if is_over
            game_info[:result] = tds[starting_index + 2].at_css('.score').content.strip
            game_info[:win]    = tds[starting_index + 2].at_css('.game-status').content == 'W'
          else
            game_info[:time] = DateTime.parse("#{game_info[:date].to_s} #{time_string}").utc
          end

        end
      end.compact.sort_by do |game|
        game[:date]
      end

      return data
    end

    private

    def by
      %w[ncf ncb].include?(league) ? 'id' : 'name'
    end

    def markup
      @markup ||= ESPN.get "#{league}/team/schedule/_/#{by}/#{name}"
    end
  end
end
