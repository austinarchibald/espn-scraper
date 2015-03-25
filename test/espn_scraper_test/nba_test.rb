require 'test_helper'

class NbaTest < EspnTest
  def setup
    any_instance_of(ESPN::Score) do |klass|
      stub(klass).teams { ['bkn', 'bos', 'tor', 'lal', 'sac', 'por', 'chi', 'cle'] }
    end
  end

  test 'nba december 25th celtics beat nets' do
    VCR.use_cassette(__method__) do
      day = Date.parse('Dec 25, 2012')
      expected = {
        :game_date=>day,
        :home_team=>"bkn",
        :home_team_name=>"Nets",
        :away_team=>"bos",
        :away_team_name=>"Celtics",
        :home_score=>76,
        :away_score=>93,
        :home_team_rank=>"",
        :away_team_rank=>"",
        :home_team_record=>"14-13",
        :away_team_record=>"14-13",
        :state=>"postgame",
        :ended_in=>"Final",
        :boxscore=>"400278125",
        :league=>"nba"
      }

      scores = ESPN::Score.find('nba', day)
      assert_equal expected, scores.first
    end
  end

  test 'nba pregame' do
    VCR.use_cassette(__method__) do
      day = Date.new(2015, 01, 19)

      expected = {
        :game_date=>day,
        :home_team=>"por",
        :home_team_name=>"Trail Blazers",
        :away_team=>"sac",
        :away_team_name=>"Kings",
        :home_score=>0,
        :away_score=>0,
        :home_team_rank=>"",
        :away_team_rank=>"",
        :home_team_record=>"30-11",
        :away_team_record=>"16-24",
        :state=>"pregame",
        :start_time=>"10:00 PM ET",
        :preview=>"400578913",
        :line=>"POR -9.5 O/U 206",
        :league=>"nba"
      }

      scores = ESPN::Score.find('nba', day)

      assert_equal expected, scores.detect { |s| s[:state] == 'pregame' }
    end
  end

  test 'nba postgame' do
    VCR.use_cassette(__method__) do
      day = Date.new(2014, 01, 19)

      expected = {
        :game_date=>day,
        :home_team=>"tor",
        :home_team_name=>"Raptors",
        :away_team=>"lal",
        :away_team_name=>"Lakers",
        :home_score=>106,
        :away_score=>112,
        :home_team_rank=>"",
        :away_team_rank=>"",
        :home_team_record=>"20-19",
        :away_team_record=>"16-25",
        :state=>"postgame",
        :ended_in=>"Final",
        :boxscore=>"400489474",
        :league=>"nba"
      }

      scores = ESPN::Score.find('nba', day)

      assert_equal expected, scores.detect { |s| s[:state] == 'postgame' }
    end
  end

  test 'nba inprogress' do
    VCR.use_cassette(__method__) do
      day = Date.new(2015, 1, 19)

      expected = {
        :game_date=>day,
        :home_team=>"cle",
        :home_team_name=>"Cavaliers",
        :away_team=>"chi",
        :away_team_name=>"Bulls",
        :home_score=>77,
        :away_score=>59,
        :home_team_rank=>"",
        :away_team_rank=>"",
        :home_team_record=>"21-20",
        :away_team_record=>"27-15",
        :state=>"in-progress",
        :time_remaining=>"2:55",
        :progress=>"3rd Qtr",
        :boxscore=>"400578912",
        :league=>"nba"
      }

      scores = ESPN::Score.find('nba', day)

      assert_equal expected, scores.detect { |s| s[:state] == 'in-progress' }
    end
  end

end
