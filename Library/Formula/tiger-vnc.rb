require 'formula'

class TigerVnc < Formula
  homepage 'http://tigervnc.org/'
  url 'http://downloads.sourceforge.net/project/tigervnc/tigervnc/1.2.0/tigervnc-1.2.0.tar.gz'
  sha1 '0542b2549a85b6723deebc3b5ecafa4f1fbee8e6'

  depends_on 'cmake' => :build
  depends_on 'gnutls' => :recommended
  depends_on 'jpeg-turbo'
  depends_on 'gettext'
  depends_on :x11

  def install
    gettext = Formula.factory('gettext')
    turbo   = Formula.factory('jpeg-turbo')
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/libjpeg.dylib
      -DCMAKE_PREFIX_PATH=#{gettext.prefix}
      .
    ]
    system 'cmake', *args
    system 'make install'
    mv (prefix+'man'), share
  end
end
