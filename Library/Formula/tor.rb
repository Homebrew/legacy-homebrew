require "formula"

class Tor < Formula
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.2.5.10.tar.gz"
  sha256 "b3dd02a5dcd2ffe14d9a37956f92779d4427edf7905c0bba9b1e3901b9c5a83b"

  bottle do
    sha1 "0bf6ef6985285bac9e67fbc78cef7ebb78844de2" => :yosemite
    sha1 "6f4d92e5a77e1d3f3da94f1b45e4817c8ccecdf9" => :mavericks
    sha1 "bae5ecb83486c16256d9d56b284bbf341c8d5a42" => :mountain_lion
  end

  depends_on "libevent"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-openssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"tor", "--version"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/tor</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
