class InreplaceTest < Test::Unit::TestCase
  def test_change_make_var
    # Replace flag
    s1="FLAG = abc"
    s1.extend(HomebrewInreplaceExtension)
    s1.change_make_var! "FLAG", "def"
    assert_equal "FLAG=def", s1
  end

  def test_change_make_var_empty
    # Replace empty flag
    s1="FLAG = \nFLAG2=abc"
    s1.extend(HomebrewInreplaceExtension)
    s1.change_make_var! "FLAG", "def"
    assert_equal "FLAG=def\nFLAG2=abc", s1
  end
    
  def test_change_make_var_empty_2
    # Replace empty flag
    s1="FLAG = \nmv file_a file_b"
    s1.extend(HomebrewInreplaceExtension)
    s1.change_make_var! "FLAG", "def"
    assert_equal "FLAG=def\nmv file_a file_b", s1
  end
    
  def test_change_make_var_append
    # Append to flag
    s1="FLAG = abc"
    s1.extend(HomebrewInreplaceExtension)
    s1.change_make_var! "FLAG", "\\1 def"
    assert_equal "FLAG=abc def", s1
  end
  
  def test_change_make_var_shell_style
    # Shell variables have no spaces around =
    s1="FLAG=abc"
    s1.extend(HomebrewInreplaceExtension)
    s1.change_make_var! "FLAG", "def"
    assert_equal "FLAG=def", s1
  end

  def test_remove_make_var
    # Replace flag
    s1="FLAG = abc\nFLAG2 = def"
    s1.extend(HomebrewInreplaceExtension)
    s1.remove_make_var! "FLAG"
    assert_equal "FLAG2 = def", s1
  end

  def test_remove_make_vars
    # Replace flag
    s1="FLAG = abc\nFLAG2 = def"
    s1.extend(HomebrewInreplaceExtension)
    s1.remove_make_var! ["FLAG", "FLAG2"]
    assert_equal "", s1
  end
end
