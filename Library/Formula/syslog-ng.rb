require 'formula'

class SyslogNg < Formula
  url 'http://www.balabit.com/downloads/files/syslog-ng/sources/3.2.5/source/syslog-ng_3.2.5.tar.gz'
  homepage 'http://www.balabit.com/network-security/syslog-ng/'
  sha1 '5541cd6711b7a9d983601d8047b9a27d98ecbe9b'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'eventlog'
  depends_on 'glib'

  def install
    ENV.append 'LDFLAGS', '-levtlog -lglib-2.0' # help the linker find symbols
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-dynamic-linking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"

    # the HAVE_ENVIRON check in configure fails
    # discussion for a fix is ongoing on the Homebrew mailing list, but for
    # now this is sufficient
    inreplace 'config.h', '#define HAVE_ENVIRON 1', ''

    system "make install"
  end
end
