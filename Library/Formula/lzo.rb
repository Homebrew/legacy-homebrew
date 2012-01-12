require 'formula'

class Lzo < Formula
  homepage 'http://www.oberhumer.com/opensource/lzo/'
  url 'http://www.oberhumer.com/opensource/lzo/download/lzo-2.06.tar.gz'
  sha256 'ff79e6f836d62d3f86ef6ce893ed65d07e638ef4d3cb952963471b4234d43e73'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make check"
    system "make install"
  end
end
