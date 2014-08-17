require "formula"

class Zpaq < Formula
  homepage "http://mattmahoney.net/dc/zpaq.html"
  url "http://mattmahoney.net/dc/zpaq649.zip"
  sha1 "aa0d8241679f314d0be8a43e7a87e5b4d4529017"
  version "6.49"

  def install
    ENV.append_to_cflags "-Dunix -O3"
    system "make", "libzpaq.o", "divsufsort.o", "zpaq.o"
    system "ar", "-r", "libzpaq.a", "libzpaq.o", "divsufsort.o"
    system ENV.cxx, "-o", "zpaq", "libzpaq.a", "zpaq.o"
    lib.install "libzpaq.a"
    include.install "libzpaq.h"
    bin.install "zpaq"
  end

  test do
    archive = testpath/'test.zpaq'
    zpaq = bin/"zpaq"
    system zpaq, "a", archive, "#{include}/libzpaq.h"
    system zpaq, "t", archive
    assert_equal "7kSt", archive.read(4)
  end
end
