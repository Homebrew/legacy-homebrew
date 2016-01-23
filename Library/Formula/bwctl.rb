class Bwctl < Formula
  desc "Command-line tool and daemon for network measuring tools"
  homepage "http://software.internet2.edu/bwctl/"
  url "http://software.internet2.edu/sources/bwctl/bwctl-1.5.4.tar.gz"
  sha256 "e6dca6ca30c8ef4d68e6b34b011a9ff7eff3aba4a84efc19d96e3675182e40ef"

  bottle do
    cellar :any
    sha256 "c8890647536e60b3ed8599eb3239ee59fde0382e9df8b7585ee7eeb20275fc39" => :yosemite
    sha256 "f10efbf8f41f526130340cc6087ce3dfad83b71b69d21e0b01c11b3169d88bdd" => :mavericks
    sha256 "b60c679e8b498ffc23e697cb025dc6decc4f4d939e2b0874ff36291967eee18d" => :mountain_lion
  end

  depends_on "i2util" => :build
  depends_on "iperf3" => :optional
  depends_on "thrulay" => :optional

  # Patch to fix failure to start under launchd. Submitted upstream at
  # https://code.google.com/p/perfsonar-ps/issues/detail?id=1043
  patch :DATA

  def install
    # configure mis-sets CFLAGS for I2util
    # https://lists.internet2.edu/sympa/arc/perfsonar-user/2015-04/msg00016.html
    # https://github.com/Homebrew/homebrew/pull/38212
    inreplace "configure", 'CFLAGS="-I$I2util_dir/include $CFLAGS"', 'CFLAGS="-I$with_I2util/include $CFLAGS"'

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-I2util=#{Formula["i2util"].opt_prefix}"
    system "make", "install"

    (buildpath+"bwctld.conf").write <<-EOS.undent
      allow_unsync
      log_location
      peer_port       6001-6200
      facility        local5
      test_port       5001-5900
      iperf_port      5001-5300
      nuttcp_port     5301-5600
      owamp_port      5601-5900
      user            nobody
      group           nobody
      EOS
    (buildpath+"bwctld.keys").write ""
    (etc+"bwctld").mkpath
    (etc+"bwctld").install "bwctld.conf" => "bwctld.conf",
                           "bwctld.keys" => "bwctld.keys",
                           "conf/bwctld.conf" => "bwctld.conf.default",
                           "conf/bwctld.limits" => "bwctld.limits"

    (var+"log/bwctld").mkpath
  end

  plist_options :startup => true,
      :manual => "bwctld -c #{HOMEBREW_PREFIX}/etc/bwctld -R #{HOMEBREW_PREFIX}/var/run"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/bwctld</string>
        <string>-c</string>
        <string>#{etc}/bwctld</string>
        <string>-R</string>
        <string>#{var}/run</string>
        <string>-Z</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}/log/bwctld</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/bwctld/output.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/bwctld/output.log</string>
      <key>HardResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>1024</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>1024</integer>
      </dict>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/bwctl", "-V"
  end
end

__END__
diff --git a/bwctld/bwctld.c b/bwctld/bwctld.c
index c155e31..3ec9f5f 100644
--- a/bwctld/bwctld.c
+++ b/bwctld/bwctld.c
@@ -2554,7 +2554,7 @@ main(int argc, char *argv[])
          * kill call.) setsid handles this when daemonizing.
          */
         mypid = getpid();
-        if(setpgid(0,mypid) != 0){
+        if(getsid(0) != mypid && setpgid(0,mypid) != 0){
             I2ErrLog(errhand,"setpgid(): %M");
             exit(1);
         }
