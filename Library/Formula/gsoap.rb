require 'formula'

class Gsoap < Formula
  homepage 'http://www.cs.fsu.edu/~engelen/soap.html'
  url 'http://sourceforge.net/projects/gsoap2/files/gSOAP/gsoap_2.8.13.zip'
  sha1 '8236bf4c214755d77ceed7e581baf0142c2034fe'

  def install
    ENV.deparallelize
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end

  def test
    system "#{bin}/soapcpp2", "-v"
  end
end
