require 'formula'

class TigerVnc < Formula
  homepage 'http://tigervnc.org/'
  url 'https://downloads.sourceforge.net/project/tigervnc/tigervnc/1.3.0/tigervnc-1.3.0.tar.bz2'
  sha1 'eda373336bee1bcfa806df1ea6389d918945a258'

  depends_on 'cmake' => :build
  depends_on 'gnutls' => :recommended
  depends_on 'jpeg-turbo'
  depends_on 'gettext'
  depends_on 'fltk'
  depends_on :x11

  def install
    gettext = Formula['gettext']
    turbo = Formula['jpeg-turbo']
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/libjpeg.dylib
      -DCMAKE_PREFIX_PATH=#{gettext.prefix}
      .
    ]
    system 'cmake', *args
    system 'make install'
  end
end
