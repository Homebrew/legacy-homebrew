require 'testing_env'
require 'test/testball'


class DefaultPatchBall < TestBall
  def patches
    # Default is p1
    "file:///#{TEST_FOLDER}/patches/noop-a.diff"
  end
end

class ListPatchBall < TestBall
  def patches
    ["file:///#{TEST_FOLDER}/patches/noop-a.diff"]
  end
end

class P0PatchBall < TestBall
  def patches
    { :p0 => ["file:///#{TEST_FOLDER}/patches/noop-b.diff"] }
  end
end

class P1PatchBall < TestBall
  def patches
    { :p1 => ["file:///#{TEST_FOLDER}/patches/noop-a.diff"] }
  end
end


class PatchingTests < Test::Unit::TestCase
  def read_file path
    File.open(path, 'r') { |f| f.read }
  end

  def test_single_patch
    shutup do
      DefaultPatchBall.new('test_patch').brew do
        s = read_file 'libexec/NOOP'
        assert !s.include?("NOOP"), "File was unpatched."
        assert s.include?("ABCD"), "File was not patched as expected."
      end
    end
  end

  def test_patch_list
    shutup do
      ListPatchBall.new('test_patch_list').brew do
        s = read_file 'libexec/NOOP'
        assert !s.include?("NOOP"), "File was unpatched."
        assert s.include?("ABCD"), "File was not patched as expected."
      end
    end
  end

  def test_p0_patch
    shutup do
      P0PatchBall.new('test_p0_patch').brew do
        s = read_file 'libexec/NOOP'
        assert !s.include?("NOOP"), "File was unpatched."
        assert s.include?("ABCD"), "File was not patched as expected."
      end
    end
  end

  def test_p1_patch
    shutup do
      P1PatchBall.new('test_p1_patch').brew do
        s = read_file 'libexec/NOOP'
        assert !s.include?("NOOP"), "File was unpatched."
        assert s.include?("ABCD"), "File was not patched as expected."
      end
    end
  end
end
