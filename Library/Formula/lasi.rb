require 'formula'

class Lasi < Formula
  url 'http://sourceforge.net/projects/lasi/files/lasi/1.1.1%20Source/libLASi-1.1.1.tar.gz'
  md5 'bc5161b1d820db3dbcea24ce1c2ed5ec'
  homepage 'http://www.unifont.org/lasi/'
  head 'https://lasi.svn.sourceforge.net/svnroot/lasi/trunk'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'pango'
  depends_on 'doxygen'

  def install
    system "cmake . -DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "make install"
  end
end
