require 'testing_env'
require 'extend/string'

class StringTest < Test::Unit::TestCase
  def test_undent
    undented = <<-EOS.undent
    hi
....my friend over
    there
    EOS
    assert undented == "hi\nmy friend over\nthere\n"
  end

  def test_undent_not_indented
    undented = <<-EOS.undent
hi
I'm not indented
    EOS
    assert undented == "hi\nI'm not indented\n"
  end
end
