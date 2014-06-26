require "formula"

class Memcached < Formula
  homepage "http://memcached.org/"
  url "http://www.memcached.org/files/memcached-1.4.20.tar.gz"
  sha1 "282a1e701eeb3f07159d95318f09da5ea3fcb39d"

  bottle do
    sha1 "d3075e31fbf68520bb615cad869e6b75295f566d" => :mavericks
    sha1 "75b9349df6c29f0535452422575b4aa342275bd1" => :mountain_lion
    sha1 "4cb8fd167de0c72822f0958845dfdc53310282d4" => :lion
  end

  depends_on "libevent"

  option "enable-sasl", "Enable SASL support -- disables ASCII protocol!"
  option "enable-sasl-pwdb", "Enable SASL with memcached's own plain text password db support -- disables ASCII protocol!"

  conflicts_with "mysql-cluster", :because => "both install `bin/memcached`"

  def install
    args = ["--prefix=#{prefix}", "--disable-coverage"]
    args << "--enable-sasl" if build.include? "enable-sasl"
    args << "--enable-sasl-pwdb" if build.include? "enable-sasl-pwdb"

    system "./configure", *args
    system "make install"
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
end
