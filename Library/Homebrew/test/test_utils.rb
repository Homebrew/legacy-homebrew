require 'testing_env'

class UtilTests < Test::Unit::TestCase
  def test_put_columns_empty
    assert_nothing_raised do
      # Issue #217 put columns with new results fails.
      puts_columns []
    end
  end
end
