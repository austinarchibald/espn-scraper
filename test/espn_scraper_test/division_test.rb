require 'test_helper'

class DivisionTest < EspnTest

  test 'nfl afc north' do
    VCR.use_cassette('nfl division') do
      nfl = ESPN::Division.find('nfl')
      assert nfl.include?('AFC North')
    end
  end

  test 'mlb al west' do
    VCR.use_cassette('mlb division') do
      mlb = ESPN::Division.find('mlb')
      assert mlb.include?('AL West')
    end
  end

  test 'nba central' do
    VCR.use_cassette('nba central') do
      nba = ESPN::Division.find('nba')
      assert nba.include?('Central')
    end
  end

  test 'nhl pacific division' do
    VCR.use_cassette('nhl pacific') do
      nhl = ESPN::Division.find('nhl')
      assert nhl.include?('Pacific Division')
    end
  end

  test 'ncf conference usa' do
    VCR.use_cassette('ncf conference') do
      ncf = ESPN::Division.find('ncf')
      assert ncf.include?('Conference USA')
    end
  end

  test 'ncb' do
    VCR.use_cassette('ncb conference') do
      ncb = ESPN::Division.find('ncb')
      assert ncb.include?('ACC')
    end
  end

end
