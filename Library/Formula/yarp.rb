require 'formula'

class Yarp < Formula
  homepage 'http://yarp.it'
  url 'http://downloads.sourceforge.net/yarp0/yarp-2.3.20.tar.gz'
  sha1 '7c9283bfe07b4da2f7c92ec584497d66248adb42'

  head 'https://yarp0.svn.sourceforge.net/svnroot/yarp0/trunk/yarp2'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on 'ace'
  depends_on 'gsl'
  depends_on 'gtk+'
  depends_on 'gtkmm'
  depends_on 'libglademm'
  depends_on 'sqlite'
  depends_on 'readline'
  depends_on 'jpeg'
  depends_on :x11

  # Fix bad includes with gtkmm-2.24.3
  # Check if this is still needed with new versions of yarp and gtkmm
  def patches
    DATA
  end

  def install
    args = std_cmake_args + %W[
      -DCREATE_LIB_MATH=TRUE
      -DCREATE_GUIS=TRUE
      -DCREATE_YMANAGER=TRUE
      -DYARP_USE_SYSTEM_SQLITE=TRUE
      -DCREATE_OPTIONAL_CARRIERS=TRUE
      -DENABLE_yarpcar_mjpeg_carrier=TRUE
      -DENABLE_yarpcar_rossrv_carrier=TRUE
      -DENABLE_yarpcar_tcpros_carrier=TRUE
      -DENABLE_yarpcar_xmlrpc_carrier=TRUE
      -DENABLE_yarpcar_bayer_carrier=TRUE
      -DUSE_LIBDC1394=FALSE
      -DENABLE_yarpcar_priority_carrier=TRUE
      -DCREATE_IDLS=TRUE
      -DENABLE_yarpidl_thrift=TRUE
      -DCREATE_YARPVIEW=TRUE
      -DCREATE_YARPSCOPE=TRUE
      -DCREATE_GYARPMANAGER=TRUE
      .]

    system "cmake", *args
    system "make install"
  end
end

__END__
diff --git a/extern/gtkdataboxmm/gtkdataboxmm/gtkdatabox/gtkdataboxmm/init.cc b/extern/gtkdataboxmm/gtkdataboxmm/gtkdatabox/gtkdataboxmm/init.cc
index 42270cb..e05fa62 100644
--- a/extern/gtkdataboxmm/gtkdataboxmm/gtkdatabox/gtkdataboxmm/init.cc
+++ b/extern/gtkdataboxmm/gtkdataboxmm/gtkdatabox/gtkdataboxmm/init.cc
@@ -17,6 +17,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <glibmm.h>
 #include <gtkmm/main.h>
 #include <gtkdataboxmmconfig.h>
 #include <gtkdataboxmm/wrap_init.h>
diff --git a/src/yarpmanager/gymanager/gymanager.cpp b/src/yarpmanager/gymanager/gymanager.cpp
index c7fee0b..8f68836 100644
--- a/src/yarpmanager/gymanager/gymanager.cpp
+++ b/src/yarpmanager/gymanager/gymanager.cpp
@@ -13,6 +13,7 @@
 #endif
 
 #include <iostream>
+#include <glibmm.h>
 #include <gtkmm/main.h>
 
 #include <yarp/os/Network.h>
diff --git a/src/yarpscope/src/main.cpp b/src/yarpscope/src/main.cpp
index 1073ca0..6afd0e2 100644
--- a/src/yarpscope/src/main.cpp
+++ b/src/yarpscope/src/main.cpp
@@ -11,6 +11,7 @@
 #include <yarp/os/ResourceFinder.h>
 #include <yarp/os/Network.h>
 
+#include <glibmm.h>
 #include <gtkmm/main.h>
 
 //#include <glibmm/i18n.h>
diff --git a/src/yarpscope/src/Graph.cpp b/src/yarpscope/src/Graph.cpp
index b825c40..8d3dec3 100644
--- a/src/yarpscope/src/Graph.cpp
+++ b/src/yarpscope/src/Graph.cpp
@@ -10,6 +10,8 @@
 #include "Debug.h"
 #include "PortReader.h"
 
+#include <glibmm.h>
+
 #include <gtkdataboxmm/lines.h>
 #include <gtkdataboxmm/bars.h>
 #include <gtkdataboxmm/points.h>
