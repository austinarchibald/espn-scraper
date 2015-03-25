require 'test_helper'

class ScheduleLeagueTest < EspnTest
  test 'NHL League Schedule' do
    VCR.use_cassette('test_NHL_League_Schedule') do
      games = ESPN::Schedule::League.find('nhl')
      assert_equal Date.new(2014, 9, 1), games.first
      assert_equal 246, games.count
    end
  end

  test 'NCF League Schedule' do
    VCR.use_cassette('test_NCF_League_Schedule') do
      games = ESPN::Schedule::League.find('ncf')
      assert_equal Date.new(2014, 8, 27), games.first
      assert_equal 75, games.count
    end
  end

  test 'NFL League Schedule' do
    VCR.use_cassette('test_NFL_League_Schedule') do
      games = ESPN::Schedule::League.find('nfl')
      assert_equal Date.new(2014, 8, 3), games.first
      assert_equal 71, games.count
    end
  end
end
