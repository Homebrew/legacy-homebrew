require 'formula'

class Metapixel < Formula
  homepage 'http://www.complang.tuwien.ac.at/schani/metapixel/'
  url 'http://www.complang.tuwien.ac.at/schani/metapixel/files/metapixel-1.0.2.tar.gz'
  sha1 'f917aec91430b1bdbcc7b3dea29cb93f15a04c77'

  depends_on 'jpeg'
  depends_on 'giflib'
  depends_on 'libpng12'

  def install
    system "make"
    # The Makefile does not create the man dir
    system "mkdir", "-p", "#{man}/man1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "metapixel --version"
  end
end
