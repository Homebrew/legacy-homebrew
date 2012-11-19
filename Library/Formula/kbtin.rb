require 'formula'

class Kbtin < Formula
  url 'http://downloads.sourceforge.net/project/kbtin/kbtin/1.0.13/kbtin-1.0.13.tar.gz'
  homepage 'http://kbtin.sourceforge.net'
  sha1 '6e3496ab629b3a7d4ef5ea61baa7efa9b19e25af'

  depends_on 'gnutls'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
