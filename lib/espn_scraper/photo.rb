require 'active_support'

module ESPN
  class Photo
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
      ESPN::Cache.fetch("get_photo_#{league}_#{game_id}", expires_in: 1.day) do
        get
      end
    end

    def get
      data[:photos] = markup.css('.photo-index img').map do |photo|
        photo.attributes['src'].value.match(/^.*(.jpg)/).to_s
      end

      data[:url]      = ESPN.url(path)
      data[:game_id]  = self.game_id
      data[:league]   = self.league

      return data
    end


    private

    def markup
      @markup ||= ESPN.get last_page
    end

    def markup
      @markup||= begin
                   if first_page.css('.photo-nav a').count > 0
                     ESPN.get(first_page.css('.photo-nav a').reject { |a| a.content.match(/Next/) }.last.attributes['href'].value)
                   else
                     first_page
                   end
                 end
    end

    def first_page
      @first_page ||= ESPN.get(path)
    end

    def path
      @url ||= "#{league}/photos?gameId=#{game_id}"
    end
  end
end
