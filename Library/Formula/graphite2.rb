class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_home"
  url "https://downloads.sourceforge.net/project/silgraphite/graphite2/graphite2-1.3.2.tgz"
  sha256 "97af064ff07828f8724b5a9c27d63e2df5aef69a742f0f67cc3f68c3f15d3850"

  bottle do
    cellar :any
    sha256 "aa87e2ced68634547500aa30334e3bd8168e13ec296f15852e456309c5998e47" => :el_capitan
    sha256 "878420245b08827cceec2cb59c4763237ce60d1111d2419d142270cfd6402207" => :yosemite
    sha256 "f1e3f1b646503b549dd04faa92a151134b37c484aa174395ebf01074b68238b2" => :mavericks
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
