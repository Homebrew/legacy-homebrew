class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.cs.fsu.edu/~engelen/soap.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gSOAP/gsoap_2.8.28.zip"
  sha256 "453b36d97a98b35c2829284219dd09a4d60f073a5b77c658c403961c54cfa328"

  bottle do
    sha256 "0f12a3f2fec76aff29c79b5e7f42ab7059e600cd7c09ccefa1708a04dbb241dc" => :el_capitan
    sha256 "bc1fc03b48a1f820a5bc54dd649dcc576699cf878691cd645512b6c5633e3db4" => :yosemite
    sha256 "300a97e3c6152f973356b49779ac332940a25f8418486ba59aac0e7501d25b9b" => :mavericks
  end

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
