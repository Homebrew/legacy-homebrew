class Dasm < Formula
  desc "Macro assembler with support for several 8-bit microprocessors"
  homepage "http://dasm-dillon.sourceforge.net"
  url "https://downloads.sourceforge.net/project/dasm-dillon/dasm-dillon/2.20.11/dasm-2.20.11-2014.03.04-source.tar.gz"
  sha256 "a9330adae534aeffbfdb8b3ba838322b92e1e0bb24f24f05b0ffb0a656312f36"
  head "svn://svn.code.sf.net/p/dasm-dillon/code/trunk"

  bottle do
    cellar :any
    sha256 "2db683ba88f8f3323517d67c0a34ad0dfbbe5dc8d81d905a9855b0c070471382" => :mavericks
    sha256 "992fe2df21a3794e509e8ba29b0c08c1fee3c04fb4e4352d0c44295435bce226" => :mountain_lion
    sha256 "5866332ebc746563da519818b581d137c82352655a171bf0eb88684812e3601c" => :lion
  end

  def install
    system "make"
    prefix.install "bin", "doc"
  end

  test do
    path = testpath/"a.asm"
    path.write <<-EOS
      processor 6502
      org $c000
      jmp $fce2
    EOS

    system bin/"dasm", path
    code = (testpath/"a.out").binread.unpack("C*")
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
