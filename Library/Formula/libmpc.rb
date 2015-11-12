class Libmpc < Formula
  desc "C library for the arithmetic of high precision complex numbers"
  homepage "http://multiprecision.org"
  url "http://ftpmirror.gnu.org/mpc/mpc-1.0.3.tar.gz"
  mirror "http://multiprecision.org/mpc/download/mpc-1.0.3.tar.gz"
  sha256 "617decc6ea09889fb08ede330917a00b16809b8db88c29c31bfbb49cbf88ecc3"

  bottle do
    cellar :any
    sha256 "04280215d9638c3e4dd0296cb1a0fe0e3e159088ebd59b6ab0c16585ada91f87" => :el_capitan
    sha1 "c96c76d63b166fb13e6818a0ae7094455002b420" => :yosemite
    sha1 "b1a74b2c579600f12002a842bc8ddd82785277ce" => :mavericks
    sha1 "5fe25b2992da6773db6fec8a72260272a6058782" => :mountain_lion
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--with-gmp=#{Formula["gmp"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr"].opt_prefix}"
    ]

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <mpc.h>

      int main()
      {
        mpc_t x;
        mpc_init2 (x, 256);
        mpc_clear (x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-lmpfr", "-lmpc", "-o", "test"
    system "./test"
  end
end
