require 'test_helper'

class StandingTest < EspnTest
  test 'standings nfl' do
    VCR.use_cassette(__method__) do
      standings = ESPN::Standing.find(ESPN::NFL, ESPN::Standing::LEAGUE)[:teams]['Nfl']
      first = {
        :team=> {
          :data_name=>"ari",
          :team_name=>"Arizona"
        },
        :stats => ["9", "3", "0", ".750", "Lost 2"]
      }

      assert_equal first, standings.first

      last = {
        :team => {
          :data_name=>"oak",
          :team_name=>"Oakland"
        },
        :stats => ["1", "11", "0", ".083", "Lost 1"]
      }
      assert_equal last, standings.last
    end
  end

  test 'standings nhl' do
    VCR.use_cassette(__method__) do
      standings = ESPN::Standing.find(ESPN::NHL, ESPN::Standing::LEAGUE)[:teams]['Nhl']

      first = {
        :team => {
          :data_name=>"ana",
          :team_name=>"Anaheim"
        },
        :stats=>["29", "18", "6", "5", "41"]
      }
      assert_equal first, standings.first

      last = {
        :team => {
          :data_name=>"edm",
          :team_name=>"Edmonton"
        },
        :stats=>["26", "6", "15", "5", "17"]
      }
      assert_equal last, standings.last
    end
  end

  test 'standings mlb' do
    VCR.use_cassette(__method__) do
      standings = ESPN::Standing.find(ESPN::MLB, ESPN::Standing::LEAGUE)[:teams]['Cactus']

      first = {
        :team => {
          :data_name=>"kc",
          :team_name=>"Kansas City"
        },
        :stats=>["5", "0", "1.000", "-", "5-0"]
      }
      assert_equal first, standings.first

      last = {
        :team => {
          :data_name=>"chc",
          :team_name=>"Chicago Cubs"
        },
        :stats=>["0", "4", ".000", "4.5", "0-4"]
      }
      assert_equal last, standings.last
    end
  end

  test 'standings ncb' do
    VCR.use_cassette(__method__) do
      standings = ESPN::Standing.find(ESPN::NCB, ESPN::Standing::LEAGUE)[:teams]['Big Ten']

      first = {
        :team => {
          :data_name=>"275",
          :team_name=>"Wisconsin"
        },
        :stats=>["16-2", "28-3"]
      }
      assert_equal first, standings.first

      last = {
        :team => {
          :data_name=>"164",
          :team_name=>"Rutgers"
        },
        :stats=>["2-16", "10-21"]
      }
      assert_equal last, standings.last
    end
  end

  # TODO: Implement (Off count)
  #test 'standings ncf' do
    #VCR.use_cassette(__method__) do
      #standings = ESPN::Standing.find(ESPN::NCF, ESPN::Standing::LEAGUE)[:teams]['Big Ten']

      #first = {
        #team: '275',
        #team_name: 'Wisconsin',
        #team_record: '28-3',
        #league: 'ncb'
      #}
      #assert_equal first, standings.first

      #last = {
        #team: '164',
        #team_name: 'Rutgers',
        #team_record: '10-21',
        #league: 'ncb'
      #}
      #assert_equal last, standings.last
    #end
  #end
end
