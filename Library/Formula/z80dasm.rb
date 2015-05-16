require 'formula'

class Z80dasm < Formula
  homepage 'http://www.tablix.org/~avian/blog/articles/z80dasm/'
  url 'http://www.tablix.org/~avian/z80dasm/z80dasm-1.1.3.tar.gz'
  sha1 'da1e2525bc0db1b86e28f65ba510196998448ed1'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"a.bin"
    path.binwrite [0xcd, 0x34, 0x12].pack("c*")

    assert shell_output("#{bin}/z80dasm #{path}").include?("call 01234h")
  end
end
