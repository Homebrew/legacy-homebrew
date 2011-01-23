require 'formula'

class Openssh <Formula
  url 'ftp://ftp.lambdaserver.com/pub/OpenBSD/OpenSSH/portable/openssh-5.4p1.tar.gz'
  homepage 'http://www.openssh.com/'
  md5 'da10af8a789fa2e83e3635f3a1b76f5e'
  version '5.4p1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--with-libedit", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
