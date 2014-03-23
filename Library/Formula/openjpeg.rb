require 'formula'

class Openjpeg < Formula
  homepage 'http://www.openjpeg.org/'
  url 'https://openjpeg.googlecode.com/files/openjpeg-1.5.1.tar.gz'
  sha1 '1b0b74d1af4c297fd82806a9325bb544caf9bb8b'
  revision 1

  head 'http://openjpeg.googlecode.com/svn/trunk/'

  depends_on 'little-cms2'
  depends_on 'libtiff'
  depends_on 'libpng'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
