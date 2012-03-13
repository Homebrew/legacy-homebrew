require 'formula'

class Emboss < Formula
  url 'ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-6.4.0.tar.gz'
  homepage 'http://emboss.sourceforge.net/'
  md5 '54993a22064222b01bd4fc8086f7684d'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
