require "formula"

class Xa < Formula
  homepage "http://www.floodgap.com/retrotech/xa/"
  url "http://www.floodgap.com/retrotech/xa/dists/xa-2.3.7.tar.gz"
  sha1 "e5a6eb86c5683c217a778553a78a30780702c1d9"

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
