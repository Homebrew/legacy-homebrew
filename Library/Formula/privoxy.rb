require 'formula'

class Privoxy < Formula
  homepage 'http://www.privoxy.org'
  url 'https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.22%20%28stable%29/privoxy-3.0.22-stable-src.tar.gz'
  sha1 '16cab9bb2055546a5f70815044dab893396c5686'

  bottle do
    sha1 "9a7f048bebdfa6737775a2b3ccbffb9813b6e548" => :yosemite
    sha1 "a1ffe0019d363486a9e8c6dabfc779596dcc7f52" => :mavericks
    sha1 "b9c9795f397f6571bab68b2a0633b493cf60c4da" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on 'pcre'

  def install
    # Find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    # No configure script is shipped with the source
    system "autoreconf", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/privoxy",
                          "--localstatedir=#{var}"
    system "make"
    system "make install"
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
