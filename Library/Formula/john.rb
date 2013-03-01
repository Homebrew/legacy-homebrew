require 'formula'

class John < Formula
  homepage 'http://www.openwall.com/john/'
  url 'http://www.openwall.com/john/g/john-1.7.9.tar.bz2'
  sha1 '8f77bdd42b7cf94ec176f55ea69c4da9b2b8fe3b'

  option 'jumbo', 'Build with jumbo-7 features'

  def patches
    p = [DATA] # Taken from MacPorts, tells john where to find runtime files
    p << "http://www.openwall.com/john/g/john-1.7.9-jumbo-7.diff.gz" if build.include? 'jumbo'
    return p
  end

  fails_with :llvm do
    build 2334
    cause "Don't remember, but adding this to whitelist 2336."
  end

  fails_with :clang do
    build 421
    cause "rawSHA1_ng_fmt.c:535:19: error: redefinition of '_mm_testz_si128'"
  end if build.include? 'jumbo'

  def install
    ENV.deparallelize
    arch = Hardware.is_64_bit? ? '64' : 'sse2'

    cd 'src' do
      system "make", "clean", "macosx-x86-#{arch}", "CC=#{ENV.cc}"
    end

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
