class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_home"
  url "https://downloads.sourceforge.net/project/silgraphite/graphite2/graphite2-1.3.2.tgz"
  sha256 "97af064ff07828f8724b5a9c27d63e2df5aef69a742f0f67cc3f68c3f15d3850"

  bottle do
    cellar :any
    sha256 "cd0782aad0cd67f788ef25af812a06c3c1fac288b73a12b70115adcdcdce56c3" => :yosemite
    sha256 "33fea1eb9f986f0b0eb4e3d42a410ab1e3bf34dcd5d548729ec0f9b3379515fb" => :mavericks
    sha256 "1403e215b4edb6c1e05711e3aac14d44cf9fa3f7fbf04652bd336f47a69a9e84" => :mountain_lion
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
