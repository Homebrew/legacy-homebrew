require 'formula'

class Asm6 < Formula
  homepage 'http://home.comcast.net/~olimar/NES/'
  url 'http://home.comcast.net/~olimar/NES/asm6.zip'
  version '1.6'
  sha1 '9fbc1eed740a16107730e7f996d7ddad8277eb4e'

  def install
    system "#{ENV.cc} -o asm6 asm6.c"
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
