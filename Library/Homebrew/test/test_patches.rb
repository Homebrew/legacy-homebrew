require 'testing_env'
require 'test/testball'
require 'set'

# Expose some internals
class Patch
  attr_reader :patch_p
  attr_reader :patch_filename
end

class PatchingTests < Test::Unit::TestCase
  def formula_with_patches &block
    formula do
      url "http://example.com/foo"
      version "0.0"
      define_method :patches, &block
    end
  end

  def test_patchSingleString
    f = formula_with_patches { "http://example.com/patch.diff" }
    assert_equal 1, f.patchlist.length
    p = f.patchlist[0]
    assert_equal :p1, p.patch_p
  end

  def test_patchArray
    f = formula_with_patches { ["http://example.com/patch1.diff", "http://example.com/patch2.diff"] }
    assert_equal 2, f.patchlist.length

    p1 = f.patchlist[0]
    assert_equal :p1, p1.patch_p

    p2 = f.patchlist[0]
    assert_equal :p1, p2.patch_p
  end

  def test_p0_hash_to_string
    f = formula_with_patches do {
      :p0 => "http://example.com/patch.diff"
    } end
    assert_equal 1, f.patchlist.length

    p = f.patchlist[0]
    assert_equal :p0, p.patch_p
  end

  def test_p1_hash_to_string
    f = formula_with_patches do {
      :p1 => "http://example.com/patch.diff"
    } end
    assert_equal 1, f.patchlist.length

    p = f.patchlist[0]
    assert_equal :p1, p.patch_p
  end

  def test_mixed_hash_to_strings
    expected = {
      :p1 => "http://example.com/patch1.diff",
      :p0 => "http://example.com/patch0.diff"
    }
    f = formula_with_patches { expected }
    assert_equal 2, f.patchlist.length

    # Make sure unique filenames were assigned
    filenames = Set.new
    f.patchlist.each do |p|
      filenames << p.patch_filename
    end

    assert_equal 2, filenames.size
  end

  def test_mixed_hash_to_arrays
    expected = {
      :p1 => ["http://example.com/patch10.diff","http://example.com/patch11.diff"],
      :p0 => ["http://example.com/patch00.diff","http://example.com/patch01.diff"]
    }
    f = formula_with_patches { expected }
    assert_equal 4, f.patchlist.length

    # Make sure unique filenames were assigned
    filenames = Set.new
    f.patchlist.each do |p|
      filenames << p.patch_filename
    end

    assert_equal 4, filenames.size
  end
end
