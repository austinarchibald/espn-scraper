module ESPN
  class Preview
    attr_accessor :league, :game_id, :data

    def self.find(league, game_id)
      new(league, game_id).get_with_cache
    end

    def initialize(league, game_id)
      self.league = league
      self.game_id = game_id
      self.data = {}
    end

    def get_with_cache
      ESPN::Cache.fetch("get_preview_#{league}_#{game_id}", expires_in: 1.day) do
        league == 'nba' ? get_updated : get
      end
    end

    def get_updated
      data[:content]    = markup.at_css('.article-body').css('p').map(&:content).join("\n")
      data[:headline]   = markup.at_css('.article-header h1').content
      data[:url]        = ESPN.url(path)
      data[:game_id]    = self.game_id
      data[:league]     = self.league
      data[:start_time] = markup.at_css('.time')

      data[:home_team_name]   = markup.at_css('.top-col.home .teamname a').content
      data[:home_team]        = markup.at_css('.top-col.home .teamshortname a').content
      data[:away_team]        = markup.at_css('.top-col.away .teamshortname a').content
      data[:away_team_name]   = markup.at_css('.top-col.away .teamname a').content
      data[:away_team_record] = markup.at_css('.top-col.away .record').content.gsub("\n", '').gsub("\t", '').strip
      data[:home_team_record] = markup.at_css('.top-col.home .record').content.gsub("\n", '').gsub("\t", '').strip

      return data
    end

    def get
      data[:content]  = markup.at_css('.article').css('p').map(&:content).join("\n")
      data[:headline] = markup.at_css('.headline h2').content
      data[:url]      = ESPN.url(path)
      data[:game_id]  = self.game_id
      data[:league]   = self.league

      markup.at_css('.game-time-location').children.tap do |game_info|
        data[:start_time] = game_info.first.content
        data[:location] = game_info.last.content
      end

      ['.team.home', '.team.away'].each do |team_css|
        team_location = team_css.gsub('.team.', '')
        team_markup = markup.at_css(team_css)
        data["#{team_location}_team_name".to_sym] = team_markup.at_css('.team-info h3 a').content
        data["#{team_location}_team".to_sym] = ESPN.parse_data_name_from(team_markup.at_css('.team-info h3'))

        record_regex = /\d*-\d/
        if league == 'nhl'
          data["#{team_location}_team_record".to_sym] = team_markup.at_css("##{team_location}Record").content.match(record_regex).to_s
        else
          data["#{team_location}_team_record".to_sym] = team_markup.at_css('.team-info p').content.match(record_regex).to_s
        end
      end

      # Series
      data[:series] = [].tap do |series|
        markup.css('.series-dropdown table').each_with_index do |series_markup, game_index|
          next unless series_markup.at_css('tr:nth-child(2) td:nth-child(3)').content.match(/Final/)
          game_content = {}

          series_markup.css('tr').each_with_index do |row, row_index|
            if row_index == 0
              game_content[:date] = Date.parse(row.content.gsub(/Game \d:/, '').strip)
            elsif row_index == 1
              game_content[:away_team] = ESPN.parse_data_name_from(row)
              game_content[:away_team_score] = row.at_css('.score').content
            elsif row_index == 2
              game_content[:home_team] = ESPN.parse_data_name_from(row)
              game_content[:home_team_score] = row.at_css('.score').content
            elsif row_index == 3
              game_content[:boxscore] = ESPN.parse_game_id_from(row.at_css('a:last'))
            end
          end

          series[game_index] = game_content
        end
      end

      if markup.at_css('.game-vitals p').content.match(/Coverage/)
        data[:channel] = markup.at_css('.game-vitals p').content.gsub('Coverage: ', '')
      end

      return data
    end

    private

    def markup
      @markup ||= ESPN.get path
    end

    def path
      "#{league}/preview?gameId=#{game_id}"
    end
  end
end
