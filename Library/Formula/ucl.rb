require 'formula'

class Ucl < Formula
  homepage 'http://www.oberhumer.com/opensource/ucl/'
  url 'http://www.oberhumer.com/opensource/ucl/download/ucl-1.03.tar.gz'
  sha1 '5847003d136fbbca1334dd5de10554c76c755f7c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
