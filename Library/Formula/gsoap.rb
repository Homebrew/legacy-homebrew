require 'formula'

class Gsoap < Formula
  url 'http://downloads.sourceforge.net/project/gsoap2/gSOAP/gsoap_2.8.6.zip'
  homepage 'http://www.cs.fsu.edu/~engelen/soap.html'
  md5 'c0b962c6216bcf59255dc4288783252f'

  def install
    ENV.deparallelize
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end

  def test
    system "#{bin}/soapcpp2 -v"
  end
end
