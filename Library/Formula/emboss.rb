require 'formula'

class Emboss <Formula
  url 'ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-6.3.1.tar.gz'
  homepage 'http://emboss.sourceforge.net/'
  md5 '04d1179b6261103a77e396d54f8ac38e'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
