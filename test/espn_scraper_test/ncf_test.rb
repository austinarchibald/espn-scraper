require 'test_helper'

class NcfTest < EspnTest
  def setup
    any_instance_of(ESPN::Score) do |klass|
      stub(klass).teams { ['265', '25', '309', '2032', '21', '70', '245', '2'] }
    end
  end

  test 'getting ncf scores by date' do
    VCR.use_cassette(__method__) do
      expected = {
        :game_date=>Date.parse('Oct 4, 2014'),
        :home_team=>"265",
        :home_team_name=>"Washington St",
        :away_team=>"25",
        :away_team_name=>"California",
        :home_score=>59,
        :away_score=>60,
        :home_team_rank=>"",
        :away_team_rank=>"",
        :away_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/25.png&w=200&h=200&transparent=true",
        :home_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/265.png&w=200&h=200&transparent=true",
        :home_team_record=>"2-4",
        :away_team_record=>"4-1",
        :state=>"postgame",
        :ended_in=>"Final",
        :boxscore=>"400548278",
        :league=>"ncf"
      }

      scores = ESPN::Score.find('ncf', Date.new(2014, 10, 4))
      assert_equal expected, scores.last
    end
  end

  #test 'college football 2012 week 9 regular season' do
    #VCR.use_cassette('college football post game') do
      #expected = {
        #:game_date=>Date.parse('Oct 23, 2012'),
        #:home_team=>"309",
        #:home_team_name=>"LA-Lafayette",
        #:away_team=>"2032",
        #:away_team_name=>"Arkansas State",
        #:home_score=>27,
        #:away_score=>50,
        #:home_team_rank=>"",
        #:away_team_rank => '',
        #:away_team_logo=> "http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/2032.png&w=200&h=200&transparent=true",
        #:home_team_logo=> "http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/309.png&w=200&h=200&transparent=true",
        #:home_team_record=>"4-3",
        #:away_team_record=>"5-3",
        #:state=>"postgame",
        #:ended_in=>"Final",
        #:boxscore=>"322970309",
        #:league=>"ncf"
      #}
      #scores = ESPN::Score.get_ncf_scores(2012, 9)
      #assert_equal expected, scores.first
    #end
  #end

  #test 'pregame of college football' do
    #VCR.use_cassette('college football pregame game') do
      #expected = {
        #:game_date=>Date.today,
        #:home_team=>"21",
        #:home_team_name=>"San Diego State",
        #:away_team=>"70",
        #:away_team_name=>"Idaho",
        #:home_score=>0,
        #:away_score=>0,
        #:home_team_rank =>"",
        #:away_team_logo => "http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/70.png&w=200&h=200&transparent=true",
        #:home_team_logo => "http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/21.png&w=200&h=200&transparent=true",
        #:away_team_rank => '',
        #:home_team_record=>"4-4",
        #:away_team_record=>"1-7",
        #:state=>"pregame",
        #:start_time=>"6:30 PM ET",
        #:line=>"SDSU -20.5 O/U 57.5",
        #:preview => '',
        #:league=>"ncf"
      #}
      #score = ESPN::Score.get_ncf_scores(2014, 11).detect { |s| s[:state] == 'pregame' }
      #assert_equal expected, score
    #end
  #end

  #test 'in-progress of college football' do
    #VCR.use_cassette('college football inprogress game') do
      #expected = {
        #:game_date=>Date.today,
        #:home_team=>"2",
        #:home_team_name=>"Auburn",
        #:away_team=>"245",
        #:away_team_name=>"Texas A&M",
        #:home_score=>31,
        #:away_score=>38,
        #:home_team_rank=>"3",
        #:away_team_rank=>"",
        #:away_team_logo=> "http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/245.png&w=200&h=200&transparent=true",
        #:home_team_logo=> "http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/2.png&w=200&h=200&transparent=true",
        #:home_team_record=>"7-1",
        #:away_team_record=>"6-3",
        #:state=>"in-progress",
        #:time_remaining=>"12:55",
        #:progress=>"4th Qtr",
        #:boxscore=>"400548346",
        #:league=>"ncf"
      #}
      #score = ESPN::Score.get_ncf_scores(2014, 11).select { |s| s[:state] == 'in-progress' }.detect { |s| s[:away_team_name] == 'Texas A&M' }
      #assert_equal expected, score
    #end
  #end

end
