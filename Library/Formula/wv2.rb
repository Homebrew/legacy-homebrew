require 'formula'

class Wv2 < Formula
  homepage 'http://wvware.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/wvware/wv2-0.4.2.tar.bz2'
  sha1 'f04fceb02c048ae46fbe679caaf694e40214a547'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on 'glib'
  depends_on 'libgsf'

  def install
    ENV.append 'LDFLAGS', '-liconv -lgobject-2.0' # work around broken detection
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
