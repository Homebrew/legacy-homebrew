class Screenbrightness < Formula
  desc "Change OS X display brightness from the command-line"
  homepage "https://github.com/nriley/brightness"
  url "https://github.com/nriley/brightness/archive/1.2.tar.gz"
  sha256 "6094c9f0d136f4afaa823d299f5ea6100061c1cec7730bf45c155fd98761f86b"

  bottle do
    cellar :any
    sha1 "af2ab5c5ba668e9be32b95ed3ac581423e14b1b8" => :yosemite
    sha1 "c780916b31a50d6a599b1c6238548a8db3a008a1" => :mavericks
    sha1 "9cf03ce35a3cb24a25bd28b9a213963f64a3dfdd" => :mountain_lion
  end

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/brightness", "-l"
  end
end
