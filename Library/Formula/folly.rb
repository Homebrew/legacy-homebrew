class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v0.48.0.tar.gz"
  sha256 "e0b6b3cd143b5d581e8cef470aea1b6f8aeaa4e7431522058872e245cac5c144"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "085000e4af6e1d62c902b6da76fcff7598324856c8c129f8dd8844c9d19e099e" => :el_capitan
    sha256 "458df2aa0cad8420b702875999bc4b75ecbb842faa85d1ebcc0d6a731da9ed60" => :yosemite
    sha256 "8dd2b333ea7c77e92eccdc7df93cd46917d7048c8834c9ec30330a91c90c91a8" => :mavericks
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
