class Opentsdb < Formula
  homepage "http://opentsdb.net"
  url "https://github.com/OpenTSDB/opentsdb/releases/download/v2.1.0/opentsdb-2.1.0.tar.gz"
  sha256 "b76e36a2d744170dde0ecd7ff3b937cbe68dd9fab9ce885aab5847de3e975157"

  def install
    ENV.deparallelize
    system "./build.sh --prefix=#{prefix}"
    system "mkdir -p #{prefix}/share/opentsdb/static/gwt/standard/images/ie6"
    Dir.chdir("build") do
      system "make", "install"
    end
  end

  test do
    system "true"
  end

  patch :p0, :DATA
end
__END__
index 7f0fb57..874d45c 100644
--- build-aux/rpm/logback.xml
+++ build-aux/rpm/logback.xml
@@ -14,11 +14,11 @@
   </appender>
   
   <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
-    <file>/var/log/opentsdb/opentsdb.log</file>
+    <file>/usr/local/var/log/opentsdb/opentsdb.log</file>
     <append>true</append>
     
     <rollingPolicy class="ch.qos.logback.core.rolling.FixedWindowRollingPolicy">
-      <fileNamePattern>/var/log/opentsdb/opentsdb.log.%i</fileNamePattern>
+      <fileNamePattern>/usr/local/var/log/opentsdb/opentsdb.log.%i</fileNamePattern>
       <minIndex>1</minIndex>
       <maxIndex>3</maxIndex>
     </rollingPolicy>
index 11f66ca..e4a90f9 100644
--- build-aux/rpm/opentsdb.conf
+++ build-aux/rpm/opentsdb.conf
@@ -27,7 +27,7 @@ tsd.network.port = 4242
 # ----------- HTTP -----------
 # The location of static files for the HTTP GUI interface.
 # *** REQUIRED ***
-tsd.http.staticroot = /usr/share/opentsdb/static/
+tsd.http.staticroot = /usr/local/opt/opentsdb/share/opentsdb/static/
 
 # Where TSD should write it's cache files to
 # *** REQUIRED ***
@@ -36,10 +36,11 @@ tsd.http.cachedir = /tmp/opentsdb
 # --------- CORE ----------
 # Whether or not to automatically create UIDs for new metric types, default
 # is False
-#tsd.core.auto_create_metrics = false
+tsd.core.auto_create_metrics = true
+tsd.storage.fix_duplicates = true
 
 # Full path to a directory containing plugins for OpenTSDB
-tsd.core.plugin_path = /usr/share/opentsdb/plugins
+#tsd.core.plugin_path = /usr/share/opentsdb/plugins
 
 # --------- STORAGE ----------
 # Whether or not to enable data compaction in HBase, default is True
index 2880752..ebed551 100755
--- build.sh
+++ build.sh
@@ -6,4 +6,4 @@ cd build
 test -f Makefile || ../configure "$@"
 MAKE=make
 [ `uname -s` = "FreeBSD" ] && MAKE=gmake
-exec ${MAKE} "$@"
+exec ${MAKE}
