class Ucon64 < Formula
  desc "A ROM backup tool and emulator's Swiss Army knife program."
  homepage "http://ucon64.sourceforge.net/"
  url "https://downloads.sourceforge.net/ucon64/ucon64-2.0.0-src.tar.gz"
  sha256 "62064324a1912387f84ac9d4c521c5d5e7b80f2567e9f61bf0ab3e1d976c0127"

  def install
    cd "src"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "ucon64"
    ohai "You can copy/move your DAT file collection to $HOME/.ucon64/dat"
    ohai "Be sure to check $HOME/.ucon64rc for some options after you've run uCON64 once."
  end

  test do
    system "#{bin}/ucon64", "--help", "--snes"
  end
end
