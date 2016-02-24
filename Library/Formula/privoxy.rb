class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "http://www.privoxy.org"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.24%20%28stable%29/privoxy-3.0.24-stable-src.tar.gz"
  sha256 "a381f6dc78f08de0d4a2342d47a5949a6608073ada34b933137184f3ca9fb012"

  bottle do
    cellar :any
    sha256 "edb1d08efa2d25658a2d4d1d2643233529c6228fe6289536e7c48f5829c6e9ad" => :el_capitan
    sha256 "0764f6e68913ea279c29a84dae2292eadcf542eacda5c21e26addd5497524cd1" => :yosemite
    sha256 "fd48bf5bee38bbca0124d7e2dc39e52f97f99536f1f04d4fcff1ba3716ebdfa2" => :mavericks
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
