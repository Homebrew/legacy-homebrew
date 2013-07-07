require 'formula'

class Libgeotiff < Formula
  homepage 'http://geotiff.osgeo.org/'
  url 'http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.0.tar.gz'
  sha1 '4c6f405869826bb7d9f35f1d69167e3b44a57ef0'

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
