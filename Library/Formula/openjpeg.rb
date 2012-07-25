require 'formula'

class Openjpeg < Formula
  homepage 'http://www.openjpeg.org/'
  url 'http://openjpeg.googlecode.com/files/openjpeg-1.5.0.tar.gz'
  sha1 'dce705ae45f137e4698a8cf39d1fbf22bc434fa8'

  head 'http://openjpeg.googlecode.com/svn/trunk/'

  depends_on 'little-cms2'
  depends_on 'libtiff'
  depends_on :libpng

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
