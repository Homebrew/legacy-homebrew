require 'formula'

class Uriparser < Formula
  homepage 'http://uriparser.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/uriparser/Sources/0.8.0/uriparser-0.8.0.tar.bz2'
  sha1 '4bfe347220b00ff9cd3252e2b784d13e583282fb'

  depends_on 'pkg-config' => :build
  depends_on 'cpptest'

  conflicts_with 'libkml', :because => 'both install `liburiparser.dylib`'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-doc"
    system "make check"
    system "make install"
  end
end
