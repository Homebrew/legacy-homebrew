require 'formula'

class Libgeotiff < Formula
  homepage 'http://geotiff.osgeo.org/'
  url 'http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.0.tar.gz'
  sha1 '4c6f405869826bb7d9f35f1d69167e3b44a57ef0'

  bottle do
    revision 1
    sha1 "61c00f4819ebf28dfa10bcd457ef70f339761b7d" => :yosemite
    sha1 "246a85f91f6deb56498ec85239c9f9f8d1357e15" => :mavericks
    sha1 "87ab83ddf59b19ebc074bed85a19be5b0924d031" => :mountain_lion
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
