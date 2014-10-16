require "formula"

class Tor < Formula
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.2.4.24.tar.gz"
  sha256 "99b15c6858c04e93a31d3ae90dd69f5021faa2237da93a24fbd246f4f1670ad1"
  revision 1

  bottle do
    sha1 "5456718ac7f890f7afdf41bf9631f1e1dad8dbf3" => :mavericks
    sha1 "cfe0bec72693402dea5b69268dc077f0c45dadf5" => :mountain_lion
    sha1 "c46da85cd7b35c1a83a27b3ef88a8a73b99c6072" => :lion
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.2.5.8-rc.tar.gz"
    version "0.2.5.8-rc"
    sha256 "a4c04e049f8c5798991eb5028fb2831ea2353bf12c7f5afa9c1df1472787b22c"
  end

  depends_on "libevent"
  depends_on "openssl"

  def install
    if build.stable?
      # Fix the path to the control cookie. (tor-ctrl removed in v0.2.5.5.)
      inreplace "contrib/tor-ctrl.sh",
        'TOR_COOKIE="/var/lib/tor/data/control_auth_cookie"',
        'TOR_COOKIE="$HOME/.tor/control_auth_cookie"'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-openssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make", "install"

    if build.stable?
      # (tor-ctrl removed in v0.2.5.5.)
      bin.install "contrib/tor-ctrl.sh" => "tor-ctrl"
    end
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
