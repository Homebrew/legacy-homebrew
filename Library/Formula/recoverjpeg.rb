require 'formula'

class Recoverjpeg < Formula
  homepage 'http://www.rfc1149.net/devel/recoverjpeg.html'
  url 'http://www.rfc1149.net/download/recoverjpeg/recoverjpeg-2.2.1.tar.gz'
  sha1 'faf4c9a324ee2697289143668514873f27d75ab6'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
