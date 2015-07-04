class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_home"
  url "https://downloads.sourceforge.net/project/silgraphite/graphite2/graphite2-1.2.4.tgz"
  sha256 "4bc3d5168029bcc0aa00eb2c973269d29407be2796ff56f9c80e10736bd8b003"

  bottle do
    cellar :any
    sha256 "24a47ed50dc7ac5ced74a8087468da3934aec145df0fa4e60091e1df7f86ff20" => :yosemite
    sha256 "cc78dfeafc94c5176930df46dd2b0918c1707d91651d55464291d936207ae855" => :mavericks
    sha256 "0ce563a4d9aa5139e45bc4e48bdc5c718095b8755eba55e3f61ff764ebd8d508" => :mountain_lion
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
