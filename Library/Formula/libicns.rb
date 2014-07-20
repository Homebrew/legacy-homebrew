require 'formula'

class Libicns < Formula
  homepage 'http://icns.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/icns/libicns-0.8.1.tar.gz'
  sha256 '335f10782fc79855cf02beac4926c4bf9f800a742445afbbf7729dab384555c2'
  revision 1

  bottle do
    cellar :any
    sha1 "f8ad93d76978de282222900ec444e103b373fb6f" => :mavericks
    sha1 "5b395ca71dad8657ff9cf93e59ddc6cb45f68052" => :mountain_lion
    sha1 "e373c0491b1647cd9fb6c430c7c38cf9739c487a" => :lion
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
