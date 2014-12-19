require "formula"

class Libiomp < Formula
  homepage "https://www.openmprtl.org/download"
  url "https://www.openmprtl.org/sites/default/files/libomp_20140926_oss.tgz"
  sha1 "488ff3874eb5c971523534cb3c987bfb5ce3addb"

  bottle do
    cellar :any
    sha1 "782faf00e595709011f1e8a19933fff0d55c954e" => :yosemite
    sha1 "070a6edb8c872e2b88f953222b72cd587f288149" => :mavericks
    sha1 "26a2f4d2d6427c1d114fdc774a71bdd06926cc13" => :mountain_lion
  end

  depends_on :arch => :intel

  fails_with :gcc  do
    cause "libiomp can only be built with clang."
  end

  fails_with :gcc_4_0 do
    cause "libiomp can only be built with clang."
  end

  ("4.3".."4.9").each do |n|
    fails_with :gcc => n do
      cause "libiomp can only be built with clang."
    end
  end

  def install
    # fix makefile for yosemite:
    inreplace "src/makefile.mk" do |s|
      s.gsub! "`sw_vers -productVersion` > 10.6", "`sw_vers -productVersion` == '10.10' || `sw_vers -productVersion`> 10.6"
    end

    intel_arch = MacOS.prefer_64_bit? ? "mac_32e" : "mac_32"

    system "make", "compiler=clang"

    (include/"libiomp").install Dir["exports/common/include/*"]
    lib.install "exports/#{intel_arch}/lib.thin/libiomp5.dylib"
  end

  test do
    testfile = <<-EOS.undent
      #include <omp.h>
      #include <stdlib.h>

      int main(void) {
          omp_set_num_threads(2);
          omp_get_num_threads();
          return EXIT_SUCCESS;
      }
    EOS
    (testpath/"test.c").write(testfile)
    system ENV.cc, "-L#{lib}", "-liomp5", "-I#{include}/libiomp", "test.c", "-o", "test"
    system "./test"
  end
end
