class Libquantum < Formula
  desc "C library for the simulation of quantum mechanics"
  homepage "http://www.libquantum.de/"
  url "http://www.libquantum.de/files/libquantum-1.0.0.tar.gz"
  sha256 "b0f1a5ec9768457ac9835bd52c3017d279ac99cc0dffe6ce2adf8ac762997b2c"

  devel do
    url "http://www.libquantum.de/files/libquantum-1.1.1.tar.gz"
    sha256 "d8e3c4407076558f87640f1e618501ec85bc5f4c5a84db4117ceaec7105046e5"
  end

  option "with-quobtools", "Install quobtools for debug"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "quobtools_install" if build.with? "quobtools"
  end

  test do
    (testpath/"qtest.c").write <<-EOS.undent
      #include <stdio.h>
      #include <stdlib.h>
      #include <time.h>
      #include <quantum.h>

      int main ()
      {
        quantum_reg reg;
        int result;
        srand(time(0));
        reg = quantum_new_qureg(0, 1);
        quantum_hadamard(0, &reg);
        result = quantum_bmeasure(0, &reg);
        printf("The Quantum RNG returned %i!\\n", result);
        return 0;
      }
    EOS
    system ENV.cc, "-O3", "-o", "qtest", "qtest.c", "-lquantum"
    system "./qtest"
  end
end
