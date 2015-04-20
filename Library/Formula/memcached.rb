class Memcached < Formula
  homepage "http://memcached.org/"
  url "http://www.memcached.org/files/memcached-1.4.22.tar.gz"
  sha1 "5968d357d504a1f52622f9f8a3e85c29558acaa5"

  bottle do
    sha256 "f14fcd969117745bc45e8d99a93363b20bec101b9a4a7de36b02e9ce330b0ad5" => :yosemite
    sha256 "119d2c653bbe6b8c4381d2b05c9a5b7dba093a212d02c5ba212116e251c7220c" => :mavericks
    sha256 "3faa59c31a3048e8be7f85142983e0cf2125726aae7382b255f7f754a08dbf7d" => :mountain_lion
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
