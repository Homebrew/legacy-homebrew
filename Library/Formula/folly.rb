class Folly < Formula
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v0.22.0.tar.gz"
  sha256 "de365f191cd88eada031c30372ff1bdf8bfeed7e3e8e4408b4695cb12ca5ab05"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "double-conversion"
  depends_on "glog"
  depends_on "gflags"
  depends_on "boost"
  depends_on "libevent"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
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
