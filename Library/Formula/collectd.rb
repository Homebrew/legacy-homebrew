class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"

  stable do
    url "https://collectd.org/files/collectd-5.5.0.tar.bz2"
    mirror "http://pkgs.fedoraproject.org/repo/pkgs/collectd/collectd-5.5.0.tar.bz2/c39305ef5514b44238b0d31f77e29e6a/collectd-5.5.0.tar.bz2"
    sha256 "847684cf5c10de1dc34145078af3fcf6e0d168ba98c14f1343b1062a4b569e88"

    patch do
      url "https://github.com/collectd/collectd/commit/e0683047a42e217c352c2419532b8e029f9f3f0a.diff"
      sha256 "7053170a072d27465b69eed269d32190ec810bcb0db59f139a1682e71a326fdd"
    end
  end

  bottle do
    revision 1
    sha256 "d07cd68645ca83f86ac0b06526a869a89d899fdd1d7211a9884f85e8d682e27a" => :el_capitan
    sha256 "9e6e01ec3af8ddda0b52756fc1516b4e9dcb68464e3fea414ab3e394f43d926b" => :yosemite
    sha256 "f964c5b63bc491b136899357923858b066069291e1210a649fa143fa8ba29145" => :mavericks
    sha256 "62c64c1d76e9c2b37845391b5dd7ec5b534190b5172ac68ca483aa3ef8241c80" => :mountain_lion
  end

  head do
    url "git://git.verplant.org/collectd.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  # Will fail against Java 1.7
  option "with-java", "Enable Java 1.6 support"
  option "with-protobuf-c", "Enable write_riemann via protobuf-c support"
  option "with-debug", "Enable debug support"

  deprecated_option "java" => "with-java"
  deprecated_option "debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "protobuf-c" => :optional
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
    # collectd breaks with makejobs
    # see: https://github.com/collectd/collectd/issues/1146
    ENV.deparallelize

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
    ]

    args << "--disable-embedded-perl" if MacOS.version <= :leopard
    args << "--disable-java" if build.without? "java"
    args << "--enable-write_riemann" if build.with? "protobuf-c"
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
