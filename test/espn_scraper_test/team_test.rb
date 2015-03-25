require 'test_helper'

class TeamTest < EspnTest

  test 'scrape nfl teams' do
    VCR.use_cassette(__method__) do
      divisions = ESPN::Team.find('nfl')
      assert_equal 8, divisions.count
      divisions.each do |name, teams|
        assert_equal 4, teams.count
      end
      teams = divisions.values.flatten

      assert_equal 32, teams.map{ |h| h[:name] }.uniq.count
      assert_equal 32, teams.map{ |h| h[:data_name] }.uniq.count
      assert divisions['NFC West'].include?({ name: 'Seattle Seahawks', data_name: 'sea', url: 'http://espn.go.com/nfl/team/_/name/sea/seattle-seahawks' })
    end
  end

  test 'scrape mlb teams' do
    VCR.use_cassette(__method__) do
      divisions = ESPN::Team.find('mlb')
      assert_equal 6, divisions.count
      divisions.each do |name, teams|
        assert_equal 5, teams.count
      end
      teams = divisions.values.flatten
      assert_equal 30, teams.map{ |h| h[:name] }.uniq.count
      assert_equal 30, teams.map{ |h| h[:data_name] }.uniq.count
      assert divisions['AL West'].include?({ name: 'Seattle Mariners', data_name: 'sea', url: 'http://espn.go.com/mlb/team/_/name/sea/seattle-mariners' })
    end
  end

  test 'scrape nba teams' do
    VCR.use_cassette(__method__) do
      divisions = ESPN::Team.find('nba')
      assert_equal 6, divisions.count
      divisions.each do |name, teams|
        assert_equal 5, teams.count
      end
      teams = divisions.values.flatten
      assert_equal 30, teams.map{ |h| h[:name] }.uniq.count
      assert_equal 30, teams.map{ |h| h[:data_name] }.uniq.count
      assert divisions['Atlantic'].include?({ name: 'Toronto Raptors', data_name: 'tor', url: 'http://espn.go.com/nba/team/_/name/tor/toronto-raptors' })
    end
  end

  test 'scrape nhl teams' do
    VCR.use_cassette(__method__) do
      divisions = ESPN::Team.find('nhl')
      assert_equal 4, divisions.count
      teams = divisions.values.flatten
      assert_equal 30, teams.map{ |h| h[:name] }.uniq.count
      assert_equal 30, teams.map{ |h| h[:data_name] }.uniq.count
      assert divisions['Atlantic Division'].include?({ name: 'Montreal Canadiens', data_name: 'mtl', url: 'http://espn.go.com/nhl/team/_/name/mtl/montreal-canadiens'})
    end
  end

  test 'scrape ncaa football teams' do
    VCR.use_cassette(__method__) do
      divisions = ESPN::Team.find('college-football')
      assert_equal 25, divisions.count
      assert_equal 14, divisions['Big Ten'].count
      assert_equal 12, divisions['Pac-12'].count

      assert divisions['Conference USA'].include?({ name: 'UAB', data_name: '5', url: 'http://espn.go.com/college-football/team/_/id/5/uab-blazers' })
    end
  end

  test 'scrape ncaa basketball teams' do
    VCR.use_cassette(__method__) do
      divisions = ESPN::Team.find('mens-college-basketball')
      assert_equal 33, divisions.count
      assert_equal 15, divisions['ACC'].count
      assert_equal 10, divisions['Patriot League'].count

      assert divisions['Southland'].include?({ name: 'Texas A&M-CC', data_name: '357', url: 'http://espn.go.com/mens-college-basketball/team/_/id/357/texas-a&m-cc-islanders' })
    end
  end

end
