class Concurrencykit < Formula
  desc "Aid design and implementation of concurrent systems"
  homepage "http://concurrencykit.org"
  url "http://concurrencykit.org/releases/ck-0.4.5.tar.gz"
  mirror "https://github.com/concurrencykit/ck/archive/0.4.5.tar.gz"
  sha256 "89feea338cd6a8efbe7bd64d033cefccb34775ea0bedbcb1612df2b822fa0356"

  head "https://github.com/concurrencykit/ck.git"

  bottle do
    cellar :any
    sha256 "782560f0c9693a783087b595548975bbc24c6dbc122a01d24dd9098de09819e0" => :yosemite
    sha256 "2bc7526a484537d45f98c2d2795e7c9ea4a4ebc5ff5003687f8718271f70a59d" => :mavericks
    sha256 "8323fa92d2f032c5ef9c793c31f0da5d6310c9dbedb9d33946fa1dc35dc4a13b" => :mountain_lion
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
