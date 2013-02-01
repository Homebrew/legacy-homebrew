require 'formula'

class Gsoap < Formula
  homepage 'http://www.cs.fsu.edu/~engelen/soap.html'
  url 'http://sourceforge.net/projects/gsoap2/files/gSOAP/gsoap_2.8.12.zip'
  sha1 '6ff652dbee1b28a21c11ddcca64128fd647a992e'

  def install
    ENV.deparallelize
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end

  def test
    system "#{bin}/soapcpp2", "-v"
  end
end
