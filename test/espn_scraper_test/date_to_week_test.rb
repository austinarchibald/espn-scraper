require 'test_helper'

class DateToWeekTest < EspnTest
  test 'NCF Schedule Date To Week' do
    VCR.use_cassette(__method__) do
      schedule = ESPN::DateToWeek.find('ncf', Date.new(2014, 9, 27))
      path = "ncf/scoreboard?confId=80&seasonYear=2014&seasonType=2&weekNumber=5"

      assert_equal path, schedule.uri
    end
  end

  test 'NCF Schedule post season' do
    VCR.use_cassette(__method__) do
      schedule = ESPN::DateToWeek.find('ncf', Date.new(2014, 12, 27))
      path = "ncf/scoreboard?confId=80&seasonYear=2014&seasonType=3&weekNumber=17"

      assert_equal path, schedule.uri
    end
  end

  test 'NFL Schedule Date To Week' do
    VCR.use_cassette(__method__) do
      schedule = ESPN::DateToWeek.find('nfl', Date.new(2014, 9, 27))
      path = "nfl/scoreboard?seasonYear=2014&seasonType=2&weekNumber=4"

      assert_equal path, schedule.uri
    end
  end

end
