require "formula"

class Sqlitewrapped < Formula

  homepage "http://www.alhem.net/project/sqlite/"
  url "http://www.alhem.net/project/sqlite/sqlitewrapped-1.3.1.tar.gz"
  sha1 "d95614429d2397477445013ed3c0b3e1947ee883"

  fails_with :clang do
    build 503
    cause "Does not properly build for x86_64 architecture with clang."
  end

  fails_with :llvm do
    build 0
    cause "Does not properly build with llvm."
  end

  depends_on "sqlite"

  # patch for mac compile. code last updated in 2008, no new updates expected.
  patch :DATA

  def install

    system "make"
    system "make", "INSTALL_PREFIX=#{prefix}", "install"
    system "ln", "-s", "#{include}/libsqlitewrapped.h", "/usr/local/include/libsqlitewrapped.h"
    system "ln", "-s", "#{lib}/libsqlitewrapped.a", "/usr/local/lib/libsqlitewrapped.a"

  end
end

__END__
diff --git a/Makefile b/Makefile
index 8272c7f..4f765bf 100644
--- a/Makefile
+++ b/Makefile
@@ -6,8 +6,8 @@ INSTALL_LIB =	$(INSTALL_PREFIX)/lib
 INSTALL_INCLUDE = $(INSTALL_PREFIX)/include
 INSTALL =	/usr/bin/install
 
-INCLUDE =	-I/usr/devel/include -I.
-CFLAGS =	-Wall -g -O2 $(INCLUDE) -MD
+INCLUDE =	-I/usr/devel/include -I/usr/include
+CFLAGS =	-Wall -g -O2 $(INCLUDE) -MD -arch x86_64
 # namespace
 #CFLAGS +=	-DSQLITEW_NAMESPACE=sqlitew
 CPPFLAGS =	$(CFLAGS)
diff --git a/SysLog.cpp b/SysLog.cpp
index ef371a8..983c3ce 100644
--- a/SysLog.cpp
+++ b/SysLog.cpp
@@ -33,6 +33,7 @@ Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 
 #include <sqlite3.h>
 #include <syslog.h>
+#include <cstring>
 
 #include "Database.h"
 #include "Query.h"
@@ -48,7 +49,7 @@ namespace SQLITEW_NAMESPACE {
 SysLog::SysLog(const std::string& appname,int option,int facility)
 {
 static	char blah[100];
-	strcpy(blah, appname.c_str());
+	std::strcpy(blah, appname.c_str());
 	openlog(blah, option, facility);
 }
 
