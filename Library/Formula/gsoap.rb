require 'formula'

class Gsoap < Formula
  homepage 'http://www.cs.fsu.edu/~engelen/soap.html'
  url 'http://downloads.sourceforge.net/project/gsoap2/gSOAP/gsoap_2.8.15.zip'
  sha1 '3238ea70fcd3356bd2e7cd3d1e2ef91c1040b81a'

  def install
    ENV.deparallelize
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end

  def test
    system "#{bin}/soapcpp2", "-v"
  end
end
