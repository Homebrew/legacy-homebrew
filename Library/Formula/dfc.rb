class Dfc < Formula
  desc "Display graphs and colors of file system space/usage"
  homepage "http://projects.gw-computing.net/projects/dfc"
  url "http://projects.gw-computing.net/attachments/download/467/dfc-3.0.5.tar.gz"
  sha256 "3c947a1d6bc53347b1643921dcbf4c6f8fe7eb6167fc1f4e9436366f036d857a"

  head "https://github.com/Rolinh/dfc.git"

  bottle do
    sha256 "ae295a2a741799b25aece646103fc20d0583589fa7c86e3315fd989270b16261" => :el_capitan
    sha256 "c9dcc6c6992488abdf62380712f1ac72e5bbc34af82920f4a3e15e6ec026d3dc" => :yosemite
    sha256 "66cb8502b640527cac7f5c3d030b19a248382c5f9ae06300ee71a84a399a904e" => :mavericks
    sha256 "4b14d40212289c0e0301e5a0785ca2cd2dd4903ae2f9605176e1cbd13cea9413" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "gettext"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"dfc", "-T"
    assert_match ",%USED,", shell_output("#{bin}/dfc -e csv")
  end
end
