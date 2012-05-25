require 'formula'

class Loudmouth < Formula
  homepage 'http://www.loudmouth-project.org/'
  url 'http://mcabber.com/files/loudmouth-1.4.3-20111204.tar.bz2'
  version '1.4.3.111204'
  sha1 '38010a74d28fa06624b7461e515aec47c0ff140e'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'libidn'

  # Fix compilation against newer glib. See:
  # https://github.com/mxcl/homebrew/issues/12240
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end


__END__
diff --git a/loudmouth/lm-error.c b/loudmouth/lm-error.c
index 103aaaf..74d3315 100644
--- a/loudmouth/lm-error.c
+++ b/loudmouth/lm-error.c
@@ -25,7 +25,7 @@
  */
 
 #include <config.h>
-#include <glib/gerror.h>
+#include <glib.h>
 #include "lm-error.h"
 
 GQuark

