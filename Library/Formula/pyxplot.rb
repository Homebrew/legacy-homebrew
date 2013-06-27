require 'formula'

class Pyxplot < Formula
  homepage 'http://pyxplot.org.uk/'
  url 'http://pyxplot.org.uk/src/pyxplot_0.9.1.tar.gz'
  sha1 '3b97367a1532b14360fcac3e715e9307f05a0703'

  depends_on :tex
  depends_on 'fftw'
  depends_on 'cfitsio' => :recommended
  depends_on :x11
  depends_on 'ghostscript' => 'with-x11'
  depends_on 'gsl'
  depends_on 'gv' => :recommended
  depends_on 'imagemagick'
  depends_on 'libpng'
  depends_on 'readline'
  depends_on 'wget' => :recommended

  def install

    # changes install directory to Cellar
    inreplace "Makefile.skel", "USRDIR=/usr/local", "USRDIR=#{prefix}" 

    system "./configure"
    system "make install" 
  end

end
