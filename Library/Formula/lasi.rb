require 'formula'

class Lasi <Formula
  head 'https://lasi.svn.sourceforge.net/svnroot/lasi/trunk'
  homepage 'http://www.unifont.org/lasi/'

  depends_on 'cmake'
  depends_on 'pkg-config'
  depends_on 'pango'
  depends_on 'doxygen'

  def install
    system "cmake . -DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "make install"
  end
end
