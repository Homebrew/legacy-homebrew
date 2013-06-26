require 'formula'

class Gearman < Formula
  homepage 'http://gearman.org/'
  url 'https://launchpad.net/gearmand/1.2/1.1.7/+download/gearmand-1.1.7.tar.gz'
  sha1 '4dbbdfbbfd184f1902fc5b139ec250dc6f260bc8'

  option 'with-mysql', 'Compile with MySQL persistent queue enabled'

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'libevent'
  depends_on 'ossp-uuid'
  depends_on :mysql => :optional

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-mysql" if build.with? 'mysql'

    system "./configure", *args
    system "make install"
  end

  plist_options :manual => "gearmand -d"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_prefix}/sbin/gearmand</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end
