class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "http://www.privoxy.org"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.23%20%28stable%29/privoxy-3.0.23-stable-src.tar.gz"
  sha256 "80b1a172d0518a9f95cde83d18dc62b9c7f117b9ada77bdcd3d310107f28f964"

  bottle do
    cellar :any
    revision 1
    sha256 "e4e52b0fb31ad33bfdc9a1e158a482272fb4c02e2c0062a28cf19fa7b0df7c8d" => :el_capitan
    sha256 "247b9897907a8cd13bc0af980a7a4251695632b359ec61ec95bf6f153bd4eab3" => :yosemite
    sha256 "5722d1d6f520f2b86f98010d1c70c9cd5da15ecd5700d0482570d0a1c15143b8" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"

  def install
    # Find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    # No configure script is shipped with the source
    system "autoreconf", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/privoxy",
                          "--localstatedir=#{var}"
    system "make"
    system "make", "install"
  end

  plist_options :manual => "privoxy #{HOMEBREW_PREFIX}/etc/privoxy/config"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{sbin}/privoxy</string>
        <string>--no-daemon</string>
        <string>#{etc}/privoxy/config</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end
end
