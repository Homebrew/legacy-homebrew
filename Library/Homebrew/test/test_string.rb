require 'testing_env'
require 'extend/string'

class StringTest < Homebrew::TestCase
  def test_undent
    undented = <<-EOS.undent
    hi
....my friend over
    there
    EOS
    assert_equal "hi\nmy friend over\nthere\n", undented
  end

  def test_undent_not_indented
    undented = <<-EOS.undent
hi
I'm not indented
    EOS
    assert_equal "hi\nI'm not indented\n", undented
  end
end
