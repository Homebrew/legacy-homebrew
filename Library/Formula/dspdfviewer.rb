class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "http://dspdfviewer.danny-edel.de"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.13.1.tar.gz"
  sha256 "333588de0316cfdb5821b8484ee55690dfa3c7431b67c126bfdbe9c9cc3e1ed4"

  head "https://github.com/dannyedel/dspdfviewer.git"

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
    assert_match /#{version}/, shell_output("dspdfviewer --version", 1)
  end
end
