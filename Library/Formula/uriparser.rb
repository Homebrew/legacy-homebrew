require 'formula'

class Uriparser < Formula
  homepage 'http://uriparser.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/uriparser/Sources/0.8.0/uriparser-0.8.0.tar.bz2'
  sha1 '4bfe347220b00ff9cd3252e2b784d13e583282fb'

  bottle do
    cellar :any
    sha1 "64e3be7bfe95e9dd4343171eeed41317e712623c" => :mavericks
    sha1 "568ce43bfdaf68cd30034b065fac52e3885013c6" => :mountain_lion
    sha1 "de7615ef6d3ef7b16bbf721d6a97dcaba3e2ff51" => :lion
  end

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
