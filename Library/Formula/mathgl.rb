require 'formula'

class Mathgl < Formula
  homepage 'http://mathgl.sourceforge.net/'
  url 'http://downloads.sourceforge.net/mathgl/mathgl-1.11.2.tar.gz'
  md5 'acd33e68911d9506f60d769dce23f95e'

  depends_on 'gsl'

  def install
    ENV.x11
    ENV['LIBS'] = '-lz'

    # Fixed upstream: this line can be removed when v2 is released
    inreplace ["mgl/mgl_export.cpp", "mgl/mgl_data_png.cpp"] do |s|
      s.gsub! /#include <png.h>/, "#include <zlib.h>\n#include <png.h>"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
