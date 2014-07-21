require 'formula'

class Privoxy < Formula
  homepage 'http://www.privoxy.org'
  url 'https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.21%20%28stable%29/privoxy-3.0.21-stable-src.tar.gz'
  sha1 '2d73a9146e87218b25989096f63ab0772ce24109'

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
