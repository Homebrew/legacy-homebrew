require 'formula'

class Cabextract <Formula
  url 'http://www.cabextract.org.uk/cabextract-1.2.tar.gz'
  homepage 'http://www.cabextract.org.uk/'
  md5 'dc421a690648b503265c82ade84e143e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
