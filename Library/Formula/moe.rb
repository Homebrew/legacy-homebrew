class Moe < Formula
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "http://ftpmirror.gnu.org/moe/moe-1.7.tar.lz"
  mirror "https://ftp.gnu.org/pub/gnu/moe/moe-1.7.tar.lz"
  sha256 "33ba66f948353c105232e9c8b2da8dc7b6ddc8cdff4beb3e3f55d78bc3acf1bb"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/moe", "--version"
  end
end
