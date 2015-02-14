class Cconv < Formula
  homepage "https://code.google.com/p/cconv/"
  url "https://cconv.googlecode.com/files/cconv-0.6.2.tar.gz"
  sha1 "9775f91fd5600d176552a88625aaa1f64ece09c1"

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
