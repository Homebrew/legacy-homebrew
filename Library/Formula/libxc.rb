class Libxc < Formula
  homepage "http://www.tddft.org/programs/octopus/wiki/index.php/Libxc"
  url "http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-2.2.2.tar.gz"
  sha256 "6ca1d0bb5fdc341d59960707bc67f23ad54de8a6018e19e02eee2b16ea7cc642"
  revision 1

  bottle do
    cellar :any
    sha256 "d8a16884883e3fe4d6f48f3341b9468bc119e450d571ed0f825a70462bf50198" => :yosemite
    sha256 "7a2469afb9d0290496b543d83f5fd9cad87b50d1fcbb9ef136a490c4c215cad3" => :mavericks
    sha256 "632e4fad48001be6f91472c77922e7288c08052f75d72641de3b6ff31f2f8e5d" => :mountain_lion
  end

  depends_on :fortran

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=#{ENV.fc} -E -x c",
                          "CC=#{ENV.cc}",
                          "CFLAGS=-pipe"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int i, vmajor, vminor, func_id = 1;
        xc_version(&vmajor, &vminor);
        printf(\"%d.%d\", vmajor, vminor);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lxc", "-I#{include}", "-o", "ctest"
    system "./ctest"

    (testpath/"test.f90").write <<-EOS.undent
      program lxctest
        use xc_f90_types_m
        use xc_f90_lib_m
      end program lxctest
    EOS
    ENV.fortran
    system ENV.fc, "test.f90", "-L#{lib}", "-lxc", "-I#{include}", "-o", "ftest"
    system "./ftest"
  end
end
