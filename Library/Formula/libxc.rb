class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "http://www.tddft.org/programs/octopus/wiki/index.php/Libxc"
  url "http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-2.2.2.tar.gz"
  sha256 "6ca1d0bb5fdc341d59960707bc67f23ad54de8a6018e19e02eee2b16ea7cc642"
  revision 1

  bottle do
    cellar :any
    sha256 "21c14d74f3b61c2a90518208500aee11fc18d0f0449cb76b0d3d30a0e8ec0fe9" => :yosemite
    sha256 "c6d5ac5639158a1c0c7e66abd31bdfe5fa3d036c702dc64d75d3d4a625897e4a" => :mavericks
    sha256 "63b05a1fb40be747e31c0d7addf8d424df06d42dd028a907e92ea738d1b0e684" => :mountain_lion
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
