require 'formula'

class Hunspell <Formula
  url 'http://downloads.sourceforge.net/hunspell/hunspell-1.2.8.tar.gz'
  homepage 'http://hunspell.sourceforge.net/'
  md5 '1177af54a09e320d2c24015f29c3a93e'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
