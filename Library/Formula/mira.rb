require 'formula'

class Mira < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/mira-assembler/'
  url 'http://downloads.sourceforge.net/project/mira-assembler/MIRA/stable/mira-3.4.0.1.tar.bz2'
  md5 '8ae61c3000aef681ef08a7936469af35'

  depends_on 'boost'
  depends_on 'google-perftools'
  depends_on 'docbook'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/mira"
  end
end
