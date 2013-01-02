require 'formula'

class Abook < Formula
  url 'http://downloads.sourceforge.net/abook/abook-0.5.6.tar.gz'
  homepage 'http://abook.sourceforge.net/'
  sha1 '79f04f2264c8bd81bbc952b6560c86d69b21615d'

  depends_on 'readline'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
