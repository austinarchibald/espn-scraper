require 'test_helper'

class NhlTest < EspnTest
  def setup
    any_instance_of(ESPN::Score) do |klass|
      stub(klass).teams { ["nyr", "stl", "dal", "chi", "tor", "nj", "ott", "ana", "nyi", "bos", "cbj", "det", "nsh", "cgy", "buf", "tb", "min", "wpg", 'buf', 'pit', 'cgy', 'fla'] }
    end
  end

  test 'final: nhl rangers beat bruins on valentines day' do
    VCR.use_cassette('nhl-final') do
      day = Date.parse('Feb 14, 2012')
      expected = {
        game_date: day,
        away_team_name: 'Rangers',
        home_team_name: 'Bruins',
        away_team_record: '37-13-5',
        home_team_record: '34-18-2',
        away_team: 'nyr',
        home_team: 'bos',
        away_score: 3,
        home_score: 0,
        state: 'postgame',
        ended_in: 'Final',
        :boxscore=>"400047109",
        league: 'nhl'
      }
      score = ESPN::Score.find('nhl', day).first
      assert_equal expected, score
    end
  end

  # This test is fragile and needs to be cached
  test 'pregame: pens vs boston on saturday november 8th' do
    VCR.use_cassette('nhl-pregame') do
      day = Date.parse('Nov 8, 2014')
      expected = {
        :game_date => day,
        :away_team_name =>'Penguins',
        :home_team_name =>'Sabres',
        :away_team_record =>'9-2-1',
        :home_team_record =>'3-10-2',
        :away_team =>'pit',
        :home_team =>'buf',
        :away_score =>0,
        :home_score =>0,
        :state =>'pregame',
        :start_time =>'7:00 PM ET',
        :line =>'BUF +285',
        :preview=>"400563813",
        :league =>'nhl'
      }
      pregame = ESPN::Score.find('nhl', day).detect { |s| s[:away_team_name] == 'Penguins' }
      assert_equal expected, pregame
    end
  end

   #This test is fragile and needs to be cached
  test 'in-progress: panthers vs flames at intermission' do
    VCR.use_cassette('nhl-in-progress-intermission') do
      day = Date.parse('Nov 8, 2014')
      expected = {
        :game_date => day,
        :away_team_name=>"Flames",
        :home_team_name=>"Panthers",
        :away_team_record=>"8-5-2",
        :home_team_record=>"4-3-4",
        :away_team=>"cgy",
        :home_team=>"fla",
        :away_score=>3,
        :home_score=>4,
        :state=>"in-progress",
        :progress=>"2nd, End",
        :time_remaining=>"",
        :boxscore=>"400564209",
        :league=>"nhl"
      }
      score = ESPN::Score.find('nhl', day).detect { |s| s[:away_team_name] == 'Flames' }
      assert_equal expected, score
    end
  end

  test 'in-progress: panthers vs flames at start of third' do
    VCR.use_cassette('nhl-in-progress-middle-of-third') do
      day = Date.parse('Nov 8, 2014')
      expected = {
        :game_date => day,
        :away_team_name=>"Flames",
        :home_team_name=>"Panthers",
        :away_team_record=>"8-5-2",
        :home_team_record=>"4-3-4",
        :away_team=>"cgy",
        :home_team=>"fla",
        :away_score=>3,
        :home_score=>4,
        :state=>"in-progress",
        :progress=>"3rd",
        :time_remaining=>"15:47",
        :boxscore=>"400564209",
        :league=>"nhl"
      }
      score = ESPN::Score.find('nhl', day).detect { |s| s[:away_team_name] == 'Flames' }
      assert_equal expected, score
    end
  end

  test 'random nhl dates' do
    random_days.each do |day|
      scores = ESPN::Score.find('nhl', day)
      assert all_names_present?(scores), 'Error on #{day} for nhl'
    end
  end

  test 'getting scores for a team that doesnt exist' do
    VCR.use_cassette('scores for a team that does not exist') do
      day = Date.new(2015, 1, 25)

      assert_equal [], ESPN::Score.find('nhl', day)
    end
  end

end
