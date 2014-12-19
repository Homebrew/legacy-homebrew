require "formula"

class Libcoap < Formula
  homepage "http://libcoap.sourceforge.net"
  url "https://downloads.sourceforge.net/project/libcoap/coap-18/libcoap-4.1.1.tar.gz"
  sha1 "137c0bfe25c735b4a85dde65fdded13e8ef0f48f"

  bottle do
    cellar :any
    revision 1
    sha1 "977001f847ae286ba3fc3496ad140280e1c80ee9" => :yosemite
    sha1 "b725f7d8be17fd319a1b3f4851396407e8da93f6" => :mavericks
    sha1 "65b9a058dffdfac73dea9141c1a08cd828a5a0e2" => :mountain_lion
  end

  depends_on "doxygen" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    include.install "coap.h"
    lib.install "libcoap.a"
    bin.install "examples/coap-server", "examples/coap-client"
  end
end
