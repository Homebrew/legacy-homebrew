require "formula"

class Rgbds < Formula
  homepage "https://github.com/bentley/rgbds"
  url "https://github.com/bentley/rgbds/releases/download/v0.1.1/rgbds-0.1.1.tar.gz"
  sha1 "948a0a7c43f79be40c53be740bcb8d5e2b548136"

  head "https://github.com/bentley/rgbds.git", :branch => "master"

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
