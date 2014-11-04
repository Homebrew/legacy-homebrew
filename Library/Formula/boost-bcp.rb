require "formula"

class BoostBcp < Formula
  homepage "http://www.boost.org/doc/tools/bcp/"
  url "https://downloads.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.bz2"
  sha1 "e151557ae47afd1b43dc3fac46f8b04a8fe51c12"

  head "http://svn.boost.org/svn/boost/trunk/"

  bottle do
    cellar :any
    sha1 "a43b921395070e10dd093ea1dcdced6013479a0c" => :yosemite
    sha1 "9ce5c7870fdf63caa0677e7cfd666755707bb9bf" => :mavericks
    sha1 "eb29007192552cd6149a8e1fecaf28d49edf6d5f" => :mountain_lion
  end

  depends_on "boost-build" => :build

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end
end
