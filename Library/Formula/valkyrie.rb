require 'formula'

class Valkyrie < Formula
  homepage 'http://valgrind.org/downloads/guis.html'
  url 'http://valgrind.org/downloads/valkyrie-2.0.0.tar.bz2'
  sha1 '999a6623eea5b7b8d59b55d59b8198f4fcd08add'

  head 'svn://svn.valgrind.org/valkyrie/trunk'

  depends_on 'qt'
  depends_on 'valgrind'

  # [fix] error: use of undeclared identifier 'usleep'
  patch :DATA

  def install
    system "qmake", "PREFIX=#{prefix}"
    system "make install"
    prefix.install bin/'valkyrie.app'
  end
end

__END__
diff --git a/src/objects/tool_object.cpp b/src/objects/tool_object.cpp
index 5424db7..85e54c7 100644
--- a/src/objects/tool_object.cpp
+++ b/src/objects/tool_object.cpp
@@ -51,6 +51,7 @@ stopProcess()
 #include <QString>
 #include <QStringList>
 
+#include <unistd.h>
 
 #if 1
 //#include "config.h"
diff --git a/src/utils/vk_config.cpp b/src/utils/vk_config.cpp
index 49d5cf2..4efbb1d 100644
--- a/src/utils/vk_config.cpp
+++ b/src/utils/vk_config.cpp
@@ -35,7 +35,7 @@
 #include <QSize>
 #include <QStringList>
 
-
+#include <unistd.h>
 
 /***************************************************************************/
 /*!
diff --git a/src/utils/vk_utils.cpp b/src/utils/vk_utils.cpp
index 4dcd893..e182683 100644
--- a/src/utils/vk_utils.cpp
+++ b/src/utils/vk_utils.cpp
@@ -22,6 +22,7 @@
 #include "utils/vk_config.h"        // vkname()
 
 #include <cstdlib>                  // exit, mkstemp, free/malloc, etc
+#include <unistd.h>
 
 #include <QDateTime>
 #include <QFile>
