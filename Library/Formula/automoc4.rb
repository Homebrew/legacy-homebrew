require 'formula'

class Automoc4 < Formula
  homepage 'http://techbase.kde.org/Development/Tools/Automoc4'
  url 'ftp://ftp.kde.org/pub/kde/stable/automoc4/0.9.88/automoc4-0.9.88.tar.bz2'
  sha1 'd864c3dda99d8b5f625b9267acfa1d88ff617e3a'

  depends_on 'cmake' => :build
  depends_on 'qt'

  # Patch needed to find Qt in Homebrew upstreamed but upstream version
  # does not apply. Won't be needed for next version.
  # https://projects.kde.org/projects/kdesupport/automoc/repository/revisions/6b9597ff
  patch :p0, :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end

__END__
--- kde4automoc.cpp.old	2009-01-22 18:50:09.000000000 +0000
+++ kde4automoc.cpp	2010-03-15 22:26:03.000000000 +0000
@@ -175,16 +175,22 @@
     dotFilesCheck(line == "MOC_INCLUDES:\n");
     line = dotFiles.readLine().trimmed();
     const QStringList &incPaths = QString::fromUtf8(line).split(';', QString::SkipEmptyParts);
+    QSet<QString> frameworkPaths;
     foreach (const QString &path, incPaths) {
         Q_ASSERT(!path.isEmpty());
         mocIncludes << "-I" + path;
+        if (path.endsWith(".framework/Headers")) {
+            QDir framework(path);
+            // Go up twice to get to the framework root
+            framework.cdUp();
+            framework.cdUp();
+            frameworkPaths << framework.path();
+        }
     }
 
-    // on the Mac, add -F always, otherwise headers in the frameworks won't be found
-    // is it necessary to do this only optionally ? Alex
-#ifdef Q_OS_MAC
-    mocIncludes << "-F/Library/Frameworks";
-#endif
+    foreach (const QString &path, frameworkPaths) {
+        mocIncludes << "-F" << path;
+    }
 
     line = dotFiles.readLine();
     dotFilesCheck(line == "CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE:\n");
