require 'formula'

class Edelta < Formula
  homepage 'http://www.diku.dk/hjemmesider/ansatte/jacobg/edelta/'
  url 'http://www.diku.dk/hjemmesider/ansatte/jacobg/edelta/edelta-0.10b.tar.gz'
  sha1 'bcf24ff68c67da47484beb9f4869c726b9f06dc2'

  def install
    system "make", "CFLAGS=#{ENV.cflags}"
    bin.install 'edelta'
  end
end
