class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "http://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_home"
  url "https://downloads.sourceforge.net/project/silgraphite/graphite2/graphite2-1.2.4.tgz"
  sha256 "4bc3d5168029bcc0aa00eb2c973269d29407be2796ff56f9c80e10736bd8b003"

  depends_on "cmake" => :build

  resource "testfont" do
    url "http://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
    sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
  end

  def install
    args = std_cmake_args
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    resource("testfont").stage do
      shape = `#{bin}/gr2fonttest Simple-Graphite-Font.ttf "abcde"`
      assert_match /67.*36.*37.*38.*71/m, shape
    end
  end
end
