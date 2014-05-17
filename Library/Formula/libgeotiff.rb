require 'formula'

class Libgeotiff < Formula
  homepage 'http://geotiff.osgeo.org/'
  url 'http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.0.tar.gz'
  sha1 '4c6f405869826bb7d9f35f1d69167e3b44a57ef0'

  bottle do
    sha1 "81c251028852c1e1cdd0f9ba8f6e023222db4099" => :mavericks
    sha1 "58398ab68357c0d5ed104eaecf1f52f684df685c" => :mountain_lion
    sha1 "5c3f8cd77572592d30d542b7d25c354aca8ef932" => :lion
  end

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
