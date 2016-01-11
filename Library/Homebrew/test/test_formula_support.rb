require "testing_env"
require "formula_support"

class KegOnlyReasonTests < Homebrew::TestCase
  def test_to_s_explanation
    r = KegOnlyReason.new :provided_by_osx, "test"
    assert_equal "test", r.to_s
  end

  def test_to_s_no_explanation
    r = KegOnlyReason.new :provided_by_osx, ""
    assert_match(/^OS X already provides/, r.to_s)
  end
end

class BottleDisableReasonTests < Homebrew::TestCase
  def test_bottle_unneeded
    bottle_disable_reason = BottleDisableReason.new :unneeded, nil
    assert_predicate bottle_disable_reason, :unneeded?
    assert_equal "This formula doesn't require compiling.", bottle_disable_reason.to_s
  end

  def test_bottle_disabled
    bottle_disable_reason = BottleDisableReason.new :disable, "reason"
    refute_predicate bottle_disable_reason, :unneeded?
    assert_equal "reason", bottle_disable_reason.to_s
  end
end
