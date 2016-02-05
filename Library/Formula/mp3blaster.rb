class Mp3blaster < Formula
  desc "Text-based mp3 player"
  homepage "http://mp3blaster.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mp3blaster/mp3blaster/mp3blaster-3.2.5/mp3blaster-3.2.5.tar.gz"
  sha256 "129115742c77362cc3508eb7782702cfb44af2463a5453e8d19ea68abccedc29"

  depends_on "sdl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3blaster", "--version"
  end
end
