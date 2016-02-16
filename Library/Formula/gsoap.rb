class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.cs.fsu.edu/~engelen/soap.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gSOAP/gsoap_2.8.28.zip"
  sha256 "453b36d97a98b35c2829284219dd09a4d60f073a5b77c658c403961c54cfa328"

  bottle do
    sha256 "bb0550d7f9a92f910758f6735a753d70876adcfd15bbc2461b15eb3917e94ee2" => :el_capitan
    sha256 "308b3ba08bab0f13ae65b0c4f4638c79ae24acb45295d4548687d91c3bd9dc0c" => :yosemite
    sha256 "2bd60448e21d2b37eadc3193aae093b7c95ed9b499b97d21de6bbe0234569046" => :mavericks
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
