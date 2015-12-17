class Spandsp < Formula
  desc "DSP functions library for telephony"
  homepage "https://www.soft-switch.org/"
  url "https://www.soft-switch.org/downloads/spandsp/spandsp-0.0.6.tar.gz"
  sha256 "cc053ac67e8ac4bb992f258fd94f275a7872df959f6a87763965feabfdcc9465"

  bottle do
    cellar :any
    revision 1
    sha256 "5e8122369eb0639aea23506d55abc5cb3617a0ce3478e8432965edcda07ba56d" => :el_capitan
    sha256 "d5d2d03d916afba36ac2ab5699991ada42b7640b8c9c324eaf39d17fd582e97b" => :yosemite
    sha256 "a565b781cab589128aa3667d1de567443bf858c7f06416e7e9a66cfd45302b3d" => :mavericks
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
