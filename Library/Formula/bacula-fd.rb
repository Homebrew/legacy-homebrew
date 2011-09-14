require 'formula'

class BaculaFd < Formula
  url 'http://downloads.sourceforge.net/project/bacula/bacula/5.0.3/bacula-5.0.3.tar.gz'
  homepage 'http://www.bacula.org/'
  md5 '9de254ae39cab0587fdb2f5d8d90b03b'

  # Cleaning seems to break things:
  def skip_clean? path
	  true
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sbindir=#{prefix}/bin",
                          "--with-working-dir=#{prefix}/var/bacula/working",
                          "--with-pid-dir=#{prefix}/var/bacula/working",
                          "--enable-client-only",
                          "--disable-conio", "--disable-readline"
    system "make"
    system "make install"
  end

end
