class Meanwhile < Formula
  desc "Implementation of Lotus Sametime Community Client protocol"
  homepage "http://meanwhile.sourceforge.net"
  url "https://downloads.sourceforge.net/project/meanwhile/meanwhile/1.0.2/meanwhile-1.0.2.tar.gz"
  sha256 "38a8059eaa549cbcb45ca0a5b453e9608ceadab360db2ae14581fb22ddabdf23"

  depends_on "pkg-config" => :build
  depends_on "glib"

  # glib has been updated:
  #   error "Only <glib.h> can be included directly."
  patch :DATA

  def install
    ENV.deparallelize

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-doxygen",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    cp "#{share}/doc/meanwhile-doc-#{version}/samples/login_server.c", testpath
    glib = Formula["glib"]
    meanwhile = Formula["meanwhile"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{meanwhile.opt_include}/meanwhile
      -L#{glib.opt_lib}
      -L#{meanwhile.opt_lib}
      -lglib-2.0
      -lmeanwhile
    ]
    system ENV.cc, "login_server.c", "-o", "login_server", *flags
  end
end

__END__
diff -r -u a/samples/logging_proxy.c b/samples/logging_proxy.c
--- a/samples/logging_proxy.c	2005-12-04 16:51:58.000000000 -0800
+++ b/samples/logging_proxy.c	2015-08-30 13:26:30.000000000 -0700
@@ -25,7 +25,6 @@
 #include <unistd.h>

 #include <glib.h>
-#include <glib/glist.h>

 #include <mw_cipher.h>
 #include <mw_common.h>
diff -r -u a/samples/login_server.c b/samples/login_server.c
--- a/samples/login_server.c	2005-12-04 17:02:24.000000000 -0800
+++ b/samples/login_server.c	2015-08-30 13:28:11.000000000 -0700
@@ -19,7 +19,6 @@
 #include <unistd.h>

 #include <glib.h>
-#include <glib/glist.h>

 #include <mw_cipher.h>
 #include <mw_common.h>
diff -r -u a/samples/nocipher_proxy.c b/samples/nocipher_proxy.c
--- a/samples/nocipher_proxy.c	2005-12-04 17:05:58.000000000 -0800
+++ b/samples/nocipher_proxy.c	2015-08-30 13:28:25.000000000 -0700
@@ -29,7 +29,6 @@
 #include <unistd.h>

 #include <glib.h>
-#include <glib/glist.h>

 #include <mw_common.h>
 #include <mw_message.h>
diff -r -u a/samples/redirect_server.c b/samples/redirect_server.c
--- a/samples/redirect_server.c	2005-12-04 17:08:25.000000000 -0800
+++ b/samples/redirect_server.c	2015-08-30 13:29:00.000000000 -0700
@@ -22,7 +22,6 @@
 #include <unistd.h>

 #include <glib.h>
-#include <glib/glist.h>

 #include <mw_common.h>
 #include <mw_message.h>
diff -r -u a/src/channel.c b/src/channel.c
--- a/src/channel.c	2005-12-08 14:04:46.000000000 -0800
+++ b/src/channel.c	2015-08-30 13:30:37.000000000 -0700
@@ -19,8 +19,6 @@
 */

 #include <glib.h>
-#include <glib/ghash.h>
-#include <glib/glist.h>
 #include <string.h>

 #include "mw_channel.h"
diff -r -u a/src/mw_debug.c b/src/mw_debug.c
--- a/src/mw_debug.c	2005-12-02 19:46:10.000000000 -0800
+++ b/src/mw_debug.c	2015-08-30 13:23:14.000000000 -0700
@@ -19,7 +19,7 @@
 */


-#include <glib/gstring.h>
+#include <glib.h>

 #include "mw_debug.h"

diff -r -u a/src/mw_message.h b/src/mw_message.h
--- a/src/mw_message.h	2005-12-14 16:30:28.000000000 -0800
+++ b/src/mw_message.h	2015-08-30 13:23:14.000000000 -0700
@@ -22,7 +22,7 @@
 #define _MW_MESSAGE_H


-#include <glib/glist.h>
+#include <glib.h>
 #include "mw_common.h"


diff -r -u a/src/mw_srvc_conf.h b/src/mw_srvc_conf.h
--- a/src/mw_srvc_conf.h	2005-12-14 16:30:28.000000000 -0800
+++ b/src/mw_srvc_conf.h	2015-08-30 13:23:14.000000000 -0700
@@ -22,7 +22,7 @@
 #define _MW_SRVC_CONF_H


-#include <glib/glist.h>
+#include <glib.h>
 #include "mw_common.h"


diff -r -u a/src/mw_srvc_dir.h b/src/mw_srvc_dir.h
--- a/src/mw_srvc_dir.h	2005-12-14 16:30:28.000000000 -0800
+++ b/src/mw_srvc_dir.h	2015-08-30 13:31:34.000000000 -0700
@@ -22,7 +22,6 @@


 #include <glib.h>
-#include <glib/glist.h>


 #ifdef __cplusplus
diff -r -u a/src/mw_srvc_place.h b/src/mw_srvc_place.h
--- a/src/mw_srvc_place.h	2005-12-14 16:30:28.000000000 -0800
+++ b/src/mw_srvc_place.h	2015-08-30 13:23:14.000000000 -0700
@@ -22,7 +22,7 @@
 #define _MW_SRVC_PLACE_H


-#include <glib/glist.h>
+#include <glib.h>
 #include "mw_common.h"


diff -r -u a/src/mw_srvc_resolve.h b/src/mw_srvc_resolve.h
--- a/src/mw_srvc_resolve.h	2005-12-14 16:30:28.000000000 -0800
+++ b/src/mw_srvc_resolve.h	2015-08-30 13:31:53.000000000 -0700
@@ -23,7 +23,6 @@


 #include <glib.h>
-#include <glib/glist.h>


 #ifdef __cplusplus
diff -r -u a/src/mw_st_list.h b/src/mw_st_list.h
--- a/src/mw_st_list.h	2005-12-14 16:30:28.000000000 -0800
+++ b/src/mw_st_list.h	2015-08-30 13:32:05.000000000 -0700
@@ -30,7 +30,6 @@


 #include <glib.h>
-#include <glib/glist.h>
 #include "mw_common.h"


diff -r -u a/src/mw_util.h b/src/mw_util.h
--- a/src/mw_util.h	2004-12-28 12:41:26.000000000 -0800
+++ b/src/mw_util.h	2015-08-30 13:32:21.000000000 -0700
@@ -23,8 +23,6 @@


 #include <glib.h>
-#include <glib/ghash.h>
-#include <glib/glist.h>


 #define map_guint_new() \
diff -r -u a/src/srvc_aware.c b/src/srvc_aware.c
--- a/src/srvc_aware.c	2005-12-08 14:02:11.000000000 -0800
+++ b/src/srvc_aware.c	2015-08-30 13:32:38.000000000 -0700
@@ -19,8 +19,6 @@
 */

 #include <glib.h>
-#include <glib/ghash.h>
-#include <glib/glist.h>
 #include <string.h>

 #include "mw_channel.h"
diff -r -u a/src/srvc_conf.c b/src/srvc_conf.c
--- a/src/srvc_conf.c	2005-12-27 18:46:54.000000000 -0800
+++ b/src/srvc_conf.c	2015-08-30 13:33:00.000000000 -0700
@@ -19,8 +19,6 @@
 */

 #include <glib.h>
-#include <glib/ghash.h>
-#include <glib/glist.h>

 #include <stdio.h>
 #include <stdlib.h>
diff -r -u a/src/srvc_dir.c b/src/srvc_dir.c
--- a/src/srvc_dir.c	2005-09-15 13:30:20.000000000 -0700
+++ b/src/srvc_dir.c	2015-08-30 13:23:14.000000000 -0700
@@ -18,7 +18,7 @@
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

-#include <glib/ghash.h>
+#include <glib.h>

 #include "mw_channel.h"
 #include "mw_common.h"
diff -r -u a/src/srvc_ft.c b/src/srvc_ft.c
--- a/src/srvc_ft.c	2005-09-15 13:30:37.000000000 -0700
+++ b/src/srvc_ft.c	2015-08-30 13:23:14.000000000 -0700
@@ -19,7 +19,7 @@
 */


-#include <glib/glist.h>
+#include <glib.h>

 #include "mw_channel.h"
 #include "mw_common.h"
diff -r -u a/src/srvc_im.c b/src/srvc_im.c
--- a/src/srvc_im.c	2005-12-27 18:46:54.000000000 -0800
+++ b/src/srvc_im.c	2015-08-30 13:33:16.000000000 -0700
@@ -19,7 +19,6 @@
 */

 #include <glib.h>
-#include <glib/glist.h>
 #include <string.h>

 #include "mw_channel.h"
diff -r -u a/src/srvc_place.c b/src/srvc_place.c
--- a/src/srvc_place.c	2005-12-02 18:00:29.000000000 -0800
+++ b/src/srvc_place.c	2015-08-30 13:33:26.000000000 -0700
@@ -19,8 +19,6 @@
 */

 #include <glib.h>
-#include <glib/ghash.h>
-#include <glib/glist.h>

 #include <stdio.h>
 #include <stdlib.h>
diff -r -u a/src/srvc_resolve.c b/src/srvc_resolve.c
--- a/src/srvc_resolve.c	2005-10-26 17:10:06.000000000 -0700
+++ b/src/srvc_resolve.c	2015-08-30 13:23:14.000000000 -0700
@@ -18,7 +18,7 @@
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

-#include <glib/ghash.h>
+#include <glib.h>

 #include "mw_channel.h"
 #include "mw_common.h"
diff -r -u a/src/srvc_store.c b/src/srvc_store.c
--- a/src/srvc_store.c	2005-11-18 17:52:42.000000000 -0800
+++ b/src/srvc_store.c	2015-08-30 13:23:14.000000000 -0700
@@ -18,7 +18,7 @@
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

-#include <glib/glist.h>
+#include <glib.h>

 #include "mw_channel.h"
 #include "mw_debug.h"
diff -r -u a/src/st_list.c b/src/st_list.c
--- a/src/st_list.c	2005-12-08 14:01:27.000000000 -0800
+++ b/src/st_list.c	2015-08-30 13:23:14.000000000 -0700
@@ -20,7 +20,7 @@

 #include <stdio.h>
 #include <string.h>
-#include <glib/gstring.h>
+#include <glib.h>

 #include "mw_debug.h"
 #include "mw_util.h"

