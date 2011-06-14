require 'formula'

class Abook < Formula
  url 'http://downloads.sourceforge.net/abook/abook-0.5.6.tar.gz'
  homepage 'http://abook.sourceforge.net/'
  md5 '87d25df96864a7c507a4965e6d1da49d'

  depends_on 'readline'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
