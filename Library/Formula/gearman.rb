class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://launchpad.net/gearmand/1.2/1.1.12/+download/gearmand-1.1.12.tar.gz"
  sha256 "973d7a3523141a84c7b757c6f243febbc89a3631e919b532c056c814d8738acb"

  bottle do
    revision 1
    sha256 "8dfadc6df40598f71f14b315f8c49cb1152490bc95ce6199042ec0c829356216" => :el_capitan
    sha256 "a3eaa2cb9241381c6679fe9f9547c0477ba0f1b860f97a405b4f4d8d8b0d7c81" => :yosemite
    sha256 "a843fcbaf51130d36e86362fd832444de1815c1e546b3590b257eada0e6c6597" => :mavericks
    sha256 "0637f412fcb5d0c324c9d63120bd8ea4809d826e729d1c357438c690f95ae954" => :mountain_lion
  end

  option "with-mysql", "Compile with MySQL persistent queue enabled"
  option "with-postgresql", "Compile with Postgresql persistent queue enabled"

  # https://bugs.launchpad.net/gearmand/+bug/1318151 - Still ongoing as of 1.1.12
  # https://bugs.launchpad.net/gearmand/+bug/1236815 - Still ongoing as of 1.1.12
  # https://github.com/Homebrew/homebrew/issues/33246 - Still ongoing as of 1.1.12
  patch :DATA

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libpqxx" if build.with? "postgresql"
  depends_on :mysql => :optional
  depends_on :postgresql => :optional
  depends_on "hiredis" => :optional
  depends_on "libmemcached" => :optional
  depends_on "openssl" => :optional
  depends_on "cyassl" => :optional
  depends_on "tokyo-cabinet" => :optional

  def install
    # https://bugs.launchpad.net/gearmand/+bug/1368926
    Dir["tests/**/*.cc", "libtest/main.cc"].each do |test_file|
      next unless /std::unique_ptr/ === File.read(test_file)
      inreplace test_file, "std::unique_ptr", "std::auto_ptr"
    end

    args = [
      "--prefix=#{prefix}",
      "--localstatedir=#{var}",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--disable-libdrizzle",
      "--with-boost=#{Formula["boost"].opt_prefix}",
      "--with-sqlite3"
    ]

    if build.with? "cyassl"
      args << "--enable-ssl" << "--enable-cyassl"
    elsif build.with? "openssl"
      args << "--enable-ssl" << "--with-openssl=#{Formula["openssl"].opt_prefix}" << "--disable-cyassl"
    else
      args << "--disable-ssl" << "--disable-cyassl"
    end

    if build.with? "postgresql"
      args << "--enable-libpq" << "--with-postgresql=#{Formula["postgresql"].opt_bin}/pg_config"
    else
      args << "--disable-libpq" << "--without-postgresql"
    end

    if build.with? "libmemcached"
      args << "--enable-libmemcached" << "--with-memcached=#{Formula["memcached"].opt_bin}/memcached"
    else
      args << "--disable-libmemcached" << "--without-memcached"
    end

    args << "--disable-libtokyocabinet" if build.without? "tokyo-cabinet"

    args << (build.with?("mysql") ? "--with-mysql=#{Formula["mysql"].opt_bin}/mysql_config" : "--without-mysql")
    args << (build.with?("hiredis") ? "--enable-hiredis" : "--disable-hiredis")

    ENV.append_to_cflags "-DHAVE_HTONLL"

    (var/"log").mkpath
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "gearmand -d"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/gearmand</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end

__END__
diff --git a/libgearman-1.0/gearman.h b/libgearman-1.0/gearman.h
index 7f6d5e7..8f7a8f0 100644
--- a/libgearman-1.0/gearman.h
+++ b/libgearman-1.0/gearman.h
@@ -50,7 +50,11 @@
 #endif
 
 #ifdef __cplusplus
+#ifdef _LIBCPP_VERSION
 #  include <cinttypes>
+#else
+#  include <tr1/cinttypes>
+#endif
 #  include <cstddef>
 #  include <cstdlib>
 #  include <ctime>

diff --git a/libgearman/byteorder.cc b/libgearman/byteorder.cc
index 674fed9..96f0650 100644
--- a/libgearman/byteorder.cc
+++ b/libgearman/byteorder.cc
@@ -65,6 +65,8 @@ static inline uint64_t swap64(uint64_t in)
 }
 #endif
 
+#ifndef HAVE_HTONLL
+
 uint64_t ntohll(uint64_t value)
 {
   return swap64(value);
@@ -74,3 +76,5 @@ uint64_t htonll(uint64_t value)
 {
   return swap64(value);
 }
+
+#endif
\ No newline at end of file
diff --git a/libgearman/client.cc b/libgearman/client.cc
index 3db2348..4363b36 100644
--- a/libgearman/client.cc
+++ b/libgearman/client.cc
@@ -599,7 +599,7 @@ gearman_return_t gearman_client_add_server(gearman_client_st *client_shell,
   {
     Client* client= client_shell->impl();
 
-    if (gearman_connection_create(client->universal, host, port) == false)
+    if (gearman_connection_create(client->universal, host, port) == NULL)
     {
       assert(client->error_code() != GEARMAN_SUCCESS);
       return client->error_code();
@@ -614,7 +614,7 @@ gearman_return_t gearman_client_add_server(gearman_client_st *client_shell,
 
 gearman_return_t Client::add_server(const char *host, const char* service_)
 {
-  if (gearman_connection_create(universal, host, service_) == false)
+  if (gearman_connection_create(universal, host, service_) == NULL)
   {
     assert(error_code() != GEARMAN_SUCCESS);
     return error_code();
@@ -946,7 +946,7 @@ gearman_return_t gearman_client_job_status(gearman_client_st *client_shell,
       *denominator= do_task->impl()->denominator;
     }
 
-    if (is_known == false and is_running == false)
+    if (! is_known and ! is_running)
     {
       if (do_task->impl()->options.is_running) 
       {
