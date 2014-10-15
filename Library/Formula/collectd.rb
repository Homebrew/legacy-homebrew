require "formula"

class Collectd < Formula
  homepage "https://collectd.org/"
  url "https://collectd.org/files/collectd-5.4.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/collectd/collectd_5.4.1.orig.tar.gz"
  sha256 "853680936893df00bfc2be58f61ab9181fecb1cf45fc5cddcb7d25da98855f65"

  # Will fail against Java 1.7
  option "java", "Enable Java 1.6 support"
  option "debug", "Enable debug support"

  head do
    url "git://git.verplant.org/collectd.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      Clang interacts poorly with the collectd-bundled libltdl,
      causing configure to fail.
    EOS
  end

  def install
    # Use system Python; doesn't compile against 2.7
    # -C enables the cache and resolves permissions errors
    args = %W[-C
              --disable-debug
              --disable-dependency-tracking
              --prefix=#{prefix}
              --localstatedir=#{var}
              --with-python=/usr/bin]

    args << "--disable-embedded-perl" if MacOS.version <= :leopard
    args << "--disable-java" unless build.include? "java"
    args << "--enable-debug" if build.include? "debug"

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
        <string>/usr/local/var/log/collectd.log</string>
        <key>StandardOutPath</key>
        <string>/usr/local/var/log/collectd.log</string>
      </dict>
    </plist>
    EOS
  end
end
