class Samba < Formula
  homepage "https://samba.org/"
  url "https://download.samba.org/pub/samba/stable/samba-3.6.25.tar.gz"
  sha1 "86fbfcfe80454cc7dbe510e7d58c02922cac3efa"

  bottle do
    sha1 "839c682640aa3fce69b7b2ba02a017130143bbca" => :yosemite
    sha1 "aeb31b142a8ac1504b0a9657e9aad6098516fc27" => :mavericks
    sha1 "6d0320a3b8d0ef29bf4909cfb9eee234be4f5353" => :mountain_lion
  end

  conflicts_with "talloc", :because => "both install `include/talloc.h`"

  skip_clean "private"
  skip_clean "var/locks"

  # Fixes the Grouplimit of 16 users os OS X.
  # Bug has been raised upstream:
  # https://bugzilla.samba.org/show_bug.cgi?id=8773
  patch :DATA

  def install
    cd "source3" do
      # This stops samba dumping .msg and .dat files directly into lib
      # It can't be set with a configure switch - There isn't one that fine-grained.
      # https://bugzilla.samba.org/show_bug.cgi?id=11120
      inreplace "configure", "${MODULESDIR}", "#{share}/codepages"

      system "./configure", "--disable-debug",
                            "--prefix=#{prefix}",
                            "--with-configdir=#{prefix}/etc",
                            "--without-ldap",
                            "--without-krb5"

      # https://bugzilla.samba.org/show_bug.cgi?id=11113
      inreplace "Makefile" do |s|
        s.gsub! /(lib\w+).dylib(.[\.\d]+)/, "\\1\\2.dylib"
      end

      system "make", "install"
      (prefix/"etc").mkpath
      touch prefix/"etc/smb.conf"
      (prefix/"private").mkpath
      (var/"locks").mkpath
    end
  end

  plist_options :manual => "smbd"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/smbd</string>
          <string>-s</string>
          <string>#{etc}/smb.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"eventlogadm", "-h"
  end
end

__END__
--- a/source3/lib/system.c	2012-02-22 22:46:14.000000000 -0200
+++ b/source3/lib/system.c	2012-02-22 22:47:51.000000000 -0200
@@ -1161,7 +1161,14 @@
 
 int groups_max(void)
 {
-#if defined(SYSCONF_SC_NGROUPS_MAX)
+#if defined(DARWINOS)
+	/* On OS X, sysconf(_SC_NGROUPS_MAX) returns 16
+	 * due to OS X's group nesting and getgrouplist
+	 * will return a flat list; users can exceed the
+	 * maximum of 16 groups. And easily will.
+	 */
+	return 32; // NGROUPS_MAX is defined, hence the define above is void.
+#elif defined(SYSCONF_SC_NGROUPS_MAX)
 	int ret = sysconf(_SC_NGROUPS_MAX);
 	return (ret == -1) ? NGROUPS_MAX : ret;
 #else
