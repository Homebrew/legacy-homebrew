require "formula"

class Tor < Formula
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.2.5.10.tar.gz"
  sha256 "b3dd02a5dcd2ffe14d9a37956f92779d4427edf7905c0bba9b1e3901b9c5a83b"

  bottle do
    sha1 "5456718ac7f890f7afdf41bf9631f1e1dad8dbf3" => :mavericks
    sha1 "cfe0bec72693402dea5b69268dc077f0c45dadf5" => :mountain_lion
    sha1 "c46da85cd7b35c1a83a27b3ef88a8a73b99c6072" => :lion
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
