class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "http://ftpmirror.gnu.org/moe/moe-1.7.tar.lz"
  mirror "https://ftp.gnu.org/pub/gnu/moe/moe-1.7.tar.lz"
  sha256 "33ba66f948353c105232e9c8b2da8dc7b6ddc8cdff4beb3e3f55d78bc3acf1bb"

  bottle do
    sha256 "d47871f32ce6e75bfad7859cbfceb900b4bc5c2858336a798b346385b6fec9ae" => :yosemite
    sha256 "4f95aa8a7068d150be7ad7c9ad4a2d2c0dc7384e70100cae21e65f2ef67bf051" => :mavericks
    sha256 "ee58b2b36a26dd18121f7edacf3d1bb645bc314a90b6a62963e8eded725970a9" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/moe", "--version"
  end
end
