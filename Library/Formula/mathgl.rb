require 'formula'

class Mathgl < Formula
  homepage 'http://mathgl.sourceforge.net/'
  url 'http://downloads.sourceforge.net/mathgl/mathgl-1.11.2.tar.gz'
  sha1 '16b9ab58e654c5b91374f8a35eafc33630d7f5c0'

  depends_on 'gsl'
  depends_on :libpng

  def install
    ENV['LIBS'] = '-lz'

    # Fixed upstream: this line can be removed when v2 is released
    inreplace ["mgl/mgl_export.cpp", "mgl/mgl_data_png.cpp"] do |s|
      s.gsub! /#include <png.h>/, "#include <zlib.h>\n#include <png.h>"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    mktemp do
      system "#{bin}/mgl_example"
    end
  end
end
