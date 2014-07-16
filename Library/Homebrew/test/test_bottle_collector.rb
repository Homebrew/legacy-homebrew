require 'testing_env'
require 'bottles'

class BottleCollectorTests < Homebrew::TestCase
  def setup
    @collector = BottleCollector.new
  end

  def test_collector_returns_passed_tags
    @collector[:lion] = "foo"
    @collector[:mountain_lion] = "bar"
    assert_equal ['bar', :mountain_lion], @collector.fetch_bottle_for(:mountain_lion)
  end

  def test_collector_returns_nil_on_no_matches
    assert_nil @collector.fetch_bottle_for(:foo)
  end

  def test_collector_finds_or_later_tags
    @collector[:lion_or_later] = "foo"
    assert_equal ['foo', :lion_or_later], @collector.fetch_bottle_for(:mountain_lion)
    assert_nil @collector.fetch_bottle_for(:snow_leopard)
  end

  def test_collector_prefers_exact_matches
    @collector[:lion_or_later] = "foo"
    @collector[:mountain_lion] = "bar"
    assert_equal ['bar', :mountain_lion], @collector.fetch_bottle_for(:mountain_lion)
  end

  def test_collector_finds_altivec_tags
    @collector[:tiger_altivec] = "foo"
    assert_equal ['foo', :tiger_altivec], @collector.fetch_bottle_for(:tiger_g4)
    assert_equal ['foo', :tiger_altivec], @collector.fetch_bottle_for(:tiger_g4e)
    assert_equal ['foo', :tiger_altivec], @collector.fetch_bottle_for(:tiger_g5)
    assert_nil @collector.fetch_bottle_for(:tiger_g3)
  end
end
