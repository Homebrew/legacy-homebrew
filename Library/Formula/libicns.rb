require 'formula'

class Libicns < Formula
  homepage 'http://icns.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/icns/libicns-0.8.1.tar.gz'
  sha256 '335f10782fc79855cf02beac4926c4bf9f800a742445afbbf7729dab384555c2'
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "8be08eb118ca3412bc4dc770e86c4086d3052a6c" => :yosemite
    sha1 "4eba2a27ee02d7747ffe339eccb086069bbfdc7e" => :mavericks
    sha1 "94076c2e477fbe0b38100aea7e5c6a6760678416" => :mountain_lion
  end

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
