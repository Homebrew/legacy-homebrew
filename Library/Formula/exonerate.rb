require 'formula'

class Exonerate <Formula
  url 'http://www.ebi.ac.uk/~guy/exonerate/exonerate-2.2.0.tar.gz'
  homepage 'http://www.ebi.ac.uk/~guy/exonerate/'
  md5 'ad3f7fc413376201c4631687b2e0ae89'
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1
    system "make"
    system "make install"
  end
end
