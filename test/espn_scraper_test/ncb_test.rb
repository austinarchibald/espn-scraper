require 'test_helper'

class NcbTest < EspnTest
  def setup
    any_instance_of(ESPN::Score) do |klass|
      stub(klass).teams { ['93', '36', '96', '238', '222', '46'] }
    end
  end

  test 'mens college basketball march 15th murray state beats colorado state' do
    VCR.use_cassette(__method__) do
      day = Date.parse('Mar 15, 2012')

      expected = {
        :game_date=>day,
        :home_team=>"93",
        :home_team_name=>"Murray State",
        :away_team=>"36",
        :away_team_name=>"Colorado State",
        :home_score=>58,
        :away_score=>41,
        :home_team_rank=>"6",
        :away_team_rank=>"11",
        :away_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/36.png&w=200&h=200&transparent=true",
        :home_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/93.png&w=200&h=200&transparent=true",
        :home_team_record=>"31-1",
        :away_team_record=>"20-12",
        :state=>"postgame",
        :ended_in=>"Final",
        :boxscore=>"320750093",
        :league=>"ncb"
      }


      scores = ESPN::Score.find('ncb', day)
      assert_equal expected, scores.first
    end
  end

  test 'ncb pregame' do
    VCR.use_cassette(__method__) do
      day = Date.new(2015, 01, 20)

      expected = {
        :game_date=>day,
        :home_team=>"96",
        :home_team_name=>"Kentucky",
        :away_team=>"238",
        :away_team_name=>"Vanderbilt",
        :home_score=>0,
        :away_score=>0,
        :home_team_rank=>"1",
        :away_team_rank=>"",
        :away_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/238.png&w=200&h=200&transparent=true",
        :home_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/96.png&w=200&h=200&transparent=true",
        :home_team_record=>"17-0",
        :away_team_record=>"11-6",
        :state=>"pregame",
        :start_time=>"9:00 PM ET",
        :preview=>"400597343",
        :line=>"UK -22.0",
        :league=>"ncb"
      }

      scores = ESPN::Score.find('ncb', day)

      assert_equal expected, scores.detect { |s| s[:state] == 'pregame' }
    end
  end

  #test 'college basketball final' do
    #VCR.use_cassette('college basketball final and again') do
      #day = Date.new(2014, 01, 19)

      #expected = {
        #:game_date=>day,
        #:home_team=>"tor",
        #:home_team_name=>"Raptors",
        #:away_team=>"lal",
        #:away_team_name=>"Lakers",
        #:home_score=>106,
        #:away_score=>112,
        #:home_team_rank=>"",
        #:away_team_rank=>"",
        #:home_team_record=>"20-1",
        #:away_team_record=>"16-2",
        #:state=>"postgame",
        #:ended_in=>"Final",
        #:boxscore=>"",
        #:league=>"nba"
      #}

      #scores = ESPN.get_ncb_scores_by_date(day)

      #assert_equal expected, scores.detect { |s| s[:state] == 'final' }
    #end
  #end

  test 'ncb inprogress' do
    VCR.use_cassette(__method__) do
      day = Date.new(2015, 1, 19)

      expected = {
        :game_date=>day,
        :home_team=>"46",
        :home_team_name=>"Georgetown",
        :away_team=>"222",
        :away_team_name=>"Villanova",
        :home_score=>18,
        :away_score=>11,
        :home_team_rank=>"",
        :away_team_rank=>"4",
        :away_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/222.png&w=200&h=200&transparent=true",
        :home_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/46.png&w=200&h=200&transparent=true",
        :home_team_record=>"12-5",
        :away_team_record=>"17-1",
        :state=>"in-progress",
        :time_remaining=>"9:46",
        :progress=>"1st",
        :boxscore=>"400588423",
        :league=>"ncb"
      }

      scores = ESPN::Score.find('ncb', day)

      assert_equal expected, scores.detect { |s| s[:state] == 'in-progress' }
    end
  end

end
