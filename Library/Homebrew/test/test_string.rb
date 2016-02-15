require "testing_env"
require "extend/string"

class StringTest < Homebrew::TestCase
  def test_undent
    undented = <<-EOS.undent
    hi
....my friend over
    there
    EOS
    assert_equal "hi\n....my friend over\nthere\n", undented
  end

  def test_undent_not_indented
    undented = <<-EOS.undent
hi
I'm not indented
    EOS
    assert_equal "hi\nI'm not indented\n", undented
  end

  def test_undent_nested
    nest = <<-EOS.undent
      goodbye
    EOS

    undented = <<-EOS.undent
      hello
      #{nest}
    EOS

    assert_equal "hello\ngoodbye\n\n", undented
  end

  def test_inreplace_sub_failure
    s = "foobar".extend StringInreplaceExtension
    s.sub! "not here", "test"
    assert_equal [%(expected replacement of "not here" with "test")], s.errors
  end
end
