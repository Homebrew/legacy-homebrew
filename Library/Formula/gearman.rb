require 'formula'

class Gearman < Formula
  homepage 'http://gearman.org/'
  url 'https://launchpad.net/gearmand/1.2/1.1.12/+download/gearmand-1.1.12.tar.gz'
  sha1 '85b5271ea3ac919d96fff9500993b73c9dc80c6c'

  option 'with-mysql', 'Compile with MySQL persistent queue enabled'
  option 'with-postgresql', 'Compile with Postgresql persistent queue enabled'

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'libevent'
  depends_on :mysql => :optional
  depends_on :postgresql => :optional

  def install
    args = ["--prefix=#{prefix}"]
    args << "--without-mysql" if build.without? 'mysql'
    if build.with? 'postgresql'
      pg_config = "#{Formula["postgresql"].opt_bin}/pg_config"
      args << "--with-postgresql=#{pg_config}"
    end
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
        <string>#{opt_sbin}/gearmand</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end
