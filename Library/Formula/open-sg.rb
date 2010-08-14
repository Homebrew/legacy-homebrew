require 'formula'

class OpenSg <Formula
  head 'cvs://:pserver:anonymous@opensg.cvs.sourceforge.net:/cvsroot/opensg:OpenSG'
  homepage 'http://www.opensg.org/wiki'

  depends_on 'libtiff'
  depends_on 'jpeg'

  def install
    ENV.deparallelize
    ENV.no_optimization
    system "./configure", "--prefix=#{prefix}", "--enable-glut", "--enable-tif", "--enable-jpg"
    Dir.chdir 'Builds/i386-apple-darwin-g++'
    system "make opt"
    system "make install"
  end
end
