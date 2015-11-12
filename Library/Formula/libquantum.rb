class Libquantum < Formula
  desc "C library for the simulation of quantum mechanics"
  homepage "http://www.libquantum.de/"
  url "http://www.libquantum.de/files/libquantum-1.0.0.tar.gz"
  sha256 "b0f1a5ec9768457ac9835bd52c3017d279ac99cc0dffe6ce2adf8ac762997b2c"

  bottle do
    cellar :any
    sha256 "ce31c2a7df81599bc4930ad4aef206f22e006db41d32d05ef1f2f3e72ff6d29d" => :yosemite
    sha256 "2347b6f64ac6a2463cded1679de4390f5bda4b07a74f304efd4ea3bc536af3df" => :mavericks
    sha256 "a7df989c22406155638d24ac755e851208d4cb7f72a8f1f17a985d172270006f" => :mountain_lion
  end

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
