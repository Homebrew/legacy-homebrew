class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "http://graphite.sil.org"
  url "https://github.com/silnrsi/graphite/archive/1.3.7.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/graphite2/graphite2_1.3.7.orig.tar.gz"
  sha256 "4689f96f6bed02ce0caff710c1f99c281c888864b0c2c10eff08605274d8f7a8"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    sha256 "39571f2f4d88c97a99923c35448ff478cd6920058563b6d78273471d418ac4d8" => :el_capitan
    sha256 "97478b8d3e7ad6fdae98d9017348704a52dc6ec17dd105ce1251ba67025d8dcb" => :yosemite
    sha256 "f01c55c3e1fbf3ddd969e6402c2130fca1d07d8ee7d1a5058bb06363c57a3826" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build

  resource "testfont" do
    url "https://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
    sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
  end

  def install
    ENV.universal_binary if build.universal?

    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    resource("testfont").stage do
      shape = shell_output("#{bin}/gr2fonttest Simple-Graphite-Font.ttf 'abcde'")
      assert_match /67.*36.*37.*38.*71/m, shape
    end
  end
end
