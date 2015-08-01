class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v0.48.0.tar.gz"
  sha256 "e0b6b3cd143b5d581e8cef470aea1b6f8aeaa4e7431522058872e245cac5c144"

  bottle do
    cellar :any
    sha256 "7f63861d73f611c756c2e701d3a66293dcb025ea6741708931757a1014dbd87d" => :yosemite
    sha256 "5138bd78569d3e6e2e01ada415d606f689f702448dc4c2c2f82cdae33b035d49" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "double-conversion"
  depends_on "glog"
  depends_on "gflags"
  depends_on "boost"
  depends_on "libevent"

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
