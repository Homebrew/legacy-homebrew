class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_home"
  url "https://github.com/silnrsi/graphite/archive/1.3.5.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/graphite2/graphite2_1.3.5.orig.tar.gz"
  sha256 "1c9064c4eb2b3ca03e7fdcfff47125c2304378f6cd4d76c5eba7d4f84d59324b"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    sha256 "30046850e8779beda6f8b3b92b386d24cac79bce535cdd1bbb8ef017d39d5032" => :el_capitan
    sha256 "1bbfd4cd29ff270b358999e4e23af0509539c64d6e4370418d613ac2cded237e" => :yosemite
    sha256 "d8661a659dba4300d5dcccfad1e572930b257dde0b2393fd846139ae72f4da7a" => :mavericks
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
