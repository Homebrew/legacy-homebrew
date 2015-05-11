class Rgbds < Formula
  homepage "https://www.anjbe.name/rgbds/"
  url "https://github.com/bentley/rgbds/releases/download/v0.2.3/rgbds-0.2.3.tar.gz"
  sha256 "7918cd7642d9b72a990c8e98e6b29268a267cbfa023cf5b20a0acf33e879c6f0"

  head "https://github.com/bentley/rgbds.git"

  bottle do
    cellar :any
    sha1 "033923dc3ed2c549519448845d30fabefeb83bf1" => :yosemite
    sha1 "9cae6061f1fce0ed5981d9ed0a7fd2885d66334f" => :mavericks
    sha1 "ca4bad2a5be8b05e0c30dfb87569de1c6a2fcb07" => :mountain_lion
  end

  def install
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
