class ThcPptpBruter < Formula
  desc "Brute force program against PPTP VPN endpoints (TCP port 1723)"
  homepage "https://thc.org"
  url "https://freeworld.thc.org/releases/thc-pptp-bruter-0.1.4.tar.gz"
  sha256 "baa05f398d325b490e3eb4cd0ffaf67a6ae306c968a7d8114267b0c088de6ee2"

  bottle do
    cellar :any
    sha1 "1693dcceb59ea85f265be800af5615d75dd217b0" => :yosemite
    sha1 "e75d5e3c5eb439522a3896956918ad0f1f676907" => :mavericks
    sha1 "febbca57781732342980f6e52c3dad393cc43b30" => :mountain_lion
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
