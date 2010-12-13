require 'formula'

class Dvdauthor <Formula
  url 'http://downloads.sourceforge.net/project/dvdauthor/dvdauthor/0.6.14/dvdauthor-0.6.14.tar.gz'
  homepage 'http://dvdauthor.sourceforge.net/'
  md5 'bd646b47950c4091ffd781d43fd2c5e9'

  depends_on 'libdvdread'
  depends_on 'libpng'

  def patches
    # won't compile without including iconv headers in readxml.c
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"

    # regular install will error out due to attempts to create the same
    # directories twice. mkdir -p will mitigate this.
    ENV['MKDIRPROG'] = '/bin/mkdir -p'
    system "make install"
  end
end

__END__
diff --git a/src/readxml.c b/src/readxml.c
index e96f869..5ff2b5d 100644
--- a/src/readxml.c
+++ b/src/readxml.c
@@ -28,6 +28,8 @@
 
 #include <libxml/xmlreader.h>
 
+#include <iconv.h>
+
 #include "readxml.h"
 
 #ifdef HAVE_LANGINFO_CODESET
