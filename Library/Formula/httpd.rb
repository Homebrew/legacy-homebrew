require 'formula'

class Httpd <Formula
  url 'http://www.bizdirusa.com/mirrors/apache/httpd/httpd-2.2.16.tar.gz'
  homepage 'http://httpd.apache.org/'
  md5 '7f33f2c8b213ad758c009ae46d2795ed'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-layout=GNU",
                          "--enable-mods-shared=all",
                          "--with-ssl=/usr",
                          "--with-mpm=prefork",
                          "--disable-unique-id",
                          "--enable-ssl",
                          "--enable-dav",
                          "--enable-cache",
                          "--enable-proxy",
                          "--enable-logio",
                          "--enable-deflate",
                          "--with-included-apr",
                          "--enable-cgi",
                          "--enable-cgid",
                          "--enable-suexec",
                          "--enable-rewrite"
    system "make"
    system "make install"
  end

  def startup_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>com.apache.httpd</string>
      <key>ProgramArguments</key>
      <array>
        <string>/usr/local/sbin/apachectl</string>
        <string>start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end
end
