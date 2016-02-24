class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "http://accellera.org"
  url "http://accellera.org/images/downloads/standards/systemc/systemc-2.3.1.tgz"
  sha256 "7ce0f68fd4759e746a9808936b54e62d498f5b583e83fc47758ca86917b4f800"

  bottle do
    cellar :any
    sha256 "3228efad334a8e66478c85245205e3b2d9f45fd227da07ac35aa8a9cca43565e" => :el_capitan
    sha256 "6f97dab7564f10fe17f43289576e4ae8a2c748bbb907538d04e79e0640744ac6" => :yosemite
    sha256 "a63276361d0399c899b61d068bf3fe92aab9882b218b749a6520920ae4c5e56b" => :mavericks
  end

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
