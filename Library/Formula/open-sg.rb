require 'formula'

class OpenSg < Formula
  homepage 'http://www.opensg.org/wiki'

  head 'cvs://:pserver:anonymous@opensg.cvs.sourceforge.net:/cvsroot/opensg:OpenSG'

  depends_on 'libtiff'
  depends_on 'jpeg'

  def install
    ENV.deparallelize
    ENV.no_optimization
    system "./configure", "--prefix=#{prefix}", "--enable-glut", "--enable-tif", "--enable-jpg"
    cd 'Builds/i386-apple-darwin-g++' do
      system "make opt"
      system "make install"
    end
  end
end
