class Cconv < Formula
  desc "Iconv based simplified-traditional Chinese conversion tool"
  homepage "https://code.google.com/p/cconv/"
  url "https://cconv.googlecode.com/files/cconv-0.6.2.tar.gz"
  sha1 "9775f91fd5600d176552a88625aaa1f64ece09c1"

  bottle do
    cellar :any
    sha1 "bf9023851423f52249b9107fe71a89f16ea00146" => :yosemite
    sha1 "d3c284caaf0ef18e98050078c9eda2f3896b666c" => :mavericks
    sha1 "3a700e441e9b0d2d2a939269fa7c71e985a453bf" => :mountain_lion
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
