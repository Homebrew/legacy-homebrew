require 'formula'

class Pyxplot < Formula
  homepage 'http://pyxplot.org.uk/'
  url 'http://pyxplot.org.uk/src/pyxplot_0.9.2.tar.gz'
  sha1 '5f09399bd00a4ae94a07ac186cf0e8e7761de625'

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
