class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "http://memcached.org/"
  url "http://www.memcached.org/files/memcached-1.4.24.tar.gz"
  sha256 "08a426c504ecf64633151eec1058584754d2f54e62e5ed2d6808559401617e55"

  bottle do
    cellar :any
    sha256 "da6347788e34f2914ec939c1f14d5a36b70ce2e546d04bf95123a01f98084674" => :el_capitan
    sha256 "5524972e73c753e43289f06eb615a3100831eb7c33ce15489ea65d2904344acf" => :yosemite
    sha256 "0ff0b4273be5860850878f391e4cc6f1492fe13ffe7f80388634511210ff473f" => :mavericks
    sha256 "ad37c20bd1dfc1275c055ec33cb3fae594ed22463a264b80f08b01db3f7d0578" => :mountain_lion
  end

  depends_on "libevent"

  option "with-sasl", "Enable SASL support -- disables ASCII protocol!"
  option "with-sasl-pwdb", "Enable SASL with memcached's own plain text password db support -- disables ASCII protocol!"

  deprecated_option "enable-sasl" => "with-sasl"
  deprecated_option "enable-sasl-pwdb" => "with-sasl-pwdb"

  conflicts_with "mysql-cluster", :because => "both install `bin/memcached`"

  def install
    args = ["--prefix=#{prefix}", "--disable-coverage"]
    args << "--enable-sasl" if build.with? "sasl"
    args << "--enable-sasl-pwdb" if build.with? "sasl-pwdb"

    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/memcached/bin/memcached"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>KeepAlive</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/memcached</string>
        <string>-l</string>
        <string>localhost</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/memcached", "-h"
  end
end
