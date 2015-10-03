require "testing_env"
require "bottles"

class BottleCollectorTests < Homebrew::TestCase
  def setup
    @collector = BottleCollector.new
  end

  def checksum_for(tag)
    @collector.fetch_checksum_for(tag)
  end

  def test_collector_returns_passed_tags
    @collector[:lion] = "foo"
    @collector[:mountain_lion] = "bar"
    assert_equal ["bar", :mountain_lion], checksum_for(:mountain_lion)
  end

  def test_collector_returns_when_empty
    assert_nil checksum_for(:foo)
  end

  def test_collector_returns_nil_for_no_match
    @collector[:lion] = "foo"
    assert_nil checksum_for(:foo)
  end

  def test_collector_returns_nil_for_no_match_when_later_tag_present
    @collector[:lion_or_later] = "foo"
    assert_nil checksum_for(:foo)
  end

  def test_collector_finds_or_later_tags
    @collector[:lion_or_later] = "foo"
    assert_equal ["foo", :lion_or_later], checksum_for(:mountain_lion)
    assert_nil checksum_for(:snow_leopard)
  end

  def test_collector_prefers_exact_matches
    @collector[:lion_or_later] = "foo"
    @collector[:mountain_lion] = "bar"
    assert_equal ["bar", :mountain_lion], checksum_for(:mountain_lion)
  end

  def test_collector_finds_altivec_tags
    @collector[:tiger_altivec] = "foo"
    assert_equal ["foo", :tiger_altivec], checksum_for(:tiger_g4)
    assert_equal ["foo", :tiger_altivec], checksum_for(:tiger_g4e)
    assert_equal ["foo", :tiger_altivec], checksum_for(:tiger_g5)
    assert_nil checksum_for(:tiger_g3)
  end
end
