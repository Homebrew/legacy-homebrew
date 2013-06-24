require 'formula'

class Libglademm < Formula
  homepage 'http://gnome.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libglademm/2.6/libglademm-2.6.7.tar.bz2'
  sha1 'd7c0138c80ea337d2e9ae55f74a6953ce2eb9f5d'

  depends_on 'pkg-config' => :build
  depends_on 'gtkmm'
  depends_on 'libglade'
  depends_on :x11

  def patches
    # fixes build against gtkmm-2.24.3
    # libglademm hasn't changed upstream since 2008
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
diff --git a/examples/derived/main.cc b/examples/derived/main.cc
index 5a72f63..38afc96 100644
--- a/examples/derived/main.cc
+++ b/examples/derived/main.cc
@@ -16,6 +16,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */

+#include <gtkmm.h>
 #include "deriveddialog.h"
 #include <iostream>

diff --git a/examples/variablesmap/main.cc b/examples/variablesmap/main.cc
index 145c93d..0c41840 100644
--- a/examples/variablesmap/main.cc
+++ b/examples/variablesmap/main.cc
@@ -16,7 +16,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */

-#include <gtkmm/main.h>
+#include <gtkmm.h>
 #include "examplewindow.h"

 int main (int argc, char *argv[])
