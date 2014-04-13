require 'formula'

class Szl < Formula
  homepage 'http://code.google.com/p/szl/'
  url 'https://szl.googlecode.com/files/szl-1.0.tar.gz'
  sha1 'e4c6d4aec1afc025257d41dd77b8f5c25ea120d4'

  depends_on :autoconf
  depends_on :automake
  depends_on 'binutils' # For objdump
  depends_on 'icu4c'
  depends_on 'protobuf' # for protoc
  depends_on 'pcre'

  fails_with :clang do
    build 503
    cause <<-EOS.undent
      engine/symboltable.cc:47:7: error: qualified reference to 'Proc' is a constructor name rather than a type wherever a constructor can be declared
      Proc::Proc* SymbolTable::init_proc_ = NULL;
    EOS
  end

  # Patches fix compile error: https://code.google.com/p/szl/issues/detail?id=28
  # icu4u incompatibility: https://code.google.com/p/szl/issues/detail?id=29
  def patches
    DATA
  end

  def install
    ENV['OBJDUMP'] = "#{HOMEBREW_PREFIX}/bin/gobjdump"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff -ur a/src/engine/code.cc b/src/engine/code.cc
--- a/src/engine/code.cc  2013-10-05 14:51:48.370237663 +0100
+++ b/src/engine/code.cc  2013-10-13 04:21:10.900414799 +0100
@@ -13,6 +13,13 @@
 // limitations under the License.
 // ------------------------------------------------------------------------

+#ifdef HAVE_CONFIG_H
+# include <config.h>
+#endif
+#ifdef HAVE_UNISTD_H
+# include <unistd.h>
+#endif
+
 #include <time.h>
 #include <stdio.h>
 #include <string>
diff -ur a/src/utilities/random_base.cc b/src/utilities/random_base.cc
--- a/src/utilities/random_base.cc  2013-10-05 14:51:48.914234921 +0100
+++ b/src/utilities/random_base.cc  2013-10-13 04:22:14.616036162 +0100
@@ -13,6 +13,13 @@
 // limitations under the License.
 // ------------------------------------------------------------------------

+#ifdef HAVE_CONFIG_H
+# include <config.h>
+#endif
+#ifdef HAVE_UNISTD_H
+# include <unistd.h>
+#endif
+
 #include <math.h>
 #include <sys/time.h>
 #include <string>
diff -ur a/configure.ac b/configure.ac
--- a/configure.ac  2013-10-05 14:51:49.882230048 +0100
+++ b/configure.ac  2013-10-13 04:16:35.314057326 +0100
@@ -135,7 +135,7 @@
 AC_LINK_IFELSE(
   AC_LANG_PROGRAM(
       [[#include <unicode/timezone.h>]],
-      [[icu::TimeZone::createTimeZone("UTF");]]
+      [[icu::TimeZone::createTimeZone(icu::UnicodeString("UTF"));]]
   ),
   [AC_MSG_RESULT([yes])],
   [AC_MSG_FAILURE([no working ICU timezone library was found])]
diff -ur a/src/utilities/timeutils.cc b/src/utilities/timeutils.cc
--- a/src/utilities/timeutils.cc  2013-10-05 14:51:48.922234881 +0100
+++ b/src/utilities/timeutils.cc  2013-10-13 10:28:06.591967037 +0100
@@ -20,6 +20,7 @@
 #include "unicode/timezone.h"
 #include "unicode/udat.h"
 #include "unicode/ustring.h"
+#include "unicode/ucal.h"

 #include "public/porting.h"
 #include "public/logging.h"
@@ -32,6 +33,14 @@
 using icu::TimeZone;
 using icu::UnicodeString;

+// The ID of the zone returned by createTimeZone for unknown identifiers.
+// It changed from "GMT" to "Etc/Unknown" in ICU's r29462 (between the
+// 4.7.1 and 4.8 releases).
+#ifdef UCAL_UNKNOWN_ZONE_ID
+# define kUnknownZoneID UCAL_UNKNOWN_ZONE_ID
+#else
+# define kUnknownZoneID "GMT"
+#endif

 // Convert a "struct tm" interpreted as *GMT* into a time_t.

@@ -100,7 +109,8 @@
   if (strcasecmp(id, kDefaultOlsonId) == 0) {
     SzlMutexLock lock(&default_timezone_lock_);
     if (default_timezone_ == NULL) {
-      default_timezone_ = TimeZone::createTimeZone(kDefaultOlsonId);
+      UnicodeString name(kDefaultOlsonId);
+      default_timezone_ = TimeZone::createTimeZone(name);
       assert(default_timezone_ != NULL);
       assert(default_timezone_->getRawOffset() == kDefaultTimeZoneRawOffset);
     }
@@ -108,22 +118,17 @@
   } else {
     // TODO: check whether we will ever need non-ASCII identifiers
     // (and if we do, convert our UTF-8 to a UChar string first.)
-    timezone_ = TimeZone::createTimeZone(id);
+    UnicodeString requested_id(id), granted_id;
+    timezone_ = TimeZone::createTimeZone(requested_id);
     CHECK(timezone_ != NULL);
     // ICU does not directly say if the id was found, but we can deduce it.
-    if (timezone_->getRawOffset() == 0 && strcasecmp(id, "GMT") != 0) {
-      // getID() returns "GMT" iff "id" is "GMT" or is not recognized.
-      UnicodeString id_string;
-      timezone_->getID(id_string);
-      if (id_string.length() == 3) {
-        const UChar* id = id_string.getBuffer();
-        if (id[0] == 'G' && id[1] == 'M' && id[2] == 'T') {
-          // the id is "GMT" so the identifier was not found
-          delete timezone_;
-          timezone_ = NULL;
-        }
-      }
-    }
+    timezone_->getID(granted_id);
+    if (UnicodeString(kUnknownZoneID) == granted_id &&  // operator==
+        requested_id.caseCompare(granted_id, 0) != 0) {
+      // the id is "Etc/Unknown" (or "GMT") so the identifier was not found
+      delete timezone_;
+      timezone_ = NULL;
+    }  // else we got the zone we asked for.
   }
 }
