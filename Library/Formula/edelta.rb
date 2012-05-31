require 'formula'

class Edelta < Formula
  homepage 'http://www.diku.dk/hjemmesider/ansatte/jacobg/edelta/'
  url 'http://www.diku.dk/hjemmesider/ansatte/jacobg/edelta/edelta-0.10b.tar.gz'
  md5 'f0306c9bca4518d86a08d8a4f98a9ca8'

  def install
    system "make", "CFLAGS=#{ENV.cflags}"
    bin.install 'edelta'
  end
end
