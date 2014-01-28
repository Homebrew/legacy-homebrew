require 'formula'

class Gsoap < Formula
  homepage 'http://www.cs.fsu.edu/~engelen/soap.html'
  url 'http://downloads.sourceforge.net/project/gsoap2/gSOAP/gsoap_2.8.17.zip'
  sha1 'd6c483ea2eabade138d71d005300be909be9a274'

  def install
    ENV.deparallelize
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end

  def test
    system "#{bin}/soapcpp2", "-v"
  end
end
