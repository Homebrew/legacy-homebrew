require 'formula'

class Bgrep < Formula
  homepage 'https://github.com/tmbinc/bgrep'
  url 'https://github.com/tmbinc/bgrep/archive/bgrep-0.2.tar.gz'
  sha1 '37f29f95397730dcd8760a0bac33ba167ac7d998'

  def install
    system "#{ENV.cc} #{ENV.cflags} -o bgrep bgrep.c"
    bin.install "bgrep"
  end

  test do
    path = testpath/"hi.prg"
    code = [0x00, 0xc0, 0xa9, 0x48, 0x20, 0xd2, 0xff,
            0xa9, 0x49, 0x20, 0xd2, 0xff, 0x60].pack("C*")
    path.open("wb") { |f| f.write code }

    lines = `#{bin}/bgrep 20d2ff #{path}`.strip.split("\n")
    assert_equal ["#{path}: 00000004", "#{path}: 00000009"], lines
    assert_equal 0, $?.exitstatus
  end
end
