require 'formula'

class TigerVnc < Formula
  homepage 'http://tigervnc.org/'
  url 'https://github.com/TigerVNC/tigervnc/archive/v1.4.0.tar.gz'
  sha1 '36252b10912bcbef44d43c5fa7977ae97988fff3'

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
