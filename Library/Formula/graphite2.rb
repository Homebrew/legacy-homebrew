class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_home"
  url "https://github.com/silnrsi/graphite/archive/1.3.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/graphite2/graphite2_1.3.4.orig.tar.gz"
  sha256 "9e3c3e223dbc48c072b654711d0c3c29c24f368f5ef628b7bb53a5a8233c6346"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    sha256 "99ca81a40901fec1f8b4fc8abc1f33973613aba65c4cba8b8ee0fdab51e1d6eb" => :el_capitan
    sha256 "9bfcf842175cf71b46fb99e2cd8aa8cff115343722b1126324eaa78aed714795" => :yosemite
    sha256 "0baa21487063934bae0467fb271af27836487d7f191d54066d08284678e3e996" => :mavericks
  end

  depends_on "cmake" => :build

  resource "testfont" do
    url "https://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
    sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
  end

  def install
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
