require 'formula'

class Libicns < Formula
  homepage 'http://icns.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/icns/icns/libicns-0.8.0/libicns-0.8.0.tar.gz'
  sha256 '8a720d45f6cf3cb88255d80965e486857b77b894a345e9a6b321cb03aa3d064a'

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
