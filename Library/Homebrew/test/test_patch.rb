require 'testing_env'
require 'patch'

class PatchTests < Test::Unit::TestCase
  def test_create_simple
    patch = Patch.create(:p2)
    assert_kind_of ExternalPatch, patch
    assert patch.external?
    assert_equal :p2, patch.strip
  end

  def test_create_io
    patch = Patch.create(:p0, StringIO.new("foo"))
    assert_kind_of IOPatch, patch
    assert !patch.external?
    assert_equal :p0, patch.strip
  end

  def test_create_io_without_strip
    patch = Patch.create(StringIO.new("foo"))
    assert_kind_of IOPatch, patch
    assert_equal :p1, patch.strip
  end

  def test_create_string
    patch = Patch.create(:p0, "foo")
    assert_kind_of IOPatch, patch
    assert_equal :p0, patch.strip
  end

  def test_create_string_without_strip
    patch = Patch.create("foo")
    assert_kind_of IOPatch, patch
    assert_equal :p1, patch.strip
  end

  def test_create_DATA
    patch = Patch.create(:p0, :DATA)
    assert_kind_of IOPatch, patch
    assert_equal :p0, patch.strip
  end

  def test_create_DATA_without_strip
    patch = Patch.create(:DATA)
    assert_kind_of IOPatch, patch
    assert_equal :p1, patch.strip
  end

  def test_raises_for_unknown_values
    assert_raises(ArgumentError) { Patch.create(Object.new) }
  end
end
