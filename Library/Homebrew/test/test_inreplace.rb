require 'testing_env'
require 'utils'
require 'extend/string'

class InreplaceTest < Test::Unit::TestCase
  def test_change_make_var
    # Replace flag
    s1="OTHER=def\nFLAG = abc\nFLAG2=abc"
    s1.extend(StringInreplaceExtension)
    s1.change_make_var! "FLAG", "def"
    assert_equal "OTHER=def\nFLAG=def\nFLAG2=abc", s1
  end

  def test_change_make_var_empty
    # Replace empty flag
    s1="OTHER=def\nFLAG = \nFLAG2=abc"
    s1.extend(StringInreplaceExtension)
    s1.change_make_var! "FLAG", "def"
    assert_equal "OTHER=def\nFLAG=def\nFLAG2=abc", s1
  end
    
  def test_change_make_var_empty_2
    # Replace empty flag
    s1="FLAG = \nmv file_a file_b"
    s1.extend(StringInreplaceExtension)
    s1.change_make_var! "FLAG", "def"
    assert_equal "FLAG=def\nmv file_a file_b", s1
  end
    
  def test_change_make_var_append
    # Append to flag
    s1="OTHER=def\nFLAG = abc\nFLAG2=abc"
    s1.extend(StringInreplaceExtension)
    s1.change_make_var! "FLAG", "\\1 def"
    assert_equal "OTHER=def\nFLAG=abc def\nFLAG2=abc", s1
  end
  
  def test_change_make_var_shell_style
    # Shell variables have no spaces around =
    s1="OTHER=def\nFLAG=abc\nFLAG2=abc"
    s1.extend(StringInreplaceExtension)
    s1.change_make_var! "FLAG", "def"
    assert_equal "OTHER=def\nFLAG=def\nFLAG2=abc", s1
  end

  def test_change_make_var_leading_space
    # Sometimes variables have leading whitespace --- this should be preserved,
    # especially in the case of tabs which are significant to make.
    s1="OTHER=def\n  FLAG = abc\n\tFLAG = abc\nFLAG2=abc"
    s1 = s1.lines.map do |l|
      l.extend(StringInreplaceExtension)
      l.change_make_var! "FLAG", "def"
      return l
    end
    assert_equal "OTHER=def\n  FLAG=def\n\tFLAG=def\nFLAG2=abc", s1.join
  end

  def test_remove_make_var
    # Replace flag
    s1="OTHER=def\nFLAG = abc\nFLAG2 = def"
    s1.extend(StringInreplaceExtension)
    s1.remove_make_var! "FLAG"
    assert_equal "OTHER=def\nFLAG2 = def", s1
  end

  def test_remove_make_var_leading_space
    # Sometimes variables have leading whitespace.
    s1="OTHER=def\n  FLAG = abc\n\tFLAG = abc\nFLAG2 = def"
    s1.extend(StringInreplaceExtension)
    s1.remove_make_var! "FLAG"
    assert_equal "OTHER=def\nFLAG2 = def", s1
  end

  def test_remove_make_vars
    # Replace flag
    s1="OTHER=def\nFLAG = abc\nFLAG2 = def\nOTHER2=def"
    s1.extend(StringInreplaceExtension)
    s1.remove_make_var! ["FLAG", "FLAG2"]
    assert_equal "OTHER=def\nOTHER2=def", s1
  end

  def test_get_make_var_leading_space
    # Get value of FLAG.
    s1="OTHER=def\n  FLAG = abc\nFLAG2 = def"
    s1.extend(StringInreplaceExtension)
    assert_equal 'abc', s1.get_make_var('FLAG')
  end
end
