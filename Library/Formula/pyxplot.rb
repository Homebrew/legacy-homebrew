require 'formula'

class Pyxplot < Formula
  homepage 'http://pyxplot.org.uk/'
  url 'http://pyxplot.org.uk/src/pyxplot_0.9.2.tar.gz'
  sha1 '5f09399bd00a4ae94a07ac186cf0e8e7761de625'
  revision 1

  depends_on :x11
  depends_on :tex
  depends_on 'fftw'
  depends_on 'cfitsio' => :recommended
  depends_on 'gv' => :recommended
  depends_on 'wget' => :recommended
  depends_on 'ghostscript' => 'with-x11'
  depends_on 'gsl'
  depends_on 'imagemagick'
  depends_on 'libpng'
  depends_on 'readline'

  def install
    # changes install directory to Cellar, per instructions
    inreplace "Makefile.skel" do |s|
      s.change_make_var! 'USRDIR', prefix
    end
    system "./configure"
    system "make install"
  end
end
