require 'formula'

class Dasm < Formula
  homepage 'http://dasm-dillon.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/dasm-dillon/dasm-dillon/2.20.11/dasm-2.20.11.tar.gz'
  sha1 '6c1f0091e88fff8f814a92304286c1875fd64693'

  def install
    system "make"
    prefix.install 'bin', 'doc'
  end

  test do
    path = testpath/"a.asm"
    path.write <<-EOS
      processor 6502
      org $c000
      jmp $fce2
    EOS

    system bin/"dasm", path
    code = File.open(testpath/"a.out", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
