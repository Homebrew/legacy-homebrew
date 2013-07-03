require 'testing_env'
require 'test/testball'

class PatchingTests < Test::Unit::TestCase
  def read_file path
    File.open(path, 'r') { |f| f.read }
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
          "file:///#{TEST_FOLDER}/patches/noop-a.diff"
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
