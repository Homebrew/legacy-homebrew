require 'formula'

class Maxima < Formula
  url 'http://sourceforge.net/projects/maxima/files/Maxima-source/5.25.1-source/maxima-5.25.1.tar.gz'
  homepage 'http://maxima.sourceforge.net/'
  md5 'f2a7399e53eadc38e0bedb843d5d7055'

  depends_on 'gettext'
  depends_on 'sbcl'
  depends_on 'gnuplot'
  depends_on 'rlwrap'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}", "--infodir=#{info}",
                          "--enable-sbcl", "--enable-gettext"
    system "make"
    system "make check"
    system "make install"
  end

  def test
    system "maxima --batch-string='run_testsuite(); quit();'"
  end
end
