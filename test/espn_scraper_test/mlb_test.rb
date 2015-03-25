require 'test_helper'

class MlbTest < EspnTest

  test 'mlb august 13th yankees beat rangers' do
    VCR.use_cassette(__method__) do
      day = Date.parse('Aug 13, 2012')
      expected = {
        :game_date=>day,
        :away_team_name=>"Rangers",
        :home_team_name=>"Yankees",
        :away_team_record=>"67-47",
        :home_team_record=>"68-47",
        :away_team=>"tex",
        :home_team=>"nyy",
        :away_score=>2,
        :home_score=>8,
        :state=>"postgame",
        :ended_in=>"Final",
        :boxscore=>"320813110",
        :league=>"mlb"
      }
      scores = ESPN::Score.find('mlb', day)
      assert_equal expected, scores.first
    end
  end

  test 'mlb pregame' do
    VCR.use_cassette(__method__) do
      day = Date.parse('March 6, 2015')
      expected = {
        :game_date=>day,
        :away_team_name=>"Royals",
        :home_team_name=>"Indians",
        :away_team_record=>"0-0",
        :home_team_record=>"0-1",
        :away_team=>"kc",
        :home_team=>"cle",
        :away_score=>0,
        :home_score=>0,
        :state=>"pregame",
        :start_time=>"3:05 PM ET",
        :preview=>"",
        :league=>"mlb"
      }
      scores = ESPN::Score.find('mlb', day)
      assert_equal expected, scores.first
    end
  end

  test 'mlb in progress' do
    VCR.use_cassette(__method__) do
      day = Date.parse('March 4, 2015')
      expected = {
        :game_date=>day,
        :away_team_name=>"Reds",
        :home_team_name=>"Indians",
        :away_team_record=>"1-0",
        :home_team_record=>"0-1",
        :away_team=>"cin",
        :home_team=>"cle",
        :away_score=>2,
        :home_score=>1,
        :league=>"mlb"
      }
      scores = ESPN::Score.find('mlb', day)
      assert_equal expected, scores.first
    end
  end

end
