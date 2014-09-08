require "formula"

class Libcoap < Formula
  homepage "http://libcoap.sourceforge.net"
  url "https://downloads.sourceforge.net/project/libcoap/coap-18/libcoap-4.1.1.tar.gz"
  sha1 "137c0bfe25c735b4a85dde65fdded13e8ef0f48f"

  bottle do
    cellar :any
    sha1 "f02f899057ee8292239e0a697188002a0743e728" => :mavericks
    sha1 "5a79a74f20beae8dc2ad7879bf8dec4f129d9a87" => :mountain_lion
    sha1 "16534d8749735472dec30484de6de432fd7d4ab3" => :lion
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
