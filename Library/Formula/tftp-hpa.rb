require 'formula'

class TftpHpa <Formula
  url 'http://www.kernel.org/pub/software/network/tftp/tftp-hpa-0.49.tar.gz'
  homepage 'http://www.kernel.org/pub/software/network/tftp/'
  md5 '321d27e46c3a2795cf7b033c56fbf657'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--without-ipv6", "--prefix=#{prefix}", "--mandir=#{prefix}/share/man"
    system "make install"
  end
end
