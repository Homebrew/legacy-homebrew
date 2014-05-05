require 'formula'

class MysqlDeps < Requirement
  fatal true
  default_formula 'mariadb'

  satisfy { which 'mysql_config' }
end

class Mydumper < Formula
  homepage 'https://launchpad.net/mydumper'
  url 'https://launchpad.net/mydumper/0.6/0.6.1/+download/mydumper-0.6.1.tar.gz'
  sha1 'b18917e5cc363e8302b1f65d987a0218ebddacad'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on MysqlDeps
  depends_on 'glib'
  depends_on 'pcre'

  conflicts_with 'mysql-cluster', 'mysql', 'percona-server',
    :because => "MySQL 5.6+ broken hash.h, see: http://bugs.mysql.com/bug.php?id=70672"

  # https://bugs.launchpad.net/mydumper/+bug/1316001
  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  test do
    system "#{bin}/mydumper", "--version"
  end
end

__END__
diff --git a/cmake/modules/FindMySQL.cmake b/cmake/modules/FindMySQL.cmake
index e649f65..c36bb0e 100644
--- a/cmake/modules/FindMySQL.cmake
+++ b/cmake/modules/FindMySQL.cmake
@@ -30,6 +30,11 @@ if(UNIX)
             OUTPUT_VARIABLE MY_TMP)
 
         set(MYSQL_CFLAGS ${MY_TMP} CACHE STRING INTERNAL)
+        # HACK: set include/private 
+        exec_program(${MYSQL_CONFIG}
+            ARGS --variable=pkgincludedir
+            OUTPUT_VARIABLE MY_PRIVATE)
+        set(MYSQL_CFLAGS "${MYSQL_CFLAGS} -I${MY_PRIVATE}/private")
 
         # set INCLUDE_DIR
         exec_program(${MYSQL_CONFIG}
@@ -76,6 +81,7 @@ find_path(MYSQL_INCLUDE_DIR mysql.h
     ${MYSQL_ADD_INCLUDE_DIR}
     /usr/local/include
     /usr/local/include/mysql 
+    /usr/local/include/mysql/private
     /usr/local/mysql/include
     /usr/local/mysql/include/mysql
     /usr/include 
