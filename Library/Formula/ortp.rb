class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp/overview"
  url "http://nongnu.askapache.com/linphone/ortp/sources/ortp-0.24.2.tar.gz"
  sha256 "cb37c76985b3703157f0ed06d900d662b903ad3c5b772e2d1ea36478ad8a6616"

  bottle do
    cellar :any
    sha256 "38b9d28c30675e6cba3889386982153baf96e2375d97bcea9de10b39ff88149a" => :yosemite
    sha256 "3aeb452ad1f254803db24c96826755188820dd144bffa842dabda4d576d08595" => :mavericks
    sha256 "5b0f1247ca43018aa4473d5e887d62f3ae9c317dbd3f6962faafae028bd28fba" => :mountain_lion
  end

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
