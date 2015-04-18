class Concurrencykit < Formula
  homepage "http://concurrencykit.org"
  url "http://concurrencykit.org/releases/ck-0.4.5.tar.gz"
  mirror "https://github.com/concurrencykit/ck/archive/0.4.5.tar.gz"
  sha256 "89feea338cd6a8efbe7bd64d033cefccb34775ea0bedbcb1612df2b822fa0356"

  head "https://github.com/concurrencykit/ck.git"

  bottle do
    cellar :any
    sha1 "86056c5005d9d4d231d2b4603415ef3f9258afd7" => :mavericks
    sha1 "a972444147a7621158474c867eca0def9da131ed" => :mountain_lion
    sha1 "949f89c08cac441c9e2153a01237941fd45ec658" => :lion
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
