require "test_helper"

class RecapTest < EspnTest
  test "NHL recap" do
    VCR.use_cassette(__method__) do
      recap = ESPN::Recap.find("nhl", "400564325")

      assert_equal 4132, recap[:content].length
      assert_equal "Islanders stay hot with shootout victory over Penguins", recap[:headline]
    end
  end

  test "NFL recap" do
    VCR.use_cassette(__method__) do
      recap = ESPN::Recap.find("nfl", "400554293")

      assert_equal 5135, recap[:content].length
      assert_equal "Derek Carr-led Raiders shock Chiefs to end losing streak at 16", recap[:headline]
    end
  end

  test "ncf recap" do
    VCR.use_cassette(__method__) do
      recap = ESPN::Recap.find("ncf", "400548328")

      assert_equal 4068, recap[:content].length
      assert_equal "No. 1 Alabama cruises past FCS-level Western Carolina", recap[:headline]
    end
  end

  test "nba recap" do
    VCR.use_cassette(__method__) do
      recap = ESPN::Recap.find("nba", "400489474")

      assert_equal 4369, recap[:content].length
      assert_equal "Nick Young scores 29 as Lakers beat Raptors", recap[:headline]
    end
  end

  test "ncb recap" do
    VCR.use_cassette(__method__) do
      recap = ESPN::Recap.find("ncb", "400588423")

      assert_equal 1, recap[:content].length
      assert_equal "No recap available", recap[:headline]
    end
  end
end
