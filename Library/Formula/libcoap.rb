require "formula"

class Libcoap < Formula
  homepage "http://libcoap.sourceforge.net"
  url "https://downloads.sourceforge.net/project/libcoap/coap-18/libcoap-4.1.1.tar.gz"
  sha1 "137c0bfe25c735b4a85dde65fdded13e8ef0f48f"

  depends_on "doxygen" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    include.install "coap.h"
    lib.install "libcoap.a"
    bin.install "examples/coap-server", "examples/coap-client"
  end
end
