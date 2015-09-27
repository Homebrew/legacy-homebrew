class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "http://dspdfviewer.danny-edel.de"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.13.1.tar.gz"
  sha256 "333588de0316cfdb5821b8484ee55690dfa3c7431b67c126bfdbe9c9cc3e1ed4"

  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    sha256 "8d6696c179bad40c541e4d32107b66ee64a83fd0b6619e1af80f04ddeb3fffa1" => :el_capitan
    sha256 "13fd6d702d95478e38dcda6c35e208d2d99a799a296e544b83bd35a6d31181fd" => :yosemite
    sha256 "f014c5237582f5f591c59835e5695e339c07415f8990ca026d88d0838935e2ef" => :mavericks
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
    assert_match /#{version}/, shell_output("dspdfviewer --version", 1)
  end
end
