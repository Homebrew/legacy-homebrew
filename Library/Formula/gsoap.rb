require 'formula'

class Gsoap < Formula
  homepage 'http://www.cs.fsu.edu/~engelen/soap.html'
  url 'http://sourceforge.net/projects/gsoap2/files/gSOAP/gsoap_2.8.11.zip'
  sha1 'b1c17d501361939c6d419eeb2aa26e7fd2b586fe'

  def install
    ENV.deparallelize
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end

  def test
    system "#{bin}/soapcpp2", "-v"
  end
end
