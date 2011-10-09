require 'formula'

class Libicns < Formula
  url 'http://downloads.sourceforge.net/project/icns/icns/libicns-0.7.1/libicns-0.7.1.tar.gz'
  homepage 'http://icns.sourceforge.net/'
  md5 'ff4624353a074c6cb51e41d145070e10'

  depends_on 'jasper'

  def install
    # Fix for libpng 1.5 on Lion, may not be needed in head version of libicns
    inreplace 'icnsutils/png2icns.c', 'png_set_gray_1_2_4_to_8', 'png_set_expand_gray_1_2_4_to_8'

    ENV.libpng
    ENV.universal_binary # Also build 32-bit so Wine can use it

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
