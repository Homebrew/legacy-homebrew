require "formula"

class Bwctl < Formula
  homepage "http://software.internet2.edu/bwctl/"
  url "http://software.internet2.edu/sources/bwctl/bwctl-1.5.2-10.tar.gz"
  sha1 "5dcc7a1d671ac8e061f859a430d56ae2551f507e"

  bottle do
    cellar :any
    sha1 "b44fbe6a0a4cb82f9d5f9af6062006bbe22d163c" => :yosemite
    sha1 "318f7c3022df966510467489102ea2f3fa6ea728" => :mavericks
    sha1 "d18b048baeb365d22717b2b831c164eb1c8ba125" => :mountain_lion
  end

  depends_on "i2util"
  depends_on "iperf3" => :optional
  depends_on "thrulay" => :optional

  # Patch to fix failure to start under launchd. Submitted upstream at
  # https://code.google.com/p/perfsonar-ps/issues/detail?id=1043
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
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
