require 'formula'

class Wv <Formula
  url 'http://www.paldo.org/paldo/sources/wv-1.0/wv-1.2.2.tar.bz2'
  homepage 'http://www.cims.nyu.edu/systems/software/desc/wv.html'
  md5 '31df6739e624a4af6c937e7732dcf647'

  depends_on 'glib'
  depends_on 'libgsf'
  depends_on 'libpng'
  depends_on 'libwmf'
  depends_on 'libxml2'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
