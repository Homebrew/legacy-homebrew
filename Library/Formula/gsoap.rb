require 'formula'

class Gsoap < Formula
  url 'http://downloads.sourceforge.net/project/gsoap2/gSOAP/gsoap_2.8.3.zip'
  homepage 'http://www.cs.fsu.edu/~engelen/soap.html'
  sha1 '55677239751253b48f448eb30a7585df97cba486'

  def install
    ENV.deparallelize
    system './configure', "--prefix=#{prefix}"
    system 'make install'
  end
end
