require 'formula'

class Automoc4 <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/automoc4/0.9.88/automoc4-0.9.88.tar.bz2'
  homepage 'http://techbase.kde.org/Development/Tools/Automoc4'
  md5 '91bf517cb940109180ecd07bc90c69ec'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def patches
    { :p0 => DATA }
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
