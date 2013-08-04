require 'testing_env'
require 'test/testball'

class PatchingTests < Test::Unit::TestCase
  def read_file path
    File.open(path, 'r') { |f| f.read }
  end

  def test_patch_dsl_p0
    shutup do
      Class.new(TestBall) do
        patch :p0, "file:///#{TEST_FOLDER}/patches/noop-b.diff",
          "57958271bb802a59452d0816e0670d16c8b70bdf6530bcf6f78726489ad89b90"
      end.new("test_patch_dsl_p0").brew do
        s = read_file 'libexec/NOOP'
        assert !s.include?("NOOP"), "File was unpatched."
        assert s.include?("ABCD"), "File was not patched as expected."
      end
    end
  end

  def test_patch_dsl_p1
    shutup do
      Class.new(TestBall) do
        patch :p1, "file:///#{TEST_FOLDER}/patches/noop-a.diff",
          "83404f4936d3257e65f176c4ffb5a5b8d6edd644a21c8d8dcc73e22a6d28fcfa"
      end.new("test_patch_dsl_p1").brew do
        s = read_file 'libexec/NOOP'
        assert !s.include?("NOOP"), "File was unpatched."
        assert s.include?("ABCD"), "File was not patched as expected."
      end
    end
  end

  def test_single_patch
    shutup do
      Class.new(TestBall) do
        def patches
          "file:///#{TEST_FOLDER}/patches/noop-a.diff"
        end
      end.new("test_single_patch").brew do
        s = read_file 'libexec/NOOP'
        assert !s.include?("NOOP"), "File was unpatched."
        assert s.include?("ABCD"), "File was not patched as expected."
      end
    end
  end

  def test_patch_array
    shutup do
      Class.new(TestBall) do
        def patches
          ["file:///#{TEST_FOLDER}/patches/noop-a.diff"]
        end
      end.new("test_patch_array").brew do
        s = read_file 'libexec/NOOP'
        assert !s.include?("NOOP"), "File was unpatched."
        assert s.include?("ABCD"), "File was not patched as expected."
      end
    end
  end

  def test_patch_p0
    shutup do
      Class.new(TestBall) do
        def patches
          { :p0 => ["file:///#{TEST_FOLDER}/patches/noop-b.diff"] }
        end
      end.new("test_patch_p0").brew do
        s = read_file 'libexec/NOOP'
        assert !s.include?("NOOP"), "File was unpatched."
        assert s.include?("ABCD"), "File was not patched as expected."
      end
    end
  end

  def test_patch_p1
    shutup do
      Class.new(TestBall) do
        def patches
          { :p1 => ["file:///#{TEST_FOLDER}/patches/noop-a.diff"] }
        end
      end.new("test_patch_p1").brew do
        s = read_file 'libexec/NOOP'
        assert !s.include?("NOOP"), "File was unpatched."
        assert s.include?("ABCD"), "File was not patched as expected."
      end
    end
  end
end
