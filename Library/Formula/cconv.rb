class Cconv < Formula
  desc "Iconv based simplified-traditional Chinese conversion tool"
  homepage "https://code.google.com/p/cconv/"
  url "https://cconv.googlecode.com/files/cconv-0.6.2.tar.gz"
  sha256 "f463da66c2ae18407441e12716f5f1c6cdea4e417ebfd475ec4c6dc6ad250c9d"

  bottle do
    cellar :any
    sha256 "65436699d38a250324868565690c295e9668d96f9fa5f1f8d23dfc2dff6fc122" => :yosemite
    sha256 "6ccd7bc724cb38fb3af7ccb07fb4b45cc6486390c6c7030dc2f9cd89e7531cf4" => :mavericks
    sha256 "21adc67fe672719cbfc93e940d044a2b2ceb32653cc1a901b79e251c3fb6d090" => :mountain_lion
  end

  def install
    # fix link with iconv: https://code.google.com/p/cconv/issues/detail?id=18
    inreplace "Makefile.in", "@ICONV_LIBS@", "@ICONV_LIBS@ -liconv"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    rm_f include/"unicode.h"
  end

  test do
    system bin/"cconv", "-l"
  end
end
