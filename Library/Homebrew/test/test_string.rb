require 'testing_env'
require 'extend/string'

class StringTest <Test::Unit::TestCase
  def test_undent
    undented = <<-EOS.undent
    hi
....my friend over
    there
    EOS
    assert undented == "hi\nmy friend over\nthere\n"
  end
end
