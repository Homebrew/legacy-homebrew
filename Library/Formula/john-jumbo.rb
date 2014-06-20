require 'formula'

class JohnJumbo < Formula
  homepage 'http://www.openwall.com/john/'
  url 'http://www.openwall.com/john/g/john-1.7.9.tar.bz2'
  sha1 '8f77bdd42b7cf94ec176f55ea69c4da9b2b8fe3b'

  bottle do
    sha1 "e8e70d8faea2a658e13eedab50e47963ec4eee90" => :mavericks
    sha1 "ab7863263afde93de0e053e69600eabed08f372c" => :mountain_lion
    sha1 "b5fdd50dfc99f07f8afc1c6fa53f6afdc0c5684c" => :lion
  end

  conflicts_with 'john', :because => 'both install the same binaries'

  depends_on "openssl"

  patch do
    url "http://www.openwall.com/john/g/john-1.7.9-jumbo-7.diff.gz"
    sha1 "22fd8294e997f45a301cfeb65a8aa7083f25a55d"
  end

  # First patch taken from MacPorts, tells john where to find runtime files
  # Second patch protects against a redefinition of _mm_testz_si128 which
  # tanked the build in clang;
  # see https://github.com/Homebrew/homebrew/issues/26531
  patch :DATA

  fails_with :llvm do
    build 2334
    cause "Don't remember, but adding this to whitelist 2336."
  end

  def install
    ENV.deparallelize
    arch = MacOS.prefer_64_bit? ? "64-opencl" : "sse2-opencl"
    target = "macosx-x86-#{arch}"

    args = %W[-C src clean CC=#{ENV.cc} #{target}]

    if MacOS.version >= :snow_leopard
      case ENV.compiler
      when :clang
        # no openmp support
      when :gcc, :llvm
        args << "OMPFLAGS=-fopenmp -msse2 -D_FORTIFY_SOURCE=0"
      else
        args << "OMPFLAGS=-fopenmp -msse2"
      end
    end

    system "make", *args

    # Remove the README symlink and install the real file
    rm 'README'
    prefix.install 'doc/README'
    doc.install Dir['doc/*']

    # Only symlink the binary into bin
    (share/'john').install Dir['run/*']
    bin.install_symlink share/'john/john'

    # Source code defaults to 'john.ini', so rename
    mv share/'john/john.conf', share/'john/john.ini'
  end
end


__END__
--- a/src/params.h	2012-08-30 13:24:18.000000000 -0500
+++ b/src/params.h	2012-08-30 13:25:13.000000000 -0500
@@ -70,15 +70,15 @@
  * notes above.
  */
 #ifndef JOHN_SYSTEMWIDE
-#define JOHN_SYSTEMWIDE			0
+#define JOHN_SYSTEMWIDE			1
 #endif
 
 #if JOHN_SYSTEMWIDE
 #ifndef JOHN_SYSTEMWIDE_EXEC /* please refer to the notes above */
-#define JOHN_SYSTEMWIDE_EXEC		"/usr/libexec/john"
+#define JOHN_SYSTEMWIDE_EXEC		"HOMEBREW_PREFIX/share/john"
 #endif
 #ifndef JOHN_SYSTEMWIDE_HOME
-#define JOHN_SYSTEMWIDE_HOME		"/usr/share/john"
+#define JOHN_SYSTEMWIDE_HOME		"HOMEBREW_PREFIX/share/john"
 #endif
 #define JOHN_PRIVATE_HOME		"~/.john"
 #endif

diff --git a/src/rawSHA1_ng_fmt.c b/src/rawSHA1_ng_fmt.c
index 5f89cda..6cbd550 100644
--- a/src/rawSHA1_ng_fmt.c
+++ b/src/rawSHA1_ng_fmt.c
@@ -530,7 +530,7 @@ static void sha1_fmt_crypt_all(int count)
 
 #if defined(__SSE4_1__)
 
-# if !defined(__INTEL_COMPILER)
+# if !defined(__INTEL_COMPILER) && !defined(__clang__)
 // This intrinsic is not always available in GCC, so define it here.
 static inline int _mm_testz_si128 (__m128i __M, __m128i __V)
 {
