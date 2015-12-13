class Spandsp < Formula
  desc "DSP functions library for telephony"
  homepage "http://www.soft-switch.org"
  url "http://www.soft-switch.org/downloads/spandsp/spandsp-0.0.6.tar.gz"
  sha256 "cc053ac67e8ac4bb992f258fd94f275a7872df959f6a87763965feabfdcc9465"

  bottle do
    cellar :any
    sha256 "68fe0041f7d4f453b8808bb5976c861f61288e6620c3405d703662cd53074b32" => :el_capitan
    sha256 "10c6dc51df1853903931769ce0cbb3a28865875152a0ad6642292e5c0ae498f9" => :yosemite
    sha256 "1bb642c61a368b058ef3fff3b2305c572e80fd31a8c20fb0648e4a2c600aa409" => :mavericks
  end

  depends_on "libtiff"

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #define SPANDSP_EXPOSE_INTERNAL_STRUCTURES
      #include <spandsp.h>

      int main()
      {
        t38_terminal_state_t t38;
        memset(&t38, 0, sizeof(t38));
        return (t38_terminal_init(&t38, 0, NULL, NULL) == NULL) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lspandsp", "-o", "test"
    system "./test"
  end
end
