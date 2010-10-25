require 'formula'

class SyslogNg <Formula
  url 'http://www.balabit.com/downloads/files/syslog-ng/open-source-edition/3.0.8/source/syslog-ng_3.0.8.tar.gz'
  homepage 'http://www.balabit.com/network-security/syslog-ng/'
  md5 '7107f5758dec4b774136f0f827b35258'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'eventlog'

  def patches
    { :p0 =>
      "http://trac.macports.org/export/70550/trunk/dports/sysutils/syslog-ng/files/patch-src-Makefile.in.diff"
    }
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-dynamic-linking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
