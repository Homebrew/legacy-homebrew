class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.cs.fsu.edu/~engelen/soap.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gSOAP/gsoap_2.8.25.zip"
  sha256 "396b66eb7ab410d89a38d1319443d99fd8b43cab8743f9c69f03a2ed3215db05"

  depends_on "openssl"

  def install
    ENV.deparallelize

    # OS X defines "TCP_FASTOPE" in netinet/tcp.h but doesn't
    # seems to recognise or accept "SOL_TCP". IPPROTO_TCP is equivalent, apparently.
    # https://github.com/Homebrew/homebrew/issues/44018#issuecomment-145231029
    inreplace "gsoap/stdsoap2.c", "SOL_TCP", "IPPROTO_TCP"
    inreplace "gsoap/stdsoap2.cpp", "SOL_TCP", "IPPROTO_TCP"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wsdl2h", "-o", "calc.h", "http://www.genivia.com/calc.wsdl"
    system "#{bin}/soapcpp2", "calc.h"
    assert File.exist?("calc.add.req.xml")
  end
end
