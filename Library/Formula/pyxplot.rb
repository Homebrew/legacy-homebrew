require 'formula'

class Pyxplot < Formula
  homepage 'http://pyxplot.org.uk/'
  url 'http://pyxplot.org.uk/src/pyxplot_0.9.1.tar.gz'
  sha1 '3b97367a1532b14360fcac3e715e9307f05a0703'

  depends_on :tex
  depends_on 'fftw'
  depends_on 'cfitsio' => :recommended
  depends_on 'ghostscript' => 'with-x11'
  depends_on 'gsl'
  depends_on 'gv' => :recommended
  depends_on 'imagemagick'
  depends_on 'libpng'
  depends_on 'readline'
  depends_on 'wget' => :recommended

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install" 
  end

end
