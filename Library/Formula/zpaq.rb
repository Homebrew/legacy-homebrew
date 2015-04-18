class Zpaq < Formula
  homepage "http://mattmahoney.net/dc/zpaq.html"
  url "http://mattmahoney.net/dc/zpaq705.zip"
  sha256 "d8abe3e3620d4c6f3ddc1da149acffa4c24296fd9c74c9d7b62319e308b63334"
  version "7.05"

  head "https://github.com/zpaq/zpaq.git"

  def install
    system "make"
    include.install "libzpaq.h"
    bin.install "zpaq"

    system "pod2man", "zpaq.pod", "zpaq.1"
    man1.install "zpaq.1"
  end

  test do
    archive = testpath/"test.zpaq"
    zpaq = bin/"zpaq"
    system zpaq, "a", archive, "#{include}/libzpaq.h"
    system zpaq, "l", archive
    assert_equal "7kSt", archive.read(4)
  end
end
