class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp/overview"
  url "http://nongnu.askapache.com/linphone/ortp/sources/ortp-0.24.2.tar.gz"
  sha256 "cb37c76985b3703157f0ed06d900d662b903ad3c5b772e2d1ea36478ad8a6616"

  bottle do
    cellar :any
    sha256 "a44c617d0bc51a7433243544b255e75fb4afe32ae939d6088450921633a4d19c" => :yosemite
    sha256 "7505c45e98f762b1ba0a51c3285ef23eefa68fad32aaded8a7b5aa719f5ca153" => :mavericks
    sha256 "2b6b871251f5ddd895fe3d680c975129dcf5d317de09752e343624bd372befa6" => :mountain_lion
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
