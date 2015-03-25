require 'test_helper'

class ScheduleTeamTest < EspnTest
  def setup
    Timecop.travel(Date.parse('Nov 2nd 2014'))
  end

  def teardown
    Timecop.return
  end

  test 'NHL schedule' do
    VCR.use_cassette('test_NHL_schedule') do
      games = ESPN::Schedule::Team.find('nhl', 'pit')
      over_game = {
        over: true,
        date: Date.parse("Nov 4 2013"),
        opponent: 'min',
        opponent_name: 'Minnesota',
        result: '4-1',
        win: true,
        is_away: true,
      }
      assert_equal over_game, games[:games].detect { |g| g[:over] == true }

      scheduled_game = {
        over: false,
        date: Date.parse('Jan 2nd 2014'),
        opponent: 'tb',
        opponent_name: 'Tampa Bay',
        time: DateTime.parse('Jan 3rd 2014 0:00'),
        is_away: false
      }
      assert_equal scheduled_game, games[:games].detect { |g| g[:over] == false }
    end
  end

  test 'NFL schedule' do
    VCR.use_cassette('test_NFL_schedule') do
      games = ESPN::Schedule::Team.find('nfl', 'pit')

      over_game = {
        over: true,
        date: Date.parse('Nov 9th 2013'),
        opponent: 'nyj',
        opponent_name: 'New York',
        result: '20-13',
        win: false,
        is_away: true
      }
      assert_equal over_game, games[:games].detect { |g| g[:over] == true }

      scheduled_game = {
        over: false,
        date: Date.parse('Dec 7 2014'),
        opponent: 'cin',
        opponent_name: 'Cincinnati',
        time: DateTime.parse('7-12-2014 1:00 PM EST').utc,
        is_away: true
      }
      assert_equal scheduled_game, games[:games].detect { |g| g[:over] == false }
    end
  end

  test 'ncf schedule' do
    VCR.use_cassette('test_ncf_schedule') do
      games = ESPN::Schedule::Team.find('ncf', '213')

      expected = {
        over: true,
        date: Date.parse('Nov 8th 2013'),
        opponent: '84',
        opponent_name: 'Indiana',
        result: '13-7',
        win: true,
        is_away: true
      }

      assert_equal expected, games[:games].detect { |g| g[:over] == true }
    end
  end

  test 'nba schedule' do
    VCR.use_cassette('test_nba_schedule') do
      games = ESPN::Schedule::Team.find('nba', 'gs')

      expected = {
        :over=>true,
        :date=>Date.new(2013, 11, 5),
        :opponent=>"lac",
        :opponent_name=>"Los Angeles",
        :is_away=>false,
        :result=>"121-104",
        :win=>true
      }

      assert_equal expected, games[:games].detect { |g| g[:over] == true }
    end
  end

  test 'ncb schedule' do
    VCR.use_cassette('test_ncb_schedule') do
      games = ESPN::Schedule::Team.find('ncb', '213')

      expected = {
        :over=>true,
        :date=>Date.new(2013, 11 ,14),
        :opponent=>"2415",
        :opponent_name=>"Morgan St",
        :is_away=>false,
        :result=>"61-48",
        :win=>true
      }

      assert_equal expected, games[:games].detect { |g| g[:over] == true }
    end
  end
end
