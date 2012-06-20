require 'testing_env'
require 'test/testball'
require 'set'

# Expose some internals
class Patches
  attr_reader :patches
end

class Patch
  attr_reader :patch_p
  attr_reader :patch_filename
end


class PatchingTests < Test::Unit::TestCase
  def test_patchSingleString
    patches = Patches.new("http://example.com/patch.diff")
    assert_equal 1, patches.patches.length
    p = patches.patches[0]
    assert_equal :p1, p.patch_p
  end

  def test_patchArray
    patches = Patches.new(["http://example.com/patch1.diff", "http://example.com/patch2.diff"])
    assert_equal 2, patches.patches.length
    
    p1 = patches.patches[0]
    assert_equal :p1, p1.patch_p
    
    p2 = patches.patches[0]
    assert_equal :p1, p2.patch_p
  end

  def test_p0_hash_to_string
    patches = Patches.new({
      :p0 => "http://example.com/patch.diff"
    })
    assert_equal 1, patches.patches.length
    
    p = patches.patches[0]
    assert_equal :p0, p.patch_p
  end

  def test_p1_hash_to_string
    patches = Patches.new({
      :p1 => "http://example.com/patch.diff"
    })
    assert_equal 1, patches.patches.length
    
    p = patches.patches[0]
    assert_equal :p1, p.patch_p
  end

  def test_mixed_hash_to_strings
    expected = {
      :p1 => "http://example.com/patch1.diff",
      :p0 => "http://example.com/patch0.diff"
    }
    patches = Patches.new(expected)
    assert_equal 2, patches.patches.length

    # Make sure unique filenames were assigned
    filenames = Set.new
    patches.each do |p|
      filenames << p.patch_filename
    end

    assert_equal 2, filenames.size
  end

  def test_mixed_hash_to_arrays
    expected = {
      :p1 => ["http://example.com/patch10.diff","http://example.com/patch11.diff"],
      :p0 => ["http://example.com/patch00.diff","http://example.com/patch01.diff"]
    }
    patches = Patches.new(expected)
    assert_equal 4, patches.patches.length

    # Make sure unique filenames were assigned
    filenames = Set.new
    patches.each do |p|
      filenames << p.patch_filename
    end

    assert_equal 4, filenames.size
  end
end
