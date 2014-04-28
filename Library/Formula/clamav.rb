require 'formula'

class Clamav < Formula
  homepage 'http://www.clamav.net/'
  url 'https://downloads.sourceforge.net/clamav/0.98/clamav-0.98.1.tar.gz'
  sha1 '9f04c0e81463c36f7e58d18f16d1b88f3332dcb8'

  skip_clean 'share'

  def install
    (share/'clamav').mkpath

    args = %W{--disable-dependency-tracking
              --prefix=#{prefix}
              --disable-zlib-vcheck
              --libdir=#{lib}
              --sysconfdir=#{etc}}
    args << "--with-zlib=#{MacOS.sdk_path}/usr" unless MacOS::CLT.installed?

    system "./configure", *args
    system "make install"
  end

  plist_options :manual => 'clamd'

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/clamd</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

end
