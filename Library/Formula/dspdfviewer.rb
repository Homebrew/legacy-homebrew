class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "http://dspdfviewer.danny-edel.de"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.13.1.tar.gz"
  sha256 "333588de0316cfdb5821b8484ee55690dfa3c7431b67c126bfdbe9c9cc3e1ed4"
  revision 1
  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    sha256 "5244f01fc6f84515341409ea8bda1edec1309fa08c34df3b752f8b51d995dff8" => :el_capitan
    sha256 "328e32166fc10b650d5ab7a4e4a781f37cb42891fcb8847af5009ef14d0f9d67" => :yosemite
    sha256 "773a1f357f93126b43779bb6ed360f487184a67dad994d86f2454def5d3c0cc9" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "poppler" => "with-qt"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/dspdfviewer --version", 1)
  end
end
