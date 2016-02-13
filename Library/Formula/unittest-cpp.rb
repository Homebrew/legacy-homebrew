class UnittestCpp < Formula
  desc "Unit testing framework for C++"
  homepage "https://github.com/unittest-cpp/unittest-cpp"
  url "https://github.com/unittest-cpp/unittest-cpp/archive/v1.5.1.tar.gz"
  sha256 "7021008424054fe17dbd10307b72367f172846173d20848e555f64b8a6b4a8a3"
  head "https://github.com/unittest-cpp/unittest-cpp.git"

  bottle do
    cellar :any
    sha256 "44d3ebdf38a4fe0f6e7c31385a6f2474eabbf228277e67fec8accb4437140f72" => :yosemite
    sha256 "5e383d6c98685cab234a7c8ddf3839df42059e5e8db493e185ff4c2259fbbe3e" => :mavericks
    sha256 "942d4451a5985818fd1a881be3405573eba6d4a93e2dabca04dfe7b9e3afc105" => :mountain_lion
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
