require "formula"

class Xa < Formula
  homepage "http://www.floodgap.com/retrotech/xa/"
  url "http://www.floodgap.com/retrotech/xa/dists/xa-2.3.6.tar.gz"
  sha1 "f4472003c939e94f28f61ce680c5b762f8ba41e1"

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DESTDIR=#{prefix}",
                   "install"
  end

  test do
    (testpath/"foo.a").write "jsr $ffd2\n"

    system "#{bin}/xa", "foo.a"
    code = File.open("a.o65", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x20, 0xd2, 0xff], code
  end
end
