require 'active_support'

module ESPN
  class Boxscore
    attr_accessor :league, :game_id, :data
    STATE_FOR_HTML = {
      'final' => 'postgame',
      'in' => 'in-progress'
    }

    def initialize(league, game_id)
      self.league = league
      self.game_id = game_id
      self.data = {}
    end

    def self.find(league, game_id)
      new(league, game_id).get_with_cache
    end

    def get_with_cache
      cache_key = "boxscore_cache_#{league}_#{game_id}"

      espn_boxscore = if ESPN::Cache.read(cache_key)
                        ESPN::Cache.read(cache_key)
                      else
                        get
                      end

      if espn_boxscore[:state] == 'postgame'
        ESPN::Cache.write(cache_key, espn_boxscore)
      end

      return get
    end

    def get
      ## Game Info
      info = markup.css('.game-time-location p')
      data[:game_date] = Time.parse(info.first.content)
      #return {} if data[:game_date] > DateTime.now

      data[:arena]     = info.last.content.gsub(/\u00A0/, '')
      data[:league]    = self.league
      data[:game_id]   = self.game_id

      game_state = markup.at_css('.game-state').content
      STATE_FOR_HTML.each do |k, _|
        data[:state] = STATE_FOR_HTML[k] if !!game_state.strip.downcase.match(/^#{k}/)
      end

      data[:time_remaining_summary] = markup.at_css('.game-state').content.strip

      ## Teams
      %w[home away].each do |team|
        team_markup = markup.css(".team.#{team} .team-info")
        data["#{team}_team".to_sym] = ESPN.parse_data_name_from(team_markup)
        data["#{team}_team_name".to_sym] = team_markup.at_css('h3 a').content

        position = team == 'home' ? 1 : 0
        data["#{team}_team_abbr".to_sym] = markup.css('.linescore .team').map(&:content)[1..2][position].gsub(/\n|\t/, '').strip

        if league == 'nhl'
          data["#{team}_team_score".to_sym] = team_markup.at_css(".gp-#{team}Score").content
          record = team_markup.at_css("##{team}Record").content
        else
          data["#{team}_team_score".to_sym] = team_markup.at_css("h3 span").content
          record = team_markup.at_css("p").content
        end

        data["#{team}_team_record".to_sym] = record.gsub(/\(|,(.*)$/, '')
      end

      ## Box score
      box_score = markup.css('.line-score-container .linescore tr')
      data[:score_summary] = []
      box_score.each_with_index do |score, i|
        data[:score_summary] << score.css('td').map do |string|
          next if string.attributes['class'] && string.attributes['class'].value == 'teamRank'

          if string.attributes['class'] && string.attributes['class'].value.match(/team/) && string.content.present?
            ESPN.parse_data_name_from(string)
          else
            string.content.strip unless string.attributes["style"] && string.attributes["style"].value.match(/display:none/)
          end

        end.compact
      end

      if markup.at_css('.game-vitals p').content.match(/Coverage/)
        data[:channel] = markup.at_css('.game-vitals p').content.gsub('Coverage: ', '')
      end

      data[:start_time] = markup.at_css('.game-time-location p:first').content
      data[:location]   = markup.at_css('.game-time-location p:last').content

      data[:game_stats] = game_stats_basketball if %w[nba ncb].include?(league)
      data[:game_stats] = game_stats_hockey if league == 'nhl'


      data[:score_detail] = if league == 'nhl'
                              score_detail_nhl
                            elsif %w[nfl ncf].include?(league)
                              score_detail_nfl
                            elsif league == 'mlb'
                              score_detail_mlb
                            end

      return data
    end

    private

    def game_stats_hockey
      headers = []
      away_stats = []
      home_stats = []

      ## All others
      markup.css('.mod-data.mod-pbp tr.even td table').each do |stat|
        header    = stat.at_css('strong').content
        away_stat = stat.css('tr')[1].content.gsub(/\u00A0/, '')
        home_stat = stat.css('tr')[2].content.gsub(/\u00A0/, '')

        if header.present? && away_stat.present? && home_stat.present?
          headers << header

          away_stats << away_stat
          home_stats << home_stat
        end
      end

      ## Power Play
      markup.css('.mod-container').each do |container|
        next unless container.at_css('.mod-header').try(:content).to_s.match(/Power/)
        headers << 'Power Play'

        container.css('tbody tr').each_with_index do |shots, index|
          total_shots = shots.css('td')[1].content
          empty_string = '0 of 0'

          away_stats << (total_shots.present? ? total_shots : empty_string) if index == 0
          home_stats << (total_shots.present? ? total_shots : empty_string) if index == 1
        end

      end

      return {
        header: headers,
        away_stats: away_stats,
        home_stats: home_stats
      }
    end

    def game_stats_basketball
      headers = []
      reject_keywords = ["TOTALS", "", "\u00A0"]

      markup.css('#my-players-table thead tr').each do |row|
        next unless row.content.match(/TOTALS/i)

        headers = row.css('th').map(&:content).reject do |c|
          reject_keywords.include?(c) || c.blank?
        end.map do |c|
          c.gsub(/\n/, '')
        end
      end

      stats = []
      markup.css('#my-players-table tr.even').each do |row|
        next unless row.at_css('td').content.empty?
        stats << row.css('td').map(&:content).reject { |c| c.blank? }
      end
      away_stats, home_stats = stats

      return {
        header: headers,
        away_stats: away_stats,
        home_stats: home_stats
      }
    end

    def score_detail_nfl
      css = '.mod-container.mod-open.mod-open-gamepack'

      score_detail_finder(css, 'th', 'td') do |content, index|
        case index
        when 0
          find_logo(content)
        when 1
          nil
        when 3
          content.children.first.content
        else
          content.content
        end
      end
    end

    def score_detail_mlb
      nhl_logo_finder
      scores = []

      markup.css('.mod-container.mod-open.mod-open-gamepack')[4].css('tr').each do |row|
        next if row.css('th').any?
        next if row.css('td').count < 3
        columns = row.children
        current_score = []

        cssKlass = columns[0].at_xpath('div').attributes['class'].value.split(' ')
        current_score << data[:away_team] if cssKlass.include? @away_team_class
        current_score << data[:home_team] if cssKlass.include? @home_team_class

        current_score << columns[1].content
        current_score << columns[2].content

        scores << current_score
      end

      return [{
        header_info: '',
        content_info: scores
      }]
    end

    def score_detail_nhl
      nhl_logo_finder

      summary_row = {}
      summary = markup.css('.mod-box .mod-data.mod-pbp')
      summary.css('tbody').each_with_index do |row, index|
        summary_row[index] = Array(summary_row[index])
        row.css('tr').each do |scores|
          content = []
          scores.css('td').each do |stuff|
            if stuff.at_xpath('div')
              cssKlass = stuff.at_xpath('div').attributes['class'].value.split(' ')
              content << data[:away_team] if cssKlass.include? @away_team_class
              content << data[:home_team] if cssKlass.include? @home_team_class
            else
              content << stuff.content.split(' ').map(&:strip).join(' ')
            end
          end

          ## Fix Order
          if content[1] && content[1].match(/^Shootout/)
            updated_content = [content[0], '', content[1]]
            content = updated_content
          else
            updated_content = [content[1], content[0], content[2]]
            content = updated_content
          end

          summary_row[index] << content.compact.map(&:strip)
        end
      end

      score_detail = []
      summary.css('thead').each_with_index do |header, i|
        header_info = begin
                        header.at_css('.mod-header').content
                      rescue
                        header.css('tr th').last.content
                      end

        score_detail << {
          header_info: header_info.titleize,
          header_row: header.css('tr th').map(&:content),
          content_info: summary_row[i],
          penalty_info: (header_info == 'Penalty Detail')
        }
      end

      return score_detail.select do |h|
        !h[:penalty_info]
      end.reject do |hash|
        hash[:content_info][0][1] == 'No scoring this period'
      end
    end

    def score_detail_finder(table_css, header_css, content_css,  &block)
      summary = markup.at_css(table_css)
      score_detail = []

      current_section = 0
      summary.css('tr').each_with_index do |row, index|
        if row.at_css(header_css)
          score_detail << {
            header_info: row.at_css(header_css).content.titleize,
            content_info: []
          }

          current_section = score_detail.count
        else
          content = []
          row.css(content_css).each_with_index do |box, i|
            content << yield(box, i)
          end

          score_detail[current_section - 1][:content_info] << content.compact.map(&:strip).take(3)
        end
      end

      return score_detail
    end

    def find_logo(specific_markup)
      if league == 'nfl'
        specific_markup.at_css('img').attributes['alt'].content
      else
        specific_markup.at_css('div').attributes["class"].value.match(/teamId-\d*/).to_s.gsub(/\D/, '')
      end
    end

    def nhl_logo_finder
      markup.css('.team-color-strip th').each do |potential_logo|
        next unless potential_logo.content.match(/#{data[:away_team_name]}|#{data[:home_team_name]}/)
        klass = potential_logo.at_xpath('div').attributes['class'].value.match(/\w*-small-\d*/).to_s
        @away_team_class = klass if potential_logo.content.match(data[:away_team_name])
        @home_team_class = klass if potential_logo.content.match(data[:home_team_name])
      end
    end

    def markup
      @markup ||= ESPN.get "#{league}/boxscore?gameId=#{game_id}"
    end
  end
end
