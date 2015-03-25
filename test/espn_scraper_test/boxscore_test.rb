require 'test_helper'

class BoxscoreTest < EspnTest
  test 'in progress NHL boxscore' do
    VCR.use_cassette(__method__) do
      boxscore = ESPN::Boxscore.find('nhl', '400564048')
      assert_equal Hash, boxscore.class
      assert_equal 'in-progress', boxscore[:state]
      assert_equal 5, boxscore[:score_summary].first.size
      assert_equal 5, boxscore[:score_summary].first.size
      assert_equal 1, boxscore[:score_detail].size
      assert_equal 1, boxscore[:score_detail].first[:content_info].size
      assert_equal 'SPNET', boxscore[:channel]
    end
  end

  test 'NHL boxscore' do
    VCR.use_cassette(__method__) do
      boxscore = ESPN::Boxscore.find('nhl', '400564325')
      assert_equal Hash, boxscore.class
      assert_equal 'postgame', boxscore[:state]
      assert_equal 3, boxscore[:score_summary].size
      assert_equal 6, boxscore[:score_summary].first.size
      assert_equal 4, boxscore[:score_detail].size
      assert_equal 5, boxscore[:score_detail].first[:content_info].size
      assert_equal 'SPNET', boxscore[:channel]
    end
  end

  test 'NFL boxscore' do
    VCR.use_cassette(__method__) do
      boxscore = ESPN::Boxscore.find('nfl', '400554293')
      assert_equal Hash, boxscore.class
      assert_equal 'postgame', boxscore[:state]
      assert_equal 3, boxscore[:score_summary].size
      assert_equal 6, boxscore[:score_summary].first.size
      assert_equal 4, boxscore[:score_detail].size
      assert_equal 1, boxscore[:score_detail].first[:content_info].size
    end
  end

  test 'ncf boxscore' do
    VCR.use_cassette(__method__) do
      boxscore = ESPN::Boxscore.find('ncf', '400548328')
      assert_equal Hash, boxscore.class
      assert_equal 'postgame', boxscore[:state]
      assert_equal 3, boxscore[:score_summary].size
      assert_equal 6, boxscore[:score_summary].first.size
      assert_equal 3, boxscore[:score_detail].size
      assert_equal 3, boxscore[:score_detail].first[:content_info].size
    end
  end

  test 'ncb boxscore' do
    VCR.use_cassette(__method__) do
      boxscore = ESPN::Boxscore.find('ncb', '400588423')
      assert_equal Hash, boxscore.class
      assert_equal 'in-progress', boxscore[:state]
      assert_equal 3, boxscore[:score_summary].size
      assert_equal 4, boxscore[:score_summary].first.size
      assert_equal nil, boxscore[:score_detail]
      assert_equal 'FOXS1', boxscore[:channel]
      assert_equal 12, boxscore[:game_stats][:away_stats].size
    end
  end

  test 'nba boxscore' do
    VCR.use_cassette(__method__) do
      boxscore = ESPN::Boxscore.find('nba', '400489474')
      assert_equal Hash, boxscore.class
      assert_equal 'postgame', boxscore[:state]
      assert_equal 3, boxscore[:score_summary].size
      assert_equal 6, boxscore[:score_summary].first.size
      assert_equal nil, boxscore[:score_detail]
      assert_equal 'TSN', boxscore[:channel]
      assert_equal 12, boxscore[:game_stats][:away_stats].size
    end
  end

  test 'mlb boxscore' do
    VCR.use_cassette(__method__) do
      boxscore = ESPN::Boxscore.find('mlb', '350303111')
      assert_equal 'OAK', boxscore[:home_team_abbr]
      assert_equal Hash, boxscore.class
      assert_equal 'postgame', boxscore[:state]
      assert_equal 3, boxscore[:score_summary].size
      assert_equal 13, boxscore[:score_summary].first.size
      # TODO: score detail should not be nil
      assert_equal nil, boxscore[:score_detail]
      assert_equal nil, boxscore[:channel]
    end
  end
end
