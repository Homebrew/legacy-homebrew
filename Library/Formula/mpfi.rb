class Mpfi < Formula
  desc "Multiple precision interval arithmetic library"
  homepage "https://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "https://gforge.inria.fr/frs/download.php/30130/mpfi-1.5.1.tar.gz"
  sha256 "ea2725c6f38ddd8f3677c9b0ce8da8f52fe69e34aa85c01fb98074dc4e3458bc"

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
