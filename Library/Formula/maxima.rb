require 'formula'

class Maxima <Formula
  url 'http://sourceforge.net/projects/maxima/files/Maxima-source/5.22.1-source/maxima-5.22.1.tar.gz'
  homepage 'http://maxima.sourceforge.net/'
  md5 '160ea8be39127d6636b934a85e407c9b'

  depends_on 'gettext'
  depends_on 'cmucl'
  depends_on 'gnuplot'
  depends_on 'rlwrap'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}", "--infodir=#{info}",
                          "--enable-cmucl", "--enable-gettext"
    system "make install"
  end
end
