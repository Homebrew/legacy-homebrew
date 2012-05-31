require 'formula'

class Hunspell < Formula
  url 'http://downloads.sourceforge.net/hunspell/hunspell-1.3.2.tar.gz'
  homepage 'http://hunspell.sourceforge.net/'
  md5 '3121aaf3e13e5d88dfff13fb4a5f1ab8'

  depends_on 'readline'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ui", "--with-readline"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
