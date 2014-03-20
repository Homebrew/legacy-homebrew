require 'formula'

class Gearman < Formula
  homepage 'http://gearman.org/'
  url 'https://launchpad.net/gearmand/1.2/1.1.9/+download/gearmand-1.1.9.tar.gz'
  sha1 '59ec305a4535451c3b51a21d2525e1c07770419d'

  option 'with-mysql', 'Compile with MySQL persistent queue enabled'
  option 'with-postgresql', 'Compile with Postgresql persistent queue enabled'

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'libevent'
  depends_on 'ossp-uuid'
  depends_on :mysql => :optional
  depends_on :postgresql => :optional

  # build fix for tr1 -> std
  # Fixes have also been applied upstream
  patch :DATA if MacOS.version >= :mavericks


  def install
    args = ["--prefix=#{prefix}"]
    args << "--without-mysql" if build.without? 'mysql'
    if build.with? 'postgresql'
      pg_config = "#{Formula["postgresql"].opt_bin}/pg_config"
      args << "--with-postgresql=#{pg_config}"
    end
    system "./configure", *args
    system "make install"
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
index 850a26d..8f7a8f0 100644
--- a/libgearman-1.0/gearman.h
+++ b/libgearman-1.0/gearman.h
@@ -50,7 +50,11 @@
 #endif

 #ifdef __cplusplus
+#ifdef _LIBCPP_VERSION
+#  include <cinttypes>
+#else
 #  include <tr1/cinttypes>
+#endif
 #  include <cstddef>
 #  include <cstdlib>
 #  include <ctime>
