class Gtimer < Formula
  desc "GTimer is a GTK application for timing how you spend your time among various projects and tasks with support for generating plain text and HTML reports."
  homepage "http://www.k5n.us/gtimer.php"
  url "http://downloads.sourceforge.net/project/gtimer/2.0.0/gtimer-2.0.0.tar.gz"
  version "2.0.0"
  sha256 "a2dd70793a5b1b4d497be0c4429b8e8cef6910497b6af8fbdedff00764308458"

  depends_on :x11
  depends_on "gtk+"


  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
                          "--with-gtk2"
    system "make"
    system "make", "install"
  end

end

__END__
diff --git a/task.c b/task.c
index baec803..8067369 100644
--- a/task.c
+++ b/task.c
@@ -56,7 +56,7 @@
 #include <dirent.h>
 #endif
 #include <errno.h>
-#include <malloc.h>
+#include <malloc/malloc.h>
 #include <string.h>
 #include <ctype.h>
 #include <sys/types.h>

diff --git a/project.c b/project.c
index 5094d13..aaf8f31 100644
--- a/project.c
+++ b/project.c
@@ -40,7 +40,7 @@
 #include <dirent.h>
 #endif
 #include <errno.h>
-#include <malloc.h>
+#include <malloc/malloc.h>
 #include <string.h>
 #include <ctype.h>
 #include <sys/types.h>

diff --git a/custom-list.c b/custom-list.c
index 1e83c18..31b7606 100644
--- a/custom-list.c
+++ b/custom-list.c
@@ -610,8 +610,8 @@ custom_list_append_record (CustomList   *custom_list,
   gulong        newsize;
   guint         pos;
 
-  g_return_if_fail (CUSTOM_IS_LIST(custom_list));
-  g_return_if_fail (name != NULL);
+  g_return_val_if_fail (CUSTOM_IS_LIST(custom_list), NULL);
+  g_return_val_if_fail (name != NULL, NULL);
 
   pos = custom_list->num_rows;
 
diff --git a/xextras.c b/xextras.c
index e2a3649..a152193 100644
--- a/xextras.c
+++ b/xextras.c
@@ -79,8 +79,10 @@ Display *display;
 */
 void set_x_error_handler ()
 {
+  /*
   XSetErrorHandler ( x_error_handler );
   XSetIOErrorHandler ( x_io_error_handler );
+  */
 }
 
 

