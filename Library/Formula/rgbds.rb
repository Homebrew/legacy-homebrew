class Rgbds < Formula
  desc "Rednex GameBoy development system"
  homepage "https://www.anjbe.name/rgbds/"
  url "https://github.com/bentley/rgbds/releases/download/v0.2.4/rgbds-0.2.4.tar.gz"
  sha256 "a7d32f369c6acf65fc0875c72873ef21f4d3a5813d3a2ab74ea604429f7f0435"

  head "https://github.com/bentley/rgbds.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "46c4d64f4ac330933afec620fb70e469461157d28bd52ddc726ab25de412a3b4" => :el_capitan
    sha256 "2cb8697c3899037e909218ad5b1786116ba1becbe735a68a0efc909e0c0a3478" => :yosemite
    sha256 "c08b856ecf4cb57390ec99241d0bc87ba623536ab7e3e11d5cc23334230ff1cd" => :mavericks
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
