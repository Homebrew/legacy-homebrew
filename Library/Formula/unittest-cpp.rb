class UnittestCpp < Formula
  desc "Unit testing framework for C++"
  homepage "https://github.com/unittest-cpp/unittest-cpp"
  url "https://github.com/unittest-cpp/unittest-cpp/archive/v1.5.1.tar.gz"
  sha256 "7021008424054fe17dbd10307b72367f172846173d20848e555f64b8a6b4a8a3"
  head "https://github.com/unittest-cpp/unittest-cpp.git"

  bottle do
    cellar :any
    sha256 "d8ab4cb9e4fb46354147c958cb6bc53edb9b3a61d13a0e03be2b40fd9880016f" => :el_capitan
    sha256 "344530b7f3c3d7db96693e4325d86ccd81f2c9df1ed21c151edff8ae92d558ce" => :yosemite
    sha256 "67f3d01e1d608e9f27d230e8e2bb35851248a69d526f120e78b13d9fdc2874b4" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules"
    system "make", "install"
  end
end
