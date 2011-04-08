require 'formula'

class SyslogNg < Formula
  url 'http://www.balabit.com/downloads/files?path=/syslog-ng/sources/3.2.1/source/syslog-ng_3.2.1.tar.gz'
  homepage 'http://www.balabit.com/network-security/syslog-ng/'
  md5 'c0160053e24a0408d08bbfd454b110df'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'eventlog'
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-dynamic-linking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
