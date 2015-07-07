require "formula"

class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "http://www.cs.fsu.edu/~engelen/soap.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gSOAP/gsoap_2.8.18.zip"
  sha1 "672d81f1b15eb64f2b55f2ba3217be43ae3b197a"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/soapcpp2", "-v"
  end
end
