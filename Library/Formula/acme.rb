require 'formula'

class Acme < Formula
  homepage 'http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/'
  url 'http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/current/acme091src.tar.gz'
  version '0.91'
  sha1 '7104ea01a2ca2962294aaac4974e10c6486534a8'

  def install
    system "make", "-C", "src", "install", "BINDIR=#{bin}"
  end

  test do
    path = testpath/"a.asm"
    path.write <<-EOS
      !to "a.out", cbm
      * = $c000
      jmp $fce2
    EOS

    system bin/"acme", path
    code = File.open(testpath/"a.out", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
