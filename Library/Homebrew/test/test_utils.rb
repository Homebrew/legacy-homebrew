require 'testing_env'

class UtilTests < Homebrew::TestCase
  def test_put_columns_empty
    # Issue #217 put columns with new results fails.
    assert_silent { puts_columns [] }
  end
end
