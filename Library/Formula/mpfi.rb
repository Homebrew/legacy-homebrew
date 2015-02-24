class Mpfi < Formula
  homepage "http://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "https://gforge.inria.fr/frs/download.php/30130/mpfi-1.5.1.tar.gz"
  sha1 "288302c0cdefe823cc3aa71de31c1da82eeb6ad0"

  depends_on "gmp"
  depends_on "mpfr"

  option "32-bit"

  def install
    ENV.m32 if build.build_32_bit?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <mpfi.h>

      int main()
      {
        mpfi_t x;
        mpfi_init(x);
        mpfi_clear(x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-lmpfr", "-lmpfi", "-o", "test"
    system "./test"
  end
end
