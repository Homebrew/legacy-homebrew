require 'formula'

class Libgeotiff <Formula
  url 'ftp://ftp.remotesensing.org/pub/geotiff/libgeotiff/libgeotiff-1.2.5.tar.gz'
  homepage 'http://geotiff.osgeo.org/'
  md5 '000f247a88510f1b38d4b314d1e47048'

  depends_on 'libtiff'
  depends_on 'jpeg' => :optional
  depends_on 'proj' => :optional

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--with-libtiff=#{HOMEBREW_PREFIX}"
    system "make" # Separate steps or install fails
    system "make install"
  end
end
