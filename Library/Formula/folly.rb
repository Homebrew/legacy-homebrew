class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v0.48.0.tar.gz"
  sha256 "e0b6b3cd143b5d581e8cef470aea1b6f8aeaa4e7431522058872e245cac5c144"
  revision 1

  bottle do
    cellar :any
    sha256 "57631c3297f2c64f311406fe1d322cbf4e7d52bc4796b145e0c802110d56bced" => :el_capitan
    sha256 "18887b38af4e91f357991455b4c1b22136ca5559e08d95491102e3658d953810" => :yosemite
    sha256 "254760684e085f7ddc96475b3f24d5c7cfc288d9dd24e3838c57b06dae66aba8" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "double-conversion"
  depends_on "glog"
  depends_on "gflags"
  depends_on "boost"
  depends_on "libevent"
  depends_on "xz"
  depends_on "snappy"
  depends_on "lz4"
  depends_on "jemalloc"
  depends_on "openssl"

  needs :cxx11
  depends_on :macos => :mavericks

  def install
    ENV.cxx11
    cd "folly" do
      system "autoreconf", "-i"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cc", "-L#{lib}", "-lfolly", "-o", "test"
    system "./test"
  end
end
