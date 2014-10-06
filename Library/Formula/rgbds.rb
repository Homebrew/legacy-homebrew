require "formula"

class Rgbds < Formula
  homepage "https://github.com/bentley/rgbds"
  url "https://github.com/bentley/rgbds/releases/download/v0.1.1/rgbds-0.1.1.tar.gz"
  sha1 "948a0a7c43f79be40c53be740bcb8d5e2b548136"

  head "https://github.com/bentley/rgbds.git", :branch => "master"

  bottle do
    cellar :any
    sha1 "4dcd554e8ff8c6dba47778461a27c04b798bcee1" => :mavericks
    sha1 "5479338e6423a60a83abb72667a410db69f97724" => :mountain_lion
    sha1 "b87f08e1ce5e1ccb4760cf722938184c3143fdcc" => :lion
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
