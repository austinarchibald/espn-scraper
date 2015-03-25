require "test_helper"

class RecapTest < EspnTest
  test "NHL photo" do
    VCR.use_cassette(__method__) do
      photo = ESPN::Photo.find("nhl", "400564325")
      assert_equal 14, photo[:photos].size
    end
  end

  test 'nfl photo' do
    VCR.use_cassette(__method__) do
      photo = ESPN::Photo.find("nfl", "400749519")
      assert_equal 36, photo[:photos].size
    end
  end

  test 'ncf photo' do
    VCR.use_cassette(__method__) do
      photo = ESPN::Photo.find("ncf", "400548278")
      assert_equal 6, photo[:photos].size
    end
  end

  test 'ncb photo' do
    VCR.use_cassette(__method__) do
      photo = ESPN::Photo.find("ncb", "400587928")
      assert_equal 30, photo[:photos].size
    end
  end

  test 'nba photo' do
    VCR.use_cassette(__method__) do
      photo = ESPN::Photo.find("nba", "400489474")
      assert_equal 16, photo[:photos].size
    end
  end
end
