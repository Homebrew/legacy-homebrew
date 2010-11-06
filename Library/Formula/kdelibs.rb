require 'formula'

class Kdelibs <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.5.2/src/kdelibs-4.5.2.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '9f2ad67a40f233a72d374800e1c2d2e2'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'gettext'
  depends_on 'pcre'
  depends_on 'jpeg'
  depends_on 'giflib'
  depends_on 'libpng' unless File.exist? "/usr/X11R6/lib"
  depends_on 'strigi'
  depends_on 'soprano'
  depends_on 'shared-desktop-ontologies'
  depends_on 'shared-mime-info'
  depends_on 'attica'
  depends_on 'docbook'
  depends_on 'd-bus'
  depends_on 'qt'

  def patches
    DATA
  end

  def install
    gettext_prefix = Formula.factory('gettext').prefix
    docbook_prefix = Formula.factory('docbook').prefix
    mkdir 'build'
    cd 'build'
    system "cmake .. #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{gettext_prefix} -DDOCBOOKXML_CURRENTDTD_DIR=#{docbook_prefix}/docbook/xml/4.5 -DDOCBOOKXSL_DIR=#{docbook_prefix} -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end
end


__END__

Index: kdelibs-4.3.2/kinit/kinit.cpp
===================================================================
--- kdelibs-4.3.2.orig/kinit/kinit.cpp	2009-10-14 18:47:04.000000000 +0200
+++ kdelibs-4.3.2/kinit/kinit.cpp	2009-10-14 19:10:14.000000000 +0200
@@ -489,6 +489,14 @@
       init_startup_info( startup_id, name, envc, envs );
 #endif
 
+  // Don't run this inside the child process, it crashes on OS/X 10.6
+  const QByteArray docPath = QFile::encodeName(KGlobalSettings::documentPath());
+  const QString helperpath = s_instance->dirs()->findExe(QString::fromLatin1("kdeinit4_helper"));
+#ifdef Q_WS_MAC
+  const QString bundlepath = s_instance->dirs()->findExe(QFile::decodeName(execpath));
+  const QString argvexe = s_instance->dirs()->findExe(QString::fromLatin1(_name));
+#endif
+
   d.errorMsg = 0;
   d.fork = fork();
   switch(d.fork) {
@@ -513,7 +521,6 @@
      if (cwd && *cwd) {
          (void)chdir(cwd);
      } else {
-         const QByteArray docPath = QFile::encodeName(KGlobalSettings::documentPath());
          (void)chdir(docPath.constData());
      }
 
@@ -549,10 +556,9 @@
      {
        int r;
        QByteArray procTitle;
-       d.argv = (char **) malloc(sizeof(char *) * (argc+1));
+       d.argv = (char **) malloc(sizeof(char *) * (argc+2));
        d.argv[0] = (char *) _name;
 #ifdef Q_WS_MAC
-       QString argvexe = s_instance->dirs()->findExe(QString::fromLatin1(d.argv[0]));
        if (!argvexe.isEmpty()) {
           QByteArray cstr = argvexe.toLocal8Bit();
           kDebug(7016) << "kdeinit4: launch() setting argv: " << cstr.data();
@@ -628,7 +634,6 @@
 
         QByteArray executable = execpath;
 #ifdef Q_WS_MAC
-        QString bundlepath = s_instance->dirs()->findExe(QFile::decodeName(executable));
         if (!bundlepath.isEmpty())
            executable = QFile::encodeName(bundlepath);
 #endif
@@ -642,25 +647,13 @@
         exit(255);
      }
 
-     void * sym = l.resolve( "kdeinitmain");
-     if (!sym )
-        {
-        sym = l.resolve( "kdemain" );
-        if ( !sym )
-           {
-            QString ltdlError = l.errorString();
-            fprintf(stderr, "Could not find kdemain: %s\n", qPrintable(ltdlError) );
-              QString errorMsg = i18n("Could not find 'kdemain' in '%1'.\n%2",
-                                      libpath, ltdlError);
-              exitWithErrorMsg(errorMsg);
-           }
-        }
-
-     d.result = 0; // Success
+     d.result = 2; // Try execing
      write(d.fd[1], &d.result, 1);
-     close(d.fd[1]);
 
-     d.func = (int (*)(int, char *[])) sym;
+     // We set the close on exec flag.
+     // Closing of d.fd[1] indicates that the execvp succeeded!
+     fcntl(d.fd[1], F_SETFD, FD_CLOEXEC);
+
      if (d.debug_wait)
      {
         fprintf(stderr, "kdeinit4: Suspending process\n"
@@ -674,8 +667,18 @@
         setup_tty( tty );
      }
 
-     exit( d.func(argc, d.argv)); /* Launch! */
+     QByteArray helperexe = QFile::encodeName(helperpath);
+     QByteArray libpathbytes = QFile::encodeName(libpath);
+     d.argv[argc] = libpathbytes.data();
+     d.argv[argc+1] = 0;
+
+     if (!helperexe.isEmpty())
+        execvp(helperexe, d.argv);
 
+     d.result = 1; // Error
+     write(d.fd[1], &d.result, 1);
+     close(d.fd[1]);
+     exit(255);
      break;
   }
   default:
Index: kdelibs-4.3.2/kinit/CMakeLists.txt
===================================================================
--- kdelibs-4.3.2.orig/kinit/CMakeLists.txt	2009-10-14 18:47:04.000000000 +0200
+++ kdelibs-4.3.2/kinit/CMakeLists.txt	2009-10-14 19:10:14.000000000 +0200
@@ -53,6 +53,16 @@
 
 install(TARGETS kdeinit4 ${INSTALL_TARGETS_DEFAULT_ARGS} )
 
+########### kdeinit4_helper ###############
+
+set(kdeinit4_helper_SRCS helper.cpp)
+
+kde4_add_executable(kdeinit4_helper NOGUI ${kdeinit4_helper_SRCS})
+
+target_link_libraries(kdeinit4_helper ${QT_QTCORE_LIBRARY})
+
+install(TARGETS kdeinit4_helper DESTINATION ${LIBEXEC_INSTALL_DIR} )
+
 ########### kwrapper4 ###############
 if (WIN32)
   set(kwrapper_SRCS kwrapper_win.cpp  )
Index: kdelibs-4.3.2/kinit/helper.cpp
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ kdelibs-4.3.2/kinit/helper.cpp	2009-10-14 19:11:06.000000000 +0200
@@ -0,0 +1,42 @@
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <QFile>
+#include <QLibrary>
+
+typedef int (*handler) (int, char *[]);
+
+int main(int argc, char *argv[])
+{
+    if (argc < 2)
+    {
+        fprintf(stderr, "Too few arguments\n");
+        exit(1);
+    }
+
+    QString libpath = QFile::decodeName(argv[argc-1]);
+    QLibrary l(libpath);
+
+    if (!libpath.isEmpty() && (!l.load() || !l.isLoaded()))
+    {
+        QString ltdlError = l.errorString();
+        fprintf(stderr, "Could not open library %s: %s\n", qPrintable(libpath), qPrintable(ltdlError) );
+        exit(1);
+    }
+
+    void * sym = l.resolve( "kdeinitmain");
+    if (!sym)
+    {
+        sym = l.resolve( "kdemain" );
+        if ( !sym )
+        {
+            QString ltdlError = l.errorString();
+            fprintf(stderr, "Could not find kdemain: %s\n", qPrintable(ltdlError) );
+            exit(1);
+        }
+    }
+
+    handler func = (int (*)(int, char *[])) sym;
+    exit( func(argc - 1, argv)); /* Launch! */
+}
+
