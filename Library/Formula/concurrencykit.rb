class Concurrencykit < Formula
  desc "Aid design and implementation of concurrent systems"
  homepage "http://concurrencykit.org"
  url "http://concurrencykit.org/releases/ck-0.5.0.tar.gz"
  mirror "https://github.com/concurrencykit/ck/archive/0.5.0.tar.gz"
  sha256 "55cbfaeace11bad65cd78ed663708652b8982f0c37bc49e6578e64dab1df3ff4"

  head "https://github.com/concurrencykit/ck.git"

  bottle do
    cellar :any
    sha256 "59dafe842df8d2529c1602491b9a86f642f02f9158f030545a4d8290a42e3b07" => :el_capitan
    sha256 "68b53204bf17e88d8444f84e8c2f4251f62ffdff22972cc234f6dda48de022b7" => :yosemite
    sha256 "69f8349c42ca56e056da0e4efaa3fdd0d40f34302d81b362135a9ec8cefb4e71" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ck_spinlock.h>
      int main()
      {
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lck",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
