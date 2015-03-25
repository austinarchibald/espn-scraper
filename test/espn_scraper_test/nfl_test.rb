require 'test_helper'

class NflTest < EspnTest
  def setup
    any_instance_of(ESPN::Score) do |klass|
      stub(klass).teams {
        ["gb", "buf", "cin", "ind", "mia", "ne", "nyg", "phi", "car", "jac", "stl", "sea", "pit", "sd", "sf", "atl", "chi", "kc", "cle", "min", "oak", "ari", "tb", "bal", "no", "hou", "wsh", "dal", "nyj", "ten", "det", "den"]
      }
    end
  end

  #test 'data names are fixed' do
    #VCR.use_cassette('data names') do
      #score = ESPN::Score.get_nfl_scores(2012, 2).first
      #assert_equal 'gb', score[:home_team]
    #end
  #end

  test 'getting NFL scores by date' do
    VCR.use_cassette(__method__) do
      expected = {
        :game_date=>Date.parse('Oct 6, 2014'),
        :home_team=>"wsh",
        :home_team_name=>"Redskins",
        :away_team=>"sea",
        :away_team_name=>"Seahawks",
        :home_score=>17,
        :away_score=>27,
        :home_team_rank=>"",
        :away_team_rank=>"",
        :away_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/nfl/500/sea.png&w=200&h=200&transparent=true",
        :home_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/nfl/500/wsh.png&w=200&h=200&transparent=true",
        :home_team_record=>"1-4",
        :away_team_record=>"3-1",
        :state=>"postgame",
        :ended_in=>"Final",
        :boxscore=>"400554282",
        :league=>"nfl"
      }

      scores = ESPN::Score.find('nfl', Date.new(2014, 10, 6))
      assert_equal expected, scores.last
    end
  end

  #test 'nfl 2012 week 8 regular season' do
    #VCR.use_cassette('nfl-final week 8') do
      #expected = {
        #:game_date=> Date.parse('Oct 29, 2012'),
        #:home_team=>"ari",
        #:home_team_name=>"Cardinals",
        #:away_team=>"sf",
        #:away_team_name=>"49ers",
        #:home_score=>3,
        #:away_score=>24,
        #:home_team_rank=>"",
        #:away_team_rank=>"",
        #:away_team_logo=> "http://a.espncdn.com/combiner/i?img=/i/teamlogos/nfl/500/sf.png&w=200&h=200&transparent=true",
        #:home_team_logo=> "http://a.espncdn.com/combiner/i?img=/i/teamlogos/nfl/500/ari.png&w=200&h=200&transparent=true",
        #:home_team_record=>"4-4",
        #:away_team_record=>"6-2",
        #:state=>"postgame",
        #:ended_in=>"Final",
        #:boxscore=>"321029022",
        #:league=>"nfl"
      #}
      #scores = ESPN::Score.get_nfl_scores(2012, 8)
      #assert_equal expected, scores.last
    #end
  #end

  #test 'nfl pregame' do
    #VCR.use_cassette('nfl-pregame') do
      #expected = {
        #:game_date=>Date.new(2014, 11, 10),
        #:home_team=>"phi",
        #:home_team_name=>"Eagles",
        #:away_team=>"car",
        #:away_team_name=>"Panthers",
        #:home_score=>0,
        #:away_score=>0,
        #:home_team_rank=>"",
        #:away_team_rank=>"",
        #:away_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/nfl/500/car.png&w=200&h=200&transparent=true",
        #:home_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/nfl/500/phi.png&w=200&h=200&transparent=true",
        #:home_team_record=>"6-2",
        #:away_team_record=>"3-5",
        #:state=>"pregame",
        #:start_time=>"8:30 PM ET",
        #:preview=>"400554408",
        #:line=>"PHI -7 O/U 48.5",
        #:league=>"nfl"
      #}
      #scores = ESPN::Score.get_nfl_scores(2014, 10)

      #assert_equal expected, scores.last
    #end
  #end

  #test 'in correctly sets the thursday game' do
    #VCR.use_cassette('nfl-thursday') do
      #score = ESPN::Score.get_nfl_scores(2014, 11).first

      #assert_equal Date.new(2014, 11, 13), score[:game_date]
    #end
  #end

  #test 'nfl inprogress' do
    #VCR.use_cassette('nfl-inprogress') do
      #expected = {
        #:game_date => Date.new(2014, 11, 9),
        #:home_team=>"ari",
        #:home_team_name=>"Cardinals",
        #:away_team=>"stl",
        #:away_team_name=>"Rams",
        #:home_score=>31,
        #:away_score=>14,
        #:home_team_rank=>"",
        #:away_team_rank=>"",
        #:away_team_logo=> "http://a.espncdn.com/combiner/i?img=/i/teamlogos/nfl/500/stl.png&w=200&h=200&transparent=true",
        #:home_team_logo=> "http://a.espncdn.com/combiner/i?img=/i/teamlogos/nfl/500/ari.png&w=200&h=200&transparent=true",
        #:home_team_record=>"7-1",
        #:away_team_record=>"3-5",
        #:state=>"in-progress",
        #:time_remaining=>"1:03",
        #:progress=>"4th Qtr",
        #:boxscore=>"400554397",
        #:league=>"nfl"
      #}

      #score = ESPN::Score.get_nfl_scores(2014, 10).detect { |s| s[:state] == 'in-progress' }

      #assert_equal expected, score
    #end
  #end

  test 'nfl without a team' do
    VCR.use_cassette(__method__) do
      assert_equal [], ESPN::Score.find('nfl', Date.new(2015, 1, 25))
    end
  end
end
