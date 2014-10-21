require "formula"

class Collectd < Formula
  homepage "https://collectd.org/"

  stable do
    url "https://collectd.org/files/collectd-5.4.1.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/c/collectd/collectd_5.4.1.orig.tar.gz"
    sha256 "853680936893df00bfc2be58f61ab9181fecb1cf45fc5cddcb7d25da98855f65"

    # Fix detection of htonll()
    # https://github.com/collectd/collectd/commit/1a822486f40
    patch do
      url "https://gist.githubusercontent.com/jacknagel/85ba734488b6fbd25957/raw/7f16be18f96f1202ec7e5b193afa46061dfd944e/collectd.diff"
      sha1 "34afbe6b9193f72ac6f2dd9a6978ff75ef9f41b0"
    end
  end

  bottle do
    sha1 "a5476eb04711bb016a4ef65412a70ba3722098e2" => :mavericks
    sha1 "4829ba6a324a3057ce56a56d378a7e6790530feb" => :mountain_lion
    sha1 "c0c82da5f79fb4c19cf7d2f16a9c008810b835c7" => :lion
  end

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
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
    ]

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
