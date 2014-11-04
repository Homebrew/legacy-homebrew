require 'formula'

class Libgeotiff < Formula
  homepage 'http://geotiff.osgeo.org/'
  url 'http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.1.tar.gz'
  sha1 'bc9e2bb43f3877b795b4b191e7aec6267f4a1c7e'

  bottle do
    sha1 "36537de4979760793a529685086eba83f6bdf5d4" => :yosemite
    sha1 "8d98c26cef589169e70db65455ee2df94cedc9ef" => :mavericks
    sha1 "552b698613f5eab0842d408406185ca069fbb0d8" => :mountain_lion
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
