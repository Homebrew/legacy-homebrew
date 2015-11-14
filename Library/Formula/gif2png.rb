class Gif2png < Formula
  desc "Convert GIFs to PNGs."
  homepage "http://www.catb.org/~esr/gif2png/"
  url "http://www.catb.org/~esr/gif2png/gif2png-2.5.11.tar.gz"
  sha256 "40483169d2de06f632ada1de780c36f63325844ec62892b1652193f77fc508f7"

  bottle do
    cellar :any
    sha256 "bef2695287ec025c045ae53ab19e7e894adb0ffd4f27e4abb0c33e85598dd6b7" => :yosemite
    sha256 "f63bffca24e8072f90b23b98a701bcedd0007ac0039e883e38376819044cfd00" => :mavericks
    sha256 "367e2fb907fe415729e147c6bdd25636fad449e30e1d52d3fc8f52d168353fba" => :mountain_lion
  end

  depends_on "libpng"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    pipe_output "#{bin}/gif2png -O", File.read(test_fixtures("test.gif"))
  end
end
