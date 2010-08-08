require 'formula'

class Maxima <Formula
  url 'http://downloads.sourceforge.net/project/maxima/Maxima-source/5.21.1-source/maxima-5.21.1.tar.gz'
  homepage 'http://maxima.sourceforge.net/'
  md5 'e08ed533f3059cec52788ef35198bdcc'

  depends_on 'gettext'
  depends_on 'cmucl'
  depends_on 'gnuplot'
  depends_on 'rlwrap'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cmucl", "--enable-gettext"
    system "make install"
  end
end
