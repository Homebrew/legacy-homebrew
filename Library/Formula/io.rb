require 'formula'

class Io < Formula
  homepage 'http://iolanguage.com/'
  url 'https://github.com/stevedekorte/io/archive/2011.09.12.tar.gz'
  sha1 'edb63aa4ee87052f1512f0770e0c9a9b1ba91082'

  head 'https://github.com/stevedekorte/io.git'

  option 'without-addons', 'Build without addons'
  option 'without-python', 'Build without python addon'

  depends_on 'cmake' => :build
  depends_on 'libevent'
  depends_on 'libffi'
  depends_on 'ossp-uuid'
  depends_on 'pcre'
  depends_on 'yajl'
  depends_on 'xz'

  # Used by Bignum add-on
  depends_on 'gmp' unless build.include? 'without-addons'

  # Used by Fonts add-on
  depends_on :freetype unless build.include? 'without-addons'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      make never completes. see:
      https://github.com/stevedekorte/io/issues/223
    EOS
  end

  # Fix recursive inline. See discussion in:
  # https://github.com/stevedekorte/io/issues/135
  def patches
    DATA
  end

  def install
    ENV.j1
    if build.include? 'without-addons'
      inreplace  "CMakeLists.txt",
        'add_subdirectory(addons)',
        '#add_subdirectory(addons)'
    end
    if build.include? 'without-python'
      inreplace  "addons/CMakeLists.txt",
        'add_subdirectory(Python)',
        '#add_subdirectory(Python)'
    end
    mkdir 'buildroot' do
      system "cmake", "..", *std_cmake_args
      system 'make'
      output = %x[./_build/binaries/io ../libs/iovm/tests/correctness/run.io]
      if $?.exitstatus != 0
        opoo "Test suite not 100% successful:\n#{output}"
      else
        ohai "Test suite ran successfully:\n#{output}"
      end
      system 'make install'
    end
  end
end

__END__
--- a/libs/basekit/source/Common_inline.h	2011-09-12 17:14:12.000000000 -0500
+++ b/libs/basekit/source/Common_inline.h	2011-12-17 00:46:02.000000000 -0600
@@ -52,7 +52,7 @@
 
 #if defined(__APPLE__) 
 
-	#define NS_INLINE static __inline__ __attribute__((always_inline))
+	#define NS_INLINE static inline
 
 	#ifdef IO_IN_C_FILE
 		// in .c 
