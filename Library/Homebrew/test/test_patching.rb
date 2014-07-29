require 'testing_env'
require 'formula'
require 'testball'

class PatchingTests < Homebrew::TestCase
  PATCH_URL_A = "file://#{TEST_DIRECTORY}/patches/noop-a.diff"
  PATCH_URL_B = "file://#{TEST_DIRECTORY}/patches/noop-b.diff"
  PATCH_A_CONTENTS = File.read "#{TEST_DIRECTORY}/patches/noop-a.diff"
  PATCH_B_CONTENTS = File.read "#{TEST_DIRECTORY}/patches/noop-b.diff"

  def formula(*args, &block)
    super do
      url "file://#{TEST_DIRECTORY}/tarballs/testball-0.1.tbz"
      sha1 "482e737739d946b7c8cbaf127d9ee9c148b999f5"
      class_eval(&block)
    end
  end

  def teardown
    @_f.clear_cache
    @_f.patchlist.select(&:external?).each(&:clear_cache)
  end

  def assert_patched(path)
    s = File.read(path)
    refute_includes s, "NOOP", "#{path} was not patched as expected"
    assert_includes s, "ABCD", "#{path} was not patched as expected"
  end

  def test_single_patch
    shutup do
      formula do
        def patches
          PATCH_URL_A
        end
      end.brew { assert_patched 'libexec/NOOP' }
    end
  end

  def test_single_patch_dsl
    shutup do
      formula do
        patch do
          url PATCH_URL_A
          sha1 "fa8af2e803892e523fdedc6b758117c45e5749a2"
        end
      end.brew { assert_patched 'libexec/NOOP' }
    end
  end

  def test_single_patch_dsl_with_strip
    shutup do
      formula do
        patch :p1 do
          url PATCH_URL_A
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
            url PATCH_URL_A
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
          url PATCH_URL_B
          sha1 "3b54bd576f998ef6d6623705ee023b55062b9504"
        end
      end.brew { assert_patched 'libexec/NOOP' }
    end
  end

  def test_patch_p0
    shutup do
      formula do
        def patches
          { :p0 => PATCH_URL_B }
        end
      end.brew { assert_patched 'libexec/NOOP' }
    end
  end

  def test_patch_array
    shutup do
      formula do
        def patches
          [PATCH_URL_A]
        end
      end.brew { assert_patched 'libexec/noop' }
    end
  end

  def test_patch_hash
    shutup do
      formula do
        def patches
          { :p1 => PATCH_URL_A }
        end
      end.brew { assert_patched 'libexec/noop' }
    end
  end

  def test_patch_hash_array
    shutup do
      formula do
        def patches
          { :p1 => [PATCH_URL_A] }
        end
      end.brew { assert_patched 'libexec/noop' }
    end
  end

  def test_patch_string
    shutup do
      formula do
        patch PATCH_A_CONTENTS
      end.brew { assert_patched 'libexec/noop' }
    end
  end

  def test_patch_string_with_strip
    shutup do
      formula do
        patch :p0, PATCH_B_CONTENTS
      end.brew { assert_patched 'libexec/noop' }
    end
  end

  def test_patch_DATA_constant
    shutup do
      formula("test", Pathname.new(__FILE__).expand_path) do
        def patches
          Formula::DATA
        end
      end.brew { assert_patched "libexec/noop" }
    end
  end
end

__END__
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
