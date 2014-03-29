require 'formula'

class Proftpd < Formula
  homepage 'http://www.proftpd.org/'
  url 'ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.4d.tar.gz'
  sha1 'a5b6c80a8ddeeeccc1c6448d797ccd62a3f63b65'

  # fixes unknown group 'nogroup'
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    ENV.j1
    system "make", "INSTALL_USER=`whoami`", "INSTALL_GROUP=admin", "install"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/proftpd</string>
        </array>
        <key>UserName</key>
        <string>root</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    The config file is in:
       #{HOMEBREW_PREFIX}/etc/proftpd.conf

    proftpd may need to be run as root, depending on configuration
    EOS
  end
end

__END__
--- a/sample-configurations/basic.conf
+++ b/sample-configurations/basic.conf
@@ -27,7 +27,7 @@

 # Set the user and group under which the server will run.
 User				nobody
-Group				nogroup
+Group				nobody

 # To cause every FTP user to be "jailed" (chrooted) into their home
 # directory, uncomment this line.
