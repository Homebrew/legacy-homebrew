require 'formula'

# Note, do not use this formula.  It is a work in progress while
# getting hivex to be functional

class Hivex <Formula
  homepage 'http://www.libguestfs.org'
  url 'http://libguestfs.org/download/hivex/hivex-1.2.3.tar.gz'
  md5 '606dd17876be527bed68f93c6468b453'

  def patches
    DATA
  end

  def install
# This may or may not be needed.  Untested until we can get hivex to
# compile properly
#    fails_with_llvm "Undefined symbols when linking", :build => "2326"

    # Some of these configure arguments may not really be needed, and
    # should be tested/cleaned up after Hivex is gotten to work
    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}",
            "--mandir=#{man}",
            "--sysconfdir=#{etc}"]

    system "./configure", *args

    system "make install"

  end
end

__END__
--- a/lib/hivex.c	2010-08-27 17:46:47.000000000 +1000
+++ b/lib/hivex.c	2010-10-11 17:37:30.000000000 +1100
@@ -29,6 +29,9 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <errno.h>
+
+#define	ENOKEY		126
+
 #include <iconv.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
