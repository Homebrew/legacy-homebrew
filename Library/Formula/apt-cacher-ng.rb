class AptCacherNg < Formula
  desc "Caching proxy"
  homepage "https://www.unix-ag.uni-kl.de/~bloch/acng/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_0.8.5.orig.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_0.8.5.orig.tar.xz"
  sha256 "f4e80adb02ad68a5f79a23335f1cc1e6b8a610b2c70749d9a1ce44171766775c"

  bottle do
    cellar :any
    sha256 "56ac8cc5e3302ef36487a0732272cc054725488335312ba20cc3c890b11f4031" => :mavericks
    sha256 "be6580890689b19b1d8c89becaaa173e6cb857e32318be40ca06360758905e5d" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on :osxfuse => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on "xz" # For LZMA

  needs :cxx11

  def install
    ENV.cxx11

    # https://alioth.debian.org/tracker/index.php?func=detail&aid=315130&group_id=100566&atid=413111
    # Clang expects a semicolon after expression usage.
    inreplace "source/lockable.cc",
              "r=pthread_cond_timedwait(&m_obj_cond, &m_obj_mutex, &timeout)",
              "r=pthread_cond_timedwait(&m_obj_cond, &m_obj_mutex, &timeout);"
    # --as-needed is unrecognised by LD on OS X and breaks compile.
    inreplace "CMakeLists.txt", "--as-needed", ""

    inreplace "conf/acng.conf" do |s|
      s.gsub! /^CacheDir: .*/, "CacheDir: #{var}/spool/apt-cacher-ng"
      s.gsub! /^LogDir: .*/, "LogDir: #{var}/log"
    end

    (var/"spool/apt-cacher-ng").mkpath
    (var/"log").mkpath

    system "make", "apt-cacher-ng"

    etc.install "conf" => "apt-cacher-ng" unless File.exist?(etc/"apt-cacher-ng")
    sbin.install "build/apt-cacher-ng"
    man8.install "doc/man/apt-cacher-ng.8"
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
      assert_match /Debian Apt-Cacher-NG/, shell_output("curl localhost:3142")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
