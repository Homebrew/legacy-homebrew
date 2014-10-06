require 'testing_env'

class UtilTests < Homebrew::TestCase
  def test_put_columns_empty
    # Issue #217 put columns with new results fails.
    assert_silent { puts_columns [] }
  end

  def test_popen_read
    out = Utils.popen_read("/bin/sh", "-c", "echo success", &:read).chomp
    assert_equal "success", out
    assert_predicate $?, :success?
  end
end
