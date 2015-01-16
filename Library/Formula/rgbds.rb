require "formula"

class Rgbds < Formula
  homepage "https://github.com/bentley/rgbds"
  url "https://github.com/bentley/rgbds/releases/download/v0.1.2/rgbds-0.1.2.tar.gz"
  sha1 "5d83defd7ee101db409e638ff32e362b6ca25a32"

  head "https://github.com/bentley/rgbds.git"

  bottle do
    cellar :any
    sha1 "033923dc3ed2c549519448845d30fabefeb83bf1" => :yosemite
    sha1 "9cae6061f1fce0ed5981d9ed0a7fd2885d66334f" => :mavericks
    sha1 "ca4bad2a5be8b05e0c30dfb87569de1c6a2fcb07" => :mountain_lion
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "MANPREFIX=#{man}"
  end

  test do
    (testpath/"source.asm").write <<-EOS.undent
      SECTION "Org $100",HOME[$100]
      nop
      jp begin
      begin:
        ld sp, $ffff
        ld a, $1
        ld b, a
        add a, b
    EOS
    system "#{bin}/rgbasm", "source.asm"
  end
end
