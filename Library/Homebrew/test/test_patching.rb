require 'testing_env'
require 'formula'
require 'testball'

class PatchingTests < Test::Unit::TestCase
  def formula(&block)
    super do
      url "file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
      sha1 "482e737739d946b7c8cbaf127d9ee9c148b999f5"
      class_eval(&block)
    end
  end

  def assert_patched(path)
    s = File.read(path)
    assert !s.include?("NOOP"), "File was unpatched."
    assert s.include?("ABCD"), "File was not patched as expected."
  end

  def test_single_patch
    shutup do
      formula do
        def patches
          "file:///#{TEST_FOLDER}/patches/noop-a.diff"
        end
      end.brew { assert_patched 'libexec/NOOP' }
    end
  end

  def test_single_patch_dsl
    shutup do
      formula do
        patch do
          url "file:///#{TEST_FOLDER}/patches/noop-a.diff"
          sha1 "fa8af2e803892e523fdedc6b758117c45e5749a2"
        end
      end.brew { assert_patched 'libexec/NOOP' }
    end
  end

  def test_single_patch_dsl_with_strip
    shutup do
      formula do
        patch :p1 do
          url "file:///#{TEST_FOLDER}/patches/noop-a.diff"
          sha1 "fa8af2e803892e523fdedc6b758117c45e5749a2"
        end
      end.brew { assert_patched 'libexec/NOOP' }
    end
  end

  def test_single_patch_dsl_with_incorrect_strip
    assert_raises(ErrorDuringExecution) do
      shutup do
        formula do
          patch :p0 do
            url "file:///#{TEST_FOLDER}/patches/noop-a.diff"
            sha1 "fa8af2e803892e523fdedc6b758117c45e5749a2"
          end
        end.brew { }
      end
    end
  end

  def test_patch_p0_dsl
    shutup do
      formula do
        patch :p0 do
          url "file:///#{TEST_FOLDER}/patches/noop-b.diff"
          sha1 "3b54bd576f998ef6d6623705ee023b55062b9504"
        end
      end.brew { assert_patched 'libexec/NOOP' }
    end
  end

  def test_patch_p0
    shutup do
      formula do
        def patches
          { :p0 => "file:///#{TEST_FOLDER}/patches/noop-b.diff" }
        end
      end.brew { assert_patched 'libexec/NOOP' }
    end
  end

  def test_patch_array
    shutup do
      formula do
        def patches
          ["file:///#{TEST_FOLDER}/patches/noop-a.diff"]
        end
      end.brew { assert_patched 'libexec/noop' }
    end
  end

  def test_patch_hash
    shutup do
      formula do
        def patches
          { :p1 => "file:///#{TEST_FOLDER}/patches/noop-a.diff" }
        end
      end.brew { assert_patched 'libexec/noop' }
    end
  end

  def test_patch_hash_array
    shutup do
      formula do
        def patches
          { :p1 => ["file:///#{TEST_FOLDER}/patches/noop-a.diff"] }
        end
      end.brew { assert_patched 'libexec/noop' }
    end
  end

  def test_patch_string
    shutup do
      formula do
        patch %q{
diff --git a/libexec/NOOP b/libexec/NOOP
index bfdda4c..e08d8f4 100755
--- a/libexec/NOOP
+++ b/libexec/NOOP
@@ -1,2 +1,2 @@
 #!/bin/bash
-echo NOOP
\ No newline at end of file
+echo ABCD
\ No newline at end of file
}
      end.brew { assert_patched 'libexec/noop' }
    end
  end

  def test_patch_string_with_strip
    shutup do
      formula do
        patch :p0, %q{
diff --git libexec/NOOP libexec/NOOP
index bfdda4c..e08d8f4 100755
--- libexec/NOOP
+++ libexec/NOOP
@@ -1,2 +1,2 @@
 #!/bin/bash
-echo NOOP
\ No newline at end of file
+echo ABCD
\ No newline at end of file
}
      end.brew { assert_patched 'libexec/noop' }
    end
  end
end
