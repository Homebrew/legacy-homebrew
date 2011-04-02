require 'formula'

class Netris < Formula
  url 'ftp://ftp.netris.org/pub/netris/netris-0.52.tar.gz'
  homepage 'http://www.netris.org/'
  md5 'b55af5697175ee06f7c6e40101979c38'

  def install
    system "sh ./Configure"
    system "make"
    bin.install("netris")
  end
end
