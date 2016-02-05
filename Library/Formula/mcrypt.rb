class Mcrypt < Formula
  desc "Replacement for the old crypt package and crypt(1) command"
  homepage "http://mcrypt.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mcrypt/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz"
  sha256 "5145aa844e54cca89ddab6fb7dd9e5952811d8d787c4f4bf27eb261e6c182098"

  bottle do
    revision 1
    sha256 "3cac7c430b1673877ba52bada82c3f710024dbd9f8dd0ff230c17c4623987beb" => :el_capitan
    sha256 "d7b36cbc7affc0e1851861381e92677abce2b011f184ab39234ff6cfbf021413" => :yosemite
    sha256 "6c060224061c43733929524f3e45010192d5fc4ece1972fbce7259f96f514fa2" => :mavericks
    sha256 "b6dd5f1210d4b0fffa7b14e4fce445c11d6245840fd38f08255149b6e27832c2" => :mountain_lion
  end

  option :universal

  depends_on "mhash"

  resource "libmcrypt" do
    url "https://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz"
    sha256 "e4eb6c074bbab168ac47b947c195ff8cef9d51a211cdd18ca9c9ef34d27a373e"
  end

  # Patch to correct inclusion of malloc function on OSX.
  # Upstream: https://sourceforge.net/p/mcrypt/patches/14/
  patch :DATA

  def install
    ENV.universal_binary if build.universal?

    resource("libmcrypt").stage do
      system "./configure", "--prefix=#{prefix}",
                            "--mandir=#{man}"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-libmcrypt-prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
      Hello, world!
    EOS
    system bin/"mcrypt", "--key", "TestPassword", "--force", "test.txt"
    rm "test.txt"
    system bin/"mcrypt", "--key", "TestPassword", "--decrypt", "test.txt.nc"
  end
end

__END__
diff --git a/src/rfc2440.c b/src/rfc2440.c
index 5a1f296..aeb501c 100644
--- a/src/rfc2440.c
+++ b/src/rfc2440.c
@@ -23,7 +23,12 @@
 #include <zlib.h>
 #endif
 #include <stdio.h>
+
+#ifdef __APPLE__
+#include <malloc/malloc.h>
+#else
 #include <malloc.h>
+#endif

 #include "xmalloc.h"
 #include "keys.h"
