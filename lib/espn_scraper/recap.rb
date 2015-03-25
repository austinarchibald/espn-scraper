module ESPN
  class Recap
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
      cache_key = "recap_cache_#{league}_#{game_id}"
      recap = if ESPN::Cache.read(cache_key)
                ESPN::Cache.read(cache_key)
              else
                get
              end

      ESPN::Cache.write(cache_key, recap) unless get[:content].match(/No recap/)

      recap
    end

    def get
      data[:content]  = markup.at_css('.article').css('p').map(&:content).join("\n")
      data[:headline] = markup.at_css('.headline h2').content.gsub("\u00A0", ' ')
      data[:url]      = "http://m.espn.go.com/#{league}/gamecast?gameId=#{game_id}&appsrc=sc"
      data[:game_id]  = self.game_id
      data[:league]   = self.league

      return data
    end

    private

    def markup
      @markup ||= ESPN.get path
    end

    def path
      @url ||= "#{league}/recap?gameId=#{game_id}"
    end
  end
end
