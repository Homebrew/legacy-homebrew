class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  url "https://collectd.org/files/collectd-5.5.0.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/collectd/collectd-5.5.0.tar.bz2/c39305ef5514b44238b0d31f77e29e6a/collectd-5.5.0.tar.bz2"
  sha256 "847684cf5c10de1dc34145078af3fcf6e0d168ba98c14f1343b1062a4b569e88"

  bottle do
    sha256 "b35bfeb9b9e5318e502c7e2a76eee1508dcf3739df96554b89f3ee49e38d6b48" => :yosemite
    sha256 "3d0911b4ea350625eba4710718c16bf254bbdd3ed2b6f4608c7c0a93a2f689ee" => :mavericks
    sha256 "8d93509655af415772ab8459b7bc62fd01ae81dd0f2e78733fde336b23af899a" => :mountain_lion
  end

  head do
    url "git://git.verplant.org/collectd.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  # Will fail against Java 1.7
  option "with-java", "Enable Java 1.6 support"
  option "with-debug", "Enable debug support"

  deprecated_option "java" => "with-java"
  deprecated_option "debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on :java => ["1.6", :optional]
  depends_on "openssl"

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      Clang interacts poorly with the collectd-bundled libltdl,
      causing configure to fail.
    EOS
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
    ]

    args << "--disable-embedded-perl" if MacOS.version <= :leopard
    args << "--disable-java" if build.without? "java"
    args << "--enable-debug" if build.with? "debug"

    system "./build.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/collectd</string>
          <string>-f</string>
          <string>-C</string>
          <string>#{etc}/collectd.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/collectd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/collectd.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    begin
      pid = fork { exec sbin/"collectd", "-f" }
      assert shell_output("nc -u -w 2 127.0.0.1 25826", 0)
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
