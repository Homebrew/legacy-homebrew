class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "http://www.boost.org/doc/tools/bcp/"
  url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
  sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"


  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any
    sha256 "ac4b08d1bd2ccc2d4adaf877f325eccd85d8c588e12d407374c08007c7ce2605" => :yosemite
    sha256 "0150fea4a1d5c67d916754502088ac8f12c5386ced91712d614cdaaaeaadef0d" => :mavericks
    sha256 "00d5d63073f6a5fe6f42822f617835e84164ff875537504b275ca072b42f67bf" => :mountain_lion
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
