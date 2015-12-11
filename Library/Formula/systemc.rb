class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "http://accellera.org"
  url "http://accellera.org/images/downloads/standards/systemc/systemc-2.3.1.tgz"
  sha256 "7ce0f68fd4759e746a9808936b54e62d498f5b583e83fc47758ca86917b4f800"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-arch-suffix=",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "systemc.h"

      int sc_main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lsystemc", "test.cpp"
    system "./a.out"
  end
end
