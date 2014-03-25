require 'formula'

class Libicns < Formula
  homepage 'http://icns.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/icns/libicns-0.8.1.tar.gz'
  sha256 '335f10782fc79855cf02beac4926c4bf9f800a742445afbbf7729dab384555c2'
  revision 1

  option :universal

  depends_on 'jasper'
  depends_on 'libpng'

  def install
    # Fix for libpng 1.5
    inreplace 'icnsutils/png2icns.c',
      'png_set_gray_1_2_4_to_8',
      'png_set_expand_gray_1_2_4_to_8'

    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
