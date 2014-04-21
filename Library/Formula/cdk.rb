require 'formula'

class Cdk < Formula
  homepage 'http://invisible-island.net/cdk/'
  url 'ftp://invisible-island.net/cdk/cdk-5.0-20140118.tgz'
  version '5.0.20140118'
  sha1 'd900e9e0d54a90701541d40ff7137507baf3b382'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
