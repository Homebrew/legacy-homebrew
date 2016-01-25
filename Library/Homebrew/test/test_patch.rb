require "testing_env"
require "patch"

class PatchTests < Homebrew::TestCase
  def test_create_simple
    patch = Patch.create(:p2, nil)
    assert_kind_of ExternalPatch, patch
    assert_predicate patch, :external?
    assert_equal :p2, patch.strip
  end

  def test_create_string
    patch = Patch.create(:p0, "foo")
    assert_kind_of StringPatch, patch
    assert_equal :p0, patch.strip
  end

  def test_create_string_without_strip
    patch = Patch.create("foo", nil)
    assert_kind_of StringPatch, patch
    assert_equal :p1, patch.strip
  end

  def test_create_DATA
    patch = Patch.create(:p0, :DATA)
    assert_kind_of DATAPatch, patch
    assert_equal :p0, patch.strip
  end

  def test_create_DATA_without_strip
    patch = Patch.create(:DATA, nil)
    assert_kind_of DATAPatch, patch
    assert_equal :p1, patch.strip
  end

  def test_raises_for_unknown_values
    assert_raises(ArgumentError) { Patch.create(Object.new) }
    assert_raises(ArgumentError) { Patch.create(Object.new, Object.new) }
  end
end

class LegacyPatchTests < Homebrew::TestCase
  def test_patch_single_string
    patches = Patch.normalize_legacy_patches("http://example.com/patch.diff")
    assert_equal 1, patches.length
    assert_equal :p1, patches.first.strip
  end

  def test_patch_array
    patches = Patch.normalize_legacy_patches(
      %w[http://example.com/patch1.diff http://example.com/patch2.diff]
    )

    assert_equal 2, patches.length
    assert_equal :p1, patches[0].strip
    assert_equal :p1, patches[1].strip
  end

  def test_p0_hash_to_string
    patches = Patch.normalize_legacy_patches(
      :p0 => "http://example.com/patch.diff"
    )

    assert_equal 1, patches.length
    assert_equal :p0, patches.first.strip
  end

  def test_p1_hash_to_string
    patches = Patch.normalize_legacy_patches(
      :p1 => "http://example.com/patch.diff"
    )

    assert_equal 1, patches.length
    assert_equal :p1, patches.first.strip
  end

  def test_mixed_hash_to_strings
    patches = Patch.normalize_legacy_patches(
      :p1 => "http://example.com/patch1.diff",
      :p0 => "http://example.com/patch0.diff"
    )
    assert_equal 2, patches.length
    assert_equal 1, patches.count { |p| p.strip == :p0 }
    assert_equal 1, patches.count { |p| p.strip == :p1 }
  end

  def test_mixed_hash_to_arrays
    patches = Patch.normalize_legacy_patches(
      :p1 => ["http://example.com/patch10.diff",
              "http://example.com/patch11.diff"],
      :p0 => ["http://example.com/patch00.diff",
              "http://example.com/patch01.diff"]
    )

    assert_equal 4, patches.length
    assert_equal 2, patches.count { |p| p.strip == :p0 }
    assert_equal 2, patches.count { |p| p.strip == :p1 }
  end

  def test_nil
    assert_empty Patch.normalize_legacy_patches(nil)
  end
end

class EmbeddedPatchTests < Homebrew::TestCase
  def test_inspect
    p = EmbeddedPatch.new :p1
    assert_equal "#<EmbeddedPatch: :p1>", p.inspect
  end
end

class ExternalPatchTests < Homebrew::TestCase
  def setup
    @p = ExternalPatch.new(:p1) { url "file:///my.patch" }

  end

  def test_url
    assert_equal "file:///my.patch", @p.url
  end

  def test_inspect
    assert_equal %(#<ExternalPatch: :p1 "file:///my.patch">), @p.inspect
  end

  def test_cached_download
    @p.resource.stubs(:cached_download).returns "/tmp/foo.tar.gz"
    assert_equal "/tmp/foo.tar.gz", @p.cached_download
  end
end

class ApplyPatchTests < Homebrew::TestCase
  def test_empty_patch_files
    patch = Patch.create(:p2, nil)
    resource = patch.resource
    patch_files = patch.patch_files
    assert_kind_of Resource::Patch, resource
    assert_equal patch_files, resource.patch_files
    assert_equal patch_files, []
  end

  def test_resource_patch_apply_method
    patch = Patch.create(:p2, nil)
    resource = patch.resource
    patch_files = patch.patch_files
    resource.apply("patch1.diff")
    assert_equal patch_files, ["patch1.diff"]
    resource.apply("patch2.diff", "patch3.diff")
    assert_equal patch_files, ["patch1.diff", "patch2.diff", "patch3.diff"]
    resource.apply(["patch4.diff", "patch5.diff"])
    assert_equal patch_files.count, 5
    resource.apply("patch4.diff", ["patch5.diff", "patch6.diff"], "patch7.diff")
    assert_equal patch_files.count, 7
  end
end
