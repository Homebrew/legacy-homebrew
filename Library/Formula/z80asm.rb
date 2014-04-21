require 'formula'

class Z80asm < Formula
  homepage 'http://www.nongnu.org/z80asm/'
  url 'http://download.savannah.gnu.org/releases/z80asm/z80asm-1.8.tar.gz'
  sha1 '9d169ac728a9a3b162c0a7ea34da55cf37ada0e1'

  def install
    system 'make'

    bin.install 'z80asm'
    man1.install 'z80asm.1'
  end

  test do
    path = testpath/"a.asm"
    path.write "call 1234h\n"

    system bin/"z80asm", path
    code = File.open(testpath/"a.bin", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0xcd, 0x34, 0x12], code
  end
end
