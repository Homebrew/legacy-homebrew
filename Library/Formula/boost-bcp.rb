class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "http://www.boost.org/doc/tools/bcp/"
  url "https://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.bz2"
  sha256 "686affff989ac2488f79a97b9479efb9f2abae035b5ed4d8226de6857933fd3b"

  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b04e4f16118f1f9c1c955e1cd9cfbd70a7223d3cfe9d4eeb821231a9b62b44ce" => :el_capitan
    sha256 "1dafec2ea159151006a5615ad710c61760bf3daad8f98d4fed905e198073e0fc" => :yosemite
    sha256 "56e649ee9c17b6defb825e6577c009493ed7c463110c43ee0127bc1643c37c13" => :mavericks
  end

  depends_on "boost-build" => :build

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--help"
  end
end
