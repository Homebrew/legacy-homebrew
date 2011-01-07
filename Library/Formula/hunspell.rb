require 'formula'

class Hunspell <Formula
  url 'http://downloads.sourceforge.net/hunspell/hunspell-1.2.12.tar.gz'
  homepage 'http://hunspell.sourceforge.net/'
  md5 '5ef2dc1026660d0ffb7eae7b511aee23'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
