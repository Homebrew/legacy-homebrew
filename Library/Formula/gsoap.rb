require 'formula'

class Gsoap < Formula
  homepage 'http://www.cs.fsu.edu/~engelen/soap.html'
  url 'http://sourceforge.net/projects/gsoap2/files/gSOAP/gsoap_2.8.14.zip'
  sha1 '4bb2f8c0bbb3be0267aaf51a7dc76817b18c5e0a'

  def install
    ENV.deparallelize
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end

  def test
    system "#{bin}/soapcpp2", "-v"
  end
end
