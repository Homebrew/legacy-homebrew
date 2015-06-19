class Libharu < Formula
  desc "Library for generating PDF files"
  homepage "http://www.libharu.org/"
  url "https://github.com/libharu/libharu/archive/RELEASE_2_3_0.tar.gz"
  sha1 "434177d4baaf2a37b2d2d16467dd786961919e0d"
  head "https://github.com/libharu/libharu.git"

  bottle do
    cellar :any
    sha1 "24ef451318dd8dba2a121585120bd29b0713001c" => :yosemite
    sha1 "e0d113830d149a48a558f7eab1c44152f2e91fbf" => :mavericks
    sha1 "0911c2c32d551471d7f0e185271bb48e06d2e9d7" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libpng"

  def install
    system "./buildconf.sh", "--force"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-png=#{Formula["libpng"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "hpdf.h"

      int main(void)
      {
        int result = 1;
        HPDF_Doc pdf = HPDF_New(NULL, NULL);

        if (pdf) {
          HPDF_AddPage(pdf);

          if (HPDF_SaveToFile(pdf, "test.pdf") == HPDF_OK)
            result = 0;

          HPDF_Free(pdf);
        }

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-lhpdf", "-lz", "-o", "test"
    system "./test"
  end
end
