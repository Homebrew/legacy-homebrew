class Folly < Formula
  desc "A collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v0.47.0.tar.gz"
  sha256 "7d3309088cae1817d60996611e5fc0825c5c8df36d244f247c1d49ebc38c35fb"

  bottle do
    cellar :any
    sha256 "e11412ea2d087e2311966f9aada79b8c40d07e0076c8b3f532ab5c34f8213dcd" => :yosemite
    sha256 "a3aecaf06209cc8d644968885bc0aa105c4ad262d54550a512274fd89981c813" => :mavericks
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
