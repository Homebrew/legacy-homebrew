require 'formula'

class Freeswitch < Formula
  homepage 'http://freeswitch.org'
  url 'git://git.freeswitch.org/freeswitch.git', :tag => 'v1.4.6'

  head 'git://git.freeswitch.org/freeswitch.git'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'pkg-config' => :build

  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on 'curl'
  depends_on 'openssl'
  depends_on 'pcre'
  depends_on 'speex'
  depends_on 'sqlite'
  depends_on :x11

  def install
    system "./bootstrap.sh -j#{ENV.make_jobs}"
    # mod_enum requires libldns-dev which doesn't seem to exist in brew
    system "perl -pi -e 's{applications/mod_enum}{#applications/mod_enum}' ./modules.conf"
    system "./configure", "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--exec_prefix=#{prefix}"

    system "make"
    system "make install"
    system "make all cd-sounds-install cd-moh-install"
  end

  plist_options :manual => "freeswitch -nc --nonat"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
        <true/>
      <key>Label</key>
        <string>#{plist_name}</string>
      <key>ProgramArguments</key>
        <array>
          <string>#{bin}/freeswitch</string>
          <string>-nc</string>
          <string>-nonat</string>
        </array>
      <key>RunAtLoad</key>
        <true/>
      <key>ServiceIPC</key>
        <true/>
    </dict>
    </plist>
    EOS
  end

  def test
    system "#{bin}/freeswitch", "-version"
  end
end
