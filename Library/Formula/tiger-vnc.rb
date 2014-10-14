require 'formula'

class TigerVnc < Formula
  homepage 'http://tigervnc.org/'
  url 'https://downloads.sourceforge.net/project/tigervnc/tigervnc/1.3.1/tigervnc-1.3.1.tar.gz'
  sha1 '308ec9a9a627d20406eebfaeac4f3d4398278cc1'
  revision 1

  depends_on 'cmake' => :build
  depends_on 'gnutls' => :recommended
  depends_on 'jpeg-turbo'
  depends_on 'gettext'
  depends_on 'fltk'
  depends_on :x11

  def install
    turbo = Formula['jpeg-turbo']
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/libjpeg.dylib
      .
    ]
    system 'cmake', *args
    system 'make install'
  end
end
