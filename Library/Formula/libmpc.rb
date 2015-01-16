class Libmpc < Formula
  homepage "http://multiprecision.org"
  url "http://ftpmirror.gnu.org/mpc/mpc-1.0.2.tar.gz"
  mirror "http://multiprecision.org/mpc/download/mpc-1.0.2.tar.gz"
  sha1 "5072d82ab50ec36cc8c0e320b5c377adb48abe70"

  bottle do
    cellar :any
    revision 3
    sha1 "6113e69eea132dfeb82db6edc10fdb964047f85d" => :yosemite
    sha1 "206544ff8ee4234e456ab778bb4c7e9d84878582" => :mavericks
    sha1 "5fe23420d4647f9447d976d19e402dbcea198c47" => :mountain_lion
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
