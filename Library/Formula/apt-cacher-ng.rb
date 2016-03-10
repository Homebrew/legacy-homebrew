class AptCacherNg < Formula
  desc "Caching proxy"
  homepage "https://www.unix-ag.uni-kl.de/~bloch/acng/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_0.9.1.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_0.9.1.orig.tar.xz"
  sha256 "24994beac6ce1c51f97ce66f49ea68cac9e30a0162c5c0ae8a36bcb8ed34c8b4"

  bottle do
    sha256 "a1df0128f290116cb8e5e9d9bcf899dda1bba6ba4bdc6a4827e0839bd2631854" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on :osxfuse => :build
  depends_on "boost" => :build
  depends_on "libtomcrypt"
  depends_on "xz" # For LZMA

  needs :cxx11

  def install
    ENV.cxx11
    ENV["TOMCRYPT_HOME"] = Formula["libtomcrypt"].opt_prefix

    (var/"spool/apt-cacher-ng").mkpath
    (var/"log").mkpath

    inreplace "conf/acng.conf.in" do |s|
      s.gsub!(/^CacheDir: .*/, "CacheDir: #{var}/spool/apt-cacher-ng")
      s.gsub!(/^LogDir: .*/, "LogDir: #{var}/log")
    end

    args = std_cmake_args
    # Build with OpenSSL enabled uses `fmemopen` in glibc and it isn't supported
    # by OS X. So we use libtomcrypt instead of OpenSSL for now.
    args << "-DUSE_SSL=OFF"
    system "cmake", ".", *args
    system "make", "apt-cacher-ng"
    system "make", "install"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>OnDemand</key>
      <false/>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/apt-cacher-ng</string>
        <string>-c</string>
        <string>#{etc}/apt-cacher-ng</string>
        <string>foreground=1</string>
      </array>
      <key>ServiceIPC</key>
      <false/>
    </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"var/log").mkpath
    (testpath/"var/spool").mkpath
    logs = "LogDir=#{testpath}/var/log"
    cache = "CacheDir=#{testpath}/var/spool"

    pid = fork do
      exec "#{sbin}/apt-cacher-ng", "-c", "#{etc}/apt-cacher-ng", logs, cache
    end
    sleep 2

    begin
      assert_match(/Not Found or APT Reconfiguration required/, shell_output("curl localhost:3142"))
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
