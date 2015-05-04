class Ortp < Formula
  homepage "http://www.linphone.org/eng/documentation/dev/ortp.html"
  url "http://nongnu.askapache.com/linphone/ortp/sources/ortp-0.24.1.tar.gz"
  sha256 "d1ecce20bed145186f727914f10f500d0594e30c2a234a276e7e12dcd8814cd5"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lortp",
           testpath/"test.c", "-o", "test"
    system "./test"
  end
end
