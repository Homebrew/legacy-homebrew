require 'formula'

class SimpleTiles < Formula
  homepage 'http://propublica.github.com/simple-tiles/'
  url 'https://github.com/propublica/simple-tiles/tarball/0.3.0'
  head 'https://github.com/propublica/simple-tiles.git'
  version '0.3.0'
  sha1 '08a4916cdb20b2f9d4030440696a20817504db93'

  depends_on "pkg-config" => :build
  depends_on :cairo
  depends_on "gdal"
  depends_on "pango"
  
  def install
    # we need to use tha Makefile's CFLAGS to get the right arguments from pkg-config
    system "./configure --prefix=#{prefix}"
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end

end