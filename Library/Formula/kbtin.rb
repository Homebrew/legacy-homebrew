require 'formula'

class Kbtin < Formula
  url 'http://downloads.sourceforge.net/project/kbtin/kbtin/1.0.13/kbtin-1.0.13.tar.gz'
  homepage 'http://kbtin.sourceforge.net'
  md5 '5e23f48ac72e1609853895b44a0e3e90'

  depends_on 'gnutls'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
