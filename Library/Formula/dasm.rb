require 'formula'

class Dasm < Formula
  homepage 'http://dasm-dillon.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/dasm-dillon/dasm-dillon/2.20.11/dasm-2.20.11-2014.03.04-source.tar.gz'
  sha1 '2ce78b29505b31778b8f796ba4b161b9f890e77e'
  head 'svn://svn.code.sf.net/p/dasm-dillon/code/trunk'

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
