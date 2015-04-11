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
        get
      end
    end

    def get
      data[:content]    = markup.at_css('.article-body').css('p').map(&:content).join("\n")
      data[:headline]   = markup.at_css('.article-header h1').content
      data[:url]        = ESPN.url(path)
      data[:game_id]    = self.game_id
      data[:league]     = self.league

      data[:home_team_name]   = markup.at_css('.top-col.home span.teamname').content.strip
      data[:home_team]        = markup.at_css('.top-col.home span.teamshortname').content.strip.downcase
      data[:away_team]        = markup.at_css('.top-col.away span.teamshortname').content.strip.downcase
      data[:away_team_name]   = markup.at_css('.top-col.away span.teamname').content.strip
      data[:away_team_record] = markup.at_css('.top-col.away .record').content.gsub("\n", '').gsub("\t", '').strip
      data[:home_team_record] = markup.at_css('.top-col.home .record').content.gsub("\n", '').gsub("\t", '').strip

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
