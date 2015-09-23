class Samba < Formula
  desc "SMB/CIFS file, print, and login server for UNIX"
  homepage "https://samba.org/"
  url "https://download.samba.org/pub/samba/stable/samba-3.6.25.tar.gz"
  sha256 "8f2c8a7f2bd89b0dfd228ed917815852f7c625b2bc0936304ac3ed63aaf83751"

  bottle do
    revision 1
    sha256 "da0c666f7090e0d838a9232e69a6669c27c54ac2f296cdd0fb3267e019abafe9" => :el_capitan
    sha256 "f1fc6a41e7ff919d7c0d2459df72df4dfa84d557481301338cbb74489e80b659" => :yosemite
    sha256 "3fe2b2aa3b3623dd7d8bc3f2ef7308600125eed03817ecf0fa9d10c0c9911705" => :mavericks
    sha256 "f6c02ca7f1dd074a3b5c021810351904cbe8b447bd81adc9598e64e1eb342e10" => :mountain_lion
  end

  conflicts_with "talloc", :because => "both install `include/talloc.h`"

  # Once the smbd daemon is executed with required root permissions
  # contents of these two directories becomes owned by root. Sad face.
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

      (prefix/"private").mkpath
      (prefix/"var/locks").mkpath

      system "make", "install"
      # makefile doesn't have an install target for these
      (lib/"pkgconfig").install Dir["pkgconfig/*.pc"]
    end

    # Install basic example configuration
    inreplace "examples/smb.conf.default" do |s|
      s.gsub! "/usr/local/samba/var/log.%m", "#{prefix}/var/log/samba/log.%m"
    end
    (prefix/"etc").install "examples/smb.conf.default" => "smb.conf"
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
