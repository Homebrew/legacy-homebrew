require 'formula'

class Libgeotiff < Formula
  homepage 'http://geotiff.osgeo.org/'
  url 'http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.1.tar.gz'
  sha1 'bc9e2bb43f3877b795b4b191e7aec6267f4a1c7e'

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
