require 'formula'

class Gsoap < Formula
  homepage 'http://www.cs.fsu.edu/~engelen/soap.html'
  url 'http://downloads.sourceforge.net/project/gsoap2/gSOAP/gsoap_2.8.16.zip'
  sha1 '8024f03dedef361a5271a7c0b26f961fd278703c'

  def install
    ENV.deparallelize
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end

  def test
    system "#{bin}/soapcpp2", "-v"
  end
end
