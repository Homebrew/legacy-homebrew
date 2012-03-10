require 'formula'

class Libgeotiff < Formula
  url 'http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.3.0.tar.gz'
  homepage 'http://geotiff.osgeo.org/'
  sha1 'b8cde5014cf82fe4683fa35fc81a5ea8d64b940f'

  depends_on 'libtiff'
  depends_on 'lzlib'
  depends_on 'jpeg'
  depends_on 'proj'

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}",
            "--with-libtiff=#{HOMEBREW_PREFIX}",
            "--with-zlib=#{HOMEBREW_PREFIX}",
            "--with-jpeg=#{HOMEBREW_PREFIX}"]
    system "./configure", *args
    system "make" # Separate steps or install fails
    system "make install"
  end
end
