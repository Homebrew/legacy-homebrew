class Memcached < Formula
  homepage "http://memcached.org/"
  url "http://www.memcached.org/files/memcached-1.4.20.tar.gz"
  sha1 "282a1e701eeb3f07159d95318f09da5ea3fcb39d"

  bottle do
    revision 1
    sha1 "2ca88974fa882f7390c1a65e6d263af0270086e0" => :yosemite
    sha1 "16d1e5a2dba018a66fc91da77ae86f6dd7e1ad7d" => :mavericks
    sha1 "c881c40cc40361c05fa8195f7b84f7a516524a75" => :mountain_lion
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
