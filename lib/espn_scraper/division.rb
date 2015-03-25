module ESPN
  class Division
    attr_accessor :league

    def initialize(league)
      self.league = league
    end

    def self.find(league)
      new(league).get
    end

    def get(&block)
      markup.map do |div|
        division_name = div.at_css('.mod-header h4 text()').content
        if block
          yield(division_name, div)
        else
          division_name
        end
      end
    end

    private

    def markup
      @markup ||= ESPN.get(league, 'teams').css('.mod-teams-list-medium')
    end

    def parse_div_name(div)
      div.at_css('.mod-header h4 text()').content
    end
  end
end
