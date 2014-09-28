require "testing_env"
require "extend/string"
require "utils/inreplace"

class InreplaceTest < Homebrew::TestCase
  def test_change_make_var
    # Replace flag
    s1 = "OTHER=def\nFLAG = abc\nFLAG2=abc"
    s1.extend(StringInreplaceExtension)
    s1.change_make_var! "FLAG", "def"
    assert_equal "OTHER=def\nFLAG=def\nFLAG2=abc", s1
  end

  def test_change_make_var_empty
    # Replace empty flag
    s1 = "OTHER=def\nFLAG = \nFLAG2=abc"
    s1.extend(StringInreplaceExtension)
    s1.change_make_var! "FLAG", "def"
    assert_equal "OTHER=def\nFLAG=def\nFLAG2=abc", s1
  end

  def test_change_make_var_empty_2
    # Replace empty flag
    s1 = "FLAG = \nmv file_a file_b"
    s1.extend(StringInreplaceExtension)
    s1.change_make_var! "FLAG", "def"
    assert_equal "FLAG=def\nmv file_a file_b", s1
  end

  def test_change_make_var_append
    # Append to flag
    s1 = "OTHER=def\nFLAG = abc\nFLAG2=abc"
    s1.extend(StringInreplaceExtension)
    s1.change_make_var! "FLAG", "\\1 def"
    assert_equal "OTHER=def\nFLAG=abc def\nFLAG2=abc", s1
  end

  def test_change_make_var_shell_style
    # Shell variables have no spaces around =
    s1 = "OTHER=def\nFLAG=abc\nFLAG2=abc"
    s1.extend(StringInreplaceExtension)
    s1.change_make_var! "FLAG", "def"
    assert_equal "OTHER=def\nFLAG=def\nFLAG2=abc", s1
  end

  def test_remove_make_var
    # Replace flag
    s1 = "OTHER=def\nFLAG = abc\nFLAG2 = def"
    s1.extend(StringInreplaceExtension)
    s1.remove_make_var! "FLAG"
    assert_equal "OTHER=def\nFLAG2 = def", s1
  end

  def test_remove_make_vars
    # Replace flag
    s1 = "OTHER=def\nFLAG = abc\nFLAG2 = def\nOTHER2=def"
    s1.extend(StringInreplaceExtension)
    s1.remove_make_var! ["FLAG", "FLAG2"]
    assert_equal "OTHER=def\nOTHER2=def", s1
  end

  def test_get_make_var
    s = "CFLAGS = -Wall -O2\nLDFLAGS = -lcrypto -lssl"
    s.extend(StringInreplaceExtension)
    assert_equal "-Wall -O2", s.get_make_var("CFLAGS")
  end

  def test_change_make_var_with_tabs
    s = "CFLAGS\t=\t-Wall -O2\nLDFLAGS\t=\t-lcrypto -lssl"
    s.extend(StringInreplaceExtension)

    assert_equal "-Wall -O2", s.get_make_var("CFLAGS")

    s.change_make_var! "CFLAGS", "-O3"
    assert_equal "CFLAGS=-O3\nLDFLAGS\t=\t-lcrypto -lssl", s

    s.remove_make_var! "LDFLAGS"
    assert_equal "CFLAGS=-O3\n", s
  end

  def test_sub_gsub
    s = "foo"
    s.extend(StringInreplaceExtension)

    s.sub!("f", "b")
    assert_equal "boo", s

    s.gsub!("o", "e")
    assert_equal "bee", s
  end

  def test_inreplace_errors
    extend(Utils::Inreplace)

    open("test", "w") { |f| f.write "a\nb\nc\n" }

    assert_raises(Utils::InreplaceError) {
      inreplace "test", "d", "f"
    }

    assert_raises(Utils::InreplaceError) {
      inreplace("test") { |s| s.gsub! "d", "f" }
    }

    assert_raises(Utils::InreplaceError) {
      inreplace("test") { |s|
        s.change_make_var! "VAR", "value"
        s.remove_make_var! "VAR2"
      }
    }
  ensure
    File.unlink("test")
  end
end
