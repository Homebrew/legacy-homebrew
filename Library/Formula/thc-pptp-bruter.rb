class ThcPptpBruter < Formula
  desc "Brute force program against PPTP VPN endpoints (TCP port 1723)"
  homepage "https://thc.org"
  url "https://freeworld.thc.org/releases/thc-pptp-bruter-0.1.4.tar.gz"
  sha256 "baa05f398d325b490e3eb4cd0ffaf67a6ae306c968a7d8114267b0c088de6ee2"

  bottle do
    cellar :any
    sha256 "9236475e9ec15fdddefd4b9ad01d619d645ad0227adc50e9ae7c5b01a68ff964" => :yosemite
    sha256 "e34bda13c8753b1064fb59712e799191dd00addfa30b0f9947d2dd97dac47b1a" => :mavericks
    sha256 "fa6df7bd11a9f2a2903e60775ab1324a7220d37da30a4bb6e4a8eb77e2163c3d" => :mountain_lion
  end

  depends_on "openssl"

  def install
    # The function openpty() is defined in pty.h on Linux, but in util.h on OS X.
    # See https://groups.google.com/group/sage-devel/msg/97916255b631e3e5
    inreplace "src/pptp_bruter.c", "pty.h", "util.h"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/thc-pptp-bruter"
  end
end
