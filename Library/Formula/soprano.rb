require 'formula'

class Soprano < Formula
  homepage 'http://soprano.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/soprano/Soprano/2.9.0/soprano-2.9.0.tar.bz2'
  sha1 '2bc0e0874f115c97a34d0bf267a1c31957ec7497'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'clucene' => :optional
  depends_on 'raptor' => :optional
  depends_on 'redland' => :optional

  def patches; DATA; end

  def install
    ENV['CLUCENE_HOME'] = HOMEBREW_PREFIX

    disabled_options = [
      "-DSOPRANO_DISABLE_DBUS=TRUE",
      "-DSOPRANO_DISABLE_SESAME2_BACKEND=TRUE",
      "-DSOPRANO_DISABLE_VIRTUOSO_BACKEND=TRUE",
      # SOPRANO_DISABLE_REDLAND_BACKEND
      "-DSOPRANO_DISABLE_RAPTOR_PARSER=TRUE",
      "-DSOPRANO_DISABLE_RAPTOR_SERIALIZER=TRUE"
    ].join(' ')
    system "cmake #{std_cmake_parameters} #{disabled_options} ."
    system "make install"
  end
end

__END__
diff -u a/server/servercore.cpp.orig b/server/servercore.cpp
--- a/server/servercore.cpp.orig	2013-04-08 10:34:34.000000000 -0400
+++ b/server/servercore.cpp	2013-04-08 10:34:52.000000000 -0400
@@ -41,7 +41,9 @@
 #include <QtNetwork/QTcpServer>
 #include <QtNetwork/QHostAddress>
 #include <QtNetwork/QTcpSocket>
+#ifdef BUILD_DBUS_SUPPORT
 #include <QtDBus/QtDBus>
+#endif


 const quint16 Soprano::Server::ServerCore::DEFAULT_PORT = 5000;
