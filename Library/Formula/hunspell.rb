require 'formula'

class Hunspell <Formula
  url 'http://downloads.sourceforge.net/hunspell/hunspell-1.2.14.tar.gz'
  homepage 'http://hunspell.sourceforge.net/'
  md5 'c2f289af57a677e6b258f2d18ecb178e'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-ui", "--with-readline"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
