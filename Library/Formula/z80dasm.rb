class Z80dasm < Formula
  desc "Disassembler for the Zilog Z80 microprocessor and compatibles"
  homepage "https://www.tablix.org/~avian/blog/articles/z80dasm/"
  url "https://www.tablix.org/~avian/z80dasm/z80dasm-1.1.3.tar.gz"
  sha256 "1d6966bf7bddd0965421455e666872607019cfa43352188f5580304dd1039539"

  bottle do
    cellar :any_skip_relocation
    sha256 "498234696c7e8e4549d7b58b5f7f4dc11b8b044aa9c5461ada53d81c481ff93f" => :el_capitan
    sha256 "9e6fc296fe40b206a8fb2b298e6a60733c7327ea8df8780285bd9720b785c923" => :yosemite
    sha256 "161e72a9b0508dc6ea20d0d0340b3b95d840c15a0e1253dd7d7e472952c67d19" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"a.bin"
    path.binwrite [0xcd, 0x34, 0x12].pack("c*")
    assert_match /call 01234h/, shell_output("#{bin}/z80dasm #{path}")
  end
end
