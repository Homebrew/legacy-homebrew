class Asm6 < Formula
  desc "6502 assembler"
  homepage "https://web.archive.org/web/20150601152433/http://home.comcast.net/~olimar/NES/"
  url "https://web.archive.org/web/20150601152433/http://home.comcast.net/~olimar/NES/asm6.zip"
  version "1.6"
  sha256 "b37956f37815a75a6712c0d1f8eea06d1207411921c2e7ff46a133f35f0b3e1d"

  def install
    system ENV.cc, "-o", "asm6", "asm6.c"
    bin.install "asm6"
  end

  test do
    (testpath/"a.asm").write <<-EOS
      org $c000
      jmp $fce2
    EOS

    system bin/"asm6", "a.asm"
    code = File.open("a.bin", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x4c, 0xe2, 0xfc], code
  end
end
