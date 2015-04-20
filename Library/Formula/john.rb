require 'formula'

class John < Formula
  homepage 'http://www.openwall.com/john/'
  url 'http://www.openwall.com/john/j/john-1.8.0.tar.xz'
  sha1 '423901b9b281c26656234ee31b362f1c0c2b680c'

  conflicts_with 'john-jumbo', :because => 'both install the same binaries'

  patch :DATA # Taken from MacPorts, tells john where to find runtime files

  fails_with :llvm do
    build 2334
    cause "Don't remember, but adding this to whitelist 2336."
  end

  def install
    ENV.deparallelize
    arch = MacOS.prefer_64_bit? ? '64' : 'sse2'
    target = "macosx-x86-#{arch}"

    system "make", "-C", "src", "clean", "CC=#{ENV.cc}", target

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
