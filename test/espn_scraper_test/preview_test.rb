require 'test_helper'

class PreviewTest < EspnTest
  test 'NHL preview' do
    VCR.use_cassette(__method__) do
      recap = ESPN::Preview.find('nhl', '400564048')

      assert_equal 23, recap[:headline].length
      assert_equal 3128, recap[:content].length
    end
  end

  test 'NFL preview' do
    VCR.use_cassette(__method__) do
      recap = ESPN::Preview.find('nfl', '400554356')

      assert_equal 4900, recap[:content].length
      assert_equal 22, recap[:headline].length
    end
  end

  test 'ncf preview' do
    VCR.use_cassette(__method__) do
      recap = ESPN::Preview.find('ncf', '400610197')

      assert_equal 3826, recap[:content].length
      assert_equal 34, recap[:headline].length
    end
  end

  test 'nba preview' do
    VCR.use_cassette(__method__) do
      recap = ESPN::Preview.find('nba', '400489474')

      assert_equal 2845, recap[:content].length
      assert_equal 22, recap[:headline].length
    end
  end

  test 'ncb preview' do
    VCR.use_cassette(__method__) do
      recap = ESPN::Preview.find('ncb', '400587928')

      assert_equal 143, recap[:content].length
      assert_equal 36, recap[:headline].length
    end
  end
end
