class Z80dasm < Formula
  desc "Disassembler for the Zilog Z80 microprocessor and compatibles"
  homepage "http://www.tablix.org/~avian/blog/articles/z80dasm/"
  url "http://www.tablix.org/~avian/z80dasm/z80dasm-1.1.3.tar.gz"
  sha256 "1d6966bf7bddd0965421455e666872607019cfa43352188f5580304dd1039539"

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
